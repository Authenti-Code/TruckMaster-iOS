 //
//  TruckMasterApp.swift
//  TruckMaster
//
//  Created by AuthentiCode on 03/06/26.
//

internal import SwiftUI
internal import GoogleMaps



@available(iOS 16.0, *)
@main
struct TruckMasterApp: App {

    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    private let container = AppContainer()
    @StateObject private var languageManager = LanguageManager.shared

    var body: some Scene {
        WindowGroup {
            container.makeRootView()
                .environmentObject(languageManager)
                .environment(
                                  \.locale,
                                  Locale(identifier: languageManager.language)
                              )
                                .environment(\.layoutDirection, languageManager.layoutDirection)
                                .preferredColorScheme(.light)
        }
    }
}

class AppDelegate: NSObject, UIApplicationDelegate {
    func application(_ application: UIApplication,
                     supportedInterfaceOrientationsFor window: UIWindow?) -> UIInterfaceOrientationMask {
        
        return .portrait
    }
    

    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        GMSServices.provideAPIKey("YOUR_GOOGLE_MAPS_API_KEY")
        return true
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
        GlobalShipmentSocket.disconnect()
    }
    
}
