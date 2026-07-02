//
//  SnackbarModifier.swift
//  TruckMaster
//
//  Created by AuthentiCode on 05/06/26.
//

//
//  SnackbarModifier.swift
//  TruckMaster
//

internal import SwiftUI

struct SnackbarModifier: ViewModifier {

    @Binding var isShowing: Bool
    let message: String
    var type: SnackbarType = .error
    var duration: Double = 3.0

    func body(content: Content) -> some View {
        ZStack(alignment: .bottom) {
            content

            if isShowing {
                SnackbarView(message: message, type: type)
                    .transition(.move(edge: .bottom).combined(with: .opacity))
                    .onAppear {
                        DispatchQueue.main.asyncAfter(deadline: .now() + duration) {
                            withAnimation(.easeInOut) {
                                isShowing = false
                            }
                        }
                    }
                    .padding(.bottom, 30)
            }
        }
        .animation(.easeInOut(duration: 0.3), value: isShowing)
    }
}

extension View {
    func snackbar(
        isShowing: Binding<Bool>,
        message: String,
        type: SnackbarType = .error,
        duration: Double = 3.0
    ) -> some View {
        modifier(SnackbarModifier(
            isShowing: isShowing,
            message: message,
            type: type,
            duration: duration
        ))
    }
}


//Usage
//// error
//.snackbar(isShowing: $viewModel.showSnackbar, message: viewModel.snackbarMessage, type: .error)
//
//// success
//.snackbar(isShowing: $viewModel.showSnackbar, message: viewModel.snackbarMessage, type: .success)
//
//// info
//.snackbar(isShowing: $viewModel.showSnackbar, message: viewModel.snackbarMessage, type: .info)
