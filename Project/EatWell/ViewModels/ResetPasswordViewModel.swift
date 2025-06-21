//
//  ResetPasswordViewModel.swift
//  EatWell
//
//  Created by Tuğba Zengin on 24.05.2025.
//

import Foundation
import Combine

class ResetPasswordViewModel: ObservableObject {
    @Published var resetData = ResetPasswordData()
    
    @Published var isVerificationSent = false
    @Published var isVerified = false
    @Published var isPasswordReset = false
    @Published var isLoading = false
    @Published var errorMessage: String?
    @Published var showError = false
    
    @Published var navigateToAuthView = false
    
    let baseURL = "http://localhost:5002/api/auth"

    func handleButtonPress() {
        if !isPasswordReset {
            if isVerified {
                // Yeni şifreyi kaydet
                resetPassword()
            } else if isVerificationSent {
                // Doğrulama kodunu kontrol et
                verifyCode()
            } else {
                // E-posta gönder
                sendResetEmail()
            }
        }
    }
    
    private func sendResetEmail() {
        print("📧 Şifre sıfırlama e-postası gönderiliyor...")
        isLoading = true
        errorMessage = nil
        showError = false
        
        guard let url = URL(string: "\(baseURL)/forget-password") else {
            showErrorMessage("Geçersiz sunucu adresi")
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let body: [String: Any] = [
            "email": resetData.email
        ]
        request.httpBody = try? JSONSerialization.data(withJSONObject: body)
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            DispatchQueue.main.async {
                self.isLoading = false
                
                if let error = error {
                    print("❌ E-posta gönderme hatası: \(error.localizedDescription)")
                    self.showErrorMessage("Bağlantı hatası: \(error.localizedDescription)")
                    return
                }
                
                guard let data = data else {
                    print("❌ Sunucudan yanıt alınamadı")
                    self.showErrorMessage("Sunucudan yanıt alınamadı")
                    return
                }
                
                if let responseString = String(data: data, encoding: .utf8) {
                    print("📥 Response: \(responseString)")
                }
                
                guard let json = try? JSONSerialization.jsonObject(with: data) as? [String: Any] else {
                    print("❌ JSON parse hatası")
                    self.showErrorMessage("Geçersiz sunucu yanıtı")
                    return
                }
                
                if let success = json["success"] as? Bool, success == true {
                    print("✅ E-posta başarıyla gönderildi!")
                    self.isVerificationSent = true
                } else {
                    let message = json["message"] as? String ?? "E-posta gönderilemedi"
                    print("❌ E-posta gönderme başarısız: \(message)")
                    
                    // User-friendly hata mesajları
                    let userFriendlyMessage: String
                    if message.contains("bulunamadı") || message.contains("not found") {
                        userFriendlyMessage = "Bu e-posta adresiyle kayıtlı kullanıcı bulunamadı"
                    } else if message.contains("geçersiz e-posta") || message.contains("invalid email") {
                        userFriendlyMessage = "Geçersiz e-posta adresi formatı"
                    } else {
                        userFriendlyMessage = message
                    }
                    
                    self.showErrorMessage(userFriendlyMessage)
                }
            }
        }.resume()
    }
    
    private func verifyCode() {
        print("🔍 Doğrulama kodu kontrol ediliyor...")
        isLoading = true
        errorMessage = nil
        showError = false
        
        guard let url = URL(string: "\(baseURL)/reset-code-check") else {
            showErrorMessage("Geçersiz sunucu adresi")
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let body: [String: Any] = [
            "email": resetData.email,
            "code": resetData.verificationCode
        ]
        request.httpBody = try? JSONSerialization.data(withJSONObject: body)
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            DispatchQueue.main.async {
                self.isLoading = false
                
                if let error = error {
                    print("❌ Kod doğrulama hatası: \(error.localizedDescription)")
                    self.showErrorMessage("Bağlantı hatası: \(error.localizedDescription)")
                    return
                }
                
                guard let data = data else {
                    print("❌ Sunucudan yanıt alınamadı")
                    self.showErrorMessage("Sunucudan yanıt alınamadı")
                    return
                }
                
                if let responseString = String(data: data, encoding: .utf8) {
                    print("📥 Response: \(responseString)")
                }
                
                guard let json = try? JSONSerialization.jsonObject(with: data) as? [String: Any] else {
                    print("❌ JSON parse hatası")
                    self.showErrorMessage("Geçersiz sunucu yanıtı")
                    return
                }
                
                if let success = json["success"] as? Bool, success == true {
                    print("✅ Kod doğrulandı!")
                    if let temporaryToken = json["data"] as? [String: Any],
                       let token = temporaryToken["temporaryToken"] as? String {
                        self.resetData.temporaryToken = token
                        self.isVerified = true
                    } else {
                        self.showErrorMessage("Geçici token alınamadı")
                    }
                } else {
                    let message = json["message"] as? String ?? "Kod doğrulanamadı"
                    print("❌ Kod doğrulama başarısız: \(message)")
                    
                    // User-friendly hata mesajları
                    let userFriendlyMessage: String
                    if message.contains("geçersiz") || message.contains("invalid") {
                        userFriendlyMessage = "Geçersiz doğrulama kodu"
                    } else if message.contains("süresi dolmuş") || message.contains("expired") {
                        userFriendlyMessage = "Doğrulama kodunun süresi dolmuş. Yeni kod isteyin."
                    } else {
                        userFriendlyMessage = message
                    }
                    
                    self.showErrorMessage(userFriendlyMessage)
                }
            }
        }.resume()
    }
    
    private func resetPassword() {
        print("🔑 Yeni şifre kaydediliyor...")
        isLoading = true
        errorMessage = nil
        showError = false
        
        guard let url = URL(string: "\(baseURL)/reset-password") else {
            showErrorMessage("Geçersiz sunucu adresi")
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let body: [String: Any] = [
            "password": resetData.newPassword,
            "temporaryToken": resetData.temporaryToken ?? ""
        ]
        request.httpBody = try? JSONSerialization.data(withJSONObject: body)
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            DispatchQueue.main.async {
                self.isLoading = false
                
                if let error = error {
                    print("❌ Şifre sıfırlama hatası: \(error.localizedDescription)")
                    self.showErrorMessage("Bağlantı hatası: \(error.localizedDescription)")
                    return
                }
                
                guard let data = data else {
                    print("❌ Sunucudan yanıt alınamadı")
                    self.showErrorMessage("Sunucudan yanıt alınamadı")
                    return
                }
                
                if let responseString = String(data: data, encoding: .utf8) {
                    print("📥 Response: \(responseString)")
                }
                
                guard let json = try? JSONSerialization.jsonObject(with: data) as? [String: Any] else {
                    print("❌ JSON parse hatası")
                    self.showErrorMessage("Geçersiz sunucu yanıtı")
                    return
                }
                
                if let success = json["success"] as? Bool, success == true {
                    print("✅ Şifre başarıyla sıfırlandı!")
                    self.isPasswordReset = true
                    DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                        self.navigateToAuthView = true
                    }
                } else {
                    let message = json["message"] as? String ?? "Şifre sıfırlanamadı"
                    print("❌ Şifre sıfırlama başarısız: \(message)")
                    self.showErrorMessage(message)
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

    func resetAll() {
        resetData = ResetPasswordData()
        isVerificationSent = false
        isVerified = false
        isPasswordReset = false
        isLoading = false
        errorMessage = nil
        showError = false
        navigateToAuthView = false
    }
}
