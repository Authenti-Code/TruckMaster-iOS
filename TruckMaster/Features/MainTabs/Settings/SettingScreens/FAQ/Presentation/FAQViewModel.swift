//
//  FAQViewModel.swift
//  TruckMaster
//
//  Created by AuthentiCode on 18/06/26.
//

internal import Foundation
internal import SwiftUI
internal import Combine

@available(iOS 16.0, *)
@MainActor
final class FAQViewModel: ObservableObject {

    @Published var state = FAQState()

    private let router: AppRouter

    init(router: AppRouter) {
        self.router = router
        loadFAQs()
    }

    func backTapped() {
        router.navigateBack()
    }

    func toggleFAQ(id: UUID) {
        state.faqs = state.faqs.map { item in
            var updatedItem = item

            if item.id == id {
                updatedItem.isExpanded.toggle()
            } else {
                updatedItem.isExpanded = false
            }

            return updatedItem
        }
    }

    private func loadFAQs() {
        state.faqs = [
            FAQItem(
                question: "How do I create an account?",
                answer: "Tap on 'Sign Up' and follow the steps to register using your email or phone number.",
                isExpanded: true
            ),
            FAQItem(
                question: "How can I reset my password?",
                answer: "Open the login screen and tap 'Forgot Password'. Follow the instructions sent to your email."
            ),
            FAQItem(
                question: "How do I update my profile information?",
                answer: "Go to Profile > Edit Profile and update your information."
            ),
            FAQItem(
                question: "How can I contact support?",
                answer: "Navigate to the Contact Us section and submit your query."
            ),
            FAQItem(
                question: "Is my data secure?",
                answer: "Yes, your data is encrypted and stored securely following industry standards."
            )
        ]
    }
}
