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
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text(appointment.dietitian)
                        .font(.appHeadline)
                        .foregroundColor(.black)
                    
                    HStack(spacing: 4) {
                        Image(systemName: "calendar")
                        Text(appointment.formattedDate)
                    }
                    .font(.appBody)
                    .foregroundColor(.secondary)
                    
                    HStack(spacing: 4) {
                        Image(systemName: "clock")
                        Text(appointment.time)
                    }
                    .font(.appBody)
                    .foregroundColor(.secondary)
                }

                Spacer()

                VStack(spacing: 8) {
                    Text(appointment.statusText)
                        .font(.caption)
                        .fontWeight(.semibold)
                        .foregroundColor(statusColor)
                        .padding(.horizontal, 12)
                        .padding(.vertical, 6)
                        .background(statusBackgroundColor)
                        .clipShape(Capsule())
                    
                    if appointment.status != "cancelled" {
                        Button(action: onCancel) {
                            HStack(spacing: 4) {
                                Image(systemName: "xmark.circle")
                                Text("İptal Et")
                            }
                            .font(.caption)
                            .foregroundColor(.red)
                            .padding(.horizontal, 8)
                            .padding(.vertical, 4)
                            .background(Color.red.opacity(0.1))
                            .clipShape(Capsule())
                        }
                    }
                }
            }
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(Color.white)
                .shadow(color: Color.black.opacity(0.1), radius: 4, x: 0, y: 2)
        )
        .padding(.horizontal)
    }
    
    private var statusColor: Color {
        switch appointment.status {
        case "approved":
            return .green
        case "pending":
            return .orange
        case "cancelled":
            return .red
        default:
            return .gray
        }
    }
    
    private var statusBackgroundColor: Color {
        switch appointment.status {
        case "approved":
            return Color.green.opacity(0.2)
        case "pending":
            return Color.orange.opacity(0.2)
        case "cancelled":
            return Color.red.opacity(0.2)
        default:
            return Color.gray.opacity(0.2)
        }
    }
}

