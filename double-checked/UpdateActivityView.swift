//
//  UpdateActivityView.swift
//  double-checked
//
//  Created by Karishma Johnson on 1/24/22.
//

import SwiftUI

struct UpdateActivityView: View {
    @StateObject var activity: Activity // sets up state on var activity to re-render on this change
    
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
                
                //Text(DateFormatter() ?? "")
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
    
//    private func dateFormatter() {
//        let dateFormatter = DateFormatter()
//        dateFormatter.dateFormat = "MM dd, yyyy"
//        return dateFormatter.string(from: activity.date)
//    }

}

struct UpdateView_Previews: PreviewProvider {
    static var previews: some View {
//        UpdateView()
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
