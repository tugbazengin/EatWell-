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
        guard let dietitian = appointment.selectedDietitian?.name else { return }
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let dateString = dateFormatter.string(from: appointment.selectedDate)
        
        guard let token = UserDefaults.standard.string(forKey: "user_token") else {
            errorMessage = "Token bulunamadı"
            return
        }
        
        guard let url = URL(string: "\(baseURL)/available?dietitian=\(dietitian.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? "")&date=\(dateString)") else { 
            errorMessage = "Geçersiz URL"
            return 
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        URLSession.shared.dataTask(with: request) { [weak self] data, response, error in
            DispatchQueue.main.async {
                if let error = error {
                    self?.errorMessage = "Network hatası: \(error.localizedDescription)"
                    return
                }
                
                guard let data = data else {
                    self?.errorMessage = "Veri alınamadı"
                    return
                }
                
                do {
                    let result = try JSONDecoder().decode(AvailableTimesResponse.self, from: data)
                    self?.times = result.available
                } catch {
                    self?.errorMessage = "Saatler alınamadı: \(error)"
                }
            }
        }.resume()
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

