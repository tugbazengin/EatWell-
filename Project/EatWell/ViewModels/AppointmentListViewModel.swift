import Foundation
import SwiftUI

class AppointmentListViewModel: ObservableObject {
    @Published var appointments: [Appointment] = []
    @Published var errorMessage: String?
    @Published var isLoading: Bool = false

    let baseURL = APIConfig.appointmentURL

    // Randevuları getir
    func fetchAppointments() {
        isLoading = true
        
        guard let token = UserDefaults.standard.string(forKey: "user_token") else {
            errorMessage = "Token bulunamadı"
            isLoading = false
            return
        }
        
        guard let url = URL(string: "\(baseURL)/my") else {
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
                    let result = try JSONDecoder().decode(MyAppointmentsResponse.self, from: data)
                    // İptal edilen randevuları filtrele
                    self?.appointments = result.appointments.filter { $0.status != "cancelled" }
                } catch {
                    self?.errorMessage = "JSON decode hatası: \(error)"
                }
            }
        }.resume()
    }

    // Randevu iptal et
    func cancelAppointment(_ appointment: Appointment) {
        guard let token = UserDefaults.standard.string(forKey: "user_token") else {
            errorMessage = "Token bulunamadı"
            return
        }
        
        guard let url = URL(string: "\(baseURL)/\(appointment.id)") else {
            errorMessage = "Geçersiz URL"
            return
        }

        var request = URLRequest(url: url)
        request.httpMethod = "DELETE"
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        URLSession.shared.dataTask(with: request) { [weak self] data, response, error in
            DispatchQueue.main.async {
                if let error = error {
                    self?.errorMessage = "İptal hatası: \(error.localizedDescription)"
                    return
                }

                // HTTP yanıt kodunu kontrol et
                if let httpResponse = response as? HTTPURLResponse,
                   httpResponse.statusCode >= 200 && httpResponse.statusCode < 300 {
                    // Başarılıysa: anında listeden kaldır (kullanıcı experience için)
                    self?.appointments.removeAll { $0.id == appointment.id }
                    
                    // Başarı mesajı temizle
                    self?.errorMessage = nil
                    
                    // Arka planda listeyi yenile (senkronizasyon için)
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                        self?.fetchAppointments()
                    }
                } else {
                    self?.errorMessage = "Randevu iptal edilemedi"
                }
            }
        }.resume()
    }
}

// API'den gelen cevabı karşılamak için struct
struct MyAppointmentsResponse: Codable {
    let appointments: [Appointment]
}

