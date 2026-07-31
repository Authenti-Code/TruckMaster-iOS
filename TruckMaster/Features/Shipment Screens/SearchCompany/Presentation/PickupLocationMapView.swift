//
//  PickupLocationMapView.swift
//  TruckMaster
//
//  Created by AuthentiCode on 30/06/26.
//

internal import SwiftUI
internal import GoogleMaps

struct PickupLocationMapView: UIViewRepresentable {

    let coordinate: CLLocationCoordinate2D
    let profileImage: UIImage?

    func makeUIView(context: Context) -> GMSMapView {
        let camera = GMSCameraPosition.camera(withTarget: coordinate, zoom: 16)
        let mapView = GMSMapView(frame: .zero, camera: camera)
        mapView.isMyLocationEnabled = false
        mapView.settings.myLocationButton = false
        mapView.settings.scrollGestures = true
        mapView.settings.zoomGestures = true
        mapView.settings.rotateGestures = true
        mapView.settings.tiltGestures = false

        let marker = GMSMarker(position: coordinate)
        marker.iconView = PulsingMarkerView(profileImage: profileImage)
        marker.groundAnchor = CGPoint(x: 0.5, y: 0.5)
        marker.map = mapView

        return mapView
    }

    func updateUIView(_ uiView: GMSMapView, context: Context) {
    }
}
