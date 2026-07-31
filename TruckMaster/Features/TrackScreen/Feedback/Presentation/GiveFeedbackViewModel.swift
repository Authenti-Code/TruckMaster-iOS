//
//  GiveFeedbackViewModel.swift
//  TruckMaster
//
//  Created by AuthentiCode on 02/07/26.
//
internal import Foundation
internal import Combine

@available(iOS 16.0, *)
@MainActor
final class GiveFeedbackViewModel: ObservableObject{
    
    @Published var state = FeedBackState()
    
    private let router: AppRouter
    
    init(router: AppRouter){
        self.router = router
    }
    
    func crossTapped(){
        router.navigateBack()
    }
}
