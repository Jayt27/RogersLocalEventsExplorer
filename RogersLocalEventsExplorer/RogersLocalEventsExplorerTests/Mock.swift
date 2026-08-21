//
//  Untitled.swift
//  RogersLocalEventsExplorer
//
//  Created by Jay Thakkar on 20/08/26.
//

import Foundation
@testable import RogersLocalEventsExplorer

// MARK: - Mock Network Manager
final class MockNetworkManager: NetworkManagerProtocol {
    func fetchEventsJSON() async throws -> [RogersLocalEventsExplorer.Event] {
        if shouldFail {
            throw URLError(.cannotParseResponse)
        }
        return mockEvents
    }

    var shouldFail = false
    var mockEvents: [Event] = []

    func fetchEvents() async throws -> [Event] {
        if shouldFail {
            throw URLError(.notConnectedToInternet)
        }
        return mockEvents
    }
}

// MARK: - Mock Local Store
final class MockLocalStore: CoreDataStoreProtocol {

    var cachedEvents: [Event] = []
    var bookmarks: Set<Int> = []
    var isExpired = false
    let cachedEvent = Event(id: 1,
                            title: "Swift Local Meetup",
                            locationName: "Calgary",
                            latitude: 0,
                            longitude: 0,
                            timestamp: Date(),
                            imageUrlString: "")

    func saveEvents(_ events: [Event]) throws {
        cachedEvents = events
    }

    func fetchCachedEvents() throws -> [Event] {
        return cachedEvents
    }

    func toggleBookmark(eventId: Int) throws -> Bool {
        if bookmarks.contains(eventId) {
            bookmarks.remove(eventId)
            return false
        } else {
            bookmarks.insert(eventId)
            return true
        }
    }

    func fetchBookmarkedIds() -> Set<Int> {
        return bookmarks
    }

    func updateLastFetchedTimestamp() {}

    func hasSavedEvents() async -> Bool { true }

    func isCacheExpired(ttl: TimeInterval) -> Bool {
        return isExpired
    }
}

final class MockEventsRepository: EventsRepositoryProtocol {
    let event1 =  Event(id: 1,
                        title: "A",
                        locationName: "Toronto - A",
                        latitude: 0,
                        longitude: 0,
                        timestamp: Date(),
                        imageUrlString: "")
    let event2 =  Event(id: 2,
                        title: "B",
                        locationName: "Toronto - B",
                        latitude: 0,
                        longitude: 0,
                        timestamp: Date(),
                        imageUrlString: "")
    func toggleBookmark(id: Int) async throws -> Bool {
        return true
    }

    // 1. Hand-picked data containers that live entirely in RAM
    var mockEvents: [Event] = []
    var mockBookmarkedIds: Set<Int> = []

    // 2. Control switches to test bad scenarios
    var shouldThrowNetworkError = false

    // Conforming to the protocol: The ViewModel thinks this is real!
    func getEvents(forceRefresh: Bool) async throws -> [Event] {
        // If our test wants to see how the app handles a crash, throw an error
        if shouldThrowNetworkError {
            throw URLError(.notConnectedToInternet)
        }
        // Otherwise, instantly hand back whatever fake events we put in RAM
        return mockEvents
    }

    func getBookmarkedIds() async -> Set<Int> {
        return mockBookmarkedIds
    }
}
