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
    
    @State private var selectedActivity = ""
    let activitieslist: [String] = ["act1", "activityB", "actC"]
    
    var body: some View {
        
        VStack {
            NavigationLink(destination: UpdateActivityView(activity: activity)) {
                Text(activity.title ?? "") // !! add > to indicate navigation
            }
            HStack {
                TextField("Item title", text: $itemTitle)
                    .textFieldStyle(.roundedBorder)
                Button(action: addItem) {
                    Label("", systemImage: "plus")
                }
            }.padding()
            
            // !! due date
            // progress bar
            
            List {
                ForEach(groupItems(), id:\.self.0){ activityName, items in
                    Section(header: Text(activityName ?? "")){
                        ForEach(items) { item in
                            if item.check {
                                Text(item.unwrappedTitle).strikethrough()
                            } else {
                                Text(item.unwrappedTitle)
                            }
                            
                        }.onDelete(perform: deleteItem)
                    }
                    
                }
            }
            
            // !! drop-down to copy from a specific activity and all its items
            // copy items to current activity with newitem.activityTitle = activitySelected.title
            // newitem.title = item.title
            
            Text(selectedActivity)
            NavigationView {
                Form {
                    Section {
                        HStack {
                            Picker("Activity", selection: $selectedActivity) {
                                ForEach(activitieslist, id:\.self) {
                                    Text($0)
                                }
                            }.pickerStyle(MenuPickerStyle())
                            
                            Button(action: addActivity) {
                                Label("", systemImage:"plus")
                            }
                        }
                    }
                    
                }
            }
        }
    }
    
    private func groupItems() -> [(String?,[Item])] {
        let items: Dictionary = Dictionary(grouping: activity.itemsArray, by: {$0.activityTitle})
        var listItems = [(String?,[Item])]()
        let strs = items.keys.compactMap {
            $0!
        }
        for key in strs.sorted() {
            listItems.append((key, items[key]!))
        }
        return listItems
        
    }
    
    private func addActivity() {
        //
    }
    
//    private func toggleCheck(at offsets: IndexSet) {
//        withAnimation {
//            for index in offsets {
//                let item = activity.itemsArray[index]
//                item.check = !item.check
//                PersistenceController.shared.saveContext()
//            }
//        }
//    }
    
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
    
}
