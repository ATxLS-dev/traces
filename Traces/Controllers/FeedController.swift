//
//  FeedController.swift
//  Traces
//
//  Created by Bryce on 9/1/23.
//

import Foundation
import SwiftUI
import MapKit
import Supabase

enum FeedOption: String, CaseIterable {
    case proximity = "Proximity"
    case mostRecent = "Most Recent"
    case mostPopular = "Most Popular"
}

@MainActor
class FeedController: ObservableObject {
    
    private var feedMaxDistanceInMiles: Double = 5.0
    
    let supabase: SupabaseClient = SupabaseClient(supabaseURL: Secrets.supabaseURL, supabaseKey: Secrets.supabaseAnonKey)
    let locator = LocationController()
    
    private var rawFeed: [Trace] = []
    private var activeFilters: [String] = []
    public var filterMode: FeedOption = .mostRecent
    
    @Published var traces: [Trace] = []
    @Published private(set) var categories: [Category] = []
    @Published private(set) var countedCategories: [(Category, Int)] = []
    @Published private(set) var filters: Set<String> = []
    
    init() {
        self.syncCategories()
        self.syncUnsortedFeed()
        self.syncTracesWithin(miles: feedMaxDistanceInMiles)
        self.syncCountedCategories()
    }
    
    private func syncCategories() {
        let query = supabase.database
            .from("categories")
            .select()
        Task {
            do {
                categories = try await query.execute().value
            } catch {
                print(error)
            }
        }
    }
    
    private func syncTracesWithin(miles distance: Double) {
        let query = supabase.database
            .rpc(fn: "get_traces_within_distance",
                 params: [locator.userLocation.latitude, locator.userLocation.longitude, distance])
        Task {
            do {
                rawFeed = try await query.execute().value
            } catch {
                print(error)
            }
        }
    }
    
    private func countCategoryOccurences(_ category: Category) -> (Category, Int) {
        let occurrences = rawFeed
            .flatMap { $0.categories }
            .filter { $0 == category.name }
            .count
        return (category, occurrences)
    }
    
    func syncCountedCategories() {
        countedCategories = []
        for category in categories {
            countedCategories.append(countCategoryOccurences(category))
        }
        countedCategories.sort { $0.1 > $1.1 }
    }
    
    func setMaxFeedDistanceInMiles(_ miles: Double) {
        self.feedMaxDistanceInMiles = miles
    }

    func setFeedMode(to option: FeedOption) {
        switch(option) {
        case .proximity:
            print("proximity")
        case .mostRecent:
            print("most recent")
        case .mostPopular:
            print("most popular")
        }
    }
    
    func syncUnsortedFeed() {
        let query = supabase.database
            .from("traces")
            .select()
            .order(column: "creation_date", ascending: true)
        Task {
            do {
                rawFeed = try await query.execute().value
                traces = rawFeed
            } catch {
                print(error)
            }
        }
    }
    
    func toggleFilter(category: String) {
        if filters.contains(category) {
            filters.remove(category)
        } else {
            filters.insert(category)
        }
        if filters == [] {
            traces = rawFeed
        } else {
            traces = traces.filter { trace in
                let commonCategories = Set(trace.categories).intersection(Set(filters))
                return !commonCategories.isEmpty
            }
        }
    }
    
    func syncFeedOrderedByProximity(maxDistanceInMiles: Int) {
        let lastUserLocation = locator.userLocation
        let maxDistanceInMeters = Double(maxDistanceInMiles) * 1609.34
        traces = rawFeed.filter { trace in
            let location = CLLocation(latitude: trace.latitude, longitude: trace.longitude)
            let distance = location.distance(from: CLLocation(latitude: lastUserLocation.latitude, longitude: lastUserLocation.longitude))
            return distance <= maxDistanceInMeters
        }.sorted { (trace1, trace2) -> Bool in
            let location1 = CLLocation(latitude: trace1.latitude, longitude: trace1.longitude)
            let location2 = CLLocation(latitude: trace2.latitude, longitude: trace2.longitude)
            let distance1 = location1.distance(from: CLLocation(latitude: lastUserLocation.latitude, longitude: lastUserLocation.longitude))
            let distance2 = location2.distance(from: CLLocation(latitude: lastUserLocation.latitude, longitude: lastUserLocation.longitude))
            return distance1 < distance2
        }
    }
}
