//
//  MapTrackViewModel.swift
//  TruckMaster
//
//  Created by AuthentiCode on 02/07/26.
//

internal import Foundation
internal import CoreLocation
internal import UIKit
internal import Combine

@available(iOS 16.0, *)
@MainActor
final class MapTrackViewModel: ObservableObject {
    @Published var state: MapTrackState
    private let router: AppRouter

    init(
        pickUpCoordinate: CLLocationCoordinate2D,
        dropCoordinate: CLLocationCoordinate2D,
        markerImg: UIImage?,
        truckImg: UIImage?,
        router: AppRouter
    ) {
        self.state = MapTrackState(pickUpCoordinate: pickUpCoordinate, dropCoordinate: dropCoordinate, markerImg: markerImg, truckImg: truckImg)
        self.router = router
    }
    
    func backTapped() {
        router.navigateBack()
    }
}
