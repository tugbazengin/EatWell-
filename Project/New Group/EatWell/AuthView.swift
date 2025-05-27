//
//  AuthView.swift
//  EatWell
//
//  Created by Tuğba Zengin on 27.03.2025.
//
import SwiftUI

struct AuthView: View {
    @State private var email: String = ""
    @State private var password: String = ""
    @State private var isRegistering: Bool = false
    @State private var navigateToProfileSetup = false
    @State private var navigateToDashboard = false
    @State private var navigateToResetPassword = false
    
    var body: some View {
        NavigationStack {
            ZStack {
               
                LinearGradient(gradient: Gradient(colors: [Color.green.opacity(1.0), Color.green.opacity(0.5)]),
                               startPoint: .top, endPoint: .bottom)
                    .edgesIgnoringSafeArea(.all)
                
                VStack(spacing: 20) {
                    Text(isRegistering ? "Kayıt Ol" : "Giriş Yap")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
          
                    TextField("E-posta", text: $email)
                        .padding()
                        .background(neumorphicEffect())
                        .cornerRadius(10)
                        .padding(.horizontal, 30)
                        .foregroundColor(.black)

               
                    SecureField("Şifre", text: $password)
                        .padding()
                        .background(neumorphicEffect())
                        .cornerRadius(10)
                        .padding(.horizontal, 30)
                        .foregroundColor(.black)
                    
               
                    Button(action: {
                        if isRegistering {
                            navigateToProfileSetup = true
                        } else {
                            navigateToDashboard = true
                        }
                    }) {
                        Text(isRegistering ? "Kayıt Ol" : "Giriş Yap")
                            .font(.title2)
                            .fontWeight(.semibold)
                            .foregroundColor(.white)
                            .frame(width: 200, height: 50)
                            .background(neumorphicButtonEffect())
                            .cornerRadius(25)
                            .shadow(radius: 5)
                    }
                    
                
                    if !isRegistering {
                        Button(action: {
                            navigateToResetPassword = true
                        }) {
                            Text("Şifremi Unuttum")
                                .foregroundColor(.white.opacity(0.8))
                                .underline()
                        }
                    }
                    
                    
                    Button(action: {
                        isRegistering.toggle()
                    }) {
                        Text(isRegistering ? "Zaten üye misin? Giriş Yap" : "Hesabın yok mu? Kayıt Ol")
                            .foregroundColor(.white)
                            .underline()
                    }
                }
            }
            // iOS 16+ uyumlu ********
            .navigationDestination(isPresented: $navigateToProfileSetup) {
                ProfileSetupView()
            }
            .navigationDestination(isPresented: $navigateToDashboard) {
                DashboardView()
            }
            .navigationDestination(isPresented: $navigateToResetPassword) {
                ResetPasswordView()
            }
        }
    }
    
  
    func neumorphicEffect() -> some View {
        RoundedRectangle(cornerRadius: 10)
            .fill(Color.white.opacity(0.9))
            .shadow(color: Color.white.opacity(0.8), radius: 6, x: -6, y: -6)
            .shadow(color: Color.black.opacity(0.2), radius: 6, x: 6, y: 6)
    }
    
 
    func neumorphicButtonEffect() -> some View {
        RoundedRectangle(cornerRadius: 25)
            .fill(LinearGradient(gradient: Gradient(colors: [Color.green.opacity(0.8), Color.green.opacity(1.0)]),
                                 startPoint: .topLeading, endPoint: .bottomTrailing))
            .shadow(color: Color.white.opacity(0.8), radius: 6, x: -6, y: -6)
            .shadow(color: Color.black.opacity(0.2), radius: 6, x: 6, y: 6)
    }
}

#Preview {
    AuthView()
}


