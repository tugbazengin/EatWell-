//
//  ResetPasswordView.swift
//  EatWell
//
//  Created by Tuğba Zengin on 24.05.2025.
//
import SwiftUI

struct ResetPasswordView: View {
    @StateObject private var viewModel = ResetPasswordViewModel()
    @Environment(\.presentationMode) var presentationMode

    var body: some View {
        NavigationStack {
            BaseView(title: nil, showsScrollView: false) {
                VStack(spacing: 30) {
                    // Header Section
                    VStack(spacing: 15) {
                        Image(systemName: "key.fill")
                            .resizable()
                            .frame(width: 60, height: 60)
                            .foregroundColor(.green)
                        
                        Text("Şifremi Unuttum")
                            .font(.appTitle)
                            .foregroundColor(.black)
                        
                        Text(getSubtitleText())
                            .font(.appBody)
                            .foregroundColor(.gray)
                            .multilineTextAlignment(.center)
                            .padding(.horizontal, 20)
                    }
                    .padding(.top, 20)
                    
                    // Form Section
                    VStack(spacing: 20) {
                        if !viewModel.isVerificationSent {
                            // Email Input
                            CustomTextField(
                                placeholder: "E-posta adresinizi girin", 
                                text: $viewModel.resetData.email,
                                keyboardType: .emailAddress
                            )
                        } else if !viewModel.isVerified {
                            // Verification Code Input
                            VStack(spacing: 10) {
                                Text("E-posta adresinize gönderilen 6 haneli kodu girin:")
                                    .font(.appBody)
                                    .foregroundColor(.gray)
                                    .multilineTextAlignment(.center)
                                
                                CustomTextField(
                                    placeholder: "Doğrulama Kodu (6 hane)", 
                                    text: $viewModel.resetData.verificationCode,
                                    keyboardType: .numberPad
                                )
                            }
                        } else if !viewModel.isPasswordReset {
                            // New Password Input
                            VStack(spacing: 15) {
                                Text("Yeni şifrenizi oluşturun:")
                                    .font(.appBody)
                                    .foregroundColor(.gray)
                                
                                CustomSecureField(
                                    placeholder: "Yeni Şifre (En az 6 karakter)", 
                                    text: $viewModel.resetData.newPassword
                                )
                                
                                // Password strength indicator
                                if !viewModel.resetData.newPassword.isEmpty {
                                    HStack {
                                        Image(systemName: viewModel.resetData.newPassword.count >= 6 ? "checkmark.circle.fill" : "xmark.circle.fill")
                                            .foregroundColor(viewModel.resetData.newPassword.count >= 6 ? .green : .red)
                                        Text("En az 6 karakter")
                                            .font(.caption)
                                            .foregroundColor(viewModel.resetData.newPassword.count >= 6 ? .green : .red)
                                        Spacer()
                                    }
                                }
                            }
                        }
                    }
                    
                    // Action Button
                    Button(action: {
                        viewModel.handleButtonPress()
                    }) {
                        HStack {
                            if viewModel.isLoading {
                                ProgressView()
                                    .progressViewStyle(CircularProgressViewStyle(tint: .white))
                                    .scaleEffect(0.9)
                            }
                            Text(getButtonText())
                                .font(.appHeadline)
                        }
                    }
                    .appButtonStyle(color: getButtonColor())
                    .disabled(viewModel.isLoading || !isButtonEnabled())
                    .opacity((viewModel.isLoading || !isButtonEnabled()) ? 0.7 : 1.0)
                    .padding(.horizontal, 30)
                    
                    // Success Message
                    if viewModel.isPasswordReset {
                        VStack(spacing: 15) {
                            Image(systemName: "checkmark.circle.fill")
                                .resizable()
                                .frame(width: 50, height: 50)
                                .foregroundColor(.green)
                            
                            Text("Şifre Başarıyla Sıfırlandı!")
                                .font(.appHeadline)
                                .foregroundColor(.green)
                                .fontWeight(.bold)
                            
                            Text("Giriş ekranına yönlendiriliyorsunuz...")
                                .font(.appBody)
                                .foregroundColor(.gray)
                        }
                        .transition(.scale.combined(with: .opacity))
                        .animation(.spring(response: 0.6, dampingFraction: 0.8), value: viewModel.isPasswordReset)
                    }
                    
                    Spacer()
                    
                    // Back to Login Button
                    if !viewModel.isPasswordReset {
                        Button(action: {
                            presentationMode.wrappedValue.dismiss()
                        }) {
                            Text("Giriş Ekranına Dön")
                                .font(.appBody)
                                .foregroundColor(.gray)
                                .underline()
                        }
                    }
                }
                .padding(.horizontal, 20)
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
            .navigationBarHidden(true)
        }
        .fullScreenCover(isPresented: $viewModel.navigateToAuthView) {
            AuthView()
                .onAppear {
                    viewModel.resetAll()
                }
        }
    }
    
    private func getSubtitleText() -> String {
        if viewModel.isPasswordReset {
            return ""
        } else if viewModel.isVerified {
            return "Güvenli ve hatırlanabilir bir şifre oluşturun"
        } else if viewModel.isVerificationSent {
            return "E-posta adresinizi kontrol edin"
        } else {
            return "Şifrenizi sıfırlamak için e-posta adresinizi girin"
        }
    }
    
    private func getButtonText() -> String {
        if viewModel.isPasswordReset {
            return "Giriş Ekranına Git"
        } else if viewModel.isVerified {
            return "Şifreyi Kaydet"
        } else if viewModel.isVerificationSent {
            return "Kodu Doğrula"
        } else {
            return "Kod Gönder"
        }
    }
    
    private func getButtonColor() -> Color {
        if viewModel.isPasswordReset {
            return .gray
        } else {
            return .green
        }
    }
    
    private func isButtonEnabled() -> Bool {
        if viewModel.isPasswordReset {
            return false
        } else if viewModel.isVerified {
            return !viewModel.resetData.newPassword.isEmpty && viewModel.resetData.newPassword.count >= 6
        } else if viewModel.isVerificationSent {
            return !viewModel.resetData.verificationCode.isEmpty && viewModel.resetData.verificationCode.count == 6
        } else {
            return !viewModel.resetData.email.isEmpty && viewModel.resetData.email.contains("@")
        }
    }
}

#Preview {
    ResetPasswordView()
}


