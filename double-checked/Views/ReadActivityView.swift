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
    @State var activityArray: FetchedResults<Activity>

    @State private var itemTitle: String = ""
    @State private var selectedActivity = ""
    
    @FetchRequest(sortDescriptors: [NSSortDescriptor(keyPath: \Activity.title, ascending: true)], predicate: NSPredicate(format: "title == %@", "Thursday Vibes"))
    var fetchedActivities: FetchedResults<Activity>
    
    /////////////////////////////////////////////
    
    var body: some View {
        ProgressBar(value: progressValue(activity: activity)).frame(height:10).padding(.leading).padding(.trailing)
        
        VStack {
//        NavigationView {
            Form {
                Section {
                    HStack {
                        Picker("Activity", selection: $selectedActivity) {
                            ForEach(getActivityTitles(activitiesList: activityArray, activityTitle: activity.unwrappedTitle), id:\.self) { act in
                                Text(act)
                            }
                        }.pickerStyle(MenuPickerStyle())
                        
                        Button(action: importActivity) {
                            Label("", systemImage:"plus")
                        }
                    }
                    HStack {
                        TextField("Item title", text: $itemTitle)
                            .textFieldStyle(.roundedBorder)
                        Button(action: addItem) {
                            Label("", systemImage: "plus")
                        }
                    }
                }
                
            }
            
//        }
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
            }//.listStyle(PlainListStyle())
            

        }.navigationBarTitle(activity.unwrappedTitle) .navigationBarItems(trailing: NavigationLink(destination: UpdateActivityView(activity: activity)) {Text(Image(systemName: "chevron.forward"))
        })
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
    
    private func getActivityTitles(activitiesList:FetchedResults<Activity>, activityTitle: String) -> [String] {
        var activityTitles = [String]()
        
        for act in activitiesList {
            if act.unwrappedTitle != activityTitle {
                activityTitles.append(act.unwrappedTitle)
            }
        }
        return activityTitles
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
            itemTitle = ""
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
    
    private func progressValue(activity: Activity) -> Float {
        let total: Int = activity.itemsArray.count
        var checkedCount: Int = 0
        for x in activity.itemsArray {
            if x.check {
                checkedCount += 1
            }
        }
        return Float(Double(checkedCount) / Double(total))
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
               
            @FetchRequest(
                sortDescriptors: [NSSortDescriptor(keyPath: \Activity.date, ascending: true)], // https://www.donnywals.com/fetching-objects-from-core-data-in-a-swiftui-project/
                animation: .default)
            var activityArray: FetchedResults<Activity>
            
            return ReadActivityView(activity: newActivity, activityArray: activityArray)
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
