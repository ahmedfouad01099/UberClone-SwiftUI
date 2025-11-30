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
    @Published var selectedLocationCoordinate: CLLocationCoordinate2D?

    private let searchCompleter = MKLocalSearchCompleter()
    var queryFragment: String = "" {
        didSet {
            searchCompleter.queryFragment = queryFragment
        }
    }

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
            self.selectedLocationCoordinate = coordinate
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
}

// MARK: - MKLocalSearchCompleterDelegate

extension LocationSearchViewModel: MKLocalSearchCompleterDelegate {
    public func completerDidUpdateResults(_ completer: MKLocalSearchCompleter) {
        self.results = completer.results
    }
}
