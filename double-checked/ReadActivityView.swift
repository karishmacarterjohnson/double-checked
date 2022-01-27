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
    @State var progressValue: Float = 0.4

    //////////////////////////////////////////
    
    let activitieslist: [String] = ["act1", "activityB", "actC"]
    
    //////////////////////////////////////////
    
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Activity.title, ascending: true)], // https://www.donnywals.com/fetching-objects-from-core-data-in-a-swiftui-project/
        animation: .default)
    private var activities: FetchedResults<Activity>
    
    /////////////////////////////////////////////
    ///
    ///
    @FetchRequest(sortDescriptors: [NSSortDescriptor(keyPath: \Activity.title, ascending: true)], predicate: NSPredicate(format: "title == %@", "OneBag"))
    var fetchedActivities: FetchedResults<Activity>
    
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
            ProgressBar(value: $progressValue).frame(height:20).padding()

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
            
            //////////////////////////////////////////
            
            Text(selectedActivity)
            NavigationView {
                Form {
                    Section {
                        HStack {
                            Picker("Activity", selection: $selectedActivity) {
                                ForEach(activities, id:\.self) { act in
                                    Text(act.unwrappedTitle)
                                }
                            }.pickerStyle(MenuPickerStyle())
                            
                            Button(action: importActivity) {
                                Label("", systemImage:"plus")
                            }
                        }
                    }
                    
                }
            }
            //////////////////////////////////////////
        }
    }
    
    private func importActivity() {
            let fetchedActivity = fetchedActivities[0]
            for item in fetchedActivity.itemsArray {
                let newItem = Item(context: viewContext)
                newItem.title = item.unwrappedTitle
                newItem.activityTitle = fetchedActivity.unwrappedTitle
                activity.addToItems(newItem)
                PersistenceController.shared.saveContext()
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


// PARTY IN THE GRAVEYARD


//    private func toggleCheck(at offsets: IndexSet) {
//        withAnimation {
//            for index in offsets {
//                let item = activity.itemsArray[index]
//                item.check = !item.check
//                PersistenceController.shared.saveContext()
//            }
//        }
//    }


//////////////////////////////////////////
///
//            Text(selectedActivity)
//            NavigationView {
//                Form {
//                    Section {
//                        HStack {
//                            Picker("Activity", selection: $selectedActivity) {
//                                ForEach(activitieslist, id:\.self) {
//                                    Text($0)
//                                }
//                            }.pickerStyle(MenuPickerStyle())
//
//                            Button(action: addActivity) {
//                                Label("", systemImage:"plus")
//                            }
//                        }
//                    }
//
//                }
//            }
//
