//
//  Event.swift
//  RogersLocalEventsExplorer
//
//  Created by Jay Thakkar on 20/08/26.
//

import Foundation

struct Event: Codable, Identifiable, Equatable {
    let id: Int
    let title: String
    let locationName: String
    let latitude: Double
    let longitude: Double
    let timestamp: Date
    let imageUrlString: String

    enum CodingKeys: String, CodingKey {
        case id, title
        case locationName = "location"
        case latitude, longitude
        case timestamp = "time"
        case imageUrlString = "image_url"
    }
}
