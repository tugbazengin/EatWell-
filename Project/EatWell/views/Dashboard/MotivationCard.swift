//
//  MotivationCard.swift
//  EatWell
//
//  Created by Tuğba Zengin on 22.05.2025.
//

import SwiftUI

struct MotivationCard: View {
    let quote: String

    var body: some View {
        VStack(spacing: 16) {
            HStack {
                Image(systemName: "quote.opening")
                    .font(.system(size: 20, weight: .bold))
                    .foregroundColor(.green.opacity(0.6))
                
                Spacer()
                
                Image(systemName: "heart.fill")
                    .font(.system(size: 16))
                    .foregroundColor(.orange.opacity(0.7))
            }
            
        Text(quote)
            .font(.appHeadline)
            .fontWeight(.medium)
            .foregroundColor(.black)
            .multilineTextAlignment(.center)
                .lineSpacing(4)
            
            HStack {
                Spacer()
                
                Image(systemName: "quote.closing")
                    .font(.system(size: 20, weight: .bold))
                    .foregroundColor(.green.opacity(0.6))
            }
        }
        .padding(24)
            .background(
            RoundedRectangle(cornerRadius: 20)
                .fill(
                    LinearGradient(
                        gradient: Gradient(colors: [
                            Color.white,
                            Color.green.opacity(0.05)
                        ]),
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
                .overlay(
                    RoundedRectangle(cornerRadius: 20)
                        .stroke(
                            LinearGradient(
                                gradient: Gradient(colors: [
                                    Color.green.opacity(0.3),
                                    Color.orange.opacity(0.2)
                                ]),
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            ),
                            lineWidth: 1
                        )
                )
                .shadow(color: .green.opacity(0.1), radius: 10, x: 0, y: 5)
            )
            .padding(.horizontal, 20)  
    }
}

