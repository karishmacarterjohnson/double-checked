//
//  ItemCheck.swift
//  double-checked
//
//  Created by Karishma Johnson on 2/2/22.
//

import Foundation
import SwiftUI

struct Checked: View {
    // https://www.simpleswiftguide.com/how-to-build-linear-progress-bar-in-swiftui/
    @Environment(\.managedObjectContext) private var viewContext

    
    @StateObject var activity: Activity
    @StateObject var item: Item
    //var box: String
    
    var body: some View {
        if item.check {
            HStack {
                Button(action: {toggleCheck(item: item)}) {
                    Label("", systemImage: "checkmark.square")
                }
                .foregroundColor(Theme.lPink)
                Text(item.unwrappedTitle).strikethrough()
                    .foregroundColor(Theme.lOrange)
                
            }
            .swipeActions(edge: .trailing, allowsFullSwipe: true) {
                Button( action: {deleteItem(item:item)}) {
                    Label("", systemImage: "trash")
                }
            }
        } else {
            
            HStack {
                Button(action: {toggleCheck(item: item)}) {
                    Label("", systemImage: "square")
                        .foregroundColor(Theme.lPink)
                }
                Text(item.unwrappedTitle)
                    .foregroundColor(Theme.lOrange)
            }
            .swipeActions(edge: .trailing, allowsFullSwipe: true) {
                Button( action: {deleteItem(item:item)}) {
                    Label("", systemImage: "trash")
                }
            }
        }
    }
    
    private func deleteItem(item: Item) {
        withAnimation {
            var ct: Int = 0
            for i in activity.itemsArray {
                if ct == 0 && item.title == i.title && item.activityTitle == i.activityTitle {
                    viewContext.delete(i)
                    ct += 1
                    PersistenceController.shared.saveContext()
                }
            }
            
        }
    }
    
    private func toggleCheck(item: Item) {
        withAnimation {
            var ct: Int = 0
            let newItem = Item(context: viewContext)
            for i in activity.itemsArray {
                if ct == 0 && item.title == i.title && item.activityTitle == i.activityTitle {
                    newItem.title = item.title
                    newItem.activityTitle = item.activityTitle
                    newItem.check = !item.check
                    activity.addToItems(newItem)
                    viewContext.delete(i)
                    ct += 1
                    PersistenceController.shared.saveContext()
                }
            }
        }
    }
}
