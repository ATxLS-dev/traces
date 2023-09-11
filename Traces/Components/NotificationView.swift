//
//  NotificationView.swift
//  Traces
//
//  Created by Bryce on 7/28/23.
//

import SwiftUI

struct NotificationView: View {
    
    @EnvironmentObject var theme: ThemeController
    @EnvironmentObject var notifications: NotificationController
    
    @State var scale = 1.0
    
    var body: some View {
        VStack {
            Spacer()
            HStack {
                Spacer()
                Text(notifications.notification?.rawValue ?? "")
                    .padding()
                    .opacity(notifications.notification != nil ? 1 : 0)
                Image(systemName: "checkmark")
                    .padding(.trailing, 24)
                    .opacity(notifications.notification != nil ? 1 : 0)
                    .scaleEffect(scale)
                    .onAppear {
                        let baseAnimation = Animation.easeInOut(duration: 1.2)
                        let repeated = baseAnimation.repeatForever(autoreverses: true)
                        withAnimation(repeated) {
                            scale = 1.2
                        }
                    }
            }
            .foregroundColor(theme.text)
            .background(BorderedCapsule(hasColoredBorder: true)
                .shadow(color: theme.shadow, radius: 4, x: 2, y: 2))
            .padding()
            .padding(.bottom, 100)
        }
        .offset(x: notifications.notification != nil ? 0 : UIScreen.main.bounds.width, y: 0)
        .animation(.interactiveSpring(response: 0.45, dampingFraction: 0.8, blendDuration: 0.69), value: notifications.notification != nil)
    }
}
