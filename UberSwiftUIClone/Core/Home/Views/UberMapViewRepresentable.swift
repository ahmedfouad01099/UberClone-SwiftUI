//
//  UberMapViewRepresentable.swift
//  UberSwiftUIClone
//
//  Created by Ahmed Fouad on 06/11/2025.
//

import MapKit
import SwiftUI

struct UberMapViewRepresentable: UIViewRepresentable {

    let mapView = MKMapView()
    let locationManager = LocationManager()
    @EnvironmentObject var viewModel: LocationSearchViewModel

    func makeUIView(context: Context) -> MKMapView {
        mapView.delegate = context.coordinator
        mapView.isRotateEnabled = false
        mapView.showsUserLocation = true
        mapView.userTrackingMode = .follow

        return mapView
    }

    func updateUIView(_ uiView: MKMapView, context: Context) {
        if let selectedLocation = viewModel.selectedLocation {
            print("DEBUG: Selected Location: \(selectedLocation)")
        }
    }

    func makeCoordinator() -> MapCoordinator {
        return MapCoordinator(parent: self)
    }
}

extension UberMapViewRepresentable {
    class MapCoordinator: NSObject, MKMapViewDelegate {
        let parent: UberMapViewRepresentable

        init(parent: UberMapViewRepresentable) {
            self.parent = parent
            super.init()
        }

        func mapView(
            _ mapView: MKMapView, didUPdate UserLocation: MKUserLocation
        ) {
            let region = MKCoordinateRegion(
                center: CLLocationCoordinate2D(
                    latitude: UserLocation.coordinate.latitude,
                    longitude: UserLocation.coordinate.longitude),
                span: MKCoordinateSpan(
                    latitudeDelta: 0.05, longitudeDelta: 0.05))

            parent.mapView.setRegion(region, animated: true)
        }
    }
}
