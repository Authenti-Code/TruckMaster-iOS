//
//  GlobalShipmentSocket.swift
//  TruckMaster-Company
//
//  Created by AuthentiCode on 24/07/26.
//

enum GlobalShipmentSocket {
    static func connectIfNeeded() {
        guard let userId = UserPreferences.shared.getUser()?.id else { return }
        OfferSocketRepository().startListening(resourceId: userId)
    }
 
    static func disconnect() {
        SocketService.shared.disconnect()
    }
}
 
