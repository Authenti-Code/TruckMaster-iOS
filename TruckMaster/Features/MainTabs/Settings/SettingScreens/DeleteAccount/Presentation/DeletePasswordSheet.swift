//
//  DeletePasswordSheet.swift
//  TruckMaster
//
//  Created by AuthentiCode on 18/06/26.
//

internal import SwiftUI

@available(iOS 16.0, *)
struct DeletePasswordSheet: View {

    @ObservedObject var viewModel: DeleteAccountViewModel

    var body: some View {
        VStack(alignment: .leading) {

            ReusableText(
                title: "delete_account_password_subheading",
                fontSize: 14,
                fontName: "Livvic-Regular",
                fontColor: AppColors.grey1
            )
            .padding(.bottom, 10)

            LabeledInputField(
                label: "password_required",
                hint: "enter_password",
                isRequired: true,
                isSecure: true,
                text: viewModel.binding(for: \.state.password)
            )
            .padding(.bottom, 10)
            
            PrimaryDanger(
                title: "delete_account_title",
                isEnabled: viewModel.state.isDeleteEnabled
            ) {
                Task{
                    await viewModel.deleteAccountTapped()
                }
            }
            .padding(.bottom, 10)
        }
        .padding(.horizontal, 20)
        .padding(.top, 20)
        .frame(maxWidth: .infinity, alignment: .leading)
       
    }
}
