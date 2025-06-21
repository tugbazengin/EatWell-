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
            if viewModel.appointments.isEmpty {
                Text("Henüz randevunuz bulunmamaktadır.")
                    .font(.appHeadline)
                    .foregroundColor(.gray)
            } else {
                VStack(spacing: 15) {
                    ForEach(viewModel.appointments) { appointment in
                        AppointmentCard(appointment: appointment) {
                            viewModel.removeAppointment(appointment)
                        }
                    }
                }
            }
            
            if let errorMessage = viewModel.errorMessage {
                Text(errorMessage)
                    .foregroundColor(.red)
                    .font(.appBody)
            }
        }
        .onAppear {
            viewModel.fetchAppointments()
        }
    }
}

#Preview {
    AppointmentListView()
}




