//
//  NewItemField.swift
//  double-checked
//
//  Created by Karishma Johnson on 2/2/22.
//

import Foundation
import SwiftUI

struct NewItemField: View {
    @Environment(\.managedObjectContext) private var viewContext
    
    @StateObject var activity: Activity
    var activityName: String
    @State var itemTitle: String = ""
    
    var body: some View {
        HStack {
            TextField("Add " + activityName + " Item", text: $itemTitle)
                .textFieldStyle(.roundedBorder)
            Spacer()
            Button(action: addItem) {
                Label("", systemImage: "plus")
            }
        }.padding(.horizontal)
    }
    
    private func addItem() {
        withAnimation {
            if itemTitle != "" {
                let newItem = Item(context: viewContext)
                newItem.title = itemTitle
                newItem.activityTitle = activityName
                
                activity.addToItems(newItem)
                itemTitle = ""
                PersistenceController.shared.saveContext()
            }
        }
    }
}
