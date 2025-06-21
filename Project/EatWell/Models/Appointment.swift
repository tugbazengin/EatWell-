//
//  Appointment.swift
//  EatWell
//
//  Created by Tuğba Zengin on 23.05.2025.
//
import Foundation

struct Appointment: Identifiable {
    let id = UUID()
    let dietitian: String
    let date: String
    let time: String
    let status: String
} 

//
//  Appointment.swift
//  EatWell
//
//  Created by Tuğba Zengin on 23.05.2025.
//
import Foundation

struct Appointment: Identifiable, Codable {
    let id: String
    let dietitian: String
    let date: String
    let time: String
    let status: String
}

