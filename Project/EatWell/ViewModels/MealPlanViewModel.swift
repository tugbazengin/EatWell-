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
    @Published var showSaveSuccess = false
    @Published var isSaved = false
    
    private let baseURL = APIConfig.generalURL
    private let currentDate = Date()
    
    // Kategoriler
    let categories = ["Kahvaltı", "Öğle Yemeği", "Akşam Yemeği", "Atıştırmalık", "Çorba", "Tatlı"]
    let mainMealCategories = ["Kahvaltı", "Öğle Yemeği", "Akşam Yemeği", "Atıştırmalık"]
    
    init() {
        // Direkt API'den veri çek, sample data yükleme
        fetchMeals()
        
        // Kaydedilmiş planı yükle (tarih kontrolü ile)
        loadSavedMealPlan()
        
        // Profil güncellendiğinde kalori sınırını yeniden hesapla
        NotificationCenter.default.addObserver(
            forName: .profileUpdated,
            object: nil,
            queue: .main
        ) { [weak self] _ in
            self?.checkCalorieLimit()
        }
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
            if endpoint.contains("/categories") {
                // Kategorilere göre gruplanan veri için CategorizedMealsResponse kullan
                let apiResponse = try JSONDecoder().decode(CategorizedMealsResponse.self, from: data)
                
                if apiResponse.success {
                    return processCategorizedMeals(from: apiResponse.data)
                } else {
                    print("❌ API başarısız: \(apiResponse.message)")
                }
            } else {
                // Düz liste için MealsListResponse kullan
                let apiResponse = try JSONDecoder().decode(MealsListResponse.self, from: data)
                
                if apiResponse.success {
                    return apiResponse.data.meals
                } else {
                    print("❌ API başarısız: \(apiResponse.message)")
                }
            }
            
        } catch {
            print("❌ Network hatası: \(error)")
        }
        
        return []
    }
    
    private func processCategorizedMeals(from categoryData: [String: [Meal]]) -> [Meal] {
        var allMeals: [Meal] = []
        
        // Kategorileri güncelle
        DispatchQueue.main.async {
            self.mealsByCategory = categoryData
            print("✅ mealsByCategory güncellendi: \(self.mealsByCategory.mapValues { $0.count })")
        }
        
        // Tüm yemekleri birleştir
        for (category, meals) in categoryData {
            allMeals.append(contentsOf: meals)
            print("🍽️ \(category): \(meals.count) yemek yüklendi")
        }
        
        print("📊 Toplam yemek sayısı: \(allMeals.count)")
        print("📋 Kategoriler: \(categoryData.keys)")
        
        return allMeals
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
            isSaved = false // Plan değişti, kaydedilmemiş oldu
        }
    }
    
    func removeMealFromPlan(meal: Meal, category: String) {
        selectedMeals[category]?.removeAll { $0.id == meal.id }
        calculateDailyNutrition()
        checkCalorieLimit()
        isSaved = false // Plan değişti, kaydedilmemiş oldu
    }
    
    func clearMealPlan() {
        for category in mainMealCategories {
            selectedMeals[category] = []
        }
        dailyNutrition = DailyNutrition()
        isSaved = false
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
    
    // MARK: - Meal Plan Persistence
    func saveMealPlan() {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let todayString = dateFormatter.string(from: currentDate)
        
        // Seçilen yemekleri UserDefaults'a kaydet
        do {
            let encoder = JSONEncoder()
            let selectedMealsData = try encoder.encode(selectedMeals)
            let nutritionData = try encoder.encode(dailyNutrition)
            
            UserDefaults.standard.set(selectedMealsData, forKey: "savedMealPlan_\(todayString)")
            UserDefaults.standard.set(nutritionData, forKey: "savedNutrition_\(todayString)")
            UserDefaults.standard.set(todayString, forKey: "lastSavedPlanDate")
            UserDefaults.standard.synchronize()
            
            print("✅ Beslenme planı kaydedildi: \(todayString)")
            
            isSaved = true
            showSaveSuccess = true
            
            // 3 saniye sonra success mesajını gizle
            DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                self.showSaveSuccess = false
            }
            
        } catch {
            print("❌ Beslenme planı kaydetme hatası: \(error)")
            handleError("Beslenme planı kaydedilemedi")
        }
    }
    
    private func loadSavedMealPlan() {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let todayString = dateFormatter.string(from: currentDate)
        
        // Kaydedilen tarihi kontrol et
        let lastSavedDate = UserDefaults.standard.string(forKey: "lastSavedPlanDate")
        
        // Bugünkü tarih ile aynı değilse planı sıfırla
        if lastSavedDate != todayString {
            print("📅 Tarih değişmiş (\(lastSavedDate ?? "yok") -> \(todayString)), plan sıfırlanıyor")
            clearMealPlan()
            isSaved = false
            return
        }
        
        // Kaydedilen planı yükle
        if let savedMealsData = UserDefaults.standard.data(forKey: "savedMealPlan_\(todayString)"),
           let savedNutritionData = UserDefaults.standard.data(forKey: "savedNutrition_\(todayString)") {
            
            do {
                let decoder = JSONDecoder()
                let loadedMeals = try decoder.decode([String: [Meal]].self, from: savedMealsData)
                let loadedNutrition = try decoder.decode(DailyNutrition.self, from: savedNutritionData)
                
                self.selectedMeals = loadedMeals
                self.dailyNutrition = loadedNutrition
                self.isSaved = true
                
                print("✅ Kaydedilmiş beslenme planı yüklendi: \(todayString)")
                
            } catch {
                print("❌ Kaydedilmiş plan yükleme hatası: \(error)")
                clearMealPlan()
                isSaved = false
            }
        } else {
            print("📝 Bugün için kaydedilmiş plan bulunamadı")
            isSaved = false
        }
    }
    
    func deleteSavedMealPlan() {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let todayString = dateFormatter.string(from: currentDate)
        
        UserDefaults.standard.removeObject(forKey: "savedMealPlan_\(todayString)")
        UserDefaults.standard.removeObject(forKey: "savedNutrition_\(todayString)")
        UserDefaults.standard.removeObject(forKey: "lastSavedPlanDate")
        UserDefaults.standard.synchronize()
        
        isSaved = false
        print("🗑️ Kaydedilmiş beslenme planı silindi")
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

struct DailyNutrition: Codable {
    var calories: Int = 0
    var protein: Double = 0.0
    var carbs: Double = 0.0
    var fat: Double = 0.0
    var preparationTime: Int = 0
    
    // Kullanıcının gerçek günlük kalori ihtiyacını al
    var dailyCalorieLimit: Int {
        return UserDefaults.standard.integer(forKey: "dailyCalorieLimit") > 0 
            ? UserDefaults.standard.integer(forKey: "dailyCalorieLimit") 
            : 2000 // Varsayılan değer
    }
    
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

// MARK: - API Response Models
struct CategorizedMealsResponse: Codable {
    let success: Bool
    let message: String
    let data: [String: [Meal]]
}

struct MealsListResponse: Codable {
    let success: Bool
    let message: String
    let data: MealsData
}

struct MealsData: Codable {
    let meals: [Meal]
    let pagination: Pagination?
}

struct Pagination: Codable {
    let current: Int
    let total: Int
    let count: Int
    let totalItems: Int
}
