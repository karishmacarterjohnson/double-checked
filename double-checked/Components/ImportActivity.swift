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
        Text(importShare(b64: "eyJ0aXRsZSI6IkJhZyIsIml0ZW1zIjpbWyJTbmFjayIsIkJhZyJdXSwibGlua0l0ZW1zIjpbXX0=") ?? "")
//        Button(action: {}){
//            Label("", systemImage: "square.and.arrow.down")
//        }
    }

    private func importShare(b64: String) -> String? {
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
