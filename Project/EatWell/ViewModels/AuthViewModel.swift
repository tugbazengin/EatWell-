//
//  AuthViewModel.swift
//  EatWell
//
//  Created by Tuğba Zengin on 22.05.2025.
//
import Foundation

class AuthViewModel: ObservableObject {
    @Published var email: String = ""
    @Published var password: String = ""
    @Published var isRegistering: Bool = false
    @Published var navigateToProfileSetup = false
    @Published var navigateToDashboard = false
    @Published var navigateToResetPassword = false

    func authenticate() {
        if isRegistering {
            // Kayıt olma işlemini burada yapabilirz...(Firebase'e bağlanınca)
            navigateToProfileSetup = true
        } else {
            // Giriş işlemini burada yapılabiliriz ..(Firebase login)
            navigateToDashboard = true
        }
    }
}

