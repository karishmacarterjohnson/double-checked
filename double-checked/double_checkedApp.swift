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
    @State public var previewActivity: Bool = false
//    @State public var importedActivity: Activity
    @State public var importedActivity: String = ""
    var body: some Scene {
        WindowGroup {
            if previewActivity {
                ImportActivityView(url: importedActivity)
                //"doublechecked://eyJ0aXRsZSI6IkJhZyIsIml0ZW1zIjpbWyJTbmFjayIsIkJhZyJdXSwibGlua0l0ZW1zIjpbXX0="
                    .environment(\.managedObjectContext, persistenceController.viewContext)
            } else {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.viewContext)
                .onOpenURL(perform: {url in
                    previewActivity = true
                    importedActivity = url.absoluteString
                })
            }
        }
    }
}

final class AppDelegate: NSObject, UIApplicationDelegate {
    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
            return true
    }
    // Other delegate methods here...
}


//
//    .onOpenURL(perform: {url in
//        let data = Data(base64Encoded: url.absoluteString)
//        let b64Decoded = String(data: data!, encoding: .utf8) // string of json
//        let jsonData = (b64Decoded?.data(using:.utf8))! // string
//        let attempt = try! JSONDecoder().decode(ActivityShared.self, from: jsonData)  // ActivityShared struct
////        return "nice, v"
//        importedActivity = Activity(context: viewContext)
//        importedActivity.title = attempt.title
//        importedActivity.date = attempt.date
//        previewActivity = true
//        // use attempt to create an activity,
//
//    })
