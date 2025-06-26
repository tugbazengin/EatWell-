//
//  AppointmentViewModel.swift
//  EatWell
//
//  Created by Tuğba Zengin on 24.05.2025.
//

import Foundation
import SwiftUI

class AppointmentViewModel: ObservableObject {
    @Published var appointment: NewAppointment
    @Published var times: [String] = []
    @Published var dietitians: [Dietitian] = []
    @Published var errorMessage: String?
    @Published var successMessage: String?
    @Published var isLoading: Bool = false

    let baseURL = APIConfig.appointmentURL

    init() {
        self.appointment = NewAppointment()
        loadDietitians()
        setDefaultTimes()
    }
    
    func loadDietitians() {
        isLoading = true
        
        guard let token = UserDefaults.standard.string(forKey: "user_token") else {
            errorMessage = "Token bulunamadı"
            isLoading = false
            return
        }
        
        guard let url = URL(string: "\(baseURL)/dietitians") else {
            errorMessage = "Geçersiz URL"
            isLoading = false
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        URLSession.shared.dataTask(with: request) { [weak self] data, response, error in
            DispatchQueue.main.async {
                self?.isLoading = false
                
                if let error = error {
                    self?.errorMessage = "Network hatası: \(error.localizedDescription)"
                    return
                }
                
                guard let data = data else {
                    self?.errorMessage = "Veri alınamadı"
                    return
                }
                
                do {
                    let result = try JSONDecoder().decode(DietitiansResponse.self, from: data)
                    self?.dietitians = result.dietitians
                } catch {
                    self?.errorMessage = "JSON decode hatası: \(error)"
                }
            }
        }.resume()
    }

    func fetchAvailableTimes() {
        guard let dietitian = appointment.selectedDietitian?.name else { 
            // Eğer diyetisyen seçilmemişse default saatleri göster
            print("🔍 Diyetisyen seçilmemiş, default saatler gösteriliyor")
            setDefaultTimes()
            return 
        }
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let dateString = dateFormatter.string(from: appointment.selectedDate)
        
        print("📅 Randevu saatleri isteniyor - Diyetisyen: \(dietitian), Tarih: \(dateString)")
        
        guard let token = UserDefaults.standard.string(forKey: "user_token") else {
            errorMessage = "Token bulunamadı"
            print("❌ Token bulunamadı, default saatler kullanılacak")
            setDefaultTimes()
            return
        }
        
        guard let url = URL(string: "\(baseURL)/available?dietitian=\(dietitian.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? "")&date=\(dateString)") else { 
            errorMessage = "Geçersiz URL"
            print("❌ Geçersiz URL, default saatler kullanılacak")
            setDefaultTimes()
            return 
        }
        
        print("🌐 API Çağrısı yapılıyor: \(url)")
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        // Loading durumunu temizle, sadece saatler için yükleniyor
        times = [] // Önceki saatleri temizle
        
        URLSession.shared.dataTask(with: request) { [weak self] data, response, error in
            DispatchQueue.main.async {
                if let error = error {
                    print("❌ Network hatası: \(error.localizedDescription)")
                    self?.errorMessage = "Bağlantı hatası, mevcut tüm saatler gösteriliyor"
                    self?.setDefaultTimes()
                    return
                }
                
                guard let data = data else {
                    print("❌ Veri alınamadı, default saatler kullanılacak")
                    self?.errorMessage = "Sunucudan veri alınamadı"
                    self?.setDefaultTimes()
                    return
                }
                
                // Response'u debug için yazdır
                if let responseString = String(data: data, encoding: .utf8) {
                    print("📡 API Response: \(responseString)")
                }
                
                // HTTP status kodu kontrol et
                if let httpResponse = response as? HTTPURLResponse {
                    print("📊 HTTP Status: \(httpResponse.statusCode)")
                    
                    if httpResponse.statusCode != 200 {
                        print("❌ HTTP Error \(httpResponse.statusCode), default saatler kullanılacak")
                        self?.errorMessage = "Sunucu hatası (\(httpResponse.statusCode))"
                        self?.setDefaultTimes()
                        return
                    }
                }
                
                do {
                    let result = try JSONDecoder().decode(AvailableTimesResponse.self, from: data)
                    print("✅ API'dan alınan saatler: \(result.available)")
                    
                    if result.available.isEmpty {
                        print("⚠️ Bu tarih/diyetisyen için uygun saat yok")
                        self?.times = []
                        self?.errorMessage = "Bu tarih için uygun randevu saati bulunmuyor"
                    } else {
                        print("✅ \(result.available.count) uygun saat bulundu")
                        self?.times = result.available
                        self?.errorMessage = nil // Başarılı olduğunda hata mesajını temizle
                    }
                } catch {
                    print("❌ JSON parse hatası: \(error)")
                    print("🔄 Backend'de sorun olabilir, default saatler gösteriliyor")
                    self?.errorMessage = "Sunucu verisi işlenemedi, tüm saatler gösteriliyor"
                    self?.setDefaultTimes()
                }
            }
        }.resume()
    }
    
    private func setDefaultTimes() {
        // Varsayılan çalışma saatleri (backend hazır değilse)
        times = [
            "09:00", "09:30", "10:00", "10:30", "11:00", "11:30",
            "12:00", "12:30", "13:00", "13:30", "14:00", "14:30",
            "15:00", "15:30", "16:00", "16:30", "17:00", "17:30"
        ]
        print("🕒 Default saatler yüklendi: \(times.count) saat mevcut")
    }

    func confirmAppointment() {
        guard let dietitian = appointment.selectedDietitian?.name,
              let time = appointment.selectedTime else { 
            errorMessage = "Lütfen diyetisyen ve saat seçin"
            return 
        }
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let dateString = dateFormatter.string(from: appointment.selectedDate)
        
        guard let token = UserDefaults.standard.string(forKey: "user_token") else {
            errorMessage = "Token bulunamadı"
            return
        }
        
        guard let url = URL(string: baseURL) else { 
            errorMessage = "Geçersiz URL"
            return 
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        
        let body: [String: Any] = [
            "dietitian": dietitian,
            "date": dateString,
            "time": time
        ]
        
        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: body)
        } catch {
            errorMessage = "İstek oluşturulamadı"
            return
        }
        
        isLoading = true
        
        URLSession.shared.dataTask(with: request) { [weak self] data, response, error in
            DispatchQueue.main.async {
                self?.isLoading = false
                
                if let error = error {
                    self?.errorMessage = "Network hatası: \(error.localizedDescription)"
                    return
                }
                
                guard let data = data else {
                    self?.errorMessage = "Veri alınamadı"
                    return
                }
                
                do {
                    let result = try JSONDecoder().decode(AppointmentResponse.self, from: data)
                    if result.success {
                        self?.successMessage = result.message
                        self?.errorMessage = nil
                        self?.resetSelection()
                    } else {
                        self?.errorMessage = result.message
                    }
                } catch {
                    // Fallback to old JSON parsing for error handling
                    if let json = try? JSONSerialization.jsonObject(with: data) as? [String: Any] {
                        let message = json["message"] as? String ?? "Randevu oluşturulamadı"
                        self?.errorMessage = message
                    } else {
                        self?.errorMessage = "Sunucu yanıtı işlenemedi"
                    }
                }
            }
        }.resume()
    }

    func resetSelection() {
        appointment.selectedTime = nil
        appointment.selectedDietitian = nil
        appointment.selectedDate = Date()
        times = []
        successMessage = nil
        errorMessage = nil
    }
}

// MARK: - Response Models
struct DietitiansResponse: Codable {
    let dietitians: [Dietitian]
}

struct AvailableTimesResponse: Codable {
    let available: [String]
}

struct AppointmentResponse: Codable {
    let success: Bool
    let message: String
    let appointment: AppointmentData?
}

struct AppointmentData: Codable {
    let _id: String
    let user: String
    let dietitian: String
    let date: String
    let time: String
    let status: String
}

