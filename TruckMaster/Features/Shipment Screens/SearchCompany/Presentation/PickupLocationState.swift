//
//  PickupLocationState.swift
//  TruckMaster
//
//  Created by AuthentiCode on 30/06/26.
//

import Foundation
import CoreLocation
import UIKit

struct PickupLocationState {
    var coordinate: CLLocationCoordinate2D
    var profileImage: UIImage?
    var companyName: String = ""
    var companies: [CompanyModel] = []
    var visibleCount: Int = 0
    var statusMessage: String = "Searching for the best company to help relocate your items"
    var isSearching: Bool = true
}
