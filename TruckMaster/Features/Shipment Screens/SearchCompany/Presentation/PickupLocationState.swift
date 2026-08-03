//
//  PickupLocationState.swift
//  TruckMaster
//
//  Created by AuthentiCode on 30/06/26.
//

internal import Foundation
internal import CoreLocation
internal import UIKit

struct PickupLocationState {
    var coordinate: CLLocationCoordinate2D
    var profileImage: UIImage?
    var companyName: String = ""
    var offers: [ActiveOrderOffer] = []
    var visibleCount: Int = 0
    var statusMessage: String = "Searching for the best company to help relocate your items"
    var isSearching: Bool = true
    var orderId: String? = nil
    var companyId: Int? = nil
}
