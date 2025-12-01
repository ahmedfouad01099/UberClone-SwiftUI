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
    @Binding var mapState: MapViewState
    @EnvironmentObject var viewModel: LocationSearchViewModel

    func makeUIView(context: Context) -> MKMapView {
        mapView.delegate = context.coordinator
        mapView.isRotateEnabled = false
        mapView.showsUserLocation = true
        mapView.userTrackingMode = .follow

        return mapView
    }

    func updateUIView(_ uiView: MKMapView, context: Context) {
        print("DEBUG: Map state is \(mapState)")
        switch mapState {
        case .noInput:
            context.coordinator.clearMapViewAndRecenterOnUserLocation()
            break
        case .searchingForLocation:
            break
        case .locationSelected:
            if let coordinate = viewModel.selectedUberLocation?.coordinate {
                context.coordinator.addAndSelectAnnotation(
                    withCoordinate: coordinate)
                context.coordinator.configurePolyline(
                    withDestensionCoordinate: coordinate)
            }
            break
        case .polylineAdded:
            break
        }
    }

    func makeCoordinator() -> MapCoordinator {
        return MapCoordinator(parent: self)
    }
}

extension UberMapViewRepresentable {
    class MapCoordinator: NSObject, MKMapViewDelegate {

        // MARK: - Properties
        let parent: UberMapViewRepresentable
        var userLocationCoordinate: CLLocationCoordinate2D?
        var currentRegion: MKCoordinateRegion?

        // MARK: - Lifecycle
        init(parent: UberMapViewRepresentable) {
            self.parent = parent
            super.init()
        }

        // MARK: - MKMapViewDelegate
        func mapView(
            _ mapView: MKMapView, didUpdate userLocation: MKUserLocation
        ) {
            self.userLocationCoordinate = userLocation.coordinate
            let region = MKCoordinateRegion(
                center: CLLocationCoordinate2D(
                    latitude: userLocation.coordinate.latitude,
                    longitude: userLocation.coordinate.longitude),
                span: MKCoordinateSpan(
                    latitudeDelta: 0.05, longitudeDelta: 0.05))

            self.currentRegion = region
            parent.mapView.setRegion(region, animated: true)
        }

        func mapView(_ mapView: MKMapView, rendererFor overlay: any MKOverlay)
            -> MKOverlayRenderer
        {
            let polyline = MKPolylineRenderer(overlay: overlay)
            polyline.strokeColor = .systemBlue
            polyline.lineWidth = 6
            return polyline
        }

        // MARK: - Helpers
        func addAndSelectAnnotation(
            withCoordinate coordinate: CLLocationCoordinate2D
        ) {
            parent.mapView.removeAnnotations(parent.mapView.annotations)
            parent.mapView.removeOverlays(parent.mapView.overlays)

            let annotation = MKPointAnnotation()
            annotation.coordinate = coordinate
            parent.mapView.addAnnotation(annotation)
            parent.mapView.selectAnnotation(annotation, animated: true)

            // Zoom to show both user location and destination
            zoomToFitAnnotations()
        }

        func zoomToFitAnnotations() {
            var zoomRect = MKMapRect.null

            // Add user location if available
            if let userLocationCoordinate = userLocationCoordinate {
                let userAnnotation = MKPointAnnotation()
                userAnnotation.coordinate = userLocationCoordinate
                parent.mapView.addAnnotation(userAnnotation)
            }

            for annotation in parent.mapView.annotations {
                let annotationPoint = MKMapPoint(annotation.coordinate)
                let pointRect = MKMapRect(
                    x: annotationPoint.x, y: annotationPoint.y, width: 0.1,
                    height: 0.1)
                zoomRect = zoomRect.union(pointRect)
            }

            let insets = UIEdgeInsets(
                top: 100, left: 100, bottom: 300, right: 100)
            parent.mapView.setVisibleMapRect(
                zoomRect, edgePadding: insets, animated: true)
        }

        func configurePolyline(
            withDestensionCoordinate coordinate: CLLocationCoordinate2D
        ) {
            guard let userLocationCoordinate = self.userLocationCoordinate
            else {
                print("DEBUG: User location not available")
                return
            }

            parent.viewModel.getDestinationRoute(
                from: userLocationCoordinate,
                to: coordinate
            ) { route in
                self.parent.mapView.addOverlay(route.polyline)
                self.parent.mapState = .polylineAdded
                
                let rect = self.parent.mapView.mapRectThatFits(
                    route.polyline.boundingMapRect,
                    edgePadding: .init(
                        top: 64, left: 32, bottom: 500, right: 32))

                self.parent.mapView.setRegion(
                    MKCoordinateRegion(rect), animated: true)
                // Debug print to verify polyline is added
                print(
                    "DEBUG: Polyline added with point count: \(route.polyline.pointCount)"
                )
            }
        }

        func clearMapViewAndRecenterOnUserLocation() {
            parent.mapView.removeAnnotations(parent.mapView.annotations)
            parent.mapView.removeOverlays(parent.mapView.overlays)

            if let currentRegion = currentRegion {
                parent.mapView.setRegion(currentRegion, animated: true)
            }
        }
    }
}
