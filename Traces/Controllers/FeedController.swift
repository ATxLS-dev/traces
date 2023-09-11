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
    
    private var feedMaxDistanceInMiles: Int = 15
    
    static let shared = FeedController()
    let supabase: SupabaseClient = SupabaseClient(supabaseURL: Secrets.supabaseURL, supabaseKey: Secrets.supabaseAnonKey)

    @EnvironmentObject var locator: LocationController
    
    @Published var feed: [Trace] = []
    
    private var rawFeed: [Trace] = []
    private var activeFilters: [String] = []
    public var filterMode: FeedOption = .mostRecent
    
    @Published private(set) var filteredTraces: [Trace] = []
    @Published private(set) var categories: [Category] = []
    @Published private(set) var filters: Set<String> = []
    
    init() {
        self.syncCategories()
    }
    
    private func syncCategories() {
        let query = supabase.database.from("categories").select()
        Task {
            do {
                categories = try await query.execute().value
            } catch {
                print(error)
            }
        }
    }

    func setFeed(to option: FeedOption) {
        switch(option) {
        case .proximity:
            print("proximity")
        case .mostRecent:
            print("most recent")
        case .mostPopular:
            print("most popular")
        }
    }
    
    //Don't want to get more than 20 at a time
    func syncUnsortedFeed() async {
        let query = supabase.database
            .from("traces")
            .select()
            .order(column: "creation_date", ascending: true)
        do {
            self.feed = try await query.execute().value
        } catch {
            print(error)
        }
    }
    
    func toggleFilter(category: String) {
        if filters.contains(category) {
            filters.remove(category)
        } else {
            filters.insert(category)
        }
        if filters == [] {
            feed = []
        } else {
            feed = rawFeed.filter { trace in
                let commonCategories = Set(trace.categories).intersection(Set(filters))
                return !commonCategories.isEmpty
            }
        }
    }
    
    func refreshTraces() {
        syncFeedOrderedByProximity(maxDistanceInMiles: feedMaxDistanceInMiles)
    }
    
    func setFeedMaxDistance(miles: Int) {
        self.feedMaxDistanceInMiles = miles
    }
    
    func syncFeedOrderedByProximity(maxDistanceInMiles: Int) {
        let lastUserLocation = locator.userLocation
        let maxDistanceInMeters = Double(maxDistanceInMiles) * 1609.34
        feed = rawFeed.filter { trace in
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
