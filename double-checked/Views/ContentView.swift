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
    //@State var progressValue: Float = 0.2
    
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
                                NavigationLink(destination: ReadActivityView(activity: activity, activityTitles: getActivityTitles(activitiesList: activities, activityTitle: activity.unwrappedTitle))) {
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
        for activity in activities {
            if activity.date == nil {
                if groupActivities["Unscheduled"] != nil {
                    groupActivities["Unscheduled"]?.append(activity)
                }
                else {
                    groupActivities["Unscheduled"] = [activity]
                }
                
            } else if Calendar.current.isDateInToday(activity.date!) {
                if groupActivities["Today"] != nil {
                    groupActivities["Today"]?.append(activity)
                } else {
                
                    groupActivities["Today"] = [activity]
                }
            } else if Calendar.current.isDateInTomorrow(activity.date!) {
                if groupActivities["Tomorrow"] != nil {
                    groupActivities["Tomorrow"]?.append(activity)
                } else {
                    groupActivities["Tomorrow"] = [activity]
                }
            } else if activity.date! < Date() {
                if groupActivities["Past"] != nil {
                    groupActivities["Past"]?.append(activity)
                } else {
                    groupActivities["Past"] = [activity]
                }
            } else {
                if groupActivities["Upcoming"] != nil {
                    groupActivities["Upcoming"]?.append(activity)
                } else {
                    groupActivities["Upcoming"] =  [activity]
                }
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
    
    private func getActivityTitles(activitiesList:FetchedResults<Activity>, activityTitle: String) -> [String] {
        var activityTitles = [String]()
        
        for act in activitiesList {
            if act.unwrappedTitle != activityTitle {
                activityTitles.append(act.unwrappedTitle)
            }
        }
        return activityTitles
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
            let newActivity = Activity(context: viewContext)
            newActivity.title = activityTitle
            activityTitle = ""
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
