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
            .padding()
            .frame(width: 200)
            .background(
                RoundedRectangle(cornerRadius: 15)
                    .fill(color.opacity(0.8))
            )
            .shadow(radius: 5)
    }
}

