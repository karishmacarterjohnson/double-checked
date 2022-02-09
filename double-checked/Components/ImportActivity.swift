//
//  ImportActivity.swift
//  double-checked
//
//  Created by Karishma Johnson on 2/8/22.
//

import SwiftUI

struct ImportActivity: View {
    //@StateObject var activity: Activity
    
    var body: some View {

        Text(importShare(url: "doublechecked://eyJ0aXRsZSI6IkJhZyIsIml0ZW1zIjpbWyJTbmFjayIsIkJhZyJdXSwibGlua0l0ZW1zIjpbXX0=") ?? "")
//        Button(action: {}){
//            Label("", systemImage: "square.and.arrow.down")
//        }
    }
    

    private func importShare(url: String) -> String? {
        let b64 = String(url.dropFirst("doublechecked://".count))
        guard let data = Data(base64Encoded: b64) else { return nil }
        let b64Decoded = String(data: data, encoding: .utf8) // string of json
        let jsonData = (b64Decoded?.data(using:.utf8))! // string
        let attempt = try! JSONDecoder().decode(ActivityShared.self, from: jsonData)  // ActivityShared struct
        return "nice, v"
        // use attempt to create an activity,
        // ReadActivityView(activity: thisnewactivity)
        // save -> persistence.controller saves
        // close -> go back to home without save
    }
}



/////////////// PARTY IN THE GRAVEYARD
//        Text(getPathFromUrl(url:"doublechecked://things"))



//    private func getPathFromUrl(url: String) -> String {
//        return String(url.dropFirst("doublechecked://".count))
//    }



//private func importActivity() -> Activity {
//    withAnimation {
//        var ct: Int = 0
//        let activityCopy = Activity(context: viewContext)
//        activityCopy.title = activity.title
//        PersistenceController.shared.saveContext()
//        for a in activities {
//            if ct == 0 && a.title == activity.title && a.date == activity.date && a.items == activity.items {
//                for i in a.itemsArray {
//                    let itemCopy = Item(context: viewContext)
//                    itemCopy.title = i.title
//                    itemCopy.activityTitle = i.activityTitle
//                    activityCopy.addToItems(itemCopy)
//                    PersistenceController.shared.saveContext()
//                }
//                for l in a.linkItemsArray {
//                    let linkItemCopy = LinkItem(context: viewContext)
//                    linkItemCopy.title = l.title
//                    linkItemCopy.link = l.link
//                    activityCopy.addToLinkitems(linkItemCopy)
//                    PersistenceController.shared.saveContext()
//                }
//
//                ct += 1
//
//            }
//        }
//    }
//}
