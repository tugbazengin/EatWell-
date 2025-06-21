//
//  DashboardViewModel.swift
//  EatWell
//
//  Created by Tuğba Zengin on 22.05.2025.
//

import Foundation

class DashboardViewModel: ObservableObject {
    @Published var userName: String = "Tuğba"
    @Published var dailyCalories: String = "2000 kcal"
    @Published var bmi: String = "22.5 BMI"
    @Published var waterIntake: String = "2.5 L"
    @Published var motivationQuote: String = "Başarı, küçük ama istikrarlı adımlarla gelir! 💪"
}
