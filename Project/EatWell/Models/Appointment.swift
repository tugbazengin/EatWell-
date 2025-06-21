//
//  Appointment.swift
//  EatWell
//
//  Created by Tuğba Zengin on 23.05.2025.
//
import Foundation

struct Appointment: Identifiable, Codable {
    let id: String
    let user: String
    let dietitian: String
    let date: String
    let time: String
    let status: String
    let createdAt: String?
    let updatedAt: String?
    
    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case user, dietitian, date, time, status, createdAt, updatedAt
    }
    
    // Date formatter for displaying formatted date
    var formattedDate: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        
        if let date = formatter.date(from: date) {
            formatter.dateFormat = "dd MMMM yyyy"
            formatter.locale = Locale(identifier: "tr_TR")
            return formatter.string(from: date)
        }
        
        // Fallback for simple date format
        let simpleFormatter = DateFormatter()
        simpleFormatter.dateFormat = "yyyy-MM-dd"
        if let date = simpleFormatter.date(from: date) {
            simpleFormatter.dateFormat = "dd MMMM yyyy"
            simpleFormatter.locale = Locale(identifier: "tr_TR")
            return simpleFormatter.string(from: date)
        }
        
        return date
    }
    
    var statusText: String {
        switch status {
        case "approved":
            return "Onaylandı"
        case "pending":
            return "Bekliyor"
        case "cancelled":
            return "İptal Edildi"
        default:
            return status
        }
    }
}

