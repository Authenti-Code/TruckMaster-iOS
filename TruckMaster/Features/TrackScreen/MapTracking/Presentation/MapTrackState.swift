//
//  MapTrackState.swift
//  TruckMaster
//
//  Created by AuthentiCode on 02/07/26.
//

internal import Foundation
internal import CoreLocation
internal import UIKit

struct MapTrackState{
    var pickUpCoordinate: CLLocationCoordinate2D
    var dropCoordinate: CLLocationCoordinate2D
    var markerImg: UIImage?
    var truckImg: UIImage?
}
