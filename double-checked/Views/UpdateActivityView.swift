//
//  UpdateActivityView.swift
//  double-checked
//
//  Created by Karishma Johnson on 1/24/22.
//

import SwiftUI

struct UpdateActivityView: View {
    @StateObject var activity: Activity
    
    @State private var activityTitle: String = ""
    @State private var activityDate: Date = Date()
    
    var body: some View {
        
        Form {
            Section(header: Text("Update Title")) {
                Text(activity.title ?? "")
                HStack {
                    TextField("New Title", text: $activityTitle)
                        .textFieldStyle(.roundedBorder)
                    Button(action: updateActivityTitle){
                        Text("Save")
                    }
                }
            }
            
            
            Section(header: Text("Select Date")) {
                HStack {
                    // current date selection
                    Text(activity.unwrappedDate) // priv func format str
                    // 
                    Spacer()
                    Button(action: clearDate) {
                        Text("Clear")
                    }
                }
                HStack {
                    DatePicker(selection: $activityDate,
                               in: Date()...,
                               displayedComponents: .date,
                               label: {Text("Choose Date")})
                    Button(action: updateActivityDate) {
                        Text("Save")
                    }
                }
                
            }
            
            // section selection button to import other activities
            
        }
        
    }
    
    private func updateActivityTitle() {
        withAnimation {
            activity.title = activityTitle
            PersistenceController.shared.saveContext()
        }
    }
    private func updateActivityDate() {
        withAnimation {
            activity.date = activityDate
            PersistenceController.shared.saveContext()
        }
    }
    private func clearDate() {
        withAnimation {
            activity.date = nil
            PersistenceController.shared.saveContext()
        }
    }
    
}

struct UpdateView_Previews: PreviewProvider {
    static var previews: some View {
        let viewContext =
        PersistenceController.preview.container.viewContext
        let newActivity = Activity(context: viewContext)
        newActivity.title = "Activity Title"
        newActivity.date = Date()
        
        return UpdateActivityView(activity: newActivity)
            .environment(\.managedObjectContext,
                          PersistenceController.preview.container.viewContext)
        
    }
}

// PARTY IN THE GRAVEYARD

//    private func dateFormatter() {
//        let dateFormatter = DateFormatter()
//        dateFormatter.dateFormat = "MM dd, yyyy"
//        return dateFormatter.string(from: activity.date)
//    }
