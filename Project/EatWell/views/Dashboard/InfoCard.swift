//
//  InfoCard.swift
//  EatWell
//
//  Created by Tuğba Zengin on 22.05.2025.
//

import SwiftUI

// Modern stat card for dashboard with improved text visibility
struct StatCard: View {
    let icon: String
    let title: String
    let value: String
    let color: Color
    let gradientColors: [Color]

    var body: some View {
        VStack(spacing: 8) {
            ZStack {
                Circle()
                    .fill(.white.opacity(0.3))
                    .frame(width: 35, height: 35)
                
                Image(systemName: icon)
                    .font(.system(size: 18, weight: .bold))
                    .foregroundColor(.white)
            }
            
            Text(value)
                .font(.system(size: 16, weight: .bold))
                .foregroundColor(.white)
                .shadow(color: .black.opacity(0.3), radius: 1, x: 0, y: 1)
            
            Text(title)
                .font(.system(size: 11, weight: .semibold))
                .foregroundColor(.white.opacity(0.95))
                .shadow(color: .black.opacity(0.3), radius: 1, x: 0, y: 1)
        }
        .frame(maxWidth: .infinity)
        .frame(height: 100)
        .background(
            RoundedRectangle(cornerRadius: 20)
                .fill(
                    LinearGradient(
                        gradient: Gradient(colors: gradientColors),
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
                .overlay(
                    RoundedRectangle(cornerRadius: 20)
                        .stroke(.white.opacity(0.2), lineWidth: 1)
                )
                .shadow(color: color.opacity(0.4), radius: 8, x: 0, y: 4)
        )
    }
}

// Main feature card for important actions with better text contrast
struct MainFeatureCard: View {
    let icon: String
    let title: String
    let subtitle: String
    let gradientColors: [Color]
    
    var body: some View {
        HStack(spacing: 16) {
            VStack {
                ZStack {
                    Circle()
                        .fill(.white.opacity(0.3))
                        .frame(width: 50, height: 50)
                    
                    Image(systemName: icon)
                        .font(.system(size: 24, weight: .bold))
                        .foregroundColor(.white)
                }
            }
            
            VStack(alignment: .leading, spacing: 6) {
                Text(title)
                    .font(.appTitle3)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                    .shadow(color: .black.opacity(0.3), radius: 1, x: 0, y: 1)
                
                Text(subtitle)
                    .font(.appBody)
                    .foregroundColor(.white.opacity(0.9))
                    .shadow(color: .black.opacity(0.3), radius: 1, x: 0, y: 1)
            }
            
            Spacer()
            
            Image(systemName: "chevron.right")
                .font(.system(size: 16, weight: .semibold))
                .foregroundColor(.white.opacity(0.8))
        }
        .padding(20)
        .background(
            RoundedRectangle(cornerRadius: 20)
                .fill(
                    LinearGradient(
                        gradient: Gradient(colors: gradientColors),
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
                .overlay(
                    RoundedRectangle(cornerRadius: 20)
                        .stroke(.white.opacity(0.2), lineWidth: 1)
                )
                .shadow(color: .black.opacity(0.15), radius: 10, x: 0, y: 5)
        )
    }
}

// Secondary feature cards with better text visibility
struct SecondaryFeatureCard: View {
    let icon: String
    let title: String
    let color: Color
    var isWide: Bool = false
    
    var body: some View {
        VStack(spacing: 12) {
            ZStack {
                Circle()
                    .fill(color.opacity(0.1))
                    .frame(width: 50, height: 50)
                
                Image(systemName: icon)
                    .font(.system(size: 24, weight: .bold))
                    .foregroundColor(color)
            }
            
            Text(title)
                .font(.appHeadline)
                .fontWeight(.bold)
                .foregroundColor(.black)
                .multilineTextAlignment(.center)
                .lineLimit(2)
                .minimumScaleFactor(0.8)
        }
        .frame(maxWidth: .infinity)
        .frame(height: isWide ? 85 : 120)
        .background(
            RoundedRectangle(cornerRadius: 18)
                .fill(.white)
                .overlay(
                    RoundedRectangle(cornerRadius: 18)
                        .stroke(color.opacity(0.3), lineWidth: 1.5)
                )
                .shadow(color: color.opacity(0.2), radius: 8, x: 0, y: 4)
        )
    }
}

// Enhanced motivation card with better text visibility
struct EnhancedMotivationCard: View {
    let quote: String
    
    var body: some View {
        VStack(spacing: 16) {
            HStack {
                Image(systemName: "quote.opening")
                    .font(.system(size: 20, weight: .bold))
                    .foregroundColor(.green.opacity(0.7))
                
                Spacer()
                
                Image(systemName: "heart.fill")
                    .font(.system(size: 16))
                    .foregroundColor(.orange.opacity(0.7))
            }
            
            Text(quote)
                .font(.appHeadline)
                .fontWeight(.semibold)
                .foregroundColor(.black)
                .multilineTextAlignment(.center)
                .lineSpacing(6)
            
            HStack {
                Spacer()
                
                Image(systemName: "quote.closing")
                    .font(.system(size: 20, weight: .bold))
                    .foregroundColor(.green.opacity(0.7))
            }
        }
        .padding(24)
        .background(
            RoundedRectangle(cornerRadius: 20)
                .fill(
                    LinearGradient(
                        gradient: Gradient(colors: [
                            Color.white,
                            Color.green.opacity(0.08)
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
                                    Color.green.opacity(0.4),
                                    Color.orange.opacity(0.3)
                                ]),
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            ),
                            lineWidth: 2
                        )
                )
                .shadow(color: .green.opacity(0.15), radius: 10, x: 0, y: 5)
        )
        .padding(.horizontal, 20)
    }
}

// Legacy InfoCard for backwards compatibility
struct InfoCard: View {
    let icon: String
    let title: String
    let value: String
    let color: Color

    var body: some View {
        VStack(spacing: 8) {
            Image(systemName: icon)
                .font(.system(size: 30, weight: .bold))
                .foregroundColor(color)

            Text(title)
                .font(.appHeadline)
                .foregroundColor(.primary)

            Text(value)
                .font(.title2)
                .fontWeight(.bold)
                .foregroundColor(color)
        }
        .padding()
        .frame(maxWidth: .infinity, minHeight: 140)
        .background(
            RoundedRectangle(cornerRadius: 20)
                .fill(Color.white)
                .shadow(color: Color.gray.opacity(0.2), radius: 5, x: 3, y: 3)
                .shadow(color: Color.white.opacity(0.8), radius: 5, x: -3, y: -3)
        )
    }
}

