//
//  ReadActivityView.swift
//  double-checked
//
//  Created by Karishma Johnson on 1/24/22.
//

import SwiftUI

struct ReadActivityView: View {
    @Environment(\.managedObjectContext) private var viewContext
    
    @StateObject var activity: Activity
    @State private var itemTitle: String = ""
    
    var body: some View {
        VStack {
            NavigationLink(destination: UpdateActivityView(activity: activity)) {
                Text(activity.title ?? "") // !! add > to indicate navigation
            }
            
            // !! due date
            // progress bar
            
            
            List { // group by unwrappedActivityTitle
                ForEach(activity.itemsArray) { item in
                    HStack{
                        Text(item.unwrappedActivityTitle)
                        Text(":")
                        Text(item.unwrappedTitle)
                        
                    }
                }.onDelete(perform: deleteItem)
            }
            
            //            List {
            //                ForEach(Dictionary(grouping: activity.itemsArray, by: {$0.activityTitle})){ activityName, items in
            //                    Section(header: Text(activityName ?? "")){
            //                        ForEach(items) { item in
            //                            Text(item.unwrappedTitle)
            //                        }.onDelete(perform: deleteItem)
            //                    }
            //
            //                }
            //            }
            
            // !! drop-down to copy from a specific activity and all its items
            // copy items to current activity with newitem.activityTitle = activitySelected.title
            // newitem.title = item.title
            HStack {
                TextField("Item title", text: $itemTitle)
                    .textFieldStyle(.roundedBorder)
                Button(action: addItem) {
                    Label("", systemImage: "plus")
                }
            }.padding()
        }
    }
    
    
    private func addItem() {
        withAnimation {
            let newItem = Item(context: viewContext)
            newItem.title = itemTitle
            newItem.activityTitle = activity.unwrappedTitle
            
            activity.addToItems(newItem)
            PersistenceController.shared.saveContext()
        }
    }
    private func deleteItem(at offsets: IndexSet) {
        withAnimation {
            for index in offsets {
                let item = activity.itemsArray[index]
                viewContext.delete(item)
                PersistenceController.shared.saveContext()
            }
        }
    }
}




struct ReadActivityView_Previews: PreviewProvider {
    static var previews: some View {
        let viewContext = PersistenceController.preview.container.viewContext
        let newActivity = Activity(context: viewContext)
        newActivity.title = "visit gf"
        newActivity.date = Date()
        
        let item1 = Item(context: viewContext)
        item1.title = "1 item"
        item1.activityTitle = "group"
        
        newActivity.addToItems(item1)
        
        return ReadActivityView(activity: newActivity)
            .environment(\.managedObjectContext,
                          PersistenceController.preview.container.viewContext)
    }
}

