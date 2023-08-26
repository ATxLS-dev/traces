//
//  Onboarding.swift
//  Traces
//
//  Created by Bryce on 8/26/23.
//

import SwiftUI

struct Onboarding: View {
    var body: some View {
        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
    }
}

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

func shouldShowOnboardingUI() {
    if UserDefaults.hasOnboarded {
        
    } else {
        
    }
}

#Preview {
    Onboarding()
}
