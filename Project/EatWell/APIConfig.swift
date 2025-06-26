import Foundation

struct APIConfig {
    // Mevcut IP adresinizi buraya girin - ağ değiştiğinde buradan güncelleyin
    static let defaultHost = "172.20.10.12:5002"
    static let localHost = "localhost:5002"
    
    // Dinamik host getter
    static var currentHost: String {
        return UserDefaults.standard.string(forKey: "api_host") ?? defaultHost
    }
    
    // Base URLs (dinamik)
    static var authURL: String {
        return "http://\(currentHost)/api/auth"
    }
    static var appointmentURL: String {
        return "http://\(currentHost)/api/appointment"
    }
    static var generalURL: String {
        return "http://\(currentHost)/api"
    }
    
    // Dinamik IP tespiti için gelecekte kullanılabilir
    static func updateHost(_ newHost: String) {
        // Bu fonksiyon gelecekte dinamik IP güncelleme için kullanılabilir
        UserDefaults.standard.set(newHost, forKey: "api_host")
    }
    
    static func getCurrentHost() -> String {
        return UserDefaults.standard.string(forKey: "api_host") ?? defaultHost
    }
    
    // IP değişikliği durumunda kullanım için
    static func useLocalHost() {
        UserDefaults.standard.set(localHost, forKey: "api_host")
    }
    
    static func useDefaultHost() {
        UserDefaults.standard.set(defaultHost, forKey: "api_host")
    }
} 