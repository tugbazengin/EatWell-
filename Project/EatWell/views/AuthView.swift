//
//  AuthView.swift
//  EatWell
//
//  Created by Tuğba Zengin on 22.05.2025.
//
import SwiftUI

struct AuthView: View {
    @StateObject private var viewModel = AuthViewModel()

    var body: some View {
        NavigationStack {
            BaseView(title: nil, showsScrollView: false) {
                VStack(spacing: 20) {
                    Text(viewModel.isRegistering ? "Kayıt Ol" : "Giriş Yap")
                        .font(.appTitle)
                        .foregroundColor(.black)

                    TextField("E-posta", text: $viewModel.email)
                        .padding()
                        .background(neumorphicEffect())
                        .cornerRadius(10)
                        .foregroundColor(.black)

                    SecureField("Şifre", text: $viewModel.password)
                        .padding()
                        .background(neumorphicEffect())
                        .cornerRadius(10)
                        .foregroundColor(.black)

                   Button(action: {
                        viewModel.authenticate()
                    }) {
                        HStack {
                            if viewModel.isLoading {
                                ProgressView()
                                    .progressViewStyle(CircularProgressViewStyle(tint: .white))
                                    .scaleEffect(0.9)
                            }
                            Text(viewModel.isRegistering ? "Kayıt Ol" : "Giriş Yap")
                                .font(.appHeadline)
                        }
                    }
                    .appButtonStyle(color: .green)
                    .padding(.horizontal, 30)
                    .disabled(viewModel.isLoading)
                    .opacity(viewModel.isLoading ? 0.7 : 1.0)

                  
                    if !viewModel.isRegistering {
                        Button(action: {
                            viewModel.navigateToResetPassword = true
                        }) {
                            Text("Şifremi Unuttum")
                                .foregroundColor(.gray)
                                .underline()
                        }
                    }

                    Button(action: {
                        viewModel.isRegistering.toggle()
                    }) {
                        Text(viewModel.isRegistering ? "Zaten üye misin? Giriş Yap" : "Hesabın yok mu? Kayıt Ol")
                            .foregroundColor(.black)
                            .underline()
                    }
                }
            }
            .overlay(
                // Error Toast
                VStack {
                    if viewModel.showError {
                        HStack {
                            Image(systemName: "exclamationmark.triangle.fill")
                                .foregroundColor(.red)
                            Text(viewModel.errorMessage ?? "Bir hata oluştu")
                                .font(.appBody)
                                .foregroundColor(.white)
                                .multilineTextAlignment(.leading)
                            Spacer()
                        }
                        .padding()
                        .background(
                            RoundedRectangle(cornerRadius: 12)
                                .fill(Color.red.opacity(0.9))
                        )
                        .shadow(radius: 8)
                        .transition(.move(edge: .top).combined(with: .opacity))
                        .animation(.spring(response: 0.5, dampingFraction: 0.8), value: viewModel.showError)
                        .padding(.horizontal)
                    }
                    Spacer()
                }
                .padding(.top, 20)
            )
            .navigationDestination(isPresented: $viewModel.navigateToProfileSetup) {
                ProfileSetupView()
            }
            .navigationDestination(isPresented: $viewModel.navigateToDashboard) {
                DashboardView()
            }
            .navigationDestination(isPresented: $viewModel.navigateToResetPassword) {
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
}


#Preview {
    AuthView()
}

