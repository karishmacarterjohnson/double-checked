//
//  double_checkedApp.swift
//  double-checked
//
//  Created by Karishma Johnson on 1/24/22.
//

import SwiftUI

@main
struct double_checkedApp: App {
    @Environment(\.managedObjectContext) private var viewContext
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    let persistenceController = PersistenceController.shared
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.viewContext)
//                .onOpenURL(perform: <#T##(URL) -> ()#>)
        }
    }
    
}

final class AppDelegate: NSObject, UIApplicationDelegate {
    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
            // do something
            return true
    }

    // Other delegate methods here...
}
