import Foundation
import SwiftUI

class AppointmentListViewModel: ObservableObject {
    @Published var appointments: [Appointment] = []
    @Published var errorMessage: String?

    let baseURL = "http://localhost:5002/appointment"

    // Randevuları getir
    func fetchAppointments() {
        guard let url = URL(string: "\(baseURL)/my") else { return }

        var request = URLRequest(url: url)
        request.httpMethod = "GET"

        // JWT Token ekle
        if let token = UserDefaults.standard.string(forKey: "jwtToken") {
            request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        }

        URLSession.shared.dataTask(with: request) { data, response, error in
            DispatchQueue.main.async {
                if let error = error {
                    self.errorMessage = "Hata: \(error.localizedDescription)"
                    return
                }

                guard let data = data else {
                    self.errorMessage = "Veri alınamadı."
                    return
                }

                do {
                    let decoder = JSONDecoder()
                    let decodedResponse = try decoder.decode(AppointmentResponse.self, from: data)
                    self.appointments = decodedResponse.appointments
                } catch {
                    self.errorMessage = "Çözümleme hatası: \(error.localizedDescription)"
                }
            }
        }.resume()
    }

    // Randevu sil
    func removeAppointment(_ appointment: Appointment) {
        guard let url = URL(string: "\(baseURL)/\(appointment.id)") else { return }

        var request = URLRequest(url: url)
        request.httpMethod = "DELETE"

        if let token = UserDefaults.standard.string(forKey: "jwtToken") {
            request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        }

        URLSession.shared.dataTask(with: request) { _, _, error in
            DispatchQueue.main.async {
                if let error = error {
                    self.errorMessage = "Silme hatası: \(error.localizedDescription)"
                    return
                }

                // Başarılıysa listeyi güncelle
                self.fetchAppointments()
            }
        }.resume()
    }
}

// API'den gelen cevabı karşılamak için struct (örnek JSON: { appointments: [...] })
struct AppointmentResponse: Codable {
    let appointments: [Appointment]
}

