//
//  double_checkedApp.swift
//  double-checked
//
//  Created by Karishma Johnson on 1/24/22.
//

import SwiftUI

struct previewActivity {
    static var status = false
}

@main
struct double_checkedApp: App {
    @Environment(\.managedObjectContext) private var viewContext
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    let persistenceController = PersistenceController.shared
    
    @State public var prevActivity: Bool = previewActivity.status
    @State public var importedActivity: String = ""
    var body: some Scene {
        WindowGroup {
            if prevActivity {
                ImportActivityView(activity: importActivityAsObject(link: importedActivity))
                //"doublechecked://eyJ0aXRsZSI6IkJhZyIsIml0ZW1zIjpbWyJTbmFjayIsIkJhZyJdXSwibGlua0l0ZW1zIjpbXX0="
                    .environment(\.managedObjectContext, persistenceController.viewContext)
            } else {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.viewContext)
                .onOpenURL(perform: {url in
                    previewActivity.status = true
                    prevActivity = true
                    importedActivity = url.absoluteString
                })
            }
        }
    }
    private func importActivityAsObject(link: String) -> Activity {
        let b64 = String(link.dropFirst("doublechecked://".count))
        let data = Data(base64Encoded: b64)
        let b64Decoded = String(data: data!, encoding: .utf8) // string of json
        let jsonData = (b64Decoded?.data(using:.utf8))! // string
        let attempt = try! JSONDecoder().decode(ActivityShared.self, from: jsonData)  // ActivityShared struct
//        return "nice, v"
        let importedActivity = Activity(context: viewContext)
        importedActivity.title = attempt.title
        importedActivity.date = attempt.date
        for i in attempt.items {
            let itemCopy = Item(context: viewContext)
            itemCopy.title = i[0]
            itemCopy.activityTitle = i[1]
            importedActivity.addToItems(itemCopy)
        }
        for l in attempt.linkItems {
            let linkItemCopy = LinkItem(context: viewContext)
            linkItemCopy.title = l[0]
            linkItemCopy.link = l[1]
            importedActivity.addToLinkitems(linkItemCopy)
        }
        return importedActivity

    }
}

final class AppDelegate: NSObject, UIApplicationDelegate {
    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
//            previewActivity.status = true
            return true
    }
    // Other delegate methods here...
}
