//
//  ProfileViewModel.swift
//  EatWell
//
//  Created by Tuğba Zengin on 23.05.2025.
//
import Foundation
import SwiftUI

class ProfileViewModel: ObservableObject {
    @Published var profile: UserProfile
    @Published var isEditing: Bool
    @Published var showDeleteConfirmation: Bool
    @Published var navigateToAuth: Bool
    @Published var errorMessage: String?
    let baseURL = "http://localhost:5002/api/auth"

    init() {
        self.profile = UserProfile(fullName: "", age: 0, height: 0, weight: 0, phoneNumber: "", targetWeight: 0, bmi: nil, dailyCalories: nil, dailyWaterIntake: nil, dailyWater: 0)
        self.isEditing = false
        self.showDeleteConfirmation = false
        self.navigateToAuth = false
        fetchProfile()
    }

    func fetchProfile() {
        guard let url = URL(string: "\(baseURL)/me") else { return }
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        if let token = UserDefaults.standard.string(forKey: "jwtToken") {
            request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        }
        URLSession.shared.dataTask(with: request) { data, response, error in
            DispatchQueue.main.async {
                if let error = error {
                    self.errorMessage = error.localizedDescription
                    return
                }
                guard let data = data,
                      let json = try? JSONSerialization.jsonObject(with: data) as? [String: Any],
                      let user = json["data"] as? [String: Any] else {
                    self.errorMessage = "Profil alınamadı."
                    return
                }
                let fullName = "\(user["name"] as? String ?? "") \(user["lastname"] as? String ?? "")"
                let age = user["age"] as? Int ?? 0
                let height = user["height"] as? Double ?? 0
                let weight = user["weight"] as? Double ?? 0
                let phoneNumber = user["phone"] as? String ?? ""
                let targetWeight = user["targetWeight"] as? Double ?? 0
                self.profile = UserProfile(fullName: fullName, age: age, height: height, weight: weight, phoneNumber: phoneNumber, targetWeight: targetWeight, bmi: nil, dailyCalories: nil, dailyWaterIntake: nil, dailyWater: 0)
            }
        }.resume()
    }

    func updateProfile() {
        guard let url = URL(string: "\(baseURL)/update-profile") else { return }
        var request = URLRequest(url: url)
        request.httpMethod = "PUT"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        if let token = UserDefaults.standard.string(forKey: "jwtToken") {
            request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        }
        let nameParts = profile.fullName.split(separator: " ")
        let name = nameParts.first.map(String.init) ?? ""
        let lastname = nameParts.dropFirst().joined(separator: " ")
        let body: [String: Any] = [
            "name": name,
            "lastname": lastname,
            "age": profile.age,
            "height": profile.height,
            "weight": profile.weight,
            "phone": profile.phoneNumber,
            "targetWeight": profile.targetWeight
        ]
        request.httpBody = try? JSONSerialization.data(withJSONObject: body)
        URLSession.shared.dataTask(with: request) { data, response, error in
            DispatchQueue.main.async {
                if let error = error {
                    self.errorMessage = error.localizedDescription
                    return
                }
                self.fetchProfile()
            }
        }.resume()
    }

    func deleteProfile() {
        // Gerçek silme işlemlerini buraya ekleyeceğiz.
        navigateToAuth = true
    }
}
