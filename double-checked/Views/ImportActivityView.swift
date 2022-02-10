//
//  ImportActivityView.swift
//  double-checked
//
//  Created by Karishma Johnson on 2/9/22.
//

import SwiftUI

struct ImportActivityView: View {
    @Environment(\.managedObjectContext) private var viewContext
    var activity: Activity
    
    var body: some View {
        NavigationView {
            VStack {
                ActivityLinks(activity: activity)
                
                List {
                    ForEach(groupItems(), id:\.self.0){ activityName, items in
                        Section(header: Text(activityName ?? "")){
                            ForEach(items) { item in
                                Checked(activity: activity, item: item)
                            }
                        }
                    }
                }
                Button(action: saveActivity) {
                    Label("Save", systemImage: "")
                }
                NavigationLink(destination: ContentView()) {
                    Text("Close")
                }//.navigationBarBackButtonHidden(true)
            }.navigationBarTitle(activity.unwrappedTitle)
                .navigationBarBackButtonHidden(true)
        }
    }
    
    //    private func cancelSaveActivity() {
    //        // go back to main view??
    //        previewActivity.status = false
    //    }
    
    private func saveActivity() {
        // actually create it here
        
        PersistenceController.shared.saveContext()
    }
    
    private func groupItems() -> [(String?,[Item])] {
        //        let activity = activity
        var items: Dictionary = Dictionary(grouping: activity.itemsArray, by: {$0.activityTitle})
        let current: [Item]? = items[activity.unwrappedTitle]
        items.removeValue(forKey: activity.unwrappedTitle)
        var listItems = [(String?,[Item])]()
        let strs = items.keys.compactMap {
            $0
        }
        listItems.append((activity.unwrappedTitle, current!))
        for key in strs.sorted() {
            listItems.append((key, items[key]!))
        }
        return listItems
        
    }
}
