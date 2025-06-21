//
//  ResetPasswordData.swift
//  EatWell
//
//  Created by Tuğba Zengin on 24.05.2025.
//
import Foundation

struct ResetPasswordData {
    var email: String
    var verificationCode: String
    var newPassword: String
    var temporaryToken: String?

    init(email: String = "",
         verificationCode: String = "",
         newPassword: String = "",
         temporaryToken: String? = nil) {
        self.email = email
        self.verificationCode = verificationCode
        self.newPassword = newPassword
        self.temporaryToken = temporaryToken
    }
}

