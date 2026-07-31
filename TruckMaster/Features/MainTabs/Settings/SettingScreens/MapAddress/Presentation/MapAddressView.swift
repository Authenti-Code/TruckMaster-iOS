//
//  MapAddressView.swift
//  TruckMaster
//

internal import SwiftUI
internal import GoogleMaps

@available(iOS 16.0, *)
struct MapAddressView: View {

    @ObservedObject var viewModel: MapAddressViewModel

    var body: some View {
        GeometryReader { geo in
            ZStack {

                GoogleMapView(
                    camera: viewModel.binding(for: \.state.camera),
                    onCameraIdle: { viewModel.onCameraIdle($0) },
                    onWillMove: { viewModel.onCameraWillMove() },
                    shouldAnimate: viewModel.state.shouldAnimateCamera
                )
                .ignoresSafeArea()

                VStack(spacing: 0) {
                    HStack(spacing: 12) {
                        Button { viewModel.backTapped() } label: {
                            Image(ImageConstants.backImage)
                        }
                        if !viewModel.state.isDetailsStage {
                            MapSearchBar(
                                placeholder: "search_location",
                                text: viewModel.state.searchText,
                                onTap: { viewModel.searchTapped() }
                            )
                        }
                        else {
                            Spacer()
                        }
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, geo.safeAreaInsets.top + 12)

                    Spacer()

                    VStack(spacing: 0) {
                        HStack {
                            Spacer()
                            Button {
                                viewModel.currentLocationTapped()
                            } label: {
                                Image(ImageConstants.gps)
                            }
                        }
                        .padding(.trailing, 20)
                        .padding(.bottom, 16)
                
                            VStack(alignment: .leading, spacing: 16) {
                                if viewModel.state.isDetailsStage {
                                    ScrollView {
                                        VStack(alignment: .leading, spacing: 16) {

                                            // Address row
                                            AddressPickerRow(
                                                locationName: viewModel.state.selectedAddress.isEmpty
                                                    ? "Fetching address..."
                                                    : viewModel.state.selectedAddress,
                                                subAddress: viewModel.state.selectedSubAddress,
                                                onChangeTapped: {
                                //                    viewModel.changeTapped()
                                                }
                                            )

                                            // Name
                                            NameInputField(
                                                label: viewModel.comingFrom == .shipmentDrop ? "receiver_name_required" : "sender_name_required",
                                                hint: viewModel.comingFrom == .shipmentDrop ? "enter_receiver_name" : "enter_sender_name",
                                                isRequired: true,
                                                text: viewModel.nameBinding
                                            )

                                            // Contact
                                            LabeledInputField(
                                                label: "contact_required",
                                                hint: "enter_contact",
                                                isRequired: true,
                                                keyboardType: .numberPad,
                                                text: viewModel.contactBinding
                                            )
                                            // Save as
                                            SaveAsSelector(selected: viewModel.binding(for: \.state.selectedLabel))
                                            PrimaryButton(
                                                title: "confirm_location_title",
                                                isEnabled: viewModel.state.name.isEmpty == false && viewModel.state.contact.isEmpty == false
                                            ) {
                                                viewModel.confirmLocationTapped()
                                            }
                                        }
                                        .padding(.horizontal, 20)
                                        .padding(.top, 8)
                                        .padding(.bottom, 10)
                                    }
                                    .scrollDismissesKeyboard(.interactively)
                                    .scrollIndicators(.hidden)
                                    .frame(maxHeight: 400)
                                }
                                else {
                                    HStack(spacing: 12) {
                                    Image(ImageConstants.location)
                                    VStack(alignment: .leading, spacing: 3) {
                                        Text(
                                            viewModel.state.selectedAddress.isEmpty
                                            ? "Fetching address..."
                                            : viewModel.state.selectedAddress
                                        )
                                        .font(.custom("Livvic-SemiBold", size: 15))
                                        .foregroundColor(AppColors.textBlack1)
                                        .lineLimit(1)
                                        
                                        if !viewModel.state.selectedSubAddress.isEmpty {
                                            Text(viewModel.state.selectedSubAddress)
                                                .font(.custom("Livvic-Regular", size: 13))
                                                .foregroundColor(AppColors.grey1)
                                                .lineLimit(2)
                                        }
                                    }
                                    Spacer()
                                }
                                    
                                    PrimaryButton(title: "confirm_location_title") {
                                        viewModel.confirmLocationTapped()
                                    }
                                }
                        }
                        .padding(.horizontal, 20)
                        .padding(.top, 24)
                        .padding(.bottom, geo.safeAreaInsets.bottom + 16)
                        .background(Color.white)
                        .clipShape(RoundedCorner(radius: 24, corners: [.topLeft, .topRight]))
                        .overlay(
                            RoundedCorner(radius: 24, corners: [.topLeft, .topRight])
                                .stroke(Color.gray.opacity(0.2), lineWidth: 1)
                        )
                    }
                }
            }
            .ignoresSafeArea(edges: .top)
            .ignoresSafeArea(edges: .bottom)
        }
        .navigationBarHidden(true)
        .overlay {
            if viewModel.state.isLoading {
                Color.black.opacity(0.3)
                    .ignoresSafeArea()
                ProgressView()
                    .tint(.white)
                    .scaleEffect(1.5)
            }
        }
        .snackbar(
            isShowing: viewModel.binding(for: \.state.showSnackbar),
            message: viewModel.state.snackbarMessage,
            type: viewModel.state.snackbarType
        )
        .onAppear {
            viewModel.onAppear()
        }
        .dismissKeyboardOnTap()
    }
}
