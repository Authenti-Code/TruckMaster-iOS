//
//  AppContainer.swift
//  TruckMaster
//
//  Created by AuthentiCode on 03/06/26.
//
internal import SwiftUI
internal import CoreLocation

@available(iOS 16.0, *)
final class AppContainer {

   private  let router = AppRouter()
    private let apiClient: APIClientProtocol = APIClient()
    let shipmentDraft = ShipmentDraft()
    private var viewModelCache: [String: Any] = [:]
    
    func makeRootView() -> some View {

        RootView(container: self)
            .environmentObject(router)
    }

    func makeSplashView() -> some View {

        let repository =
            SplashRepositoryImpl()

        let useCase =
            CheckAppLaunchUseCase(
                repository: repository
            )

        let viewModel =
            SplashViewModel(
                checkAppLaunchUseCase: useCase,
                router: router
            )

        return SplashView(
            viewModel: viewModel
        )
    }
    
    func makeOnboardingView()
    -> some View {

        let repository =
            OnboardingRepositoryImpl()

        let useCase =
            GetOnboardingUseCase(
                repository: repository
            )

        let viewModel =
            OnboardingViewModel(
                getOnboardingUseCase: useCase,
                router: router
            )

        return OnboardingView(
            viewModel: viewModel
        )
    }
    
    
    func makePreferredLanguageView()
    -> some View {

        let repository =
            PreferredLanguageRepositoryImpl()

        let useCase =
            GetPreferredLanguageUseCase(
                repository: repository
            )

        let viewModel =
        PreferredLanguageViewModel(
                getPreferredLanguageUseCase: useCase,
                router: router
            )

        return PreferredLanguageView(
            viewModel: viewModel
        )
    }
    
    
    func makeSignUpView() -> some View {
           let repository = SignUpRepositoryImpl(apiClient: apiClient)
           let useCase    = SignUpUseCase(repository: repository)
           let viewModel  = SignUpViewModel(
               registerUseCase: useCase,
               router: router  
           )
           return SignUpView(viewModel: viewModel)
       }
    
    func makeSignInView() -> some View {
           let repository = SignInRepositoryImpl(apiClient: apiClient)
           let useCase    = SignInUseCase(repository: repository)
           let viewModel  = SignInViewModel(
               loginUseCase: useCase,
               router: router
           )
           return SignInView(viewModel: viewModel)
       }
    
    
    func makeForgotPasswordView() -> some View {
           let repository = ForgotPasswordRepositoryImpl(apiClient: apiClient)
           let useCase    = ForgotPasswordUseCase(repository: repository)
           let viewModel  = ForgotPasswordViewModel(
               forgotPasswordUseCase: useCase,
               router: router
           )
           return ForgotPasswordView(viewModel: viewModel)
       }
    
    func makeVerifyCodeView(resetToken: String) -> some View {
        let repository = VerifyCodeRepositoryImpl(apiClient: apiClient)
        let useCase    = VerifyCodeUseCase(repository: repository)
        let viewModel  = VerifyCodeViewModel(
            verifyCodeUseCase: useCase,
            router: router
        )
        viewModel.state.resetToken = resetToken 
        return VerifyCodeView(viewModel: viewModel)
    }
    
    func makeUpdatePasswordView(resetToken: String) -> some View {
        let repository = UpdatePasswordRepositoryImpl(apiClient: apiClient)
        let useCase    = UpdatePasswordUseCase(repository: repository)
        let viewModel  = UpdatePasswordViewModel(
            updatePasswordUseCase: useCase,
            router: router
        )
        viewModel.state.resetToken = resetToken 
        return UpdatePasswordView(viewModel: viewModel)
    }
    
    func makeMainTabView() -> some View {
        GlobalShipmentSocket.connectIfNeeded()
        return MainTabView(container: self)
    }
    
    func makeHomeView() -> some View {
        let repository = HomeRepositoryImpl(apiClient: apiClient)
        let useCase    = GetShipmentsUseCase(repository: repository)
        let viewModel  = HomeViewModel(
            getShipmentsUseCase: useCase,
            draft: shipmentDraft,
            router: router
        )
        return HomeView(viewModel: viewModel)
    }

    func makeOrdersView() -> some View {
        let repository = OrdersRepositoryImpl(apiClient: apiClient)
        let useCase    = GetOrdersUseCase(repository: repository)
        let viewModel  = OrdersViewModel(
            getOrdersUseCase: useCase,
            router: router
        )
        return OrdersView(viewModel: viewModel)
    }

    func makeSettingsView() -> some View {
        let repository = SettingsRepositoryImpl(apiClient: apiClient)
        let useCase    = GetUserProfileUseCase(repository: repository)
        let viewModel  = SettingsViewModel(
            getUserProfileUseCase: useCase,
            router: router
        )
        return SettingsView(viewModel: viewModel)
    }
    
    func makeTermsConditionView(isPolicy: Bool) -> some View {
        let repository = TermsConditionRepositoryImpl(apiClient: apiClient)
        let useCase    = GetTermsConditionUseCase(repository: repository)
        let viewModel  = TermsConditionViewModel(
            getTermsConditionUseCase: useCase,
            router: router, isPolicy: isPolicy
        )
        return TermConditionsView(viewModel: viewModel)
    }
    
    func makeEditProfileView() -> some View {
        let repository = EditProfileRepositoryImpl(apiClient: apiClient)
        let useCase    = EditProfileUseCase(repository: repository)
        let viewModel  = EditProfileViewModel(
            editProfileUseCase: useCase,
            router: router
        )
        return EditProfileView(viewModel: viewModel)
    }
    
    func makeSavedAddressView() -> some View {
        let repository = SavedAddressRepositoryImpl(apiClient: apiClient)
        let useCase    = GetSavedAddressesUseCase(repository: repository)
        let viewModel  = SavedAddressViewModel(
            useCase: useCase,
            router: router
        )
        return SavedAddressView(viewModel: viewModel)
    }
    
    func makeMapAddressView(isUpdatingLocation: Bool, comingFrom: ComingFrom) -> MapAddressView {
        let viewModel = MapAddressViewModel(router: router, isUpdatingLocation: isUpdatingLocation, comingFrom: comingFrom, draft: shipmentDraft)
        return MapAddressView(viewModel: viewModel)
    }
    
    func makeAddAddressView(location: SelectedLocation, editingAddress: SavedAddressModel? = nil) -> some View {
        let repository = AddAddressRepositoryImpl(apiClient: apiClient)
        let useCase    = AddAddressUseCase(repository: repository)
        let viewModel  = AddAddressViewModel(
            addAddressUseCase: useCase,
            router: router,
            location: location,
            editingAddress: editingAddress
        )
        return AddAddressView(viewModel: viewModel)
    }
    
    func makeAccountSettingsView() -> some View {
        let viewModel  = AccountSettingsViewModel(router: router)
        return AccountSettingsView(viewModel: viewModel)
    }
    
    func makeChangePasswordView() -> some View {
        let repository = ChangePasswordRepositoryImpl(apiClient: apiClient)
        let useCase    = ChangePasswordUseCase(repository: repository)
        let viewModel  = ChangePasswordViewModel(changePasswordUseCase: useCase, router: router)
        return ChangePasswordView(viewModel: viewModel)
    }
    
    func makeHelpSupportView() -> some View {
        let repository = SupportRepositoryImpl(apiClient: apiClient)
        let getMessagesUseCase = GetSupportMessagesUseCase(repository: repository)
        let sendMessageUseCase = SendSupportMessageUseCase(repository: repository)
        let viewModel = HelpSupportViewModel(
            getMessagesUseCase: getMessagesUseCase,
            sendMessageUseCase: sendMessageUseCase,
            router: router
        )
        return HelpSupportView(viewModel: viewModel)
    }
    
    func makeNotificationView() -> some View {
        let repository = NotificationRepositoryImpl(apiClient: apiClient)
        let useCase    = GetNotificationsUseCase(repository: repository)
        let viewModel  = NotificationViewModel(getNotificationsUseCase: useCase, router: router)
        return NotificationView(viewModel: viewModel)
    }
    
    func makeFaqView() -> some View {
        let viewModel = FAQViewModel(
            router: router
        )

        return FAQView(viewModel: viewModel)
    }
    
    func makeDeleteAccountView() -> some View {
        let repository = DeleteAccountRepositoryImpl(apiClient: apiClient)
        let useCase    = DeleteAccountUseCase(repository: repository)
        let viewModel = DeleteAccountViewModel(
            deleteAccountUseCase: useCase,
            router: router
        )

        return DeleteAccountView(viewModel: viewModel)
    }
    
    func makeStartShipmentView() -> some View {
        let profileRepository = SettingsRepositoryImpl(apiClient: apiClient)
        let profileUseCase = GetUserProfileUseCase(repository: profileRepository)

        let addressRepository = SavedAddressRepositoryImpl(apiClient: apiClient)
        let addressUseCase = GetSavedAddressesUseCase(repository: addressRepository)

        let viewModel = StartShipmentViewModel(
            getUserProfileUseCase: profileUseCase,
            getSavedAddressesUseCase: addressUseCase,
            draft: shipmentDraft,
            router: router
        )
        return StartShipmentView(viewModel: viewModel)
    }
    
    func makeShipmentCompletedView() -> some View {
        let viewModel = ShipmentCompletedViewModel(router: router)
        return ShipmentCompletedView(viewModel: viewModel)
    }
    
    func makeSelectCategoryView() -> some View {
        let viewModel = cachedViewModel(key: "selectCategory") {
            let repository = SelectCategoryRepositoryImpl(apiClient: apiClient)
            let useCase    = NewCategoryUseCase(repository: repository)
            return SelectCategoryViewModel(
                getCategoryUseCase: useCase,
                draft: shipmentDraft,
                router: router
            )
        }
        return SelectCategoryView(viewModel: viewModel)
    }
    
    func makeQuantityView(categoryId: Int, categoryName: String, subCategories: [SubCategoryModel]) -> some View {
        let viewModel = QuantityViewModel(
            categoryId: categoryId,
            categoryName: categoryName,
            subCategories: subCategories,
            draft: shipmentDraft,
            router: router
        )
        return QuantityView(viewModel: viewModel)
    }
    
    func makeExtrasView() -> some View {
        let viewModel = ExtrasViewModel(
            draft: shipmentDraft,
            router: router
        )
        return ExtrasView(viewModel: viewModel)
    }
    
    func makeReviewBookingView() -> some View {

        let categoryRepository = SelectCategoryRepositoryImpl(apiClient: apiClient)
        let categoryUseCase = NewCategoryUseCase(repository: categoryRepository)

        let createOrderRepository = CreateOrderRepositoryImpl(apiClient: apiClient)
        let createOrderUseCase = CreateOrderUseCaseImpl(
            repository: createOrderRepository
        )

        let viewModel = ReviewBookingViewModel(
            getCategoryUseCase: categoryUseCase,
            createOrderUseCase: createOrderUseCase,
            draft: shipmentDraft,
            router: router
        )

        return ReviewBookingView(viewModel: viewModel)
    }
    
    
    func makePickupLocationView() -> some View {
        let lat: Double = Double(shipmentDraft.pickup?.latitude ?? "") ?? 0.0
        let lng: Double = Double(shipmentDraft.pickup?.longitude ?? "") ?? 0.0
        let coordinate = CLLocationCoordinate2D(latitude: lat, longitude: lng)

        let viewModel = PickupLocationViewModel(
            coordinate: coordinate,
            profileImage: UIImage(named: ImageConstants.user),
            repository: SearchCompanyRepositoryImpl(apiClient: apiClient),
            router: router
        )

        return SearchCompanyView(viewModel: viewModel)
    }
    
    func makeOrderDetailView(orderId: String, companyId: Int) -> some View {
        let viewModel = OrderDetailViewModel(
            useCase: OrderDetailUseCase(
                repository: OrderDetailRepositoryImpl(apiClient: apiClient)
            ),
            router: router,
            orderId: orderId,
            companyId: companyId
        )
    
        return OrderDetailView(viewModel: viewModel)
    }
    
    func makeEnRouteView() -> some View {
        let viewModel = EnRouteViewModel(
            useCase: EnRouteUseCase(
                repository: EnRouteRepositoryImpl(apiClient: apiClient)
            ),
            router: router
        )
        return EnRouteView(viewModel: viewModel)
    }
    
    func makeFeedbackView() -> some View {
        let viewModel = GiveFeedbackViewModel(
            router: router
        )
        return GiveFeedbackView(viewModel: viewModel)
    }
    
    
    func makeMapTrackView() -> some View {
        let lat: Double = Double(shipmentDraft.pickup?.latitude ?? "") ?? 0.0
        let lng: Double = Double(shipmentDraft.pickup?.longitude ?? "") ?? 0.0
        let coordinate = CLLocationCoordinate2D(latitude: lat, longitude: lng)

        let viewModel = MapTrackViewModel(pickUpCoordinate: coordinate, dropCoordinate: coordinate, markerImg: UIImage(named: ImageConstants.marker), truckImg: UIImage(named: ImageConstants.truckImage), router: router)

        return MapTrackView(viewModel: viewModel)
    }
    
    
    func makeDeliveredDetailView() -> some View {
        let viewModel = DeliveredDetailViewModel(
            router: router
        )
        return DeliveredDetailView(viewModel: viewModel)
    }
    
    
    private func cachedViewModel<T: AnyObject>(
         key: String,
         create: () -> T
     ) -> T {
         if router.shouldResetShipmentCache {
             viewModelCache.removeAll()
             router.shouldResetShipmentCache = false
         }

         if let cached = viewModelCache[key] as? T {
             return cached
         }
         let new = create()
         viewModelCache[key] = new
         return new
     }

    func clearViewModelCache() {
        viewModelCache.removeAll()
    }
    
}

