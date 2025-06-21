//
//  AuthViewModel.swift
//  EatWell
//
//  Created by Tuğba Zengin on 22.05.2025.
//
import Foundation

class AuthViewModel: ObservableObject {
    @Published var email: String
    @Published var password: String
    @Published var isRegistering: Bool
    @Published var navigateToProfileSetup: Bool
    @Published var navigateToDashboard: Bool
    @Published var navigateToResetPassword: Bool
    @Published var errorMessage: String?

    let baseURL = "http://localhost:5002/api/auth"

    init(email: String = "",
         password: String = "",
         isRegistering: Bool = false,
         navigateToProfileSetup: Bool = false,
         navigateToDashboard: Bool = false,
         navigateToResetPassword: Bool = false) {
        self.email = email
        self.password = password
        self.isRegistering = isRegistering
        self.navigateToProfileSetup = navigateToProfileSetup
        self.navigateToDashboard = navigateToDashboard
        self.navigateToResetPassword = navigateToResetPassword
    }

    func authenticate() {
        if isRegistering {
            register()
        } else {
            login()
        }
    }

    private func register() {
        print("🔥 Registration started")
        guard let url = URL(string: "\(baseURL)/register") else { 
            print("❌ Invalid URL")
            return 
        }
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        let body: [String: Any] = [
            "email": email,
            "password": password,
            "name": "Test", // TODO: Kayıt ekranından alınmalı
            "lastname": "User" // TODO: Kayıt ekranından alınmalı
        ]
        request.httpBody = try? JSONSerialization.data(withJSONObject: body)
        print("🚀 Sending registration request to: \(url)")
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            DispatchQueue.main.async {
                if let error = error {
                    print("❌ Registration error: \(error.localizedDescription)")
                    self.errorMessage = error.localizedDescription
                    return
                }
                
                if let httpResponse = response as? HTTPURLResponse {
                    print("📡 HTTP Status Code: \(httpResponse.statusCode)")
                }
                
                guard let data = data else {
                    print("❌ No data received")
                    self.errorMessage = "Sunucudan yanıt alınamadı."
                    return
                }
                
                if let responseString = String(data: data, encoding: .utf8) {
                    print("📥 Response: \(responseString)")
                }
                
                guard let json = try? JSONSerialization.jsonObject(with: data) as? [String: Any] else {
                    print("❌ Failed to parse JSON")
                    self.errorMessage = "Geçersiz sunucu yanıtı."
                    return
                }
                
                if let success = json["success"] as? Bool, success == true {
                    if let token = json["token"] as? String {
                        print("✅ Registration successful! Token received: \(token.prefix(20))...")
                        UserDefaults.standard.set(token, forKey: "jwtToken")
                        UserDefaults.standard.set(true, forKey: "isLoggedIn")
                        print("🏠 Setting navigateToProfileSetup to true")
                        self.errorMessage = nil
                        self.navigateToProfileSetup = true
                        print("🏠 navigateToProfileSetup is now: \(self.navigateToProfileSetup)")
                    } else {
                        print("❌ No token in successful response")
                        self.errorMessage = "Token alınamadı."
                    }
                } else {
                    let message = json["message"] as? String ?? "Kayıt başarısız."
                    print("❌ Registration failed: \(message)")
                    self.errorMessage = message
                }
            }
        }.resume()
    }

    private func login() {
        guard let url = URL(string: "\(baseURL)/login") else { return }
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        let body: [String: Any] = [
            "email": email,
            "password": password
        ]
        request.httpBody = try? JSONSerialization.data(withJSONObject: body)
        URLSession.shared.dataTask(with: request) { data, response, error in
            DispatchQueue.main.async {
                if let error = error {
                    self.errorMessage = error.localizedDescription
                    return
                }
                guard let data = data,
                      let json = try? JSONSerialization.jsonObject(with: data) as? [String: Any],
                      let token = json["token"] as? String else {
                    self.errorMessage = "Giriş başarısız."
                    return
                }
                UserDefaults.standard.set(token, forKey: "jwtToken")
                self.navigateToDashboard = true
        }
        }.resume()
    }
}
