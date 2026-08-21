//
//  EventDetailViewModel.swift
//  RogersLocalEventsExplorer
//
//  Created by Jay Thakkar on 20/08/26.
//

import Foundation
import CoreLocation
import Combine

@MainActor
final class EventDetailViewModel: ObservableObject {

    let title: String
    let imageUrlString: String
    let locationName: String

    private let event: Event
    private let repository: EventsRepositoryProtocol
    private var userLocation: CLLocation?

    /// Tracks the live bookmark state
    @Published private(set) var isBookmarked: Bool

    init(
        event: Event,
        isBookmarked: Bool,
        repository: EventsRepositoryProtocol = EventsRepository()
    ) {
        self.event = event
        self.title = event.title
        self.imageUrlString = event.imageUrlString
        self.locationName = event.locationName
        self.isBookmarked = isBookmarked
        self.repository = repository
    }

    /// Called from EventDetailView's onReceive(locationProvider.$location) —
    /// updates through the ViewModel.
    func updateUserLocation(_ location: CLLocation) {
        self.userLocation = location
    }

    var distanceAndLocationText: String {
        if calculateDistance() == 0 {
            return "Sorry, We are not able to find distance. Please check your location settings."
        } else {
            return String(format: "%@\n(%.1f km away)", event.locationName, calculateDistance())
        }
    }

    // Calculate distance from current location to selected event
    func calculateDistance() -> Double {
        guard let userLoc = userLocation else {
            return 0
        }
        let eventLoc = CLLocation(latitude: event.latitude, longitude: event.longitude)
        return userLoc.distance(from: eventLoc) / 1000.0
    }

    var coordinates: (latitude: Double, longitude: Double) {
        return (event.latitude, event.longitude)
    }


    /// call through the repository, reflect the persisted result.
    func toggleBookmark() {
        Task {
            do {
                isBookmarked = try await repository.toggleBookmark(id: event.id)
            } catch {
                // Non-fatal: leave isBookmarked as-is rather than showing
                // a full error state for a background persistence hiccup.
                print("Failed to toggle bookmark: \(error.localizedDescription)")
            }
        }
    }
}
