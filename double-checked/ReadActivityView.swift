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
    
//    @FetchRequest(
//        sortDescriptors: [
//            NSSortDescriptor(keyPath: \Item.title, ascending: true),
//        ],
//        predicate: NSPredicate(format: "unwrappedActivityTitle == %@", activity.unwrappedTitle))
//                  var items: FetchedResults<Item>
    
    var body: some View {
        VStack {
            NavigationLink(destination: UpdateActivityView(activity: activity)) {
                Text(activity.title ?? "") // !! add > to indicate navigation
            }
            
            // !! due date
            // progress bar
            
            
//            List { // group by unwrappedActivityTitle
//                ForEach(activity.itemsArray) { item in
//                    HStack{
////                        Button(action: toggleCheck) {
////                            Label("", systemImage: "plus") // edit systemImage!!
////                        }
//                        Text(item.unwrappedActivityTitle)
//                        Text(":")
//                        Text(item.unwrappedTitle)
//                        Text(item.unwrappedCheck)
//
//                    }
//                }.onDelete(perform: deleteItem)
//            }
            
            
            
            
//            List {
//                ForEach(groupItems, id:\.self) {group in
//                    Section(header: Text(group.someObject)) {
//                        ForEach(group.valueObjects) { item in
//                            Text(item.unwrappedTitle)
//
//                        }
//                    }
//                }
//            }
            
                        List {
                            ForEach(groupItems(), id:\.self.0){ activityName, items in
                                Section(header: Text(activityName ?? "")){
                                    ForEach(items) { item in
                                        Text(item.unwrappedTitle)
                                    }.onDelete(perform: deleteItem)
                                }
            
                            }
                        }
            
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
    
    private func groupItems() -> [(String?,[Item])] {
        let items: Dictionary = Dictionary(grouping: activity.itemsArray, by: {$0.activityTitle})
        //let listItems = [ListItem]()
        var listItems = [(String?,[Item])]()
        var strs = items.keys.compactMap {
            $0!
        }
        for key in strs.sorted() {
            //listItems.append(ListItem(someObject: key, valueObjects: items[key]!))
            listItems.append((key, items[key]!))
        }
        return listItems
        
    }
    
    private func toggleCheck(at offsets: IndexSet) {
        withAnimation {
            
            for index in offsets {
                let item = activity.itemsArray[index]
                item.check = !item.check

            }
            PersistenceController.shared.saveContext()
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
    
//    private func groupItems() {
//
//        struct ListItem {
//            let someObject: String
//            let valueObjects: [Item]
//        }
//
//        let items: Dictionary = Dictionary(grouping: activity.itemsArray, by: {$0.activityTitle})
//        let listItems = [ListItem]()
//
//        for key in items.keys.sorted() {
//            listItems.append(ListItem(someObject: key, valueObjects: items[key]!))
//        }
//
//        return listItems
//
//    }
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

