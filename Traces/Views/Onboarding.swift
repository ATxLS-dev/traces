//
//  Onboarding.swift
//  Traces
//
//  Created by Bryce on 8/26/23.
//

import SwiftUI

@propertyWrapper
struct UserDefault<Value> {
    let key: String
    let defaultValue: Value
    let container: UserDefaults = .standard
    
    var wrappedValue: Value {
        get {
            container.object(forKey: key) as? Value ?? defaultValue
        }
        set {
            container.set(newValue, forKey: key)
        }
    }
    
}

extension UserDefaults {
    
    public enum Keys {
        static let hasOnboarded = "hasOnboarded"
    }
    
    @UserDefault(key: UserDefaults.Keys.hasOnboarded, defaultValue: false)
    static var hasOnboarded: Bool
    
}

struct Onboarding: View {
    
    @EnvironmentObject var theme: ThemeController
    @State var shouldPresentAuth: Bool = false
    @State var selectedTab: Int = 1
    
    var body: some View {
        ZStack {
            VStack {
                HStack {
                    Spacer()
                    Button(action: {
                        UserDefaults.hasOnboarded = true
                        print(UserDefaults.hasOnboarded)
                    }) {
                        HStack {
                            Text("Skip intro")
                            Image(systemName: "chevron.right")
                        }
                        .padding()
                    }
                }
                Spacer()
            }
            .padding(.top, 60)
            TabView(selection: $selectedTab) {
                page1
                    .tag(1)
                page2
                    .tag(2)
                page3
                    .tag(3)
                page4
                    .tag(4)
                page5
                    .tag(5)
            }
            .tabViewStyle(PageTabViewStyle(indexDisplayMode: .always))
        }
        .ignoresSafeArea()

    }
    
    @ViewBuilder
    var page1: some View {
        HStack {
            Text("Welcome to Traces")
                .font(.title)
                .padding()
            Spacer()
            Image(systemName: "arrow.right")
        }
        .padding()
    }
    
    @ViewBuilder
    var page2: some View {
        VStack {
            Text("Find stuff to do near you")
            Spacer()
            Image("home")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .foregroundColor(theme.text)
                .padding()
        }
        .padding(.top, 80)
        .padding(.bottom, 40)
    }
    
    @ViewBuilder
    var page3: some View {
        VStack {
            Text("Browse the map and find places to visit")
            Spacer()
            Image("map")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .foregroundColor(theme.text)
                .padding()
        }
        .padding(.top, 80)
        .padding(.bottom, 40)
    }
    
    @ViewBuilder
    var page4: some View {
        VStack {
            Text("Leave traces for others")
            Spacer()
            Image("new_trace")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .foregroundColor(theme.text)
                .padding()
        }
        .padding(.top, 80)
        .padding(.bottom, 40)
    }
    
    @ViewBuilder
    var page5: some View {
        VStack {
            Button(action: {
                shouldPresentAuth.toggle()
            }) {
                Text("Sign Up/Log in?")
                    .padding()
                    .foregroundColor(theme.text)
                    .background {
                        BorderedCapsule()
                    }
            }
        }
        .sheet(isPresented: $shouldPresentAuth) {
            AuthView(isPresented: $shouldPresentAuth)
        }
        .padding(.top, 80)
        .padding(.bottom, 40)
    }
    

}
