//
//  DashboardViewModel.swift
//  EatWell
//
//  Created by Tuğba Zengin on 22.05.2025.
//

import Foundation

class DashboardViewModel: ObservableObject {
    @Published var userName: String = "Kullanıcı"
    @Published var dailyCalories: String = "2000 kcal"
    @Published var bmi: String = "22.5 BMI"
    @Published var waterIntake: String = "2.5 L"
    @Published var motivationQuote: String = "Başarı, küçük ama istikrarlı adımlarla gelir! 💪"
    @Published var isLoading: Bool = false
    
    // Kullanıcı verileri
    private var userAge: Int = 0
    private var userHeight: Double = 0
    private var userWeight: Double = 0
    private var userTargetWeight: Double = 0
    
    init() {
        loadUserProfile()
        
        // Profil güncellendiğinde dashboard'ı yenile
        NotificationCenter.default.addObserver(
            forName: .profileUpdated,
            object: nil,
            queue: .main
        ) { [weak self] _ in
            self?.loadUserProfile()
        }
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    func loadUserProfile() {
        isLoading = true
        
        guard let token = UserDefaults.standard.string(forKey: "user_token") else {
            print("Token bulunamadı")
            isLoading = false
            return
        }
        
        guard let url = URL(string: "\(APIConfig.authURL)/me") else {
            print("Geçersiz URL")
            isLoading = false
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        URLSession.shared.dataTask(with: request) { [weak self] data, response, error in
            DispatchQueue.main.async {
                self?.isLoading = false
                
                if let error = error {
                    print("Network hatası: \(error)")
                    return
                }
                
                guard let data = data else {
                    print("Veri alınamadı")
                    return
                }
                
                do {
                    let result = try JSONDecoder().decode(UserProfileResponse.self, from: data)
                    if result.success {
                        self?.userName = result.data.name
                        
                        // Kullanıcı verilerini kaydet
                        self?.userAge = result.data.age ?? 25
                        self?.userHeight = Double(result.data.height ?? 170)
                        self?.userWeight = Double(result.data.weight ?? 70)
                        self?.userTargetWeight = Double(result.data.targetWeight ?? 65)
                        
                        // Hesaplamaları yap
                        self?.calculateHealthMetrics()
                    }
                } catch {
                    print("JSON decode hatası: \(error)")
                }
            }
        }.resume()
    }
    
    private func calculateHealthMetrics() {
        calculateBMI()
        calculateDailyCalories()
        calculateDailyWaterIntake()
    }
    
    private func calculateBMI() {
        guard userHeight > 0 && userWeight > 0 else {
            bmi = "-- BMI"
            return
        }
        let heightInMeters = userHeight / 100
        let bmiValue = userWeight / (heightInMeters * heightInMeters)
        bmi = String(format: "%.1f BMI", bmiValue)
    }
    
    private func calculateDailyCalories() {
        guard userHeight > 0 && userWeight > 0 && userAge > 0 else {
            dailyCalories = "-- kcal"
            return
        }
        
        // BMR hesaplama (Mifflin-St Jeor Equation for women)
        let bmr = 10 * userWeight + 6.25 * userHeight - 5 * Double(userAge) + 5
        
        // Hedef kilo farkı varsa deficit hesapla
        let deficitCalories = userTargetWeight > 0 ? (userWeight - userTargetWeight) * 7700 / 30 : 0
        
        // Minimum 1200 kalori
        let dailyCalorieIntake = max(1200, bmr - deficitCalories)
        
        dailyCalories = String(format: "%.0f kcal", dailyCalorieIntake)
    }
    
    private func calculateDailyWaterIntake() {
        guard userWeight > 0 else {
            waterIntake = "-- L"
            return
        }
        
        let waterIntakeValue = userWeight * 0.033
        waterIntake = String(format: "%.1f L", waterIntakeValue)
    }
    
    // Profil güncellendiğinde dashboard'ı yenile
    func refreshDashboard() {
        loadUserProfile()
    }
}

struct UserProfileResponse: Codable {
    let success: Bool
    let message: String
    let data: UserData
}

struct UserData: Codable {
    let _id: String
    let name: String
    let lastname: String
    let email: String
    let phone: String?
    let birthDate: String?
    let age: Int?
    let height: Int?
    let weight: Int?
    let targetWeight: Int?
}
