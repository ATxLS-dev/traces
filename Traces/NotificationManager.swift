//
//  NotificationManager.swift
//  Traces
//
//  Created by Bryce on 7/28/23.
//

import Foundation

enum Notification : String {
    case signedIn = "Signed in"
    case signedOut = "Signed out"
    case accountCreated = "Account created"
    case traceSaved = "Trace saved"
    case traceUpdated = "Trace updated"
    case traceReported = "Trace reported"
    case traceDeleted = "Trace deleted"
    case linkCopied = "Link copied to clipboard"
}

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
