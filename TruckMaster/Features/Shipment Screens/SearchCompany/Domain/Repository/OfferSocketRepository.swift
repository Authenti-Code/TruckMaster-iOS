//
//  OfferSocketRepository.swift
//  TruckMaster
//
//  Created by AuthentiCode on 03/08/26.
//

import Foundation


protocol OfferSocketRepositoryProtocol {
    func startListening(resourceId: String)
    func stopListening()
    func shipmentStream() -> AsyncStream<ActiveOrderOffer>
}


final class OfferSocketRepository: OfferSocketRepositoryProtocol {

    private let socketService: SocketServiceProtocol

    init(socketService: SocketServiceProtocol = SocketService.shared) {
        self.socketService = socketService
    }

    func startListening(resourceId: String) {
        socketService.connect(resource: "user", resourceId: resourceId)
    }

    func stopListening() {
        socketService.disconnect()
    }

    func shipmentStream() -> AsyncStream<ActiveOrderOffer> {
        let newOfferStream = socketService.events(SocketEvent.newOffer)

        return AsyncStream { continuation in


            let offerTask = Task {
                for await data in newOfferStream {
                    do {
                        let shipment = try JSONDecoder().decode(ActiveOrderOffer.self, from: data)
                        continuation.yield(shipment)
                    } catch {
                        print("new_order decode error:", error)
                    }
                }
            }
            continuation.onTermination = { _ in
                offerTask.cancel()
            }
        }
    }
}
