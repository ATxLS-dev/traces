import SwiftUI
import CoreData
import MapKit
import PopupView


struct TraceDetailView: View {
    
    var trace: Trace
    
    
    @Environment(\.dismiss) var dismiss
    @State var username: String = ""
    
    @EnvironmentObject var theme: ThemeController
    @EnvironmentObject var notifications: NotificationController
    @EnvironmentObject var supabase: SupabaseController
    
    func getUsername(_ id: UUID) {
        Task {
            self.username = await supabase.getFromUserID(id, column: "username")
        }
    }
    
    var body: some View {
        createContent()
    }
    
    func createContent() -> some View {
        ZStack {
            BorderedRectangle(cornerRadius: 24)
            VStack(spacing: 20) {
                HStack {
                    createMap()
                    Spacer()
                    VStack(alignment: .trailing) {
                        createTitle()
                        Spacer()
                        createUsername()
                        createDate()
                    }
                    .frame(height: 144)
                    .padding(6)
                }
                createCategory()
                createDescription()
                Spacer()
                HStack() {
                    Spacer()
                    cancelButton()
                    shareButton()
                }
            }
            .task {
                getUsername(trace.userID)
                print(trace.locationName)
            }
            .padding()
        }
        .padding(16)
        .frame(height: 480)
    }

    func createMap() -> some View {
        MapBox(focalTrace: trace)
            .clipShape(RoundedRectangle(cornerRadius: 29))
            .frame(width: 144, height: 144)
            .padding(4)
            .background( BorderedRectangle() )
    }
    
    func createTitle() -> some View {
        Text(trace.locationName)
            .font(.title2)
            .foregroundColor(theme.text)
    }
    
    func createDate() -> some View {
        Text(Date().formatted())
            .font(.caption)
            .foregroundColor(theme.text)
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
                                .shadow(color: theme.shadow, radius: 4, x: 2, y: 2)
                        )
                        .padding(2)
                        .foregroundColor(theme.text)
                }
                .padding(.vertical, 8)
            }
        }
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
                        .foregroundColor(theme.text)
                    Spacer()
                }
                .padding()
            }
        }
        
    }
    
    func createUsername() -> some View {
        return Text(username)
            .font(.caption)
            .foregroundColor(theme.text)
            .task {
                username = await supabase.getFromUserID(trace.userID, column: "username")
            }
    }
    
    
    func shareButton() -> some View {
        Button(action: {
            notifications.sendNotification(.linkCopied)
            dismiss()
        }) {
            BorderedHalfButton(icon: "square.and.arrow.up.circle")
        }
    }
    
    func cancelButton() -> some View {
        Button(action: {
            dismiss()
        }) {
            BorderedHalfButton(icon: "xmark.circle", noBorderColor: true, noBackgroundColor: true)
                .rotationEffect(.degrees(180))
        }
    }
}
