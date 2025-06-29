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
        VStack(spacing: 16) {
            // Header with doctor name and status
            HStack {
                VStack(alignment: .leading, spacing: 8) {
                    HStack(spacing: 8) {
                        Image(systemName: "stethoscope")
                            .font(.system(size: 16, weight: .semibold))
                            .foregroundColor(.blue)
                        
                        Text(appointment.dietitian)
                            .font(.appTitle3)
                            .fontWeight(.bold)
                            .foregroundColor(.black)
                    }
                    
                    Text("Diyetisyen")
                        .font(.appCaption)
                        .foregroundColor(.blue.opacity(0.7))
                }

                Spacer()

                // Status badge
                Text(appointment.statusText)
                    .font(.appCaption)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                    .padding(.horizontal, 12)
                    .padding(.vertical, 6)
                    .background(
                        Capsule()
                            .fill(statusColor)
                    )
            }
            
            // Date and time information
            HStack(spacing: 20) {
                // Date section
                VStack(spacing: 8) {
                    ZStack {
                        RoundedRectangle(cornerRadius: 12)
                            .fill(Color.green.opacity(0.1))
                            .frame(width: 60, height: 60)
                        
                        VStack(spacing: 2) {
                            Image(systemName: "calendar")
                                .font(.system(size: 18, weight: .semibold))
                                .foregroundColor(.green)
                            
                            Text("Tarih")
                                .font(.system(size: 8, weight: .medium))
                                .foregroundColor(.green)
                        }
                    }
                    
                    Text(appointment.formattedDate)
                        .font(.appHeadline)
                        .fontWeight(.semibold)
                        .foregroundColor(.black)
                        .multilineTextAlignment(.center)
                }
                
                // Time section
                VStack(spacing: 8) {
                    ZStack {
                        RoundedRectangle(cornerRadius: 12)
                            .fill(Color.orange.opacity(0.1))
                            .frame(width: 60, height: 60)
                        
                        VStack(spacing: 2) {
                            Image(systemName: "clock")
                                .font(.system(size: 18, weight: .semibold))
                                .foregroundColor(.orange)
                            
                            Text("Saat")
                                .font(.system(size: 8, weight: .medium))
                                .foregroundColor(.orange)
                        }
                    }
                    
                    Text(appointment.time)
                        .font(.appTitle3)
                        .fontWeight(.bold)
                        .foregroundColor(.black)
                }
                
                Spacer()
                
                // Cancel button
                if appointment.status != "cancelled" {
                    Button(action: onCancel) {
                        VStack(spacing: 6) {
                            ZStack {
                                Circle()
                                    .fill(Color.red.opacity(0.1))
                                    .frame(width: 40, height: 40)
                                
                                Image(systemName: "xmark")
                                    .font(.system(size: 16, weight: .bold))
                                    .foregroundColor(.red)
                            }
                            
                            Text("İptal Et")
                                .font(.system(size: 10, weight: .semibold))
                                .foregroundColor(.red)
                        }
                    }
                }
            }
        }
        .padding(20)
        .background(
            RoundedRectangle(cornerRadius: 20)
                .fill(.white)
                .overlay(
                    RoundedRectangle(cornerRadius: 20)
                        .stroke(statusColor.opacity(0.2), lineWidth: 1)
                )
                .shadow(color: statusColor.opacity(0.1), radius: 8, x: 0, y: 4)
        )
        .padding(.horizontal, 20)
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
}

