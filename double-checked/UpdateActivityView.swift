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
    
    var body: some View {
        VStack {
            HStack {
                TextField("Update activity title", text: $activityTitle)
                    .textFieldStyle(.roundedBorder)
                Button(action: updateActivity) {
                    Label("", systemImage: "arrowshape.turn.up.left") // sf symbols
                }
            }.padding()
            Text(activity.title ?? "")
            Spacer()
        }
    }
    
    private func updateActivity() {
        withAnimation {
            activity.title = activityTitle
            PersistenceController.shared.saveContext()
        }
    }
}

struct UpdateView_Previews: PreviewProvider {
    static var previews: some View {
//        UpdateView()
        let viewContext =
            PersistenceController.preview.container.viewContext
        let newActivity = Activity(context: viewContext)
        newActivity.title = "new title"
        
        return UpdateActivityView(activity: newActivity)
                .environment(\.managedObjectContext,
                    PersistenceController.preview.container.viewContext)
        
    }
}
