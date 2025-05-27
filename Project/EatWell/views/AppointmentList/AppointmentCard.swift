//
//  AppointmentCard.swift
//  EatWell
//
//  Created by Tuğba Zengin on 23.05.2025.
//

import SwiftUI

struct AppointmentCard: View {
    let appointment: Appointment
    let onCancel: () -> Void

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Text(appointment.dietitian)
                    .font(.appHeadline)
                    .foregroundColor(.black)

                Spacer()

                Text(appointment.status)
                    .font(.appBody)
                    .foregroundColor(appointment.status == "Onaylandı" ? .green : .orange)
                    .padding(.horizontal, 12)
                    .padding(.vertical, 6)
                    .background(
                        (appointment.status == "Onaylandı" ? Color.green.opacity(0.2) : Color.orange.opacity(0.2))
                    )
                    .clipShape(Capsule())
            }

            Divider()

            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text("📅 Tarih: \(appointment.date)")
                    Text("⏰ Saat: \(appointment.time)")
                }
                .font(.appBody)
                .foregroundColor(.black.opacity(0.8))

                Spacer()

                Button("İptal Et", action: onCancel)
                    .appButtonStyle(color: .red)
                    .frame(width: 100)
            }
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(Color.white.opacity(0.95))
                .shadow(radius: 4)
        )
        .appContentsPadding()
    }
}

