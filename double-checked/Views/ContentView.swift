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
    @State var progressValue: Float = 0.2
    
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
                
                List { // !! group by date: today, upcoming, else.
                    
                    ForEach(activities) {activity in
                        NavigationLink(destination: ReadActivityView(activity: activity, activityTitles: getActivityTitles(activitiesList: activities, activityTitle: activity.unwrappedTitle))) {
                            VStack {
                                HStack {
                                    Text(activity.title ?? "")
                                    Text(activity.unwrappedDate)
                                }
                                ProgressBar(value: $progressValue).frame(height:10) //$progressValue should be calculated based on count of true values / activity.itemsArray.count rounded?
                            }
                        }
                    }.onDelete(perform: deleteActivity) //.listRowBackground(Color(UIColor.systemPink))
                }.toolbar{ EditButton() } .listStyle(SidebarListStyle())
            }.navigationBarTitle("Activities", displayMode: .inline)
        }
    }
    
    private func groupActivities() { // -> [(String?, [Activity])]
        // var groupActivities = Dictionary()
        // for activity in activities {
        ///     if Calendar.current.isDateInToday{activity.date
        ///
        /// var groupedActivities = [(String?,[Activity])]()
        ///
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
