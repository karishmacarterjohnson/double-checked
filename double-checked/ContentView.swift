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
    
    @FetchRequest( // property wrapper
        sortDescriptors: [NSSortDescriptor(keyPath: \Activity.title, ascending: true)], // how to organize data
        animation: .default)
    private var activities: FetchedResults<Activity> // sets up object in coredata repo for ui
    
    var body: some View {
        NavigationView{
            //Text("Hello, world!")
            //.padding()
            
            VStack { // orders vertically
                HStack { // horizontal stack of things in these brackets
                    TextField("Activity Name", text: $activityTitle)
                        .textFieldStyle(.roundedBorder)
                    Button(action: addActivity) {
                        Label("", systemImage: "plus")
                    }
                }.padding()
                //Spacer() // sends to top
                List {
                    ForEach(activities) {activity in
                        //Text (activity.title ?? "")
                        NavigationLink(destination: UpdateActivityView(activity: activity)) {
                            VStack {
                            Text(activity.title ?? "")
                            Text("<status bar here>")
                            }
                            //Spacer()
                        }
                    }.onDelete(perform: deleteActivity) // swipe button
                }.toolbar{ EditButton() }
            }//.navigationTitle("Activities")
            
        }
    }
    private func deleteActivity(offsets: IndexSet) {
        withAnimation {
            offsets.map {activities[$0]} . forEach(viewContext.delete)
            PersistenceController.shared.saveContext()
        }
    }
    
    private func addActivity() { // creates newActivity object and assigns title
        withAnimation {
            let newActivity = Activity(context: viewContext)
            newActivity.title = activityTitle
            PersistenceController.shared.saveContext()
        }
    }
    
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        //        ContentView()
        ContentView().environment(\.managedObjectContext,
                                   PersistenceController.preview.container.viewContext)
    }
}
