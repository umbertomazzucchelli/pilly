//
//  NotificationManager.swift
//  pilly
//
//  Created by Umberto Mazzucchelli on 12/6/24.
//

import Foundation

class NotificationManager {
    static let shared = NotificationManager()
    private init() {}
    
    // Keep track of observers to prevent duplicates
    private var registeredObservers: [String: NSObjectProtocol] = [:]
    
    func addObserver(for name: Notification.Name,
                     object: Any? = nil,
                     identifier: String,
                     using block: @escaping (Notification) -> Void) {
        // Remove existing observer if any
        removeObserver(identifier: identifier)
        
        // Add new observer
        let observer = NotificationCenter.default.addObserver(
            forName: name,
            object: object,
            queue: .main,
            using: block
        )
        
        registeredObservers[identifier] = observer
    }
    
    func removeObserver(identifier: String) {
        if let observer = registeredObservers[identifier] {
            NotificationCenter.default.removeObserver(observer)
            registeredObservers.removeValue(forKey: identifier)
        }
    }
    
    func removeAllObservers() {
        registeredObservers.forEach { (_, observer) in
            NotificationCenter.default.removeObserver(observer)
        }
        registeredObservers.removeAll()
    }
    
    func post(name: Notification.Name, object: Any? = nil) {
        NotificationCenter.default.post(name: name, object: object)
    }
    
    deinit {
        removeAllObservers()
    }
}
