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
        sortDescriptors: [NSSortDescriptor(keyPath: \Activity.date, ascending: true)], // https://www.donnywals.com/fetching-objects-from-core-data-in-a-swiftui-project/
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
                }.padding(.leading).padding(.trailing)
                
                List {
                    ForEach(groupActivities(), id:\.self.0) {group, activitiesArray in
                        Section(header: Text(group)) {
                            ForEach(activitiesArray) {activity in
                                NavigationLink(destination: ReadActivityView(activity: activity  ,activityArray: activities)) {
                                    VStack {
                                        HStack {
                                            Text(activity.title ?? "")
                                            Text(activity.unwrappedDate)
                                        }
                                        ProgressBar(value: progressValue(activity: activity)).frame(height:10)
                                    }
                                }
                            }
                        }
                        
                    }.onDelete(perform: deleteActivity) //.listRowBackground(Color(UIColor.systemPink))
                }.toolbar{ EditButton() } .listStyle(SidebarListStyle())
                
            }.navigationBarTitle("Activities", displayMode: .inline)
        }
    }
    
    private func groupActivities() -> [(String, [Activity])] { // -> [(String?, [Activity])]
        var groupActivities = [String:[Activity]]()
        
        func buildGroup(group: String, act: Activity) {
            if groupActivities[group] != nil {
                groupActivities[group]?.append(act)
            }
            else {
                groupActivities[group] = [act]
            }
        }
        
        for activity in activities {
            if activity.date == nil {
                buildGroup(group: "Unscheduled", act: activity)
            } else if Calendar.current.isDateInToday(activity.date!) {
                buildGroup(group: "Today", act: activity)
            } else if Calendar.current.isDateInTomorrow(activity.date!) {
                buildGroup(group: "Tomorrow", act: activity)
            } else if activity.date! < Date() {
                // if # complete == act.itemsArray.count -> ()
                buildGroup(group: "Past", act: activity)
            } else {
                buildGroup(group: "Upcoming", act: activity)
            }
            
        }
        
        var groupedActivities = [(String, [Activity])]()
        let groups = ["Today", "Tomorrow", "Upcoming", "Unscheduled", "Past"]
        
        for group in groups {
            if groupActivities[group] != nil {
                groupedActivities.append((group, groupActivities[group]!))
            }
        }
        return groupedActivities
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
    
    private func deleteActivity(offsets: IndexSet) {
        withAnimation {
            offsets.map {activities[$0]} . forEach(viewContext.delete)
            PersistenceController.shared.saveContext()
        }
    }
    
    private func addActivity() {
        withAnimation {
            if activityTitle != "" {
                let newActivity = Activity(context: viewContext)
                newActivity.title = activityTitle
                activityTitle = ""
                PersistenceController.shared.saveContext()
            }
        }
    }
    
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView().environment(\.managedObjectContext,
                                   PersistenceController.preview.container.viewContext)
    }
}
