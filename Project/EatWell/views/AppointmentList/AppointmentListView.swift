//
//  AppointmentListView.swift
//  EatWell
//
//  Created by Tuğba Zengin on 23.05.2025.
//
import SwiftUI

struct AppointmentListView: View {
    @StateObject private var viewModel = AppointmentListViewModel()

    var body: some View {
        BaseView(title: "Randevularım", showsScrollView: true) {
            if viewModel.isLoading {
                VStack {
                    ProgressView()
                        .scaleEffect(1.5)
                    Text("Randevular yükleniyor...")
                        .font(.appBody)
                        .foregroundColor(.secondary)
                        .padding(.top)
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            } else if viewModel.appointments.isEmpty {
                VStack(spacing: 20) {
                    Image(systemName: "calendar.badge.exclamationmark")
                        .font(.system(size: 60))
                        .foregroundColor(.gray.opacity(0.5))
                    
                    Text("Henüz randevunuz bulunmamaktadır.")
                        .font(.appHeadline)
                        .foregroundColor(.gray)
                        .multilineTextAlignment(.center)
                    
                    Text("Randevu almak için Ana Sayfa'daki Randevu Al seçeneğini kullanabilirsiniz.")
                        .font(.appBody)
                        .foregroundColor(.secondary)
                        .multilineTextAlignment(.center)
                }
                .padding()
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            } else {
                LazyVStack(spacing: 12) {
                    ForEach(viewModel.appointments) { appointment in
                        AppointmentCard(appointment: appointment) {
                            viewModel.cancelAppointment(appointment)
                        }
                    }
                }
                .padding(.top)
            }
            
            if let errorMessage = viewModel.errorMessage {
                VStack {
                    Text(errorMessage)
                        .foregroundColor(.red)
                        .font(.appBody)
                        .multilineTextAlignment(.center)
                        .padding()
                        .background(Color.red.opacity(0.1))
                        .cornerRadius(8)
                        .padding(.horizontal)
                    
                    Button("Tekrar Dene") {
                        viewModel.fetchAppointments()
                    }
                    .appButtonStyle(color: .blue)
                    .padding(.horizontal)
                }
            }
        }
        .onAppear {
            viewModel.fetchAppointments()
        }
        .refreshable {
            viewModel.fetchAppointments()
        }
    }
}

#Preview {
    AppointmentListView()
}




