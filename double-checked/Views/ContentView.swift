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
    
    private var main1: Color = Color(red: 214 / 255, green: 41 / 255, blue: 0 / 255)
    private var main2: Color = Color(red: 255 / 255, green: 100 / 255, blue: 160 / 255)
    private var main3: Color = Color(red: 255 / 255, green: 193 / 255, blue: 125 / 255)
    
    var body: some View {
        NavigationView{
            VStack {
                HStack {
                    TextField("Activity Name", text: $activityTitle)
                        .textFieldStyle(.roundedBorder)
                        .foregroundColor(main2)
                    Button(action: addActivity) {
                        Label("", systemImage: "plus")
                    }
                }.padding(.horizontal)
                
                List {
                    ForEach(groupActivities(), id:\.self.0) {group, activitiesArray in
                        Section(header: Text(group)
                                    .foregroundColor(main1)
                                    .font(.body)
                                    .textCase(.uppercase)) {
                            ForEach(activitiesArray, id:\.self.title) {activity in
                                NavigationLink(destination: ReadActivityView(activity: activity, activityArray: activities)) {
                                    VStack {
                                        HStack { // (alignment: .bottom)
                                            Text(activity.title ?? "")
                                            Spacer()
                                            Text(activity.unwrappedDate)
                                                .fontWeight(.light)
                                                .font(.caption)
                                            
                                        }.foregroundColor(main1)
                                            .font(.body)
                                        ProgressBar(value: progressValue(activity: activity)).frame(height:4)
                                    }
                                    
                                }.swipeActions(edge: .trailing, allowsFullSwipe: false) {
                                    Button( action: {deleteActivity(activity: activity)}) {
                                        Label("", systemImage: "trash")
                                    }
                                }
                                //.listRowSeparator(.hidden)
                                
                                .listRowBackground(main3)
                            }
                        }
                        
                    }
                }.listStyle(SidebarListStyle())
                
            }.navigationBarTitle("Activities", displayMode: .inline)
                .background(main3)
                .foregroundColor(main1)
            
        }.foregroundColor(main1)
    }
    
    private func groupActivities() -> [(String, [Activity])] {
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
                if countComplete(activity: activity) != activity.itemsArray.count {
                    buildGroup(group: "Overdue", act: activity)
                } else {
                    buildGroup(group: "Past", act: activity)
                }
            } else {
                buildGroup(group: "Upcoming", act: activity)
            }
            
        }
        
        var groupedActivities = [(String, [Activity])]()
        let groups = ["Today", "Tomorrow", "Overdue", "Upcoming", "Unscheduled", "Past"]
        
        for group in groups {
            if groupActivities[group] != nil {
                groupedActivities.append((group, groupActivities[group]!))
            }
        }
        return groupedActivities
    }
    
    private func countComplete(activity: Activity) -> Int {
        var checkedCount: Int = 0
        for x in activity.itemsArray {
            if x.check {
                checkedCount += 1
            }
        }
        return checkedCount
    }
    
    private func progressValue(activity: Activity) -> Float {
        let total: Int = activity.itemsArray.count
        return Float(Double(countComplete(activity: activity)) / Double(total))
    }
    
    private func deleteActivity(activity: Activity) {
        withAnimation {
            var ct: Int = 0
            for a in activities {
                if ct == 0 && a.title == activity.title && a.date == activity.date && a.items == activity.items {
                    viewContext.delete(a)
                    ct += 1
                    PersistenceController.shared.saveContext()
                }
            }
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
