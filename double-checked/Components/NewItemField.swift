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
            HStack {
                TextField("New " + activityName + " Item", text: $itemTitle)
                    .modifier(TextFieldM())
                Spacer()
                Button(action: {itemTitle = ""}) {
                    Label("", systemImage: "delete.left")
                }
                    .modifier(ClearButtonM())
                    .foregroundColor(itemTitle.isEmpty ? Theme.emptyButtonColor : Theme.filledButtonColor)
            }.modifier(InputStackM())
            
            Button(action: addItem) {
                Label("", systemImage: "plus")
            }.modifier(AddButtonM())
                .foregroundColor(itemTitle.isEmpty ? Theme.emptyButtonColor : Theme.filledButtonColor)
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

