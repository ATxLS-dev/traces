//
//  TraceManager.swift
//  Traces
//
//  Created by Bryce on 5/19/23.
//

import Foundation

//func generateUsername() -> String {
//    let adjectives = ["Happy", "Silly", "Clever", "Awesome", "Brave"]
//    let animals = ["Dog", "Cat", "Elephant", "Lion", "Monkey"]
//    let adjective = adjectives.randomElement()!
//    let animal = animals.randomElement()!
//    let username = "\(adjective)\(animal)\(Int.random(in: 1...100))"
//    return username
//}
//
//struct SampleTrace {
//    let username: String
//    let datePosted: Date
//    let name: String
//    let content: String
//    let latitude: Double
//    let longitude: Double
//}


//func generateRandomDate() -> Date {
//    let thirtyDays: TimeInterval = 30 * 24 * 60 * 60
//    let now = Date()
//    let thirtyDaysAgo = now.addingTimeInterval(-thirtyDays)
//    let randomTime = TimeInterval.random(in: thirtyDaysAgo.timeIntervalSince1970...now.timeIntervalSince1970)
//    return Date(timeIntervalSince1970: randomTime)
//}
//
//let sampleTraces = [
//    SampleTrace(username: generateUsername(), datePosted: generateRandomDate(), name: "St Francis Memorial Hospital", content: "Top-quality medical care", latitude: 37.789467, longitude: -122.416772),
//    SampleTrace(username: generateUsername(), datePosted: generateRandomDate(), name: "The Ritz-Carlton, San Francisco", content: "Luxurious hotel experience", latitude: 37.791965, longitude: -122.406903),
//    SampleTrace(username: generateUsername(), datePosted: generateRandomDate(), name: "Honey Honey Cafe & Crepery", content: "Delicious sweet and savory crepes", latitude: 37.787891, longitude: -122.411223),
//    SampleTrace(username: generateUsername(), datePosted: generateRandomDate(), name: "Golden Gate Bridge", content: "Iconic suspension bridge", latitude: 37.8199, longitude: -122.4783),
//    SampleTrace(username: generateUsername(), datePosted: generateRandomDate(), name: "Alcatraz Island", content: "Famous former prison island", latitude: 37.8267, longitude: -122.4233),
//    SampleTrace(username: generateUsername(), datePosted: generateRandomDate(), name: "Fisherman's Wharf", content: "Vibrant waterfront district", latitude: 37.8087, longitude: -122.4098),
//    SampleTrace(username: generateUsername(), datePosted: generateRandomDate(), name: "Chinatown, San Francisco", content: "Rich cultural heritage", latitude: 37.7941, longitude: -122.4078),
//    SampleTrace(username: generateUsername(), datePosted: generateRandomDate(), name: "Union Square, San Francisco", content: "Shopping and entertainment hub", latitude: 37.7881, longitude: -122.4075),
//    SampleTrace(username: generateUsername(), datePosted: generateRandomDate(), name: "Muir Woods National Monument", content: "Gorgeous coastal redwoods", latitude: 37.8974, longitude: -122.5812),
//    SampleTrace(username: generateUsername(), datePosted: generateRandomDate(), name: "Stanford University", content: "Renowned educational institution", latitude: 37.4275, longitude: -122.1697),
//    SampleTrace(username: generateUsername(), datePosted: generateRandomDate(), name: "Googleplex", content: "Google's headquarters", latitude: 37.4219, longitude: -122.0841),
//    SampleTrace(username: generateUsername(), datePosted: generateRandomDate(), name: "Facebook Headquarters", content: "Facebook's main campus", latitude: 37.4847, longitude: -122.1484),
//    SampleTrace(username: generateUsername(), datePosted: generateRandomDate(), name: "Apple Park", content: "Apple's futuristic campus", latitude: 37.3349, longitude: -122.0089),
//    SampleTrace(username: generateUsername(), datePosted: generateRandomDate(), name: "Oracle Arena", content: "Sports and entertainment venue", latitude: 37.7503, longitude: -122.2033),
//    SampleTrace(username: generateUsername(), datePosted: generateRandomDate(), name: "SAP Center", content: "Home of the Sharks", latitude: 37.3327, longitude: -121.9011),
//    SampleTrace(username: generateUsername(), datePosted: generateRandomDate(), name: "Levi's Stadium", content: "Home of the 49ers", latitude: 37.4030, longitude: -121.9700),
//    SampleTrace(username: generateUsername(), datePosted: generateRandomDate(), name: "Oakland Zoo", content: "Family-friendly wildlife experience", latitude: 37.7479, longitude: -122.1537),
//    SampleTrace(username: generateUsername(), datePosted: generateRandomDate(), name: "Great America", content: "Amusement park with thrill rides", latitude: 37.3961, longitude: -121.9772),
//    SampleTrace(username: generateUsername(), datePosted: generateRandomDate(), name: "California's Great America", content: "Exciting theme park adventures", latitude: 37.3985, longitude: -121.9748),
//    SampleTrace(username: generateUsername(), datePosted: generateRandomDate(), name: "Computer History Museum", content: "Exploring computing's past", latitude: 37.4140, longitude: -122.0764)
//]
