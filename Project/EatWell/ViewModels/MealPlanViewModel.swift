//
//  MealPlanViewModel.swift
//  EatWell
//
//  Created by Tuğba Zengin on 22.05.2025.
//

import Foundation

@MainActor
final class MealPlanViewModel: ObservableObject {
    @Published var allMeals: [Meal] = []
    @Published var mealsByCategory: [String: [Meal]] = [:]
    @Published var selectedMeals: [String: [Meal]] = [
        "Kahvaltı": [],
        "Öğle Yemeği": [],
        "Akşam Yemeği": [],
        "Atıştırmalık": []
    ]
    @Published var dailyNutrition = DailyNutrition()
    @Published var isLoading = false
    @Published var errorMessage: String?
    @Published var showError = false
    @Published var calorieWarning: String = ""
    @Published var showCalorieWarning = false
    
    private let baseURL = APIConfig.generalURL
    
    // Kategoriler
    let categories = ["Kahvaltı", "Öğle Yemeği", "Akşam Yemeği", "Atıştırmalık", "Çorba", "Tatlı"]
    let mainMealCategories = ["Kahvaltı", "Öğle Yemeği", "Akşam Yemeği", "Atıştırmalık"]
    
    init() {
        // Direkt API'den veri çek, sample data yükleme
        fetchMeals()
    }
    
    // MARK: - Sample Data (Backup)
    private func loadSampleData() {
        let sampleMeals = Meal.sampleMeals
        self.allMeals = sampleMeals
        
        // Kategorilere göre gruplama
        var grouped: [String: [Meal]] = [:]
        for category in categories {
            grouped[category] = sampleMeals.filter { $0.category == category }
        }
        self.mealsByCategory = grouped
    }
    
    // MARK: - API Calls
    func fetchMeals() {
        Task {
            await fetchAllMeals()
        }
    }
    
    private func fetchAllMeals() async {
        isLoading = true
        errorMessage = nil
        
        // ZORUNLU: Test endpoint'ini kullan
        var meals = await fetchMealsFromAPI(endpoint: "/meals/test/categories")
        print("🚀 Test endpoint'inden \(meals.count) yemek geldi")
        
        // Test başarısız olursa gerçek API'yi dene
        if meals.isEmpty {
            print("🔄 Test API boş, gerçek API deneniyor...")
            meals = await fetchMealsFromAPI(endpoint: "/meals/categories")
        }
        
        if !meals.isEmpty {
            self.allMeals = meals
            groupMealsByCategory()
            print("✅ \(meals.count) yemek başarıyla yüklendi")
        } else {
            // API başarısız olursa sample data'yı kullan ama önce boş başlat
            print("⚠️ API'den veri alınamadı, sample data kullanılıyor")
            self.allMeals = []
            self.mealsByCategory = [:]
            loadSampleData()
        }
        
        isLoading = false
    }
    
    private func fetchMealsFromAPI(endpoint: String) async -> [Meal] {
        guard let url = URL(string: baseURL + endpoint) else {
            print("❌ Geçersiz URL: \(baseURL + endpoint)")
            return []
        }
        
        do {
            let (data, response) = try await URLSession.shared.data(from: url)
            
            if let httpResponse = response as? HTTPURLResponse {
                print("📡 API Response Status: \(httpResponse.statusCode)")
                
                guard httpResponse.statusCode == 200 else {
                    print("❌ API hatası: \(httpResponse.statusCode)")
                    return []
                }
            }
            
            // Response'u parse et
            let apiResponse = try JSONDecoder().decode(APIResponse.self, from: data)
            
            if apiResponse.success {
                if endpoint.contains("/categories") {
                    // Kategorilere göre gruplanan veri
                    return parseCategorizedMeals(from: apiResponse.data)
                } else {
                    // Düz liste
                    if let mealsData = apiResponse.data,
                       let meals = mealsData["meals"] as? [[String: Any]] {
                        return parseMealsArray(from: meals)
                    }
                }
            } else {
                print("❌ API başarısız: \(apiResponse.message)")
            }
            
        } catch {
            print("❌ Network hatası: \(error)")
        }
        
        return []
    }
    
    private func parseCategorizedMeals(from data: [String: Any]?) -> [Meal] {
        guard let categorizedData = data as? [String: [[String: Any]]] else {
            print("❌ Kategori verisi parse edilemedi")
            return []
        }
        
        var allMeals: [Meal] = []
        var categoryGroups: [String: [Meal]] = [:]
        
        for (category, mealsData) in categorizedData {
            let meals = parseMealsArray(from: mealsData)
            allMeals.append(contentsOf: meals)
            categoryGroups[category] = meals
            print("🍽️ \(category): \(meals.count) yemek yüklendi")
        }
        
        print("📊 Toplam yemek sayısı: \(allMeals.count)")
        print("📋 Kategoriler: \(categoryGroups.keys)")
        
        // Kategorileri güncelle
        DispatchQueue.main.async {
            self.mealsByCategory = categoryGroups
            print("✅ mealsByCategory güncellendi: \(self.mealsByCategory.mapValues { $0.count })")
        }
        
        return allMeals
    }
    
    private func parseMealsArray(from mealsData: [[String: Any]]) -> [Meal] {
        var meals: [Meal] = []
        
        for mealDict in mealsData {
            if let meal = parseSingleMeal(from: mealDict) {
                meals.append(meal)
            }
        }
        
        return meals
    }
    
    private func parseSingleMeal(from dict: [String: Any]) -> Meal? {
        guard let name = dict["name"] as? String,
              let category = dict["category"] as? String,
              let calories = dict["calories"] as? Int,
              let protein = dict["protein"] as? Double,
              let carbs = dict["carbs"] as? Double,
              let fat = dict["fat"] as? Double,
              let description = dict["description"] as? String,
              let ingredients = dict["ingredients"] as? [String],
              let preparationTime = dict["preparationTime"] as? Int else {
            print("❌ Yemek parse hatası: \(dict)")
            return nil
        }
        
        let id = dict["_id"] as? String ?? UUID().uuidString
        
        return Meal(
            id: id,
            name: name,
            category: category,
            calories: calories,
            protein: protein,
            carbs: carbs,
            fat: fat,
            description: description,
            ingredients: ingredients,
            preparationTime: preparationTime
        )
    }
    
    private func groupMealsByCategory() {
        var grouped: [String: [Meal]] = [:]
        
        for category in categories {
            grouped[category] = allMeals.filter { $0.category == category }
        }
        
        self.mealsByCategory = grouped
    }
    
    // MARK: - Meal Selection
    func addMealToPlan(meal: Meal, category: String) {
        if mainMealCategories.contains(category) {
            selectedMeals[category]?.append(meal)
            calculateDailyNutrition()
            checkCalorieLimit()
        }
    }
    
    func removeMealFromPlan(meal: Meal, category: String) {
        selectedMeals[category]?.removeAll { $0.id == meal.id }
        calculateDailyNutrition()
        checkCalorieLimit()
    }
    
    func clearMealPlan() {
        for category in mainMealCategories {
            selectedMeals[category] = []
        }
        dailyNutrition = DailyNutrition()
    }
    
    // MARK: - Nutrition Calculation
    private func calculateDailyNutrition() {
        var totalCalories = 0
        var totalProtein = 0.0
        var totalCarbs = 0.0
        var totalFat = 0.0
        var totalTime = 0
        
        for category in mainMealCategories {
            if let meals = selectedMeals[category] {
                for meal in meals {
                    totalCalories += meal.calories
                    totalProtein += meal.protein
                    totalCarbs += meal.carbs
                    totalFat += meal.fat
                    totalTime += meal.preparationTime
                }
            }
        }
        
        dailyNutrition = DailyNutrition(
            calories: totalCalories,
            protein: totalProtein,
            carbs: totalCarbs,
            fat: totalFat,
            preparationTime: totalTime
        )
    }
    
    // MARK: - Suggestions
    func getMealsForCategory(_ category: String) -> [Meal] {
        let meals = mealsByCategory[category] ?? []
        print("🔍 getMealsForCategory(\(category)): \(meals.count) yemek dönüyor")
        if meals.count < 5 {
            print("⚠️ Az yemek var! Meal names: \(meals.map { $0.name })")
        }
        return meals
    }
    
    func getRandomMealsForCategory(_ category: String, count: Int = 3) -> [Meal] {
        let meals = getMealsForCategory(category)
        return Array(meals.shuffled().prefix(count))
    }
    
    func searchMeals(_ query: String) -> [Meal] {
        guard !query.isEmpty else { return allMeals }
        
        return allMeals.filter { meal in
            meal.name.localizedCaseInsensitiveContains(query) ||
            meal.description.localizedCaseInsensitiveContains(query) ||
            meal.ingredients.contains { $0.localizedCaseInsensitiveContains(query) }
        }
    }
    
    func getMealsByCalorieRange(min: Int, max: Int) -> [Meal] {
        return allMeals.filter { $0.calories >= min && $0.calories <= max }
    }
    
    func getHighProteinMeals(minProtein: Double = 15.0) -> [Meal] {
        return allMeals.filter { $0.protein >= minProtein }
    }
    
    func getLowCalorieMeals(maxCalories: Int = 200) -> [Meal] {
        return allMeals.filter { $0.calories <= maxCalories }
    }
    
    // MARK: - Calorie Control
    private func checkCalorieLimit() {
        if dailyNutrition.isOverLimit {
            calorieWarning = dailyNutrition.calorieWarningText
            showCalorieWarning = true
            
            // 8 saniye sonra uyarıyı gizle
            DispatchQueue.main.asyncAfter(deadline: .now() + 8) {
                self.showCalorieWarning = false
            }
        } else {
            showCalorieWarning = false
        }
    }
    
    // MARK: - Error Handling
    private func handleError(_ message: String) {
        errorMessage = message
        showError = true
        
        // 5 saniye sonra hatayı gizle
        DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
            self.showError = false
        }
    }
}

// MARK: - Supporting Models
struct JSONKeys: CodingKey {
    var stringValue: String
    var intValue: Int?
    
    init?(stringValue: String) {
        self.stringValue = stringValue
        self.intValue = nil
    }
    
    init?(intValue: Int) {
        self.stringValue = String(intValue)
        self.intValue = intValue
    }
}

struct DailyNutrition {
    var calories: Int = 0
    var protein: Double = 0.0
    var carbs: Double = 0.0
    var fat: Double = 0.0
    var preparationTime: Int = 0
    var dailyCalorieLimit: Int = 2000 // Varsayılan günlük kalori hedefi
    
    var formattedProtein: String {
        return String(format: "%.1f", protein)
    }
    
    var formattedCarbs: String {
        return String(format: "%.1f", carbs)
    }
    
    var formattedFat: String {
        return String(format: "%.1f", fat)
    }
    
    var preparationTimeText: String {
        if preparationTime == 0 {
            return "Hazır"
        } else if preparationTime < 60 {
            return "\(preparationTime) dk"
        } else {
            let hours = preparationTime / 60
            let minutes = preparationTime % 60
            if minutes == 0 {
                return "\(hours) saat"
            } else {
                return "\(hours) saat \(minutes) dk"
            }
        }
    }
    
    var isOverLimit: Bool {
        return calories > dailyCalorieLimit
    }
    
    var calorieWarningText: String {
        if isOverLimit {
            let excess = calories - dailyCalorieLimit
            return "⚠️ Günlük kalori limitini \(excess) kalori aştınız!"
        }
        return ""
    }
    
    var remainingCalories: Int {
        return max(0, dailyCalorieLimit - calories)
    }
}

struct APIResponse: Decodable {
    let success: Bool
    let message: String
    let data: [String: Any]?
    
    enum CodingKeys: String, CodingKey {
        case success, message, data
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        success = try container.decode(Bool.self, forKey: .success)
        message = try container.decode(String.self, forKey: .message)
        
        // data alanını [String: Any] olarak decode et
        if container.contains(.data) {
            let dataContainer = try container.nestedContainer(keyedBy: JSONKeys.self, forKey: .data)
            var dataDict: [String: Any] = [:]
            
            for key in dataContainer.allKeys {
                if let stringValue = try? dataContainer.decode(String.self, forKey: key) {
                    dataDict[key.stringValue] = stringValue
                } else if let intValue = try? dataContainer.decode(Int.self, forKey: key) {
                    dataDict[key.stringValue] = intValue
                } else if let arrayValue = try? dataContainer.decode([[String: String]].self, forKey: key) {
                    dataDict[key.stringValue] = arrayValue
                }
            }
            data = dataDict.isEmpty ? nil : dataDict
        } else {
            data = nil
        }
    }
}
