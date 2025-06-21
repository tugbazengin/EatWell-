//
//  UserCredentials.swift
//  EatWell
//
//  Created by Tuğba Zengin on 22.05.2025.
//
import Foundation

struct UserCredentials {
    var email: String
    var password: String

    init(email: String, password: String) {
        self.email = email
        self.password = password
    }
}
