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
    case traceReported = "Trace reported"
    case linkCopied = "Link copied to clipboard"
}

class NotificationManager: ObservableObject {
    
    static let shared = NotificationManager()
    
    @Published var notification: Notification? = nil
    
    func sendNotification(_ notification: Notification) {
        self.notification = notification
    }
    
    
}
