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
        VStack {
            Image(dietitian.image)
                .resizable()
                .scaledToFill()
                .frame(width: 80, height: 80)
                .clipShape(Circle())
                .overlay(
                    Circle()
                        .stroke(isSelected ? Color.green : Color.gray, lineWidth: 3)
                )

            Text(dietitian.name)
                .font(.appBody)
                .multilineTextAlignment(.center)
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

