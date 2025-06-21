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
    
    @Published var resetMethod: ResetMethod
    @Published var resetData: ResetPasswordData
    
    @Published var isVerificationSent: Bool
    @Published var isVerified: Bool
    @Published var isPasswordReset: Bool
    
    @Published var navigateToAuthView: Bool
    
    init(resetMethod: ResetMethod = .email,
         resetData: ResetPasswordData = ResetPasswordData(),
         isVerificationSent: Bool = false,
         isVerified: Bool = false,
         isPasswordReset: Bool = false,
         navigateToAuthView: Bool = false) {
        self.resetMethod = resetMethod
        self.resetData = resetData
        self.isVerificationSent = isVerificationSent
        self.isVerified = isVerified
        self.isPasswordReset = isPasswordReset
        self.navigateToAuthView = navigateToAuthView
    }
    
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
