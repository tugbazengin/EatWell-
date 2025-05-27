//
//  ProfileInfoCard.swift
//  EatWell
//
//  Created by Tuğba Zengin on 23.05.2025.
//
import SwiftUI

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
