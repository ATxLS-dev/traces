//
//  NotificationManager.swift
//  Traces
//
//  Created by Bryce on 7/28/23.
//

import Foundation

class NotificationManager: ObservableObject {
    
    static var shared = NotificationManager()
    
    @Published var notification: Notification?
    @Published var shouldPresent: Bool = false
    
    func sendNotification(_ notificaiton: Notification) {
        self.notification = notificaiton
        self.shouldPresent = true
    }
    
    func endNotificaiton() {
        self.notification = nil
        self.shouldPresent = false
    }
    
}
