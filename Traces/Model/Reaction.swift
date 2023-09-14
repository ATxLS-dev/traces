//
//  ReactionView.swift
//  Traces
//
//  Created by Bryce on 8/27/23.
//

import SwiftUI

struct Reaction: Codable, Identifiable, Equatable, Hashable {
    let id: UUID
    let traceID: UUID
    let userID: UUID
    let creationDate: String
    let reactionType: UUID
    
    enum CodingKeys: String, CodingKey {
        case id = "id"
        case traceID = "trace_id"
        case userID = "user_id"
        case creationDate = "creation_date"
        case reactionType = "reaction_type"
        
        var stringValue: String {
            return rawValue
        }
    }
}

struct ReactionType: Codable, Identifiable, Equatable, Hashable {
    
    var id: UUID
    var value: String
    
    enum CodingKeys: String, CodingKey {
        case id = "id"
        case value = "value"
        
        var stringValue: String {
            return rawValue
        }
    }
}

struct CountedReaction: Hashable {
    let value: String
    let occurences: Int
}

enum ReactionError: Error {
    case signedOut
    case reactionTypeNotFound
    case databaseError
}
