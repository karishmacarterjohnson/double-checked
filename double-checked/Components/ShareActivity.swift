//
//  ShareActivity.swift
//  double-checked
//
//  Created by Karishma Johnson on 2/8/22.
//
import SwiftUI

struct ActivityShared: Codable {
    var title: String?
    var date: Date?
    var items: [[String?]]
    var linkItems: [[String?]]
}

struct ShareActivity: View {
    @StateObject var activity: Activity
    
    var body: some View {
        Text(createShare() ?? "")
        
//        Button(action: createShare){
//            Label("", systemImage: "square.and.arrow.up")
//        }
    }
    private func createShare() -> String? {
        // sharing reduced list data
        var shareItems = [[String]]()
        for i in activity.itemsArray {
            shareItems.append([i.unwrappedTitle, i.unwrappedActivityTitle])
        }
        var shareLinkItems = [[String]]()
        for l in activity.linkItemsArray {
            shareLinkItems.append([l.unwrappedTitle, l.unwrappedLink])
        }
        
        // create it
        let activityToShare = ActivityShared(title: activity.unwrappedTitle, date: activity.date, items:shareItems, linkItems: shareLinkItems)
        
        let jsonData = try! JSONEncoder().encode(activityToShare)
        let json = String(data: jsonData, encoding: String.Encoding.utf8)

        return json?.data(using: .utf8)?.base64EncodedString()
    }
}


// https://www.twilio.com/blog/working-with-json-in-swift
