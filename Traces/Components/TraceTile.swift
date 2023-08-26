//
//  TraceTileDetail.swift
//  Traces
//
//  Created by Bryce on 8/21/23.
//

import SwiftUI

struct TraceTile: View {
    
    @ObservedObject var themeController = ThemeController.shared
    @ObservedObject var supabaseController = SupabaseController.shared
    @ObservedObject var notificationController = NotificationController.shared
    @State var username: String = ""
    @State var shouldShowDetails: Bool = false
    @State var shouldPresentOptions: Bool = false
    @State var shouldPresentEditSheet: Bool = false
    @State var userHasOwnership: Bool = false
    @State var deleteConfirmed: Bool = false
    
    let trace: Trace
    
    var body: some View {
        VStack {
            buildDivider()
            buildTileBody()
                .padding(.vertical, 4)
                .background(themeController.theme.background)
                .zIndex(1.0)
                .onTapGesture {
                    withAnimation {
                        shouldPresentOptions = false
                        shouldShowDetails.toggle()
                    }
                }
            if shouldPresentOptions {
                buildOptions()
                    .transition(.move(edge: .trailing))
                    .frame(height: 128)
            }
            if shouldShowDetails {
                details
                    .zIndex(0.0)
                    .transition(.move(edge: .top))
            }
        }
        .animation(
            .interactiveSpring(response: 0.45, dampingFraction: 0.8, blendDuration: 0.69), value: self.shouldPresentOptions)

    }
    
    private func buildDivider() -> some View {
        Rectangle()
            .fill(themeController.theme.border.opacity(0.1))
            .frame(height: 1.4)
            .padding(.horizontal, 8)
    }
    
    private func buildTileBody() -> some View {
        HStack {
            MapBox(focalTrace: trace)
                .clipShape(RoundedRectangle(cornerRadius: 29))
                .frame(width: 144, height: 144)
                .padding(4)
                .background( BorderedRectangle() )
            Spacer()
            VStack(alignment: .trailing, spacing: 2) {
                buildOptionsButton()
                Spacer()
                Text(trace.locationName)
                    .foregroundColor(themeController.theme.text)
                if !userHasOwnership {
                    Text("@\(username)")
                        .foregroundColor(themeController.theme.text.opacity(0.4))
                        .font(.caption)
                }
                Text(getFormattedDate())
                    .foregroundColor(themeController.theme.text.opacity(0.6))
                    .font(.caption2)
            }
        }
        .task {
            username = await supabaseController.getUsernameFromID(trace.userID)
        }
        .padding(.horizontal, 16)
        .frame(height: 160)
    }
    
    private func buildOptionsButton() -> some View {
        Button(action: {
            withAnimation {
                shouldPresentOptions.toggle()
                shouldShowDetails = false
                deleteConfirmed = false
            }
        }) {
            Image(systemName: "ellipsis")
                .foregroundColor(themeController.theme.text.opacity(0.6))
                .padding(6)
                .frame(width: 24, height: 24)
        }
    }
    
    var details: some View {
        VStack {
            createCategory()
            if trace.content != "" {
                createDescription()
            }
        }
        .padding()
    }
    
    func createCategory() -> some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack {
                ForEach(trace.categories, id: \.self) { tag in
                    Text(tag)
                        .font(.caption)
                        .padding(.horizontal, 16)
                        .padding(.vertical, 10)
                        .background(
                            BorderedCapsule(hasThinBorder: true)
                                .shadow(color: themeController.theme.shadow, radius: 4, x: 2, y: 2)
                        )
                        .padding(2)
                        .foregroundColor(themeController.theme.text.opacity(0.8))
                }
            }
        }
    }
    
    private func buildOptions() -> some View {
        HStack {
            Spacer()
            VStack() {
                Button(action: {
                    let pasteboard = UIPasteboard.general
                    pasteboard.string = String("\(trace.locationName), \(trace.latitude), \(trace.longitude)")
                    notificationController.sendNotification(.linkCopied)
                    shouldPresentOptions.toggle()
                }) {
                    settingsItem(title: "Share", icon: "square.and.arrow.up")
                }
                
                if userHasOwnership {
                    Button(action: {
                        shouldPresentOptions.toggle()
                        TraceEditPopup(trace: trace).showAndStack()
                    }) {
                        settingsItem(title: "Edit", icon: "pencil")
                    }
                    Button(action: {
                        print(deleteConfirmed)
                        if !deleteConfirmed {
                            deleteConfirmed = true
                        } else {
                            notificationController.sendNotification(.traceDeleted)
                            supabaseController.deleteTrace(trace)
                            shouldPresentOptions.toggle()
                            deleteConfirmed = false
                        }
                    }) {
                        settingsItem(title: deleteConfirmed ? "Are you sure?" : "Delete", icon: "trash", isCritical: true)
                            .animation(.easeInOut, value: deleteConfirmed)
                    }
                    
                } else {
                    Button(action: {
                        let pasteboard = UIPasteboard.general
                        pasteboard.string = String("\(trace.latitude), \(trace.longitude)")
                        notificationController.sendNotification(.coordinatesCopied)
                        shouldPresentOptions.toggle()
                    }) {
                        settingsItem(title: "Copy Coordinates", icon: "scope")
                    }
                    Button(action: {
                        notificationController.sendNotification(.traceReported)
                        shouldPresentOptions.toggle()
                    }) {
                        settingsItem(title: "Report", icon: "exclamationmark.bubble", isCritical: true)
                    }
                }
                
            }
        }
    }
    
    private func settingsItem(title: String, icon: String, isCritical: Bool = false) -> some View {
        HStack {
            Text(title)
                .font(.body)
            Spacer()
            Circle()
                .fill(.clear)
                .overlay(
                    Image(systemName: icon)
                )
        }
        .foregroundColor(isCritical ? .red.opacity(0.8) : themeController.theme.text.opacity(0.8))
        .frame(width: 196)
        .padding(.trailing)
    }
    
    func createDescription() -> some View {
        VStack {
            FieldLabel(fieldLabel: "Notes")
                .offset(x: -100, y: 20)
                .zIndex(1)
            ZStack {
                BorderedRectangle(cornerRadius: 24, accented: true)
                HStack {
                    Text(trace.content)
                        .foregroundColor(themeController.theme.text)
                    Spacer()
                }
                .padding()
            }
        }
        
    }
    
    private func getFormattedDate() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .short
        dateFormatter.timeStyle = .none
        let dateString = dateFormatter.string(from: supabaseController.convertFromTimestamptzDate(trace.creationDate))
        return dateString
    }
}


//
//#Preview {
//    TraceTileDetail()
//}
