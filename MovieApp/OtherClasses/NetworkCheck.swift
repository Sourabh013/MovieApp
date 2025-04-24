//
//  NetworkCheck.swift
//  MovieApp
//
//  Created by Sourabh Modi on 19/10/24.
//

import Foundation
import Network

var networkStatus:Bool?

class NetworkCheck {
    static let shared = NetworkCheck()
    private let monitor: NWPathMonitor
    private(set) var isConnected: Bool = false
    private var initialized = false
    
    private init() {
        monitor = NWPathMonitor()
    }
    func startMonitoring() {
        guard !initialized else { return }
        
        monitor.pathUpdateHandler = { [weak self] path in
            guard let self = self else { return }
            let newStatus = (path.status == .satisfied)
            if self.isConnected != newStatus {
                self.isConnected = newStatus
                DispatchQueue.main.async {
                    NotificationCenter.default.post(name: .networkStatusChanged, object: nil)
                }
            }
            print("Network status changed: \(self.isConnected ? "Connected" : "Not Connected")")
        }
        let queue = DispatchQueue(label: "NetworkMonitor")
        monitor.start(queue: queue)
        initialized = true
    }
}
extension Notification.Name {
    static let networkStatusChanged = Notification.Name("networkStatusChanged")
}
