//
//  ContentView.swift
//  double-checked
//
//  Created by Karishma Johnson on 1/24/22.
//

import SwiftUI

struct ContentView: View {
    @Environment(\.managedObjectContext) private var viewContext
    
    @State private var activityTitle: String = ""
    
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Activity.title, ascending: true)], // https://www.donnywals.com/fetching-objects-from-core-data-in-a-swiftui-project/
        animation: .default)
    private var activities: FetchedResults<Activity>
    
    var body: some View {
        NavigationView{
            VStack {
                HStack {
                    TextField("Activity Name", text: $activityTitle)
                        .textFieldStyle(.roundedBorder)
                    Button(action: addActivity) {
                        Label("", systemImage: "plus")
                    }
                }
                List { // !! group by date: today, upcoming, else.
                    ForEach(activities) {activity in
                        NavigationLink(destination: ReadActivityView(activity: activity)) {
                            VStack {
                            Text(activity.title ?? "")
                            Text("<status bar here>") // progress bar
                            }
                        }
                    }.onDelete(perform: deleteActivity)
                }.toolbar{ EditButton() }
            }//.navigationTitle("Activities")
            
        }
    }
    
//    private func getActivityTitles() -> [String?] {
//        var activityTitles = [String?]()
//        for activity in activities {
//            activityTitles.append(activity.unwrappedTitle)
//        }
//        return activityTitles
//    }
    
    
    private func deleteActivity(offsets: IndexSet) {
        withAnimation {
            offsets.map {activities[$0]} . forEach(viewContext.delete)
            PersistenceController.shared.saveContext()
        }
    }
    
    private func addActivity() {
        withAnimation {
            let newActivity = Activity(context: viewContext)
            newActivity.title = activityTitle
            PersistenceController.shared.saveContext()
        }
    }
    
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView().environment(\.managedObjectContext,
                                   PersistenceController.preview.container.viewContext)
    }
}
