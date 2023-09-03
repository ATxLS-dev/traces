//
//  Parsed.swift
//  Traces
//
//  Created by Bryce on 8/31/23.
//

import Foundation

extension String {
    func parseData(_ column: String) -> String {
        guard let jsonData = self.data(using: .utf8) else { return "Invalid JSON string" }
        do {
            if let jsonArray = try JSONSerialization.jsonObject(with: jsonData, options: []) as? [[String: Any]],
               let column = jsonArray.first?[column] as? String {
                return column
            } else {
                print("JSON format invalid")
            }
        } catch {
            print("Error parsing JSON: \(error)")
        }
        return "No data found"
    }
    
    func convertFromTimestamptz() -> Date {
        let formatter = ISO8601DateFormatter()
        if let date = formatter.date(from: self) {
            return date
        }
        return Date()
    }
}
