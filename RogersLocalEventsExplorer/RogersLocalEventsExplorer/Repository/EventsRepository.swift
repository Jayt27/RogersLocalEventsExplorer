//
//  EventsRepository.swift
//  RogersLocalEventsExplorer
//
//  Created by Jay Thakkar on 20/08/26.
//


import Foundation

protocol EventsRepositoryProtocol {
    /// Get All Events
    func getEvents(forceRefresh: Bool) async throws -> [Event]

    /// Get Bookmark Ids saved
    func getBookmarkedIds() async -> Set<Int>

    /// Toggle Bookmarks for specifc ID
    func toggleBookmark(id: Int) async throws -> Bool
}

final class EventsRepository: EventsRepositoryProtocol {
    func getEvents(forceRefresh: Bool) async throws -> [Event] {
        return []
    }
    
    func getBookmarkedIds() async -> Set<Int> {
        return []
    }
    
    func toggleBookmark(id: Int) async throws -> Bool {
        true
    }
    
    
}
