
//
//  Supabaseinator.swift
//  Traces
//
//  Created by Bryce on 6/8/23.


import Foundation
import Supabase

let shared = SupabaseManager()


struct SupabaseManager {

    var categories: [String] = []
    
}



//struct SupabaseManager {
//    static let shared = SupabaseManager()
//    
//    private let supabase: SupabaseClient
//    
//    private var traces: [Trace]
//    
//    private init() {
//        let supabaseURL = URL(string: "https://ivdcgbbkxazshjuxgnwu.supabase.co'")!
//        let supabasePublicKey = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Iml2ZGNnYmJreGF6c2hqdXhnbnd1Iiwicm9sZSI6ImFub24iLCJpYXQiOjE2ODYyNDQwNzQsImV4cCI6MjAwMTgyMDA3NH0.psBYXva3kS6o4psOtIOBkp34q3u3Gmh_5By8hYaG52Y"
//        
//        supabase = SupabaseClient(supabaseURL: supabaseURL, supabaseKey: supabasePublicKey)
//        
//    }
//    
//    
//    func fetchTraces() async {
//        traces = Task {
//            let response: [Trace] = try await supabase.database
//                    .from("traces")
//                    .select()
//                    .execute()
//                    .value
//            return response
//            }
//        }
//    }
//
//    
//    func fetchTraces(completion: @escaping (Result<[Trace], Error>) -> Void) {
//        
//        let query = supabase.database
//            .from("traces")
//            .select()
//        
//        Task {
//            do {
//                let response: [Trace] = try await query.execute().value
//                print("### Returned: \(response)")
//            } catch {
//                print("### Insert Error: \(error)")
//            }
//        }
//    }
//    
//    private func parseTraces(traces: [Trace]) {
//        
//        
//        
//    }
//}
//
//private enum SupabaseError: Error {
//    case dataNotFound
//    case concurrentRequest
//}
