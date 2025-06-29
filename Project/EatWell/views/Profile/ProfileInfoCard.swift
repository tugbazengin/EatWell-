//
//  ProfileInfoCard.swift
//  EatWell
//
//  Created by Tuğba Zengin on 23.05.2025.
//
import SwiftUI

// Modern profile info card with gradients
struct ModernProfileInfoCard: View {
    var title: String
    var value: String
    var icon: String
    var gradientColors: [Color]

    var body: some View {
        HStack(spacing: 16) {
            // Icon container with circular background
            ZStack {
                Circle()
                    .fill(.white.opacity(0.2))
                    .frame(width: 50, height: 50)
                
                Image(systemName: icon)
                    .font(.system(size: 24, weight: .bold))
                    .foregroundColor(.white)
            }

            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.appHeadline)
                    .fontWeight(.semibold)
                    .foregroundColor(.white)
                
                Text(value)
                    .font(.appTitle3)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
            }
            
            Spacer()
        }
        .padding(20)
        .background(
            RoundedRectangle(cornerRadius: 18)
                .fill(
                    LinearGradient(
                        gradient: Gradient(colors: gradientColors),
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
                .shadow(color: gradientColors.first?.opacity(0.3) ?? .clear, radius: 8, x: 0, y: 4)
        )
    }
}

// Simplified modern profile row for editable fields
struct ModernProfileRow: View {
    var icon: String
    var label: String
    @Binding var value: String
    var isEditing: Bool
    var keyboardType: UIKeyboardType = .default
    var color: Color

    var body: some View {
        HStack(spacing: 16) {
            // Icon with colored background
            ZStack {
                Circle()
                    .fill(color.opacity(0.1))
                    .frame(width: 40, height: 40)
                
                Image(systemName: icon)
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundColor(color)
            }
            
            VStack(alignment: .leading, spacing: 4) {
                Text(label)
                    .font(.appCaption)
                    .fontWeight(.medium)
                    .foregroundColor(.black.opacity(0.7))
                
                if isEditing {
                    TextField(label, text: $value)
                        .font(.appHeadline)
                        .fontWeight(.semibold)
                        .foregroundColor(.black)
                        .keyboardType(keyboardType)
                        .textFieldStyle(PlainTextFieldStyle())
                        .overlay(
                            Rectangle()
                                .frame(height: 1)
                                .foregroundColor(color.opacity(0.3)),
                            alignment: .bottom
                        )
                } else {
                    Text(value.isEmpty ? "-" : value)
                        .font(.appHeadline)
                        .fontWeight(.semibold)
                        .foregroundColor(.black)
                }
            }
            
            Spacer()
            
            if isEditing {
                Image(systemName: "pencil")
                    .font(.system(size: 14, weight: .medium))
                    .foregroundColor(color.opacity(0.6))
            }
        }
        .padding(.vertical, 8)
    }
}

// Legacy ProfileInfoCard for backwards compatibility
struct ProfileInfoCard: View {
    var title: String
    var value: String
    var icon: String
    var color: Color

    var body: some View {
        HStack(spacing: 15) {
            Image(systemName: icon)
                .foregroundColor(.white)
                .frame(width: 30, height: 30)
                .padding()
                .background(color)
                .clipShape(Circle())

            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.appHeadline)
                    .foregroundColor(.white)
                Text(value)
                    .font(.appBody)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
            }
            Spacer()
        }
        .padding()
        .frame(maxWidth: .infinity)
        .background(color.opacity(0.85))
        .cornerRadius(15)
        .shadow(radius: 5)
        .appContentsPadding()
    }
}
