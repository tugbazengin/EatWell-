//
//  ProfileSetupViewModel.swift
//  EatWell
//
//  Created by Tuğba Zengin on 23.05.2025.
//
import Foundation
import SwiftUI

class ProfileSetupViewModel: ObservableObject {
    @Published var user = UserProfile(
        fullName: "",
        age: 0,
        height: 0.0,
        weight: 0.0,
        phoneNumber: "",
        targetWeight: 70.0
    )
    
    @Published var isProfileCompleted = false
    
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
        // Buraya Firebase veya veri kaydetme işlemlerini ekleyeceğiz.
        isProfileCompleted = true
    }
}

