//
//  NotificationView.swift
//  Traces
//
//  Created by Bryce on 7/28/23.
//

import SwiftUI

struct NotificationView: View {
    @ObservedObject var themeManager = ThemeManager.shared
    @ObservedObject var notificationManager = NotificationManager.shared
    
    @Binding var isPresented: Bool
    @State private var dismissTimer: Timer? // Step 1: Add a timer to dismiss the view
    
    var body: some View {
        HStack {
            Spacer()
            Text(notificationManager.notification?.rawValue ?? "Notification")
                .bold()
                .foregroundColor(themeManager.theme.text)
                .padding()
                .padding(.trailing, 24)
        }
        .background(BorderedCapsule())
        .padding()
        .onAppear {
            // Step 2: Start the timer when the view appears
            dismissTimer = Timer.scheduledTimer(withTimeInterval: 3.0, repeats: false) { _ in
                isPresented = false
            }
        }
        .onDisappear {
            // Step 3: Invalidate the timer when the view disappears
            dismissTimer?.invalidate()
            dismissTimer = nil
        }
    }
}

struct NotificationView_Previews: PreviewProvider {
    static var previews: some View {
        NotificationView(isPresented: .constant(true))
    }
}
