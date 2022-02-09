//
//  ImportActivityView.swift
//  double-checked
//
//  Created by Karishma Johnson on 2/9/22.
//

import SwiftUI

struct ImportActivityView: View {
    @Environment(\.managedObjectContext) private var viewContext
    
    
    @StateObject var activity: Activity

    var body: some View {
//        ShareActivity(activity: activity)
//        ImportActivity()
        VStack {
            ProgressBar(value: progressValue(activity: activity)).frame(height:10).padding(.horizontal)

            ActivityLinks(activity: activity)
            
            List {
                ForEach(groupItems(), id:\.self.0){ activityName, items in
                    Section(header: Text(activityName ?? "")){
                        ForEach(items) { item in
                            Checked(activity:activity, item: item)
                        }
                    }
                }
            }
            Button(action: saveActivity) {
                Label("Save", systemImage: "")
            }
            Button(action: cancelSaveActivity) {
                Label("Close", systemImage: "")
            }
        }.navigationBarTitle(activity.unwrappedTitle)
    }
    
    private func cancelSaveActivity() {
        // go back to main view??
        // maybe just make the button a navlink
    }
    
    private func saveActivity() {
        // actually create it here
        PersistenceController.shared.saveContext()
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
    
    private func groupItems() -> [(String?,[Item])] {
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
        // show current one first
        
        return listItems
        
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
