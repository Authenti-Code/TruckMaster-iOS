internal import SwiftUI

@available(iOS 16.0, *)
struct EditProfileView: View {

    @StateObject var viewModel: EditProfileViewModel
    @State private var showImageOptions = false
    @State private var showCamera = false
    @State private var showGallery = false

    var body: some View {
        VStack(spacing: 0) {

            // MARK: - Header
            ZStack {

                ReusableText(
                    title: "edit_profile_title",
                    fontSize: 16,
                    fontName: "Livvic-SemiBold",
                    fontColor: AppColors.textBlack1
                )

                HStack {

                    Button {
                        viewModel.backTapped()
                    } label: {
                        Image(ImageConstants.backImage)
                    }

                    Spacer()

                }
            }
            .padding(.horizontal, 20)
            .padding(.vertical, 16)
            // MARK: - Content


            VStack(spacing: 0) {

                // MARK: - Profile Image
                ZStack(alignment: .bottom) {
                    // Profile Image
                    if let selectedImage = viewModel.state.selectedImage {
                        Image(uiImage: selectedImage)
                            .resizable()
                            .scaledToFill()
                            .frame(width: 110, height: 110)
                            .clipShape(Circle())
                    } else if viewModel.state.profileImg.isEmpty {
                        Image(ImageConstants.user)
                            .resizable()
                            .scaledToFill()
                            .frame(width: 110, height: 110)
                            .clipShape(Circle())
                    } else {
                        AsyncImage(url: URL(string: viewModel.state.profileImg)) { image in
                            image
                                .resizable()
                                .scaledToFill()
                        } placeholder: {
                            Circle()
                                .fill(AppColors.grey2)
                                .frame(width: 110, height: 110)
                                .shimmer()
                        }
                        .frame(width: 110, height: 110)
                        .clipShape(Circle())
                    }

                    // Bottom Overlay
                    Button {
                        showImageOptions = true
                    } label: {
                        ZStack {
                            Rectangle()
                                .fill(.white.opacity(0.85))
                                .frame(height: 28)

                            Image(ImageConstants.edit)
                                .font(.system(size: 14, weight: .medium))
                                .foregroundColor(AppColors.primary)
                        }
                    }
                }
                .frame(width: 110, height: 110)
                .clipShape(Circle())
                .padding(.top, 20)
                .padding(.bottom, 30)

                // MARK: - Form Fields
                VStack(alignment: .leading, spacing: 16) {

                    // Name
                    VStack(alignment: .leading, spacing: 4) {
                        NameInputField(
                            label: "name_required",
                            hint: "enter_name",
                            isRequired: true,
                            text: viewModel.nameBinding
                        )
                    }

                    // Email
                    LabeledInputField(
                        label: "email_address_required",
                        hint: "enter_email",
                        isRequired: true,
                        text: viewModel.emailBinding
                    )

                    // Contact
                    VStack(alignment: .leading, spacing: 4) {
                        LabeledInputField(
                            label: "contact_required",
                            hint: "enter_contact",
                            isRequired: true,
                            keyboardType: .numberPad,
                            text: viewModel.contactBinding
                        )
                    }
                }
                .padding(.horizontal, 20)

                Spacer()

                PrimaryButton(title: "update_title") {
                    Task {
                        viewModel.updateTapped()
                    }
                }
                .padding(.horizontal, 20)
                .padding(.bottom, 20)
            }
        }

        .background(Color.white)
        .navigationBarHidden(true)
        .onAppear {
            viewModel.onAppear()
        }
        .snackbar(
            isShowing: viewModel.binding(for: \.state.showSnackbar),
            message: viewModel.state.snackbarMessage,
            type: viewModel.state.snackbarType
        )
        .overlay {
            if viewModel.state.isLoading {
                Color.black.opacity(0.3)
                    .ignoresSafeArea()

                ProgressView()
                    .tint(.white)
                    .scaleEffect(1.5)
            }
        }
        .confirmationDialog(
            "Select Image Source",
            isPresented: $showImageOptions,
            titleVisibility: .visible
        ) {

            Button("Choose From Gallery") {
                showGallery = true
            }

            if UIImagePickerController.isSourceTypeAvailable(.camera) {
                Button("Take Photo") {
                    showCamera = true
                }
            }

            Button("Cancel", role: .cancel) { }
        }

        .sheet(isPresented: $showGallery) {
            GalleryPicker { image in
                viewModel.state.selectedImage = image
                showGallery = false
            }
        }

        .fullScreenCover(isPresented: $showCamera) {
            CameraView { image in
                viewModel.state.selectedImage = image
                showCamera = false
            }
            .ignoresSafeArea()
        }
        .dismissKeyboardOnTap()
    }
}

#Preview {
    if #available(iOS 16.0, *) {
        let repo = EditProfileRepositoryImpl(apiClient: APIClient())
        let useCase = EditProfileUseCase(repository: repo)

        EditProfileView(
            viewModel: EditProfileViewModel(
                editProfileUseCase: useCase,
                router: AppRouter()
            )
        )
    }
}
