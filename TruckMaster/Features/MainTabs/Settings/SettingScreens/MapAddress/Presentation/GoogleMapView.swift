//
//  GoogleMapView.swift
//  TruckMaster
//

internal import SwiftUI
internal import GoogleMaps

struct GoogleMapView: UIViewRepresentable {

    @Binding var camera: GMSCameraPosition
    var onCameraIdle: (GMSCameraPosition) -> Void
    var onWillMove: () -> Void
    var shouldAnimate: Bool

    func makeUIView(context: Context) -> GMSMapView {
        let mapView = GMSMapView(frame: .zero, camera: camera)
        mapView.delegate = context.coordinator
        mapView.isMyLocationEnabled = true
        mapView.settings.myLocationButton = false

        let marker = GMSMarker()
        marker.position = camera.target
        marker.icon = UIImage(named: ImageConstants.marker)
        marker.groundAnchor = CGPoint(x: 0.5, y: 1.0)
        marker.map = mapView
        context.coordinator.marker = marker

        return mapView
    }

    func updateUIView(_ mapView: GMSMapView, context: Context) {
        guard shouldAnimate else { return }
        context.coordinator.shouldAnimateNextUpdate = false
        mapView.animate(to: camera)
    }

    func makeCoordinator() -> Coordinator { Coordinator(self) }

    class Coordinator: NSObject, GMSMapViewDelegate {
        var parent: GoogleMapView
        var marker: GMSMarker?
        var isMoving = false
        var shouldAnimateNextUpdate = true

        init(_ parent: GoogleMapView) { self.parent = parent }

        func mapView(_ mapView: GMSMapView, willMove gesture: Bool) {
            if gesture {
                isMoving = true
                parent.onWillMove()
            }
        }

        func mapView(_ mapView: GMSMapView, didChange position: GMSCameraPosition) {
            marker?.position = position.target
        }

        func mapView(_ mapView: GMSMapView, idleAt position: GMSCameraPosition) {
            isMoving = false
            marker?.position = position.target
            parent.onCameraIdle(position)
        }
    }
}
