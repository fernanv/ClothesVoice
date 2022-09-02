//
//  ClothesVoiceApp.swift
//  ClothesVoice
//
//  Created by Fernando Villalba  on 8/3/21.
//

import SwiftUI
import Firebase

@main
struct ClothesVoiceApp: App {
    @UIApplicationDelegateAdaptor(Delegar.self) var delegar
    var body: some Scene {
        WindowGroup {
            VistaInicio()
        }
    }
}

class Delegar: NSObject, UIApplicationDelegate{
    func application(_ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions:
        [UIApplication.LaunchOptionsKey: Any]? = nil) -> Bool {
           FirebaseApp.configure()
            return true
    }
}
