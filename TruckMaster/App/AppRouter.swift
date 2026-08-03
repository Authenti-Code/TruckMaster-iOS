internal import SwiftUI
internal import Combine

enum Route: Hashable {
    case splash
    case onboarding
    case selectLanguage
    case signIn
    case signUp
    case forgotPassword
    case verifyCode(resetToken: String)
    case updatePassword(resetToken: String)
    case home
    case profile
    case notifications
    case editProfile
    case savedAddress
    case addAddress(isUpdatingLocation: Bool, comingFrom: ComingFrom)
    case addNewAddress(location: SelectedLocation, editingAddress: SavedAddressModel? = nil)
    case accountSettings
    case deleteAccount
    case changePassword
    case helpAndSupport
    case faqs
    case termsAndConditions(isPolicy: Bool)
    case privacyPolicy
    
    //Start Shipment
    case startShipment
    case selectCategory
    case shipmentCompleted
    case quantity(categoryId: Int, categoryName: String, subCategories: [SubCategoryModel])
    case extras
    case reviewBooking
    case searchCompany
    case orderDetails(orderId: String, companyId: Int)
    
    //Track Order
    case enRoute
    case giveFeedback
    case mapTrack
    case deliveredDetail
}



@available(iOS 16.0, *)
@MainActor
final class AppRouter: ObservableObject {

    @Published var path = NavigationPath()
    var pendingLocationUpdate: SelectedLocation?
    var shouldResetShipmentCache = false
    
    func navigate(to route: Route) {
        path.append(route)
    }

    func navigateBack() {
        guard !path.isEmpty else { return }
        path.removeLast()
    }

    func navigateToRoot() {
        path.removeLast(path.count)
    }
    
    func startNewShipment() {
            shouldResetShipmentCache = true
            path.removeLast(path.count)
        }
    
    func navigateBack(_ count: Int) {
        guard path.count >= count else {
            navigateToRoot()
            return
        }

        path.removeLast(count)
    }
}

@available(iOS 16.0, *)
struct RootView: View {

    @EnvironmentObject var router: AppRouter
    let container: AppContainer

    var body: some View {
        NavigationStack(path: $router.path) {
            container.makeSplashView()
                .navigationBarHidden(true)
                .navigationDestination(for: Route.self) { route in
                    switch route {
                    case .splash:
                        container.makeSplashView()

                    case .onboarding:
                        container.makeOnboardingView()

                    case .selectLanguage:
                        container.makePreferredLanguageView()

                    case .signIn:
                        container.makeSignInView()
                        
                    case .signUp:
                        container.makeSignUpView()
                    
                    case .forgotPassword:
                        container.makeForgotPasswordView()
                    
                    case .verifyCode(let resetToken):
                        container.makeVerifyCodeView(resetToken: resetToken)
                    
                    case .updatePassword(let resetToken):
                        container.makeUpdatePasswordView(resetToken: resetToken)
                        
                    case .home:
                        container.makeMainTabView()
                            .navigationBarHidden(true)
                                   .toolbar(.hidden, for: .navigationBar)
                        
                    case .notifications:
                        container.makeNotificationView()

                    case .profile:
                        Text("Profile")
                        
                    case .editProfile:
                        container.makeEditProfileView()
                  
                    case .termsAndConditions(let isPolicy):
                        container.makeTermsConditionView(isPolicy: isPolicy)
                        
                    case .savedAddress:
                        container.makeSavedAddressView()
                    
                    case .addAddress(let isUpdatingLocation, let comingFrom):
                        container.makeMapAddressView(isUpdatingLocation: isUpdatingLocation, comingFrom: comingFrom)
                    
                    case .addNewAddress(let location, let editingAddress):
                        container.makeAddAddressView(location: location, editingAddress: editingAddress)
                        
                    case .accountSettings:
                        container.makeAccountSettingsView()
                        
                    case .changePassword:
                        container.makeChangePasswordView()
                        
                    case .helpAndSupport:
                        container.makeHelpSupportView()
                       
                    case .faqs:
                        container.makeFaqView()
                    case .privacyPolicy:
                        container.makeTermsConditionView(isPolicy: true)
                    case .deleteAccount:
                        container.makeDeleteAccountView()
                        
                        
                    //Start Shimpment
                    case .startShipment:
                        container.makeStartShipmentView()
    
                    case .shipmentCompleted:
                        container.makeShipmentCompletedView()
                        
                    case .selectCategory:
                        container.makeSelectCategoryView()
                    
                    case .quantity(let categoryId, let categoryName, let subCategories):
                        container.makeQuantityView(categoryId: categoryId, categoryName: categoryName, subCategories: subCategories)
                        
                    case .extras:
                        container.makeExtrasView()
                        
                    case .reviewBooking:
                        container.makeReviewBookingView()
                        
                    case .searchCompany:
                        container.makePickupLocationView()
                        
                    case .orderDetails(let orderId, let companyId):
                        container.makeOrderDetailView(orderId: orderId, companyId: companyId)
                        
                    case .enRoute:
                        container.makeEnRouteView()
                        
                    case .giveFeedback:
                        container.makeFeedbackView()
                        
                    case .mapTrack:
                        container.makeMapTrackView()
                        
                    case .deliveredDetail:
                        container.makeDeliveredDetailView()
                    }
                }
        }
    }
}
