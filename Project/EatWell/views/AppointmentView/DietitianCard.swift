//
//  DietitianCard.swift
//  EatWell
//
//  Created by Tuğba Zengin on 24.05.2025.
//
import SwiftUI

struct DietitianCard: View {
    let dietitian: Dietitian
    let isSelected: Bool
    let onTap: () -> Void

    var body: some View {
        VStack(spacing: 8) {
            // Placeholder image since we don't have actual images
            Circle()
                .fill(LinearGradient(gradient: Gradient(colors: [Color.green.opacity(0.7), Color.blue.opacity(0.7)]), startPoint: .topLeading, endPoint: .bottomTrailing))
                .frame(width: 80, height: 80)
                .overlay(
                    Text(String(dietitian.name.prefix(1)))
                        .font(.title)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                )
                .overlay(
                    Circle()
                        .stroke(isSelected ? Color.green : Color.gray, lineWidth: 3)
                )

            VStack(spacing: 4) {
                Text(dietitian.name)
                    .font(.appBody)
                    .fontWeight(.semibold)
                    .multilineTextAlignment(.center)
                
                Text(dietitian.specialty)
                    .font(.caption)
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
                
                Text(dietitian.experience)
                    .font(.caption2)
                    .foregroundColor(.secondary)
            }
        }
        .padding(12) 
        .background(
            RoundedRectangle(cornerRadius: 10)
                .fill(Color.white)
                .shadow(radius: 3)
        )
        .onTapGesture {
            onTap()
        }
    }
}

