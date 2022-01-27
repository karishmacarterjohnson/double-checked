//
//  ContentView.swift
//  double-checked
//
//  Created by Karishma Johnson on 1/24/22.
//

import SwiftUI

struct ProgressBar: View {
    @Binding var value: Float
    
    var body: some View {
        GeometryReader { geometry in
            ZStack(alignment: .leading) {
                Rectangle().frame(width: geometry.size.width , height: geometry.size.height)
                    .opacity(0.3)
                    .foregroundColor(Color(UIColor.systemTeal))
                withAnimation {
                Rectangle().frame(width: min(CGFloat(self.value)*geometry.size.width, geometry.size.width), height: geometry.size.height)
                    .foregroundColor(Color(UIColor.systemBlue))
                }
            }.cornerRadius(45.0)
        }
    }
}

struct ContentView: View {
    @Environment(\.managedObjectContext) private var viewContext
    
    @State private var activityTitle: String = ""
    @State var progressValue: Float = 0.2
    
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
                                ProgressBar(value: $progressValue).frame(height:20) //$progressValue should be calculated based on count of true values / activity.itemsArray.count rounded?
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
