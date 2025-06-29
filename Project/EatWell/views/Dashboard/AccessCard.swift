//
//   AccessCard.swift
//  EatWell
//
//  Created by Tuğba Zengin on 22.05.2025.
//
import SwiftUI

struct AccessCard: View {
    let icon: String
    let title: String

    var body: some View {
        VStack(spacing: 12) {
            Image(systemName: icon)
                .font(.system(size: 28, weight: .bold))
                .foregroundColor(.green)
            
            Text(title)
                .font(.appHeadline)
                .fontWeight(.semibold)
                .foregroundColor(.primary)
                .multilineTextAlignment(.center)
        }
        .padding(16)
        .frame(maxWidth: .infinity, minHeight: 100)
        .background(
            RoundedRectangle(cornerRadius: 18)
                .fill(.white)
                .overlay(
                    RoundedRectangle(cornerRadius: 18)
                        .stroke(Color.green.opacity(0.2), lineWidth: 1)
                )
                .shadow(color: .green.opacity(0.15), radius: 8, x: 0, y: 4)
        )
    }
}

