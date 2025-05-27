//
//  AppointmentListViewModel.swift
//  EatWell
//
//  Created by Tuğba Zengin on 23.05.2025.
//

import Foundation
import SwiftUI

class AppointmentListViewModel: ObservableObject {
    @Published var appointments: [Appointment] = [
        Appointment(dietitian: "Dr. Tuğba Zengin", date: "25 Mart 2025", time: "10:00", status: "Onaylandı"),
        Appointment(dietitian: "Dr. Berke Baş", date: "27 Mart 2025", time: "14:00", status: "Beklemede"),
        Appointment(dietitian: "Dr. Sıla Bıçakçı", date: "29 Mart 2025", time: "16:00", status: "Onaylandı")
    ]

    func removeAppointment(_ appointment: Appointment) {
        withAnimation {
            appointments.removeAll { $0.id == appointment.id }
        }
    }
}
