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
    
    func sendNotification(_ notification: Notification) {
        self.notification = notification
    }
    
    func endNotification() {
        self.notification = nil
    }
    
}
