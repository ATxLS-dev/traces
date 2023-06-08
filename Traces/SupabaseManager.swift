//
//  Supabaseinator.swift
//  Traces
//
//  Created by Bryce on 6/8/23.
//

import Foundation
import Supabase



struct SupabaseTrace: InteractiveTrace, Decodable {
    let id: UUID
    let creationDate: Date
    let username: String
    let locationName: String
    let latitude: Double
    let longitude: Double
    let content: String
    let category: String
    func buildPopup() {}
}

struct SupabaseManager {
    static let shared = SupabaseManager()
    
    private let supabase: SupabaseClient
    
    private init() {
        let supabaseURL = URL(string: "https://ivdcgbbkxazshjuxgnwu.supabase.co'")!
        let supabasePublicKey = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Iml2ZGNnYmJreGF6c2hqdXhnbnd1Iiwicm9sZSI6ImFub24iLCJpYXQiOjE2ODYyNDQwNzQsImV4cCI6MjAwMTgyMDA3NH0.psBYXva3kS6o4psOtIOBkp34q3u3Gmh_5By8hYaG52Y"
        
        supabase = SupabaseClient(supabaseURL: supabaseURL, supabaseKey: supabasePublicKey)
    }
    
    func fetchSomeData() async {
        let query =  supabase.database
            .from("traces")
            .select()
        do {
            let response: [SupabaseTrace] = try await query.execute().value
            print("### Returned: \(response)")
        } catch {
            print("### Insert Error: \(error)")
        }
    }
//    let query = """
//    SELECT * FROM traces;
//    """
//
//    let data = supabase.database
//        .from("traces")
//        .select()
//

    
    //            .onSuccess { [weak self] result in
    //                guard let self = self else { return }
    //
    //                switch result {
    //                case .success(let response):
    //                    do {
    //                        let traces = try self.parseTraces(from: response)
    //                        completion(.success(traces))
    //                    } catch {
    //                        completion(.failure(error))
    //                    }
    //                case .failure(let error):
    //                    completion(.failure(error))
    //                }
    //            }
    //            .catch { error in
    //                completion(.failure(error))
    //            }
//}
    
//    private func parseTraces(from response: SupabaseResponse) throws -> [SupabaseTrace] {
//        guard let data = response.data else {
//            throw SupabaseError.dataNotFound
//        }
//
//        let decoder = JSONDecoder()
//        decoder.keyDecodingStrategy = .convertFromSnakeCase
//
//        do {
//            let traces = try decoder.decode([SupabaseTrace].self, from: data)
//            return traces
//        } catch {
//            throw error
//        }
//    }

}

private enum SupabaseError: Error {
    case dataNotFound
}
