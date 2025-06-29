//
//  InfoBox.swift
//  EatWell
//
//  Created by Tuğba Zengin on 23.05.2025.
//
import SwiftUI

struct InfoBox: View {
    let text: String
    let color: Color
    
    var body: some View {
        Text(text)
            .font(.appHeadline)
            .fontWeight(.bold)
            .foregroundColor(.white)
            .shadow(color: .black.opacity(0.3), radius: 1, x: 0, y: 1)
            .padding(.horizontal, 16)
            .padding(.vertical, 12)
            .frame(minWidth: 200)
            .background(
                RoundedRectangle(cornerRadius: 16)
                    .fill(
                        LinearGradient(
                            gradient: Gradient(colors: [
                                color.opacity(0.9),
                                color.opacity(0.7)
                            ]),
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .overlay(
                        RoundedRectangle(cornerRadius: 16)
                            .stroke(.white.opacity(0.3), lineWidth: 1)
                    )
                    .shadow(color: color.opacity(0.4), radius: 8, x: 0, y: 4)
            )
    }
}

