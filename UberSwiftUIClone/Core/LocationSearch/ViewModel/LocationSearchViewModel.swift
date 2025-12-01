//
//  LocationSearchViewModel.swift
//  UberSwiftUIClone
//
//  Created by Ahmed Fouad on 12/11/2025.
//

import Foundation
import MapKit

public class LocationSearchViewModel: NSObject, ObservableObject {

    // MARK: - Properties

    @Published var searchText: String = ""
    @Published var results = [MKLocalSearchCompletion]()
    @Published var selectedUberLocation: UberLocation?
    @Published var pickupTime: String?
    @Published var dropOffTime: String?

    private let searchCompleter = MKLocalSearchCompleter()
    var queryFragment: String = "" {
        didSet {
            searchCompleter.queryFragment = queryFragment
        }
    }

    var userLocation: CLLocationCoordinate2D?

    public override init() {
        super.init()
        searchCompleter.delegate = self
        searchCompleter.queryFragment = queryFragment
    }

    // MARK: - Helpers
    func selectLocation(_ localSearch: MKLocalSearchCompletion) {
        locationSearch(forLocalSearcCompletion: localSearch) {
            response, error in
            if let error = error {
                print("DEBUG: Location search coordinate error: \(error)")
                return
            }
            guard let item = response?.mapItems.first else { return }

            let coordinate = item.placemark.coordinate
            self.selectedUberLocation = UberLocation(
                title: localSearch.title, coordinate: coordinate)
        }
    }

    // MARK: - Natural Search location
    func locationSearch(
        forLocalSearcCompletion localSearch: MKLocalSearchCompletion,
        completion: @escaping MKLocalSearch.CompletionHandler
    ) {
        let searchRequest = MKLocalSearch.Request()
        searchRequest.naturalLanguageQuery = localSearch.title.appending(
            localSearch.subtitle)
        let search = MKLocalSearch(request: searchRequest)
        search.start(completionHandler: completion)
    }

    func computeRidePrice(forType type: RideType) -> Double {
        guard let coordinate = selectedUberLocation?.coordinate else {
            return 0
        }
        guard let userCoordinate = self.userLocation else { return 0 }

        let userLocation = CLLocation(
            latitude: userCoordinate.latitude,
            longitude: userCoordinate.longitude)

        let destination = CLLocation(
            latitude: coordinate.latitude, longitude: coordinate.longitude)

        let tripDistanceMeters = userLocation.distance(from: destination)
        return type.computePrice(for: tripDistanceMeters)
    }

    func getDestinationRoute(
        from userLocation: CLLocationCoordinate2D,
        to destination: CLLocationCoordinate2D,
        completion: @escaping (MKRoute) -> Void
    ) {
        let userPlaceMark = MKPlacemark(coordinate: userLocation)
        let destinationPlaceMark = MKPlacemark(coordinate: destination)

        let request = MKDirections.Request()
        request.source = MKMapItem(placemark: userPlaceMark)
        request.destination = MKMapItem(placemark: destinationPlaceMark)
        request.transportType = .automobile

        let directions = MKDirections(request: request)
        directions.calculate { response, error in
            if let error = error {
                print(
                    "DEBUG: Failed to get directions: \(error.localizedDescription)"
                )
                return
            }

            guard let route = response?.routes.first else {
                print("DEBUG: No routes found")
                return
            }
            self.configurePickupAndDropoffTimes(with: route.expectedTravelTime)
            completion(route)
        }
    }

    func configurePickupAndDropoffTimes(with expectedTravelTime: Double) {
        let formatter = DateFormatter()
        formatter.dateFormat = "hh:mm a"

        pickupTime = formatter.string(from: Date())
        dropOffTime = formatter.string(from: Date() + expectedTravelTime)

    }
}

// MARK: - MKLocalSearchCompleterDelegate

extension LocationSearchViewModel: MKLocalSearchCompleterDelegate {
    public func completerDidUpdateResults(_ completer: MKLocalSearchCompleter) {
        self.results = completer.results
    }
}
