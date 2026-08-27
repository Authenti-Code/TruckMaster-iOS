//
//  SupportTicketSheet.swift
//  TruckMaster
//
//  Created by AuthentiCode on 23/06/26.
//

internal import SwiftUI

@available(iOS 16.0, *)
struct RaiseTicketSheet: View {

    @ObservedObject var viewModel: RaiseTicketViewModel
    @Environment(\.dismiss) private var dismiss
    var body: some View {
        
        //heading
        VStack(alignment: .leading) {
            
            HStack(alignment: .center){
                Spacer()
                ReusableText(title: "raise_ticket_title1", fontSize: 16, fontName: "Livvic-SemiBold", fontColor: AppColors.textBlack1)
                Spacer()
            }
            
            //sizes options
            ScrollView {
                VStack(spacing: 8) {
                    
                    //title
                    LabeledInputField(
                        label: "title_title",
                        hint: "enter_title",
                        isRequired: true,
                        keyboardType: .default,
                        isMultiline: true,
                        lineLimit: 1...2,
                        text: viewModel.titleBinding
                    )
                    
                    //Description
                    LabeledInputField(
                        label: "description_title",
                        hint: "enter_description",
                        isRequired: true,
                        keyboardType: .default,
                        isMultiline: true,
                        lineLimit: 3...3,
                        text: viewModel.descriptionBinding
                    )
                    
                    
                }
            }
            .scrollIndicators(.hidden)

            //save button
            PrimaryButton(title: "submit_title") {
                if viewModel.submitTapped() {
                    dismiss()
                }
            }
            .padding(.bottom, 10)
        }
        .padding(.horizontal, 20)
        .padding(.top, 20)
        .frame(maxWidth: .infinity, alignment: .leading)
        .snackbar(
            isShowing: viewModel.binding(for: \.state.showSnackbar),
            message: viewModel.state.snackbarMessage,
            type: viewModel.state.snackbarType
        )
        .dismissKeyboardOnTap()
    }
}
