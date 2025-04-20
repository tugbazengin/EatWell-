//
//  AppointmentListView.swift
//  EatWell
//
//  Created by Tuğba Zengin on 28.03.2025.
//
import SwiftUI

struct AppointmentListView: View {
    @State private var appointments: [Appointment] = [
        Appointment(dietitian: "Dr. Tuğba Zengin", date: "25 Mart 2025", time: "10:00", status: "Onaylandı"),
        Appointment(dietitian: "Dr. Berke Baş", date: "27 Mart 2025", time: "14:00", status: "Beklemede"),
        Appointment(dietitian: "Dr. Sıla Bıçakçı", date: "29 Mart 2025", time: "16:00", status: "Onaylandı")
    ]

    var body: some View {
        ZStack {
            // Arka plan rengini değiştirdik
            Color(red: 0.95, green: 1.0, blue: 0.95)
                .edgesIgnoringSafeArea(.all)

            VStack(spacing: 15) {
                Text("Randevularım")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .padding(.top, 20)

                if appointments.isEmpty {
                    Text("Henüz randevunuz bulunmamaktadır.")
                        .font(.headline)
                        .foregroundColor(.gray)
                        .padding()
                } else {
                    ScrollView {
                        VStack(spacing: 15) {
                            ForEach(appointments) { appointment in
                                AppointmentCard(appointment: appointment) {
                                    removeAppointment(appointment)
                                }
                            }
                        }
                        .padding()
                    }
                }
                Spacer()
            }
        }
    }

    private func removeAppointment(_ appointment: Appointment) {
        withAnimation {
            appointments.removeAll { $0.id == appointment.id }
        }
    }
}

// 📌 Randevu Modeli
struct Appointment: Identifiable {
    let id = UUID()
    let dietitian: String
    let date: String
    let time: String
    let status: String
}

// 📌 Randevu Kartı Bileşeni
struct AppointmentCard: View {
    let appointment: Appointment
    let onCancel: () -> Void

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Text(appointment.dietitian)
                    .font(.headline)
                    .foregroundColor(.black)

                Spacer()

                Text(appointment.status)
                    .font(.subheadline)
                    .foregroundColor(appointment.status == "Onaylandı" ? .green : .orange)
                    .padding(6)
                    .background(appointment.status == "Onaylandı" ? Color.green.opacity(0.2) : Color.orange.opacity(0.2))
                    .clipShape(Capsule())
            }

            Divider()

            HStack {
                VStack(alignment: .leading) {
                    Text("📅 Tarih: \(appointment.date)")
                    Text("⏰ Saat: \(appointment.time)")
                }
                .font(.subheadline)
                .foregroundColor(.black.opacity(0.8))

                Spacer()

                Button(action: onCancel) {
                    Text("İptal Et")
                        .foregroundColor(.white)
                        .padding(.horizontal, 16)
                        .padding(.vertical, 8)
                        .background(Color.red)
                        .clipShape(Capsule())
                        .shadow(radius: 3)
                }
            }
        }
        .padding()
        .background(RoundedRectangle(cornerRadius: 12).fill(Color.white.opacity(0.95)).shadow(radius: 4))
        .padding(.horizontal, 10)
    }
}

// 📌 Önizleme
struct AppointmentListView_Previews: PreviewProvider {
    static var previews: some View {
        AppointmentListView()
    }
}

