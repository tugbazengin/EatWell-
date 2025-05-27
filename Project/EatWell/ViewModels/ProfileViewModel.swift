//
//  ProfileViewModel.swift
//  EatWell
//
//  Created by Tuğba Zengin on 23.05.2025.
//
import Foundation
import SwiftUI

class ProfileViewModel: ObservableObject {
    @Published var profile = UserProfile(
        fullName: "Adınız Soyadınız",
        age: 25,
        height: 170.0,
        weight: 70.0,
        phoneNumber: "555-123-4567",
        targetWeight: 65.0,
        bmi: "22.5",
        dailyCalories: "2000",
        dailyWaterIntake: "2.3"
        
    )
    
    @Published var isEditing: Bool = false
    @Published var showDeleteConfirmation: Bool = false
    @Published var navigateToAuth: Bool = false

    func deleteProfile() {
        // Gerçek silme işlemlerini buraya ekleyecceğiz.
        navigateToAuth = true
    }
}

