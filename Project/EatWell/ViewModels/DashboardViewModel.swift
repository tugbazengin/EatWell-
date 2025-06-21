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
    
    init() {
        loadUserProfile()
    }
    
    func loadUserProfile() {
        isLoading = true
        
        guard let token = UserDefaults.standard.string(forKey: "user_token") else {
            print("Token bulunamadı")
            isLoading = false
            return
        }
        
        guard let url = URL(string: "http://localhost:5002/api/auth/me") else {
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
                        
                        // BMI hesapla (eğer height ve weight varsa)
                        if let height = result.data.height, let weight = result.data.weight, height > 0 {
                            let heightInMeters = Double(height) / 100
                            let bmi = Double(weight) / (heightInMeters * heightInMeters)
                            self?.bmi = String(format: "%.1f BMI", bmi)
                        }
                    }
                } catch {
                    print("JSON decode hatası: \(error)")
                }
            }
        }.resume()
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
