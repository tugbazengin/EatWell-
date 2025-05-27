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
        Text(quote)
            .font(.appBody)
            .foregroundColor(.primary)
            .padding()
            .frame(maxWidth: .infinity)
            .background(
                RoundedRectangle(cornerRadius: 15)
                    .fill(Color.white)
                    .shadow(color: Color.gray.opacity(0.2), radius: 5, x: 3, y: 3)
                    .shadow(color: Color.white.opacity(0.8), radius: 5, x: -3, y: -3)
            )
            .padding(.horizontal, 20)  
    }
}

