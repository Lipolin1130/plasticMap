//
//  plasticMapApp.swift
//  plasticMap
//
//  Created by iOS Club on 2021/7/16.
//

import SwiftUI
import Firebase

@main
struct plasticMapApp: App {
    
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    
    var body: some Scene {
        
        WindowGroup {
            ContentView()
        }
    }
}

class AppDelegate: UIResponder, UIApplicationDelegate {

  func application(_ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions:
        [UIApplication.LaunchOptionsKey: Any]? = nil) -> Bool {
    
    FirebaseApp.configure()
    
    return true
  }
}
//
//service cloud.firestore {
//  match /databases/{database}/documents {
//    // Allow the user to access documents in the "cities" collection
//    // only if they are authenticated.
//    match /cities/{city} {
//      allow read, write: if request.auth != null;
//    }
//  }
//}
