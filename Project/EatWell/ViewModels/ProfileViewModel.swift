//
//  ProfileViewModel.swift
//  EatWell
//
//  Created by Tuğba Zengin on 23.05.2025.
//
import Foundation
import SwiftUI

class ProfileViewModel: ObservableObject {
    @Published var profile: UserProfile
    @Published var isEditing: Bool
    @Published var showDeleteConfirmation: Bool
    @Published var navigateToAuth: Bool
    @Published var errorMessage: String?
    @Published var isLoading: Bool = false
    @Published var showSuccessMessage: Bool = false
    let baseURL = APIConfig.authURL

    init() {
        self.profile = UserProfile(fullName: "", age: 0, height: 0, weight: 0, phoneNumber: "", targetWeight: 0, bmi: nil, dailyCalories: nil, dailyWaterIntake: nil, dailyWater: 0)
        self.isEditing = false
        self.showDeleteConfirmation = false
        self.navigateToAuth = false
        fetchProfile()
    }

    func fetchProfile() {
        guard let url = URL(string: "\(baseURL)/me") else { return }
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        if let token = UserDefaults.standard.string(forKey: "user_token") {
            request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        }
        URLSession.shared.dataTask(with: request) { data, response, error in
            DispatchQueue.main.async {
                if let error = error {
                    self.errorMessage = error.localizedDescription
                    return
                }
                guard let data = data,
                      let json = try? JSONSerialization.jsonObject(with: data) as? [String: Any],
                      let user = json["data"] as? [String: Any] else {
                    self.errorMessage = "Profil alınamadı."
                    return
                }
                let fullName = "\(user["name"] as? String ?? "") \(user["lastname"] as? String ?? "")"
                let age = user["age"] as? Int ?? 0
                let height = user["height"] as? Double ?? 0
                let weight = user["weight"] as? Double ?? 0
                let phoneNumber = user["phone"] as? String ?? ""
                let targetWeight = user["targetWeight"] as? Double ?? 0
                self.profile = UserProfile(fullName: fullName, age: age, height: height, weight: weight, phoneNumber: phoneNumber, targetWeight: targetWeight, bmi: nil, dailyCalories: nil, dailyWaterIntake: nil, dailyWater: 0)
                
                // Profil yüklendikten sonra hesaplamaları yap
                self.calculateHealthMetrics()
            }
        }.resume()
    }

    func calculateHealthMetrics() {
        calculateBMI()
        calculateDailyCalories()
        calculateDailyWaterIntake()
    }
    
    func calculateBMI() {
        guard profile.height > 0 else { return }
        let heightInMeters = profile.height / 100
        let bmiValue = profile.weight / (heightInMeters * heightInMeters)
        profile.bmi = String(format: "%.2f", bmiValue)
    }
    
    func calculateDailyCalories() {
        let bmr = 10 * profile.weight + 6.25 * profile.height - 5 * Double(profile.age) + 5
        let deficitCalories = (profile.weight - profile.targetWeight) * 7700 / 30
        let dailyCalorieIntake = max(1200, bmr - deficitCalories)
        profile.dailyCalories = String(format: "%.0f", dailyCalorieIntake)
        
        // Günlük kalori ihtiyacını UserDefaults'a kaydet
        UserDefaults.standard.set(Int(dailyCalorieIntake), forKey: "dailyCalorieLimit")
        UserDefaults.standard.synchronize()
    }
    
    func calculateDailyWaterIntake() {
        let waterIntake = profile.weight * 0.033
        profile.dailyWaterIntake = String(format: "%.2f", waterIntake)
    }

    func updateProfile() {
        print("🔄 Profil güncelleniyor...")
        isLoading = true
        errorMessage = nil
        
        guard let url = URL(string: "\(baseURL)/update-profile") else { 
            isLoading = false
            return 
        }
        var request = URLRequest(url: url)
        request.httpMethod = "PUT"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        if let token = UserDefaults.standard.string(forKey: "user_token") {
            request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        }
        let nameParts = profile.fullName.split(separator: " ")
        let name = nameParts.first.map(String.init) ?? ""
        let lastname = nameParts.dropFirst().joined(separator: " ")
        let body: [String: Any] = [
            "name": name,
            "lastname": lastname,
            "age": profile.age,
            "height": profile.height,
            "weight": profile.weight,
            "phone": profile.phoneNumber,
            "targetWeight": profile.targetWeight
        ]
        print("📤 Gönderilen veriler: \(body)")
        request.httpBody = try? JSONSerialization.data(withJSONObject: body)
        URLSession.shared.dataTask(with: request) { data, response, error in
            DispatchQueue.main.async {
                self.isLoading = false
                
                if let error = error {
                    print("❌ Güncelleme hatası: \(error.localizedDescription)")
                    self.errorMessage = error.localizedDescription
                    return
                }
                
                if let httpResponse = response as? HTTPURLResponse {
                    print("📡 HTTP Durum Kodu: \(httpResponse.statusCode)")
                    if httpResponse.statusCode == 200 {
                        print("✅ Profil başarıyla güncellendi!")
                        
                        // Başarı mesajını göster
                        self.showSuccessMessage = true
                        
                        // 2 saniye sonra mesajı gizle
                        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                            self.showSuccessMessage = false
                        }
                        
                        // Profil güncellendikten sonra hesaplamaları hemen yap
                        self.calculateHealthMetrics()
                        
                        // Dashboard'ın güncellenmesi için notification gönder
                        NotificationCenter.default.post(name: .profileUpdated, object: nil)
                    }
                }
            }
        }.resume()
    }

    func logout() {
        print("🚪 Çıkış işlemi başlatılıyor...")
        
        // Kullanıcı verilerini temizle
        UserDefaults.standard.removeObject(forKey: "user_token")
        UserDefaults.standard.removeObject(forKey: "isLoggedIn")
        UserDefaults.standard.synchronize()
        
        print("✅ Çıkış başarıyla tamamlandı!")
        
        // Auth ekranına yönlendir
        navigateToAuth = true
    }

    func deleteProfile() {
        print("🗑️ Hesap silme işlemi başlatılıyor...")
        
        // Loading state'i başlat
        isLoading = true
        errorMessage = nil
        
        // URL kontrolü
        let deleteURL = "\(baseURL)/delete-account"
        print("🌐 Delete URL: \(deleteURL)")
        
        guard let url = URL(string: deleteURL) else {
            print("❌ Geçersiz URL: \(deleteURL)")
            DispatchQueue.main.async {
                self.isLoading = false
                self.errorMessage = "Geçersiz sunucu adresi"
            }
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "DELETE"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        // Token kontrolü
        guard let token = UserDefaults.standard.string(forKey: "user_token") else {
            print("❌ Token bulunamadı!")
            DispatchQueue.main.async {
                self.isLoading = false
                self.errorMessage = "Oturum süresi dolmuş. Lütfen tekrar giriş yapın."
            }
            return
        }
        
        print("🔑 Token mevcut, uzunluk: \(token.count)")
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        
        print("📤 Delete request gönderiliyor...")
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            DispatchQueue.main.async {
                self.isLoading = false
                
                if let error = error {
                    print("❌ Network hatası: \(error.localizedDescription)")
                    self.errorMessage = "Ağ bağlantı hatası: \(error.localizedDescription)"
                    return
                }
                
                if let httpResponse = response as? HTTPURLResponse {
                    print("📡 HTTP Durum Kodu: \(httpResponse.statusCode)")
                    
                    // Response data'sını da kontrol et
                    if let data = data,
                       let responseString = String(data: data, encoding: .utf8) {
                        print("📥 Response: \(responseString)")
                    }
                    
                    if httpResponse.statusCode == 200 {
                        print("✅ Hesap başarıyla silindi!")
                        
                        // Kullanıcı verilerini temizle
                        UserDefaults.standard.removeObject(forKey: "user_token")
                        UserDefaults.standard.removeObject(forKey: "isLoggedIn")
                        UserDefaults.standard.removeObject(forKey: "dailyCalorieLimit")
                        UserDefaults.standard.synchronize()
                        
                        print("🔄 Auth ekranına yönlendiriliyor...")
                        
                        // Auth ekranına yönlendir
                        self.navigateToAuth = true
                        
                        // Başarı mesajı (opsiyonel)
                        self.showSuccessMessage = true
                        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                            self.showSuccessMessage = false
                        }
                        
                    } else {
                        print("❌ HTTP Hata Kodu: \(httpResponse.statusCode)")
                        
                        let errorMsg = "Hesap silinirken bir hata oluştu (Kod: \(httpResponse.statusCode))"
                        
                        if httpResponse.statusCode == 401 {
                            self.errorMessage = "Oturum süresi dolmuş. Lütfen tekrar giriş yapın."
                        } else if httpResponse.statusCode == 404 {
                            self.errorMessage = "Kullanıcı bulunamadı."
                        } else {
                            self.errorMessage = errorMsg
                        }
                    }
                } else {
                    print("❌ HTTP Response alınamadı")
                    self.errorMessage = "Sunucudan yanıt alınamadı"
                }
            }
        }.resume()
    }
}

// Notification name'i extension
extension Notification.Name {
    static let profileUpdated = Notification.Name("profileUpdated")
}
