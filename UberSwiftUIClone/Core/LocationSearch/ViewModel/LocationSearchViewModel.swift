//
//  LocationSearchViewModel.swift
//  UberSwiftUIClone
//
//  Created by Ahmed Fouad on 12/11/2025.
//

import Foundation
import MapKit

class LocationSearchViewModel: NSObject, ObservableObject {

    // MARK: - Properties

    @Published var searchText: String = ""
    @Published var results = [MKLocalSearchCompletion]()
    @Published var selectedLocation: String?

    private let searchCompleter = MKLocalSearchCompleter()
    var queryFragment: String = "" {
        didSet {
            searchCompleter.queryFragment = queryFragment
        }
    }

    override init() {
        super.init()
        searchCompleter.delegate = self
        searchCompleter.queryFragment = queryFragment
    }

    // MARK: - Helpers
    func selectedLocation(_ location: String) {
        self.selectedLocation = location
        
        print("DEBUG: Selected location: \(self.selectedLocation)")
    }
}

// MARK: - MKLocalSearchCompleterDelegate

extension LocationSearchViewModel: MKLocalSearchCompleterDelegate {
    func completerDidUpdateResults(_ completer: MKLocalSearchCompleter) {
        self.results = completer.results
    }
}
