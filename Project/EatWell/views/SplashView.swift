//
//  SplashView.swift
//  EatWell
//
//  Created by Tuğba Zengin on 25.05.2025.
//

import SwiftUI

struct SplashView: View {
    @StateObject private var viewModel = SplashViewModel()
    
    var body: some View {
        ZStack {
            Color.green.opacity(0.8)
                .edgesIgnoringSafeArea(.all)
            
            VStack(spacing: 20) {
                // Ana başlık
                HStack(spacing: 2) {
                    ForEach(Array(viewModel.title.enumerated()), id: \.offset) { index, letter in
                        Text(String(letter))
                            .font(.system(size: 50, weight: .bold, design: .rounded))
                            .foregroundColor(.white)
                            .scaleEffect(viewModel.showText ? 1.0 : 0.5)
                            .opacity(viewModel.showText ? 1.0 : 0.0)
                            .animation(
                                .spring(response: 0.6, dampingFraction: 0.8)
                                .delay(Double(index) * 0.1),
                                value: viewModel.showText
                            )
                    }
                }
                
                // Slogan
                if viewModel.showSlogan {
                    Text(viewModel.slogan)
                        .font(.title2)
                        .fontWeight(.medium)
                        .foregroundColor(.white)
                        .multilineTextAlignment(.center)
                        .opacity(viewModel.showSlogan ? 1.0 : 0.0)
                        .scaleEffect(viewModel.showSlogan ? 1.0 : 0.8)
                        .animation(.easeOut(duration: 0.8), value: viewModel.showSlogan)
                }
                
                // Loading indicator
                if viewModel.showLoading {
                    VStack(spacing: 8) {
                        ProgressView()
                            .progressViewStyle(CircularProgressViewStyle(tint: .white))
                            .scaleEffect(1.2)
                        
                        Text("Yükleniyor...")
                            .font(.caption)
                            .foregroundColor(.white.opacity(0.8))
                    }
                    .opacity(viewModel.showLoading ? 1.0 : 0.0)
                    .animation(.easeIn(duration: 0.5), value: viewModel.showLoading)
                }
            }
        }
        .onAppear {
            viewModel.startAnimationSequence()
        }
        .fullScreenCover(isPresented: $viewModel.navigateToAuth) {
            AuthView()
        }
        .fullScreenCover(isPresented: $viewModel.navigateToDashboard) {
            ContentView()
        }
    }
}

#Preview {
    SplashView()
}
