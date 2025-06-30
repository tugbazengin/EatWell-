//
//  ProfileView.swift
//  EatWell
//
//  Created by Tuğba Zengin on 23.05.2025.
import SwiftUI

struct ProfileView: View {
    @StateObject private var viewModel = ProfileViewModel()
    
    // Numeric alanları String olarak bind etmek için computed property'ler
    private var ageBinding: Binding<String> {
        Binding(
            get: { String(viewModel.profile.age) },
            set: { newValue in
                if let intValue = Int(newValue) {
                    viewModel.profile.age = intValue
                    if viewModel.isEditing {
                        viewModel.calculateHealthMetrics()
                    }
                }
            }
        )
    }
    
    private var heightBinding: Binding<String> {
        Binding(
            get: { String(viewModel.profile.height) },
            set: { newValue in
                if let doubleValue = Double(newValue) {
                    viewModel.profile.height = doubleValue
                    if viewModel.isEditing {
                        viewModel.calculateHealthMetrics()
                    }
                }
            }
        )
    }
    
    private var weightBinding: Binding<String> {
        Binding(
            get: { String(viewModel.profile.weight) },
            set: { newValue in
                if let doubleValue = Double(newValue) {
                    viewModel.profile.weight = doubleValue
                    if viewModel.isEditing {
                        viewModel.calculateHealthMetrics()
                    }
                }
            }
        )
    }
    
    private var targetWeightBinding: Binding<String> {
        Binding(
            get: { String(viewModel.profile.targetWeight) },
            set: { newValue in
                if let doubleValue = Double(newValue) {
                    viewModel.profile.targetWeight = doubleValue
                    if viewModel.isEditing {
                        viewModel.calculateHealthMetrics()
                    }
                }
            }
        )
    }

    var body: some View {
        NavigationStack {
            BaseView(title: "Profil") {
                ScrollView {
                    VStack(spacing: 30) {
                        profileHeaderSection
                        personalInfoSection
                        healthMetricsSection
                        Spacer(minLength: 80)
                    }
                }
                .onAppear {
                    viewModel.fetchProfile()
                }
                .overlay(editButtonOverlay)
                .overlay(successToastOverlay)
                .overlay(loadingOverlay)
                .alert(isPresented: $viewModel.showDeleteConfirmation) {
                    Alert(
                        title: Text("Profil Silinsin Mi?"),
                        message: Text("Bu işlemi geri alamazsınız."),
                        primaryButton: .destructive(Text("Evet"), action: viewModel.deleteProfile),
                        secondaryButton: .cancel(Text("Hayır"))
                    )
                }
                .alert("Hata", isPresented: Binding<Bool>(
                    get: { viewModel.errorMessage != nil },
                    set: { _ in viewModel.errorMessage = nil }
                )) {
                    Button("Tamam") {
                        viewModel.errorMessage = nil
                    }
                } message: {
                    if let errorMessage = viewModel.errorMessage {
                        Text(errorMessage)
                    }
                }
                .fullScreenCover(isPresented: $viewModel.navigateToAuth) {
                    AuthView()
                }
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Text("Profil")
                        .font(.appHeadline)
                        .foregroundColor(.primary)
                }
                ToolbarItemGroup(placement: .navigationBarTrailing) {
                    Button(action: { 
                        print("🗑️ Çöp kutusu butonuna tıklandı!")
                        print("📊 Mevcut showDeleteConfirmation: \(viewModel.showDeleteConfirmation)")
                        viewModel.showDeleteConfirmation = true
                        print("📊 Yeni showDeleteConfirmation: \(viewModel.showDeleteConfirmation)")
                    }) {
                        Image(systemName: "trash")
                            .font(.title2)
                            .foregroundColor(.red)
                    }
                    Button(action: { 
                        print("🚪 Çıkış butonuna tıklandı - direkt logout!")
                        viewModel.logout()
                    }) {
                        Image(systemName: "rectangle.portrait.and.arrow.forward")
                            .font(.title2)
                            .foregroundColor(.blue)
                    }
                }
            }
        }
    }
    
    // MARK: - Profile Header Section
    private var profileHeaderSection: some View {
        VStack(spacing: 20) {
            // Profile Avatar with enhanced styling
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
                    .frame(width: 130, height: 130)
                    .shadow(color: .green.opacity(0.3), radius: 10, x: 0, y: 5)
                
                Image(systemName: "person.fill")
                    .font(.system(size: 60, weight: .semibold))
                    .foregroundColor(.white)
            }
            .padding(.top, 20)
            
            // User name display
            Text(viewModel.profile.fullName.isEmpty ? "Kullanıcı" : viewModel.profile.fullName)
                .font(.appTitle3)
                .fontWeight(.bold)
                .foregroundColor(.black)
        }
        .padding(.bottom, 10)
    }
    
    // MARK: - Personal Information Section
    private var personalInfoSection: some View {
        VStack(spacing: 16) {
            HStack {
                Image(systemName: "person.text.rectangle")
                    .font(.system(size: 20, weight: .semibold))
                    .foregroundColor(.green)
                Text("Kişisel Bilgiler")
                    .font(.appTitle3)
                    .fontWeight(.bold)
                    .foregroundColor(.black)
                Spacer()
            }
            .padding(.horizontal, 20)
            
            VStack(spacing: 12) {
                profileDataFields
            }
            .padding(20)
            .background(
                RoundedRectangle(cornerRadius: 20)
                    .fill(.white)
                    .shadow(color: .black.opacity(0.05), radius: 10, x: 0, y: 5)
            )
            .padding(.horizontal, 20)
        }
    }
    
    // MARK: - Profile Data Fields
    private var profileDataFields: some View {
        Group {
            ModernProfileRow(
                icon: "person.fill",
                label: "Ad Soyad",
                value: $viewModel.profile.fullName,
                isEditing: viewModel.isEditing,
                color: .green
            )
            
            ModernProfileRow(
                icon: "calendar",
                label: "Yaş",
                value: ageBinding,
                isEditing: viewModel.isEditing,
                keyboardType: .numberPad,
                color: .blue
            )
            
            ModernProfileRow(
                icon: "arrow.up.and.down",
                label: "Boy (cm)",
                value: heightBinding,
                isEditing: viewModel.isEditing,
                keyboardType: .decimalPad,
                color: .orange
            )
            
            ModernProfileRow(
                icon: "scalemass",
                label: "Kilo (kg)",
                value: weightBinding,
                isEditing: viewModel.isEditing,
                keyboardType: .decimalPad,
                color: .green
            )
            
            ModernProfileRow(
                icon: "phone.fill",
                label: "Telefon",
                value: $viewModel.profile.phoneNumber,
                isEditing: viewModel.isEditing,
                keyboardType: .phonePad,
                color: .blue
            )
            
            ModernProfileRow(
                icon: "target",
                label: "Hedef Kilo",
                value: targetWeightBinding,
                isEditing: viewModel.isEditing,
                keyboardType: .decimalPad,
                color: .orange
            )
        }
    }
    
    // MARK: - Health Metrics Section
    private var healthMetricsSection: some View {
        VStack(spacing: 16) {
            HStack {
                Image(systemName: "heart.text.square")
                    .font(.system(size: 20, weight: .semibold))
                    .foregroundColor(.orange)
                Text("Sağlık Metrikleri")
                    .font(.appTitle3)
                    .fontWeight(.bold)
                    .foregroundColor(.black)
                Spacer()
            }
            .padding(.horizontal, 20)
            
            VStack(spacing: 12) {
                healthMetricCards
            }
            .padding(.horizontal, 20)
        }
    }
    
    // MARK: - Health Metric Cards
    private var healthMetricCards: some View {
        Group {
            ModernProfileInfoCard(
                title: "Vücut Kitle Endeksi",
                value: viewModel.profile.bmi ?? "-",
                icon: "chart.bar.fill",
                gradientColors: [Color.green.opacity(0.8), Color.green.opacity(0.6)]
            )
            
            ModernProfileInfoCard(
                title: "Günlük Kalori İhtiyacı",
                value: "\(viewModel.profile.dailyCalories ?? "0") kcal",
                icon: "flame.fill",
                gradientColors: [Color.orange.opacity(0.8), Color.orange.opacity(0.6)]
            )
            
            ModernProfileInfoCard(
                title: "Günlük Su Tüketimi",
                value: "\(viewModel.profile.dailyWaterIntake ?? "0.00") L",
                icon: "drop.fill",
                gradientColors: [Color.blue.opacity(0.8), Color.blue.opacity(0.6)]
            )
        }
    }
    
    // MARK: - Edit Button Overlay
    private var editButtonOverlay: some View {
        VStack {
            Spacer()
            HStack {
                Spacer()
                Button(action: { 
                    if viewModel.isEditing {
                        viewModel.updateProfile()
                    }
                    viewModel.isEditing.toggle() 
                }) {
                    ZStack {
                        Circle()
                            .fill(
                                LinearGradient(
                                    gradient: Gradient(colors: viewModel.isEditing ? 
                                        [Color.green.opacity(0.8), Color.green.opacity(0.6)] :
                                        [Color.blue.opacity(0.8), Color.blue.opacity(0.6)]
                                    ),
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                )
                            )
                            .frame(width: 60, height: 60)
                            .shadow(color: (viewModel.isEditing ? Color.green : Color.blue).opacity(0.3), radius: 8, x: 0, y: 4)
                        
                        if viewModel.isLoading {
                            ProgressView()
                                .progressViewStyle(CircularProgressViewStyle(tint: .white))
                        } else {
                            Image(systemName: viewModel.isEditing ? "checkmark" : "pencil")
                                .font(.system(size: 24, weight: .bold))
                                .foregroundColor(.white)
                        }
                    }
                }
                .disabled(viewModel.isLoading)
            }
            .padding(20)
        }
    }
    
    // MARK: - Success Toast Overlay
    private var successToastOverlay: some View {
        VStack {
            if viewModel.showSuccessMessage {
                HStack {
                    Image(systemName: "checkmark.circle.fill")
                        .foregroundColor(.green)
                    Text("Profil başarıyla güncellendi!")
                        .font(.appBody)
                        .foregroundColor(.white)
                }
                .padding()
                .background(
                    RoundedRectangle(cornerRadius: 12)
                        .fill(Color.black.opacity(0.8))
                )
                .transition(.move(edge: .top).combined(with: .opacity))
                .animation(.spring(), value: viewModel.showSuccessMessage)
            }
            Spacer()
        }
        .padding(.top, 60)
    }
    
    // MARK: - Loading Overlay
    private var loadingOverlay: some View {
        Group {
            if viewModel.isLoading {
                ZStack {
                    Color.black.opacity(0.3)
                        .ignoresSafeArea()
                    
                    VStack(spacing: 20) {
                        ProgressView()
                            .progressViewStyle(CircularProgressViewStyle(tint: .white))
                            .scaleEffect(1.5)
                        
                        Text("İşlem gerçekleştiriliyor...")
                            .font(.appBody)
                            .foregroundColor(.white)
                    }
                    .padding(30)
                    .background(
                        RoundedRectangle(cornerRadius: 16)
                            .fill(Color.black.opacity(0.8))
                    )
                }
                .transition(.opacity)
                .animation(.easeInOut, value: viewModel.isLoading)
            }
        }
    }
}
