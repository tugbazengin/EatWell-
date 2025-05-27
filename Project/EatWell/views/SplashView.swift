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
            
            VStack {
                HStack(spacing: 0) {
                    ForEach(Array(viewModel.title.enumerated()), id: \.offset) { index, letter in
                        Text(String(letter))
                            .font(.system(size: 50, weight: .bold, design: .rounded))
                            .foregroundColor(.white)
                            .opacity(viewModel.showText ? 1 : 0)
                            .offset(y: viewModel.showText ? 0 : 20)
                            .animation(.spring().delay(0.1 * Double(index)), value: viewModel.showText)
                    }
                }
                
                if viewModel.showSlogan {
                    Text(viewModel.slogan)
                        .font(.title2)
                        .foregroundColor(.white)
                        .padding(.top, 10)
                        .transition(.opacity)
                        .animation(.easeIn(duration: 1), value: viewModel.showSlogan)
                }
                
                if viewModel.showLoading {
                    Text("⏳")
                        .font(.system(size: 40))
                        .padding(.top, 20)
                        .transition(.opacity)
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
    }
}

#Preview {
    SplashView()
}
