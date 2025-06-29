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
        VStack(spacing: 12) {
            // Enhanced profile circle with better visibility
            ZStack {
                Circle()
                    .fill(
                        LinearGradient(
                            gradient: Gradient(colors: [
                                Color.green.opacity(0.8),
                                Color.blue.opacity(0.6)
                            ]),
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .frame(width: 85, height: 85)
                    .shadow(color: isSelected ? .green.opacity(0.4) : .black.opacity(0.1), radius: 8, x: 0, y: 4)
                
                Text(String(dietitian.name.prefix(1)))
                    .font(.system(size: 32, weight: .bold))
                    .foregroundColor(.white)
                
                // Selection ring
                if isSelected {
                    Circle()
                        .stroke(Color.green, lineWidth: 3)
                        .frame(width: 95, height: 95)
                        .overlay(
                            Circle()
                                .stroke(Color.white, lineWidth: 2)
                                .frame(width: 91, height: 91)
                        )
                }
            }

            // Doctor information with better text visibility
            VStack(spacing: 6) {
                Text(dietitian.name)
                    .font(.appHeadline)
                    .fontWeight(.bold)
                    .foregroundColor(.black)
                    .multilineTextAlignment(.center)
                    .lineLimit(2)
                    .minimumScaleFactor(0.8)
                
                Text(dietitian.specialty)
                    .font(.appCaption)
                    .fontWeight(.medium)
                    .foregroundColor(.blue)
                    .multilineTextAlignment(.center)
                    .lineLimit(2)
                
                HStack(spacing: 4) {
                    Image(systemName: "star.fill")
                        .font(.system(size: 10))
                        .foregroundColor(.orange)
                    
                    Text(dietitian.experience)
                        .font(.system(size: 11, weight: .medium))
                        .foregroundColor(.gray)
                }
            }
            .frame(width: 120)
        }
        .padding(16)
        .frame(width: 140, height: 180)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(.white)
                .overlay(
                    RoundedRectangle(cornerRadius: 16)
                        .stroke(
                            isSelected ? Color.green.opacity(0.3) : Color.gray.opacity(0.1),
                            lineWidth: isSelected ? 2 : 1
                        )
                )
                .shadow(
                    color: isSelected ? .green.opacity(0.2) : .black.opacity(0.05),
                    radius: isSelected ? 12 : 6,
                    x: 0,
                    y: isSelected ? 6 : 3
                )
        )
        .scaleEffect(isSelected ? 1.05 : 1.0)
        .animation(.spring(response: 0.3, dampingFraction: 0.8), value: isSelected)
        .onTapGesture {
            onTap()
        }
    }
}

