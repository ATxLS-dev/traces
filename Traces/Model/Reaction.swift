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

struct ReactionType: Codable, Identifiable, Equatable {
    
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

extension SupabaseController {
    
    func getReactions(to traceID: UUID) async -> [(String, Int)] {
        
        var result: [Reaction] = []
        let query = supabase.database
            .from("reactions")
            .select()
            .eq(column: "trace_id", value: traceID)
        
        do {
            result = try await query.execute().value
        } catch {
            print("Error fetching reactions: \(error)")
        }
        
        var reactionRawTypes: [UUID: String] = [:]
        reactionTypes.forEach { item in
            reactionRawTypes[item.id] = item.value
        }
        
        let reactions: [UUID] = result.map(\.reactionType)
        let end = Dictionary(grouping: reactions) { $0 }
            .map { (reactionRawTypes[$0]!, $1.count) }

        return end
    }
    
    func createReaction(to traceID: UUID, reactionType: String) {
        if auth.authChangeEvent != .signedIn { print("Cannot leave reactions without signing in") }
        let date = Date()
        let formatter = ISO8601DateFormatter()
        formatter.formatOptions = [.withInternetDateTime]
        let creationDateInTimestamptz = formatter.string(from: date)
        
        let reactionTypeID: UUID = reactionTypes
            .filter { $0.value == reactionType }
            .map { $0.id }
            .first!

        let newReaction: Reaction = Reaction(
            id: UUID(),
            traceID: traceID,
            userID: auth.session!.user.id,
            creationDate: creationDateInTimestamptz,
            reactionType: reactionTypeID)
        print(newReaction)
        
        let query = supabase.database
            .from("reactions")
            .insert(values: newReaction)
            
        Task {
            do {
                try await query.execute()
            } catch {
                print("Error inserting reaction: \(error)")
            }
        }
    }
    
    func updateReaction() {
        
    }
    
    func deleteReaction() {
        
    }
}
