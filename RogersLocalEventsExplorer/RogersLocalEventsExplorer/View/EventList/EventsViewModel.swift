//
//  EventsViewModel.swift
//  RogersLocalEventsExplorer
//
//  Created by Jay Thakkar on 20/08/26.
//

import Foundation
import Combine

@MainActor
final class EventsViewModel: ObservableObject {

    private var allEvents: [Event] = []
    @Published private(set) var events: [Event] = []
    @Published private(set) var bookmarkedIds: Set<Int> = []
    @Published private(set) var isLoading = false
    @Published private(set) var errorMessage: String?
    @Published private(set) var isFilteringBookmarks: Bool = false

    private(set) var repository: EventsRepositoryProtocol

    init(repository: EventsRepositoryProtocol? = nil) {
        self.repository = repository ?? EventsRepository()
    }

    func fetchEvents(forceRefresh: Bool = false) async {
        isLoading = true
        errorMessage = nil

        do {
            self.allEvents = try await repository.getEvents(forceRefresh: forceRefresh)
            self.bookmarkedIds = await repository.getBookmarkedIds()
            applyCurrentFilter()
        } catch {
            self.errorMessage = error.localizedDescription
        }

        isLoading = false
    }

    func toggleBookmark(for eventId: Int) async {
        do {
            let isNowBookmarked = try await repository.toggleBookmark(id: eventId)
            if isNowBookmarked {
                bookmarkedIds.insert(eventId)
            } else {
                bookmarkedIds.remove(eventId)
            }
            applyCurrentFilter()
        } catch {
            self.errorMessage = "Could not update bookmark."
        }
    }

    func updateBookmarkStateOnly() async {
        self.bookmarkedIds = await repository.getBookmarkedIds()
        applyCurrentFilter()
    }

    func toggleBookmarkFilter() {
        isFilteringBookmarks.toggle()
        applyCurrentFilter()
    }

    func applyCurrentFilter() {
        if isFilteringBookmarks {
            events = allEvents.filter { bookmarkedIds.contains($0.id) }
        } else {
            events = allEvents
        }
    }

    func isEventBookmarked(_ eventId: Int) -> Bool {
        return bookmarkedIds.contains(eventId)
    }

    func clearError() {
        errorMessage = nil
    }
}
