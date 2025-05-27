//
//  ResetPasswordViewModel.swift
//  EatWell
//
//  Created by Tuğba Zengin on 24.05.2025.
//

import Foundation
import Combine

class ResetPasswordViewModel: ObservableObject {
    enum ResetMethod {
        case email, phone
    }
    
    @Published var resetMethod: ResetMethod = .email
    @Published var resetData = ResetPasswordData()
    
    @Published var isVerificationSent = false
    @Published var isVerified = false
    @Published var isPasswordReset = false
    
    @Published var navigateToAuthView = false
    
    func handleButtonPress() {
        if isVerified {
            // Şifre sıfırlama işlemi..... (backend
            isPasswordReset = true
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                self.navigateToAuthView = true
            }
        } else if isVerificationSent {
            // Doğrulama kodu kontrolü ....backend
            isVerified = true
        } else {
            // Doğrulama kodu gönderme işlemi yapılır...
            isVerificationSent = true
        }
    }
    
    func resetAll() {
        resetData = ResetPasswordData()
        isVerificationSent = false
        isVerified = false
        isPasswordReset = false
        navigateToAuthView = false
    }
}
