//
//  TraceTileDetail.swift
//  Traces
//
//  Created by Bryce on 8/21/23.
//

import SwiftUI

struct TraceTile: View {
    
//    @ObservedObject var themeController = ThemeController.shared
    @EnvironmentObject var theme: ThemeController
    @ObservedObject var supabaseController = SupabaseController.shared
    @ObservedObject var notificationController = NotificationController.shared
    @State var username: String = ""
    @State var shouldShowDetails: Bool = false
    @State var shouldPresentOptions: Bool = false
    @State var shouldPresentEditSheet: Bool = false
    @State var userHasOwnership: Bool = false
    @State var deleteConfirmed: Bool = false
    @State var countedReactions: [CountedReaction] = []
    
    let trace: Trace
    
    var body: some View {
        VStack {
            buildDivider()
            buildTileBody()
                .padding(.vertical, 4)
                .background(theme.background)
                .zIndex(1.0)
                .onTapGesture {
                    withAnimation {
                        shouldPresentOptions = false
                        shouldShowDetails.toggle()
                    }
                }
            reactions
                .padding(.horizontal)
            if shouldPresentOptions {
                buildOptions()
                    .transition(.move(edge: .trailing))
                    .frame(height: 128)
            }
            if shouldShowDetails {
                details
                    .transition(.move(edge: .leading))
            }
        }
        .animation(
            .interactiveSpring(response: 0.45, dampingFraction: 0.8, blendDuration: 0.69), value: self.shouldPresentOptions)

    }
    
    private func buildDivider() -> some View {
        Rectangle()
            .fill(theme.border.opacity(0.1))
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
                    .foregroundColor(theme.text)
                if !userHasOwnership {
                    Text("@\(username)")
                        .foregroundColor(theme.text.opacity(0.4))
                        .font(.caption)
                }
                Text(getFormattedDate())
                    .foregroundColor(theme.text.opacity(0.6))
                    .font(.caption2)
            }
        }
        .task {
            username = await supabaseController.getFromID(trace.userID, column: "username")
            await syncReactions()
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
                .foregroundColor(theme.text.opacity(0.6))
                .padding(6)
                .frame(width: 24, height: 24)
        }
    }
    
    private func syncReactions() async {
        let counted = await supabaseController.getReactions(to: trace.id)
        countedReactions = counted.map { CountedReaction(value: $0, occurences: $1)}
        if countedReactions == [] {
            countedReactions = supabaseController.reactionTypes.map { CountedReaction(value: $0.value, occurences: 0)}
        }
    }
    
    var reactions: some View {
            HStack {
                Spacer()
                ForEach(countedReactions, id: \.self) { reaction in
                    Button(action: {
                        supabaseController.createReaction(to: trace.id, reactionType: reaction.value)
                        Task {
                            await syncReactions()
                        }
                    }) {
                        ReactionCounter(reaction)
                    }
                }
            }
        }
    
    var details: some View {
        VStack {
            categories
            if trace.content != "" {
                description
            }
        }
        .padding()
    }
    
    var categories: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack {
                ForEach(trace.categories, id: \.self) { tag in
                    Text(tag)
                        .font(.caption)
                        .padding(.horizontal, 16)
                        .padding(.vertical, 10)
                        .background(
                            BorderedCapsule(hasThinBorder: true)
                                .shadow(color: theme.shadow, radius: 4, x: 2, y: 2)
                        )
                        .padding(2)
                        .foregroundColor(theme.text.opacity(0.8))
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
        .foregroundColor(isCritical ? .red.opacity(0.8) : theme.text.opacity(0.8))
        .frame(width: 196)
        .padding(.trailing)
    }
    
    var description: some View {
        VStack {
            FieldLabel(fieldLabel: "Notes")
                .offset(x: -100, y: 20)
                .zIndex(1)
            ZStack {
                BorderedRectangle(cornerRadius: 24, accented: true)
                HStack {
                    Text(trace.content)
                        .foregroundColor(theme.text)
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
        let dateString = dateFormatter.string(from: trace.creationDate.convertFromTimestamptz())
        return dateString
    }
}
