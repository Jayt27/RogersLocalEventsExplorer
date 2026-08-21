//
//  EventsListView.swift
//  RogersLocalEventsExplorer
//
//  Created by Jay Thakkar on 20/08/26.
//

import SwiftUI

struct EventsListView: View {
    @StateObject private var viewModel = EventsViewModel()

    var body: some View {
        NavigationStack {
            content
                .navigationTitle(viewModel.isFilteringBookmarks ? "Bookmarked" : "Local Events")
                .toolbar {
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Button {
                            viewModel.toggleBookmarkFilter()
                        } label: {
                            Image(systemName: viewModel.isFilteringBookmarks ? "bookmark.fill" : "bookmark")
                        }
                    }
                }
                .alert(
                    "Alert",
                    isPresented: Binding(
                        get: { viewModel.errorMessage != nil },
                        set: { isPresented in
                            if !isPresented { viewModel.clearError() }
                        }
                    )
                ) {
                    Button("Dismiss", role: .cancel) {}
                } message: {
                    Text(viewModel.errorMessage ?? "")
                }
                .task {
                    await viewModel.fetchEvents()
                }
                .refreshable {
                    // Same forceRefresh:true parameter the manual/background
                    // paths already share — pull-to-refresh needed zero new
                    // logic beyond this one call, per the earlier discussion
                    // of how that path was designed to be reused.
                    await viewModel.fetchEvents(forceRefresh: true)
                }
        }
    }

    @ViewBuilder
    private var content: some View {
        if viewModel.isLoading && viewModel.events.isEmpty {
            ProgressView()
                .frame(maxWidth: .infinity, maxHeight: .infinity)
        } else {
            List(viewModel.events) { event in
                NavigationLink {
                    EventDetailView(
                        viewModel: EventDetailViewModel(
                            event: event,
                            isBookmarked: viewModel.isEventBookmarked(event.id)
                        )
                    )
                } label: {
                    EventRow(
                        event: event,
                        isBookmarked: viewModel.isEventBookmarked(event.id),
                        onBookmarkTapped: {
                            Task { await viewModel.toggleBookmark(for: event.id) }
                        }
                    )
                }
            }
            .listStyle(.plain)
        }
    }
}
