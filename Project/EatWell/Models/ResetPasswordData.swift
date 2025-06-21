//
//  ResetPasswordData.swift
//  EatWell
//
//  Created by Tuğba Zengin on 24.05.2025.
//
import Foundation

struct ResetPasswordData {
    var email: String = ""
    var phoneNumber: String = ""
    var verificationCode: String = ""
    var newPassword: String = ""
}



//
//  ResetPasswordData.swift
//  EatWell
//
//  Created by Tuğba Zengin on 24.05.2025.
//
import Foundation

struct ResetPasswordData {
    var email: String
    var phoneNumber: String
    var verificationCode: String
    var newPassword: String

    init(email: String = "",
         phoneNumber: String = "",
         verificationCode: String = "",
         newPassword: String = "") {
        self.email = email
        self.phoneNumber = phoneNumber
        self.verificationCode = verificationCode
        self.newPassword = newPassword
    }
}

