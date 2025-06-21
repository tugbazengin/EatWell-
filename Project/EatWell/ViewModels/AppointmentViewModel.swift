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
    @Published var dietitians: [Dietitian]
    @Published var errorMessage: String?
    @Published var successMessage: String?

    let baseURL = "http://localhost:5002/appointment"

    init() {
        self.appointment = NewAppointment()
        self.dietitians = [
            Dietitian(name: "Dr. Tuğba Zengin", specialization: "Klinik Beslenme Uzmanı", image: "dietitian1"),
            Dietitian(name: "Dr. Berke Baş", specialization: "Sporcu Beslenmesi Uzmanı", image: "dietitian2"),
            Dietitian(name: "Dr. Sıla Bıçakçı", specialization: "Diyetisyen", image: "dietitian3")
        ]
    }

    func fetchAvailableTimes() {
        guard let dietitian = appointment.selectedDietitian?.name else { return }
        
        // Use simple date format for backend compatibility
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let dateString = dateFormatter.string(from: appointment.selectedDate)
        
        guard let url = URL(string: "\(baseURL)/available?dietitian=\(dietitian.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? "")&date=\(dateString)") else { return }
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        if let token = UserDefaults.standard.string(forKey: "jwtToken") {
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
                      let available = json["available"] as? [String] else {
                    self.errorMessage = "Saatler alınamadı."
                    return
                }
                self.times = available
            }
        }.resume()
    }

    func confirmAppointment() {
        guard let dietitian = appointment.selectedDietitian?.name,
              let time = appointment.selectedTime else { return }
        
        // Use simple date format for backend compatibility
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let dateString = dateFormatter.string(from: appointment.selectedDate)
        
        guard let url = URL(string: baseURL) else { return }
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        if let token = UserDefaults.standard.string(forKey: "jwtToken") {
            request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        }
        let body: [String: Any] = [
            "dietitian": dietitian,
            "date": dateString,
            "time": time
        ]
        request.httpBody = try? JSONSerialization.data(withJSONObject: body)
        URLSession.shared.dataTask(with: request) { data, response, error in
            DispatchQueue.main.async {
                if let error = error {
                    self.errorMessage = error.localizedDescription
                    return
                }
                
                guard let data = data,
                      let json = try? JSONSerialization.jsonObject(with: data) as? [String: Any] else {
                    self.errorMessage = "Geçersiz sunucu yanıtı."
                    return
                }
                
                if let success = json["success"] as? Bool, success {
                    self.successMessage = "Randevu başarıyla oluşturuldu."
                    self.errorMessage = nil
                    // Reset form after successful appointment
                    self.resetSelection()
                } else {
                    let message = json["message"] as? String ?? "Randevu oluşturulamadı."
                    self.errorMessage = message
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

