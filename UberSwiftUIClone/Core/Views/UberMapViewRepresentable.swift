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

    func makeUIView(context: Context) -> MKMapView {
        mapView.isRotateEnabled = false
        mapView.showsUserLocation = true
        mapView.userTrackingMode = .follow

        return mapView
    }

    func updateUIView(_ uiView: MKMapView, context: Context) {

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
    }
}
