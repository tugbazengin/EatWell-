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
                VStack(spacing: 0) {
                    headerSection
                    formSection
                    actionButtonsSection
                    alternativeSection
                    Spacer()
                }
                .padding(.horizontal, 20)
            }
            .overlay(errorToastOverlay)
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
    
    // MARK: - Header Section
    private var headerSection: some View {
        VStack(spacing: 25) {
            // App Logo/Icon with gradient
            ZStack {
                Circle()
                    .fill(
                        LinearGradient(
                            gradient: Gradient(colors: [
                                Color.green.opacity(0.8),
                                Color.green.opacity(0.6)
                            ]),
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .frame(width: 120, height: 120)
                    .shadow(color: .green.opacity(0.3), radius: 12, x: 0, y: 6)
                
                Image(systemName: "leaf.fill")
                    .font(.system(size: 50, weight: .bold))
                    .foregroundColor(.white)
            }
            .padding(.top, 40)
            
            VStack(spacing: 8) {
                Text("EatWell")
                    .font(.system(size: 32, weight: .bold))
                        .foregroundColor(.black)

                Text(viewModel.isRegistering ? "Hesap Oluştur" : "Hoş Geldin")
                    .font(.appTitle3)
                    .fontWeight(.semibold)
                    .foregroundColor(.black.opacity(0.7))
            }
        }
        .padding(.bottom, 40)
    }
    
    // MARK: - Form Section
    private var formSection: some View {
        VStack(spacing: 20) {
            ModernAuthTextField(
                icon: "envelope.fill",
                placeholder: "E-posta",
                text: $viewModel.email,
                keyboardType: .emailAddress,
                color: .blue
            )
            
            ModernAuthSecureField(
                icon: "lock.fill",
                placeholder: "Şifre",
                text: $viewModel.password,
                color: .green
            )
        }
        .padding(.bottom, 30)
    }
    
    // MARK: - Action Buttons Section
    private var actionButtonsSection: some View {
        VStack(spacing: 20) {
            // Main Action Button
                   Button(action: {
                        viewModel.authenticate()
                    }) {
                HStack(spacing: 12) {
                            if viewModel.isLoading {
                                ProgressView()
                                    .progressViewStyle(CircularProgressViewStyle(tint: .white))
                                    .scaleEffect(0.9)
                    } else {
                        Image(systemName: viewModel.isRegistering ? "person.badge.plus" : "arrow.right.circle.fill")
                            .font(.system(size: 18, weight: .bold))
                            }
                    
                            Text(viewModel.isRegistering ? "Kayıt Ol" : "Giriş Yap")
                                .font(.appHeadline)
                        .fontWeight(.bold)
                    }
                .foregroundColor(.white)
                .frame(maxWidth: .infinity)
                .frame(height: 56)
                .background(
                    LinearGradient(
                        gradient: Gradient(colors: [
                            Color.green.opacity(0.8),
                            Color.green.opacity(0.6)
                        ]),
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
                .clipShape(RoundedRectangle(cornerRadius: 16))
                .shadow(color: .green.opacity(0.3), radius: 8, x: 0, y: 4)
            }
                    .disabled(viewModel.isLoading)
                    .opacity(viewModel.isLoading ? 0.7 : 1.0)

            // Forgot Password Button (only for login)
                    if !viewModel.isRegistering {
                        Button(action: {
                            viewModel.navigateToResetPassword = true
                        }) {
                    HStack(spacing: 8) {
                        Image(systemName: "key.fill")
                            .font(.system(size: 14))
                            Text("Şifremi Unuttum")
                            .font(.appBody)
                            .fontWeight(.medium)
                    }
                    .foregroundColor(.orange)
                    .padding(.vertical, 12)
                    .padding(.horizontal, 20)
                    .background(
                        RoundedRectangle(cornerRadius: 12)
                            .fill(Color.orange.opacity(0.1))
                            .overlay(
                                RoundedRectangle(cornerRadius: 12)
                                    .stroke(Color.orange.opacity(0.2), lineWidth: 1)
                            )
                    )
                }
            }
        }
        .padding(.bottom, 30)
                        }
    
    // MARK: - Alternative Section
    private var alternativeSection: some View {
        VStack(spacing: 20) {
            // Divider with text
            HStack {
                Rectangle()
                    .fill(Color.gray.opacity(0.3))
                    .frame(height: 1)
                
                Text("veya")
                    .font(.appCaption)
                    .foregroundColor(.gray)
                    .padding(.horizontal, 16)
                
                Rectangle()
                    .fill(Color.gray.opacity(0.3))
                    .frame(height: 1)
            }
            .padding(.horizontal, 20)
            
            // Switch Auth Mode Button
                    Button(action: {
                withAnimation(.easeInOut(duration: 0.3)) {
                        viewModel.isRegistering.toggle()
                }
                    }) {
                HStack(spacing: 10) {
                    Image(systemName: viewModel.isRegistering ? "arrow.left.circle" : "person.badge.plus")
                        .font(.system(size: 16, weight: .semibold))
                    
                        Text(viewModel.isRegistering ? "Zaten üye misin? Giriş Yap" : "Hesabın yok mu? Kayıt Ol")
                        .font(.appHeadline)
                        .fontWeight(.semibold)
                }
                .foregroundColor(.blue)
                .padding(.vertical, 16)
                .padding(.horizontal, 24)
                .background(
                    RoundedRectangle(cornerRadius: 14)
                        .fill(Color.blue.opacity(0.1))
                        .overlay(
                            RoundedRectangle(cornerRadius: 14)
                                .stroke(Color.blue.opacity(0.2), lineWidth: 1)
                        )
                )
            }
        }
        .padding(.bottom, 40)
    }
    
    // MARK: - Error Toast Overlay
    private var errorToastOverlay: some View {
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
    }
}

#Preview {
    AuthView()
}

