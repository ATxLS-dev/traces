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
    
    @State var scale = 1.0
    
    var body: some View {
        VStack {
            Spacer()
            HStack {
                Spacer()
                Text(notificationManager.notification?.rawValue ?? "")
                    .padding()
                    .opacity(notificationManager.notification != nil ? 1 : 0)
                Image(systemName: "checkmark")
                    .padding(.trailing, 24)
                    .opacity(notificationManager.notification != nil ? 1 : 0)
                    .scaleEffect(scale)
                    .onAppear {
                        let baseAnimation = Animation.easeInOut(duration: 1.2)
                        let repeated = baseAnimation.repeatForever(autoreverses: true)
                        withAnimation(repeated) {
                            scale = 1.2
                        }
                    }
            }
            .foregroundColor(themeManager.theme.text)
            .background(BorderedCapsule(hasColoredBorder: true)
                .shadow(color: themeManager.theme.shadow, radius: 4, x: 2, y: 2))
            .padding()
            .padding(.bottom, 100)
        }
        .offset(x: notificationManager.notification != nil ? 0 : UIScreen.main.bounds.width, y: 0)
        .animation(.interactiveSpring(response: 0.45, dampingFraction: 0.8, blendDuration: 0.69), value: notificationManager.notification != nil)
    }
}

struct NotificationView_Previews: PreviewProvider {
    static var previews: some View {
        NotificationView()
    }
}
