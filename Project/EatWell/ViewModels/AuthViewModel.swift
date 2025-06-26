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
    @Published var isLoading: Bool = false
    @Published var showError: Bool = false

    let baseURL = APIConfig.authURL

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
        isLoading = true
        errorMessage = nil
        showError = false
        
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
            "name": "Kullanıcı", // Geçici isim - ProfileSetup'ta güncellenecek
            "lastname": "Adı" // Geçici soyisim - ProfileSetup'ta güncellenecek
        ]
        request.httpBody = try? JSONSerialization.data(withJSONObject: body)
        print("🚀 Sending registration request to: \(url)")
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            DispatchQueue.main.async {
                if let error = error {
                    print("❌ Registration error: \(error.localizedDescription)")
                    self.showErrorMessage(error.localizedDescription)
                    return
                }
                
                if let httpResponse = response as? HTTPURLResponse {
                    print("📡 HTTP Status Code: \(httpResponse.statusCode)")
                }
                
                guard let data = data else {
                    print("❌ No data received")
                    self.showErrorMessage("Sunucudan yanıt alınamadı.")
                    return
                }
                
                if let responseString = String(data: data, encoding: .utf8) {
                    print("📥 Response: \(responseString)")
                }
                
                guard let json = try? JSONSerialization.jsonObject(with: data) as? [String: Any] else {
                    print("❌ Failed to parse JSON")
                    self.showErrorMessage("Geçersiz sunucu yanıtı.")
                    return
                }
                
                if let success = json["success"] as? Bool, success == true {
                    if let token = json["token"] as? String {
                        print("✅ Registration successful! Token received: \(token.prefix(20))...")
                        UserDefaults.standard.set(token, forKey: "user_token")
                        UserDefaults.standard.set(true, forKey: "isLoggedIn")
                        print("🏠 Setting navigateToProfileSetup to true")
                        self.isLoading = false
                        self.errorMessage = nil
                        self.navigateToProfileSetup = true
                        print("🏠 navigateToProfileSetup is now: \(self.navigateToProfileSetup)")
                    } else {
                        print("❌ No token in successful response")
                        self.showErrorMessage("Token alınamadı.")
                    }
                } else {
                    let message = json["message"] as? String ?? "Kayıt başarısız."
                    print("❌ Registration failed: \(message)")
                    
                    // Backend'den gelen hata mesajlarını kullanıcı dostu hale getir
                    let userFriendlyMessage: String
                    if message.contains("zaten mevcut") || message.contains("already exists") || message.contains("already registered") {
                        userFriendlyMessage = "Bu e-posta adresi zaten kayıtlı. Giriş yapmayı deneyin."
                    } else if message.contains("geçersiz e-posta") || message.contains("invalid email") {
                        userFriendlyMessage = "Geçersiz e-posta adresi formatı"
                    } else if message.contains("şifre çok kısa") || message.contains("password too short") {
                        userFriendlyMessage = "Şifre en az 6 karakter olmalıdır"
                    } else {
                        userFriendlyMessage = message
                    }
                    
                    self.showErrorMessage(userFriendlyMessage)
                }
            }
        }.resume()
    }

    private func login() {
        print("🔑 Login started")
        guard let url = URL(string: "\(baseURL)/login") else { 
            showErrorMessage("Geçersiz sunucu adresi")
            return 
        }
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        let body: [String: Any] = [
            "email": email,
            "password": password
        ]
        request.httpBody = try? JSONSerialization.data(withJSONObject: body)
        print("🚀 Sending login request to: \(url)")
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            DispatchQueue.main.async {
                if let error = error {
                    print("❌ Login error: \(error.localizedDescription)")
                    self.showErrorMessage("Bağlantı hatası: \(error.localizedDescription)")
                    return
                }
                
                if let httpResponse = response as? HTTPURLResponse {
                    print("📡 HTTP Status Code: \(httpResponse.statusCode)")
                }
                
                guard let data = data else {
                    print("❌ No data received")
                    self.showErrorMessage("Sunucudan yanıt alınamadı")
                    return
                }
                
                if let responseString = String(data: data, encoding: .utf8) {
                    print("📥 Response: \(responseString)")
                }
                
                guard let json = try? JSONSerialization.jsonObject(with: data) as? [String: Any] else {
                    print("❌ Failed to parse JSON")
                    self.showErrorMessage("Geçersiz sunucu yanıtı")
                    return
                }
                
                if let success = json["success"] as? Bool, success == true {
                    if let token = json["token"] as? String {
                        print("✅ Login successful! Token received: \(token.prefix(20))...")
                        UserDefaults.standard.set(token, forKey: "user_token")
                        UserDefaults.standard.set(true, forKey: "isLoggedIn")
                        self.isLoading = false
                        self.errorMessage = nil
                        self.navigateToDashboard = true
                    } else {
                        print("❌ No token in successful response")
                        self.showErrorMessage("Giriş token'ı alınamadı")
                    }
                } else {
                    let message = json["message"] as? String ?? "Giriş başarısız"
                    print("❌ Login failed: \(message)")
                    
                    // Backend'den gelen hata mesajlarını kullanıcı dostu hale getir
                    let userFriendlyMessage: String
                    if message.contains("kullanıcı bulunamadı") || message.contains("User not found") {
                        userFriendlyMessage = "Bu e-posta adresiyle kayıtlı kullanıcı bulunamadı"
                    } else if message.contains("şifre yanlış") || message.contains("Invalid password") {
                        userFriendlyMessage = "Hatalı şifre girdiniz"
                    } else if message.contains("Invalid credentials") {
                        userFriendlyMessage = "E-posta veya şifre hatalı"
                    } else {
                        userFriendlyMessage = message
                    }
                    
                    self.showErrorMessage(userFriendlyMessage)
                }
            }
        }.resume()
    }

    private func showErrorMessage(_ message: String) {
        self.errorMessage = message
        self.showError = true
        self.isLoading = false
        
        // 5 saniye sonra hata mesajını gizle
        DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
            self.showError = false
            self.errorMessage = nil
        }
    }
}
