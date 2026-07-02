//
//  AlertHelper.swift
//  TruckMaster
//
//  Created by AuthentiCode on 03/06/26.
//
internal import SwiftUI

struct AlertHelper {

    static func errorMessage(
        _ message: String
    ) -> Alert {

        Alert(
            title: Text("Error"),
            message: Text(message),
            dismissButton: .default(Text("OK"))
        )
    }
}

//Usage
//    .alert(
//        isPresented: $showAlert
//    ) {
//        AlertHelper.errorMessage(
//            "Something went wrong"
//        )
//    }
