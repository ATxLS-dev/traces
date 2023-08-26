//
//  NotificationManager.swift
//  Traces
//
//  Created by Bryce on 7/28/23.
//

import Foundation
import SwiftUI

enum Notification : String {
    case signedIn = "Signed in"
    case signedOut = "Signed out"
    case accountCreated = "Account created"
    case traceSaved = "Trace saved"
    case traceUpdated = "Trace updated"
    case traceReported = "Trace reported"
    case traceDeleted = "Trace deleted"
    case traceCreated = "Trace created"
    case bioUpdated = "Bio updated"
    case linkCopied = "Details copied to clipboard"
    case coordinatesCopied = "Coordinates copied to clipboard"
}

class NotificationController: ObservableObject {
    
    static var shared = NotificationController()
    
    @Published var notification: Notification?
    
    func sendNotification(_ notification: Notification) {
        self.notification = notification
        Task {
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.6) {
                self.endNotification()
            }
        }
    }
    
    func endNotification() {
        self.notification = nil
    }
    
}
