//
//  NotificationView.swift
//  Traces
//
//  Created by Bryce on 7/28/23.
//

import SwiftUI

enum Notification : String {
    case signedIn = "Signed in"
    case signedOut = "Signed out"
    case accountCreated = "Account created"
    case traceSaved = "Trace saved"
    case traceReported = "Trace reported"
    case linkCopied = "Link copied to clipboard"
}

struct NotificationView: View {
    @ObservedObject var themeManager = ThemeManager.shared
    @ObservedObject var notificationManager = NotificationManager.shared
    
    var notification: Notification?
    
    var body: some View {
        if notificationManager.notification != nil {
            buildNotification()
                .onAppear {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1.6) {
                        notificationManager.endNotification()
                    }
                }
        }
        
    }

    func buildNotification() -> some View {
        VStack {
            Spacer()
            HStack {
                Spacer()
                Text(notification?.rawValue ?? "No notification")
                    .foregroundColor(themeManager.theme.text)
                    .padding()
                Image(systemName: "checkmark")
                    .padding(.trailing, 24)
                
            }
            .background(BorderedCapsule(hasColoredBorder: true))
            .padding()
            .padding(.bottom, 80)
        }
    }
}

struct NotificationView_Previews: PreviewProvider {
    static var previews: some View {
        NotificationView(notification: .accountCreated)
    }
}
