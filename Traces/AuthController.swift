//
//  AuthController.swift
//  Traces
//
//  Created by Bryce on 6/8/23.
//

import SwiftUI
import GoTrue

final class AuthController: ObservableObject {
    @Published var session: Session?
    
    var currentUserID: UUID {
        guard let id = session?.user.id else {
            preconditionFailure("Required session.")
        }
        
        return id
    }
}
