//
//  ExtrasViewModel.swift
//  TruckMaster
//
//  Created by AuthentiCode on 24/06/26.
//

internal import Foundation
internal import Combine

@available(iOS 16.0, *)
@MainActor
final class ExtrasViewModel: ObservableObject {

    @Published var state = ExtrasState()
    let draft: ShipmentDraft
    private let router: AppRouter

    init(draft: ShipmentDraft, router: AppRouter) {
        self.draft = draft
        self.router = router

        state.helpers          = draft.extras.helpers
        state.fragileHandling  = draft.extras.fragileHandling
        state.stairsCarry      = draft.extras.stairsCarry
        state.urgent           = draft.extras.urgent
        state.zipHandler       = draft.extras.zipHandler
        state.elevator         = draft.extras.elevator
        state.additionalInfo   = draft.extras.additionalInfo ?? ""
    }

    func backTapped() {
        router.navigateBack()
    }

    func helperPlusTapped() {
        state.helpers += 1
    }

    func helperMinusTapped() {
        state.helpers = max(0, state.helpers - 1)
    }

    func fragileHandlingTapped() {
        state.fragileHandling.toggle()
    }

    func stairsCarryTapped() {
        state.stairsCarry.toggle()
    }

    func urgentTapped() {
        state.urgent.toggle()
    }

    func zipHandlerTapped() {
        state.zipHandler.toggle()
    }

    func elevatorChanged(to value: Bool) {
        state.elevator = value
    }

    func nextTapped() {
        draft.extras = ExtrasRequest(
            helpers: state.helpers,
            fragileHandling: state.fragileHandling,
            stairsCarry: state.stairsCarry,
            urgent: state.urgent,
            zipHandler: state.zipHandler,
            elevator: state.elevator,
            additionalInfo: {
                let trimmed = state.additionalInfo?
                    .trimmingCharacters(in: .whitespacesAndNewlines)
                return trimmed?.isEmpty == true ? nil : trimmed
            }()
            
        )
        
        print("Address payload : \(draft)")
         router.navigate(to: .reviewBooking) 
    }
}
