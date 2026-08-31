//
//  HelpSupportState.swift
//  TruckMaster
//
//  Created by AuthentiCode on 17/06/26.
//


struct HelpSupportState {
    var messages: [ChatMessageModel] = []
    var inputText: String = ""
    var isLoading: Bool = false
    var isLoadingMore: Bool = false
    var currentPage: Int = 1
    var hasMore: Bool = true
    var showSnackbar: Bool = false
    var snackbarMessage: String = ""
    var snackbarType: SnackbarType = .error
}
