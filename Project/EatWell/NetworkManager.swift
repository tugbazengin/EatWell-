import Foundation
import Network

class NetworkManager: ObservableObject {
    @Published var currentBaseURL: String = APIConfig.generalURL
    private let monitor = NWPathMonitor()
    private let queue = DispatchQueue(label: "NetworkMonitor")
    
    init() {
        startMonitoring()
    }
    
    private func startMonitoring() {
        monitor.pathUpdateHandler = { [weak self] path in
            DispatchQueue.main.async {
                if path.status == .satisfied {
                    // Ağ değişikliği tespit edildi, IP'yi kontrol et
                    self?.updateIPIfNeeded()
                }
            }
        }
        monitor.start(queue: queue)
    }
    
    private func updateIPIfNeeded() {
        // Basit ping testi ile mevcut IP'nin çalışıp çalışmadığını kontrol et
        testConnection { [weak self] isWorking in
            if !isWorking {
                // Mevcut IP çalışmıyorsa, yeni IP'yi bul
                self?.findCurrentIP()
            }
        }
    }
    
    private func testConnection(completion: @escaping (Bool) -> Void) {
        guard let url = URL(string: "\(APIConfig.generalURL)/health") else {
            completion(false)
            return
        }
        
        let task = URLSession.shared.dataTask(with: url) { _, response, error in
            DispatchQueue.main.async {
                if let httpResponse = response as? HTTPURLResponse {
                    completion(httpResponse.statusCode == 200)
                } else {
                    completion(false)
                }
            }
        }
        task.resume()
        
        // 5 saniye timeout
        DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
            task.cancel()
            completion(false)
        }
    }
    
    private func findCurrentIP() {
        // Bilinen IP'ler listesi (bu listeyi backend CORS ayarlarından alabilirsiniz)
        let knownIPs = [
            "172.20.10.12:5002",
            "192.168.1.101:5002",
            "192.168.172.217:5002",
            "172.16.4.65:5002",
            "localhost:5002"
        ]
        
        for ip in knownIPs {
            testSpecificIP(ip) { [weak self] isWorking in
                if isWorking {
                    print("🌐 Yeni çalışan IP bulundu: \(ip)")
                    self?.updateAPIConfig(newHost: ip)
                    return
                }
            }
        }
    }
    
    private func testSpecificIP(_ host: String, completion: @escaping (Bool) -> Void) {
        guard let url = URL(string: "http://\(host)/api/health") else {
            completion(false)
            return
        }
        
        let task = URLSession.shared.dataTask(with: url) { _, response, error in
            DispatchQueue.main.async {
                if let httpResponse = response as? HTTPURLResponse {
                    completion(httpResponse.statusCode == 200)
                } else {
                    completion(false)
                }
            }
        }
        task.resume()
        
        // 3 saniye timeout
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
            task.cancel()
            completion(false)
        }
    }
    
    private func updateAPIConfig(newHost: String) {
        APIConfig.updateHost(newHost)
        // Tüm URL'leri güncelle
        self.currentBaseURL = "http://\(newHost)/api"
        
        // Notification gönder - ViewModel'lar bunu dinleyebilir
        NotificationCenter.default.post(name: .apiHostChanged, object: newHost)
    }
    
    deinit {
        monitor.cancel()
    }
}

extension Notification.Name {
    static let apiHostChanged = Notification.Name("apiHostChanged")
} 