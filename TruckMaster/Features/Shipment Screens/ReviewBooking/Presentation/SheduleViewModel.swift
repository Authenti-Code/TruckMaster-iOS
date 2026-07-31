//
//  SheduleViewModel.swift
//  TruckMaster
//
//  Created by AuthentiCode on 26/06/26.
//
internal import Foundation
internal import Combine

@available(iOS 16.0, *)
@MainActor
final class SheduleViewModel: ObservableObject {
    @Published var state = SheduleState()
    let draft: ShipmentDraft
    private let router: AppRouter
    private let createOrderUseCase: CreateOrderUseCase
    init(draft: ShipmentDraft, router: AppRouter,
         createOrderUseCase: CreateOrderUseCase) {
        self.draft = draft
        self.router = router
        self.createOrderUseCase = createOrderUseCase
        
        state.instantBooking = draft.scheduleType == "instant"
        state.sheduleBooking = draft.scheduleType == "scheduled"

        if let scheduledAt = draft.scheduledAt,
           let date = Self.isoFormatter.date(from: scheduledAt) {
            state.selectedDate = date
            state.selectedTime = date
        }
    }

    func backTapped() {
        router.navigateBack()
    }

    func instantTapped() {
        state.instantBooking = true
        state.sheduleBooking = false
    }

    func sheduledTapped() {
        state.instantBooking = false
        state.sheduleBooking = true
    }

    private func triggerError(_ message: String) {
        state.snackbarMessage = message
        state.snackbarType    = .error
        state.showSnackbar    = true
    }

    private func triggerSuccess(_ message: String) {
        state.snackbarMessage = message
        state.snackbarType    = .success
        state.showSnackbar    = true
    }
    
    func continueTapped() {

        guard validateSchedule() else { return }

        draft.scheduleType = state.instantBooking ? "instant" : "scheduled"
        draft.scheduledAt = state.sheduleBooking
            ? Self.isoFormatter.string(from: combinedDateTime())
            : nil

        guard let request = draft.buildRequest() else {
            triggerError("Something went wrong. Please try again.")
            return
        }

        Task {
            do {
                try await createOrderUseCase.execute(request: request)
                router.navigate(to: .searchCompany)
            } catch {
                triggerError(error.localizedDescription)
            }
        }
    }

    // MARK: - Private

    private func validateSchedule() -> Bool {
        guard state.instantBooking || state.sheduleBooking else {
            triggerError("Please select instant or scheduled booking")
            return false
        }

        if state.sheduleBooking {
            let scheduledDateTime = combinedDateTime()
            guard scheduledDateTime > Date() else {
                triggerError("Please select a valid future date and time")
                return false
            }
        }

        return true
    }
    
    
    // MARK: - Private

    private func combinedDateTime() -> Date {
        let calendar = Calendar.current
        let dateComponents = calendar.dateComponents([.year, .month, .day], from: state.selectedDate)
        let timeComponents  = calendar.dateComponents([.hour, .minute, .second], from: state.selectedTime)

        var merged = DateComponents()
        merged.year   = dateComponents.year
        merged.month  = dateComponents.month
        merged.day    = dateComponents.day
        merged.hour   = timeComponents.hour
        merged.minute = timeComponents.minute
        merged.second = timeComponents.second

        return calendar.date(from: merged) ?? state.selectedDate
    }

    private static let isoFormatter: ISO8601DateFormatter = {
        let formatter = ISO8601DateFormatter()
        formatter.formatOptions = [.withInternetDateTime]
        formatter.timeZone = TimeZone(identifier: "UTC")
        return formatter
    }()
}
