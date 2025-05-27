//
//  SplashView.swift
//  EatWell
//
//  Created by Tuğba Zengin on 29.03.2025.
//

import SwiftUI

struct SplashView: View {
    @State private var showText = false
    @State private var showSlogan = false
    @State private var showLoading = false
    @State private var navigateToAuth = false
    
    let title = "EatWell"
    let slogan = "Sağlıklı beslen, mutlu yaşa!"
    
    var body: some View {
        ZStack {
            Color.green.opacity(0.8) 
                .edgesIgnoringSafeArea(.all)
            
            VStack {
                
                HStack(spacing: 0) {
                    ForEach(Array(title.enumerated()), id: \.offset) { index, letter in
                        Text(String(letter))
                            .font(.system(size: 50, weight: .bold, design: .rounded))
                            .foregroundColor(.white)
                            .opacity(showText ? 1 : 0)
                            .offset(y: showText ? 0 : 20)
                            .animation(.spring().delay(0.1 * Double(index)), value: showText)
                    }
                }
                
                
                if showSlogan {
                    Text(slogan)
                        .font(.title2)
                        .foregroundColor(.white)
                        .padding(.top, 10)
                        .transition(.opacity)
                        .animation(.easeIn(duration: 1), value: showSlogan)
                }
                
             
                if showLoading {
                    Text("⏳")
                        .font(.system(size: 40))
                        .padding(.top, 20)
                        .transition(.opacity)
                        .animation(.easeIn(duration: 0.5), value: showLoading)
                }
            }
        }
        .onAppear {
            withAnimation {
                showText = true
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                withAnimation {
                    showSlogan = true
                }
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                withAnimation {
                    showLoading = true
                }
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 5) { // Süre 5 saniye
                navigateToAuth = true
            }
        }
        .fullScreenCover(isPresented: $navigateToAuth) {
            AuthView() // Giriş ekranına yönlendirme
        }
    }
}

#Preview {
    SplashView()
}
