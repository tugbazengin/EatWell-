//
//  UserProfile.swift
//  EatWell
//
//  Created by Tuğba Zengin on 23.05.2025.
//
import Foundation

struct UserProfile: Codable {
    var fullName: String
    var age: Int
    var height: Double
    var weight: Double
    var phoneNumber: String
    var targetWeight: Double
    var bmi: String?
    var dailyCalories: String?
    var dailyWaterIntake: String?
    var dailyWater: Double

    init(fullName: String,
         age: Int,
         height: Double,
         weight: Double,
         phoneNumber: String,
         targetWeight: Double,
         bmi: String? = nil,
         dailyCalories: String? = nil,
         dailyWaterIntake: String? = nil,
         dailyWater: Double = 0.0) {
        self.fullName = fullName
        self.age = age
        self.height = height
        self.weight = weight
        self.phoneNumber = phoneNumber
        self.targetWeight = targetWeight
        self.bmi = bmi
        self.dailyCalories = dailyCalories
        self.dailyWaterIntake = dailyWaterIntake
        self.dailyWater = dailyWater
    }
}
