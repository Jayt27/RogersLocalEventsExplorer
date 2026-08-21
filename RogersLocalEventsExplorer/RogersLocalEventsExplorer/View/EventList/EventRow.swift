//
//  EventRow.swift
//  RogersLocalEventsExplorer
//
//  Created by Jay Thakkar on 20/08/26.
//

import SwiftUI

struct EventRow: View {
    let event: Event
    let isBookmarked: Bool
    let onBookmarkTapped: () -> Void

    @State private var image: UIImage?

    var body: some View {
        HStack(spacing: 12) {
            Group {
                if let image {
                    Image(uiImage: image)
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                } else {
                    Color.gray.opacity(0.15)
                }
            }
            .frame(width: 60, height: 60)
            .clipShape(RoundedRectangle(cornerRadius: 8))

            VStack(alignment: .leading, spacing: 4) {
                Text(event.title)
                    .font(.headline)
                Text(event.locationName)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            }

            Spacer()

            Button(action: onBookmarkTapped) {
                Image(systemName: isBookmarked ? "bookmark.fill" : "bookmark")
            }
            .buttonStyle(.plain)
        }
        .padding(.vertical, 4)
        .task(id: event.imageUrlString) {
            image = await ImageDownloader.shared.downloadImage(from: event.imageUrlString)
        }
    }
}
