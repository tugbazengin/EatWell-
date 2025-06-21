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
    
    let baseURL = "http://localhost:5002/api/auth"

    init() {
        fetchUserData()
    }
    
    private func fetchUserData() {
        guard let url = URL(string: "\(baseURL)/me") else { return }
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        
        if let token = UserDefaults.standard.string(forKey: "jwtToken") {
            request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        }
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            DispatchQueue.main.async {
                if let error = error {
                    print("Dashboard data fetch error: \(error.localizedDescription)")
                    return
                }
                
                guard let data = data,
                      let json = try? JSONSerialization.jsonObject(with: data) as? [String: Any],
                      let userData = json["data"] as? [String: Any] else {
                    print("Failed to parse user data")
                    return
                }
                
                // Update user name
                let name = userData["name"] as? String ?? ""
                let lastname = userData["lastname"] as? String ?? ""
                self.userName = "\(name) \(lastname)".trimmingCharacters(in: .whitespaces)
                
                // Calculate BMI if height and weight available
                if let height = userData["height"] as? Double,
                   let weight = userData["weight"] as? Double,
                   height > 0 {
                    let heightInMeters = height / 100
                    let bmiValue = weight / (heightInMeters * heightInMeters)
                    self.bmi = String(format: "%.1f BMI", bmiValue)
                }
                
                // Calculate daily calories if age, height, weight available
                if let age = userData["age"] as? Int,
                   let height = userData["height"] as? Double,
                   let weight = userData["weight"] as? Double,
                   let targetWeight = userData["targetWeight"] as? Double {
                    let bmr = 10 * weight + 6.25 * height - 5 * Double(age) + 5
                    let deficitCalories = (weight - targetWeight) * 7700 / 30
                    let dailyCalorieIntake = max(1200, bmr - deficitCalories)
                    self.dailyCalories = String(format: "%.0f kcal", dailyCalorieIntake)
                }
                
                // Calculate water intake
                if let weight = userData["weight"] as? Double {
                    let waterIntake = weight * 0.033
                    self.waterIntake = String(format: "%.1f L", waterIntake)
                }
            }
        }.resume()
    }
}
