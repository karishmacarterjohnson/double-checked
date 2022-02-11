//
//  ShareActivity.swift
//  double-checked
//
//  Created by Karishma Johnson on 2/8/22.
//
import SwiftUI

struct ActivityShared: Codable {
    var title: String?
    var items: [[String?]]
    var linkItems: [[String?]]
}

struct ShareActivity: View {
    @StateObject var activity: Activity
    @State private var linkCopied: Bool = false
    
    var body: some View {
        Button(action: {UIPasteboard.general.string = createShare()}) {
            Label("", systemImage: "square.and.arrow.up")
        }.alert("Link Copied", isPresented: $linkCopied) {
            Button("thank you", role:.cancel, action: {linkCopied = false})
        }
        
    }
    private func createShare() -> String? {
        var shareItems = [[String]]()
        for i in activity.itemsArray {
            shareItems.append([i.unwrappedTitle, i.unwrappedActivityTitle])
        }
        var shareLinkItems = [[String]]()
        for l in activity.linkItemsArray {
            shareLinkItems.append([l.unwrappedTitle, l.unwrappedLink])
        }
        
        let activityToShare = ActivityShared(title: activity.unwrappedTitle, items:shareItems, linkItems: shareLinkItems)
        
        let jsonData = try! JSONEncoder().encode(activityToShare)
        let json = String(data: jsonData, encoding: String.Encoding.utf8)
        
        let jsonString = json?.data(using: .utf8)?.base64EncodedString() ?? ""
        
        let activityURL = "doublechecked://" + jsonString
        linkCopied = true
        return activityURL
    }
}


// https://www.twilio.com/blog/working-with-json-in-swift
// return jsonString

//        https://www.advancedswift.com/a-guide-to-urls-in-swift/#create-url-string
//        var activityURL = URLComponents()
//        activityURL.scheme = "doublechecked"
//        activityURL.path = "//" + jsonString
