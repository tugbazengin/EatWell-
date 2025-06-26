//
//  ProfileSetupViewModel.swift
//  EatWell
//
//  Created by Tuğba Zengin on 23.05.2025.
//
import Foundation
import SwiftUI

class ProfileSetupViewModel: ObservableObject {
    @Published var user: UserProfile
    @Published var isProfileCompleted: Bool

    let baseURL = APIConfig.authURL

    init(user: UserProfile = UserProfile(
                fullName: "",
                age: 0,
                height: 0.0,
                weight: 0.0,
                phoneNumber: "",
                targetWeight: 70.0,
                bmi: nil,
                dailyCalories: nil,
                dailyWaterIntake: nil,
                dailyWater: 0.0),
         isProfileCompleted: Bool = false) {
        self.user = user
        self.isProfileCompleted = isProfileCompleted
    }
    
    func calculateBMI() {
        guard user.height > 0 else { return }
        let heightInMeters = user.height / 100
        let bmiValue = user.weight / (heightInMeters * heightInMeters)
        user.bmi = String(format: "%.2f", bmiValue)
    }
    
    func calculateDailyCalories() {
        let bmr = 10 * user.weight + 6.25 * user.height - 5 * Double(user.age) + 5
        let deficitCalories = (user.weight - user.targetWeight) * 7700 / 30
        let dailyCalorieIntake = max(1200, bmr - deficitCalories)
        user.dailyCalories = String(format: "%.0f", dailyCalorieIntake)
    }
    
    func calculateDailyWaterIntake() {
        let waterIntake = user.weight * 0.033
        user.dailyWaterIntake = String(format: "%.2f", waterIntake)
    }
    
    func saveProfile() {
        print("🔥 Profile save started")
        
        guard let token = UserDefaults.standard.string(forKey: "user_token") else {
            print("❌ No JWT token found")
            return
        }
        
        guard let url = URL(string: "\(baseURL)/update-profile") else {
            print("❌ Invalid URL")
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "PUT"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        
        // Split fullName into name and lastname
        let nameParts = user.fullName.split(separator: " ", maxSplits: 1)
        let name = String(nameParts.first ?? "")
        let lastname = nameParts.count > 1 ? String(nameParts[1]) : ""
        
        let body: [String: Any] = [
            "name": name,
            "lastname": lastname,
            "phone": user.phoneNumber,
            "age": user.age,
            "height": Int(user.height),
            "weight": Int(user.weight),
            "targetWeight": Int(user.targetWeight)
        ]
        
        request.httpBody = try? JSONSerialization.data(withJSONObject: body)
        print("🚀 Sending profile update request to: \(url)")
        print("📊 Profile data: \(body)")
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            DispatchQueue.main.async {
                if let error = error {
                    print("❌ Profile update error: \(error.localizedDescription)")
                    return
                }
                
                if let httpResponse = response as? HTTPURLResponse {
                    print("📡 HTTP Status Code: \(httpResponse.statusCode)")
                }
                
                guard let data = data else {
                    print("❌ No data received")
                    return
                }
                
                if let responseString = String(data: data, encoding: .utf8) {
                    print("📥 Response: \(responseString)")
                }
                
                guard let json = try? JSONSerialization.jsonObject(with: data) as? [String: Any] else {
                    print("❌ Failed to parse JSON")
                    return
                }
                
                if let success = json["success"] as? Bool, success {
                    print("✅ Profile updated successfully!")
                    UserDefaults.standard.set(true, forKey: "isLoggedIn")
                    self.isProfileCompleted = true
                } else {
                    let message = json["message"] as? String ?? "Profile update failed"
                    print("❌ Profile update failed: \(message)")
                }
            }
        }.resume()
    }
}


