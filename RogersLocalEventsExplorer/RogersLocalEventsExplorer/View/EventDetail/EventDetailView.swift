//
//  EventDetailView.swift
//  RogersLocalEventsExplorer
//
//  Created by Jay Thakkar on 20/08/26.
//

import SwiftUI
import MapKit
import Combine

struct EventDetailView: View {
    @ObservedObject var viewModel: EventDetailViewModel
    @StateObject private var locationProvider = LocationProvider()
    @State private var image: UIImage?

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                topImage

                HStack(alignment: .top) {
                    Text(viewModel.title)
                        .font(.title2.bold())

                    Spacer()

                    Button {
                        viewModel.toggleBookmark()
                    } label: {
                        Image(systemName: viewModel.isBookmarked ? "bookmark.fill" : "bookmark")
                            .font(.title3)
                    }.tint(.black)
                }
                .padding(.horizontal)

                Text(viewModel.distanceAndLocationText)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                    .padding(.horizontal)

                Button {
                    openInMaps()
                } label: {
                    Label("Get Directions", systemImage: "arrow.triangle.turn.up.right.diamond")
                        .frame(maxWidth: .infinity)
                }
                .buttonStyle(.borderedProminent)
                .padding(.horizontal)
            }
        }
        .navigationTitle("Event Details")
        .navigationBarTitleDisplayMode(.inline)
        .task {
            image = await ImageDownloader.shared.downloadImage(from: viewModel.imageUrlString)
        }
        .onAppear {
            locationProvider.requestLocation()
        }
        .onReceive(locationProvider.$location.compactMap { $0 }) { newLocation in
            viewModel.updateUserLocation(newLocation)
        }
    }

    @ViewBuilder
    private var topImage: some View {
        Group {
            if let image {
                Image(uiImage: image)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
            } else {
                Color.gray.opacity(0.15)
            }
        }
        .frame(height: 220)
        .frame(maxWidth: .infinity)
        .clipped()
    }

    private func openInMaps() {
        let coords = viewModel.coordinates
        let destinationCoordinates = CLLocationCoordinate2D(latitude: coords.latitude, longitude: coords.longitude)

        let placemark = MKPlacemark(coordinate: destinationCoordinates, addressDictionary: nil)
        let mapItem = MKMapItem(placemark: placemark)
        mapItem.name = viewModel.title

        let launchOptions = [MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeDriving]
        mapItem.openInMaps(launchOptions: launchOptions)
    }
}
