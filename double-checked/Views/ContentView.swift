//
//  ContentView.swift
//  double-checked
//
//  Created by Karishma Johnson on 1/24/22.
//

import SwiftUI

struct ContentView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @State private var prevActivity: Bool = false
    @State private var newImport: Activity?
    @State private var invalidLink: Bool = false
    @State private var isActive: Bool = false
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
            if isActive {
                if prevActivity {
                    /////////////////////////////////////// import
                    VStack {
                        if newImport!.linkItemsArray.count != 0 {
                            ScrollView(.horizontal) {
                                
                                HStack {
                                    
                                    ForEach(newImport!.linkItemsArray) { linkitem in
                                        
                                        Link(destination: URL(string: linkitem.unwrappedLink)!) {
                                            HStack {
                                                VStack(alignment: .leading) {
                                                    Text(linkitem.unwrappedTitle)
                                                    Text(linkitem.unwrappedLink)
                                                        .font(.caption)
                                                }.frame(maxWidth: 160)
                                                Image(systemName: "link.circle.fill")
                                                    .font(.largeTitle)
                                            }
                                            
                                        }
                                    }.padding()
                                }
                            }.frame(height: 100).padding(.horizontal)
                        }
                        
                        List {
                            ForEach(groupItems(), id:\.self.0){ activityName, items in
                                Section(header: Text(activityName ?? "")){
                                    ForEach(items) { item in
                                        Text(item.unwrappedTitle)
                                    }
                                }
                            }
                        }
                        HStack {
                            Button(action: {prevActivity = false}) {
                                Label("Save", systemImage: "")
                            }
                            Button(action: {
                                prevActivity = false
                                deleteActivity(activity: newImport!)
                                
                                
                            }) {Label("Close", systemImage:"")}
                        }
                    }.navigationBarTitle(newImport!.unwrappedTitle)
                    
                    ////////////////////////////////////////// import
                    
                }
                else { /////////////////////////////////////// default
                    VStack {
                        HStack {
                            HStack {
                                TextField("Activity Name", text: $activityTitle)
                                    .modifier(TextFieldM())
                                Spacer()
                                Button(action: {activityTitle = ""}) {
                                    Label("", systemImage: "delete.left")
                                }
                                .modifier(ClearButtonM())
                                .foregroundColor(activityTitle.isEmpty ? Theme.emptyButtonColor : Theme.filledButtonColor)
                            }
                            Button(action: addActivity) {
                                Label("", systemImage: "plus")
                            }.modifier(AddButtonM())
                        }.padding(4).padding(.horizontal)
                        
                        List {
                            ForEach(groupActivities(), id:\.self.0) {group, activitiesArray in
                                Section(header: Text(group)
                                            .foregroundColor(main1)
                                            .font(.body)
                                            .textCase(.uppercase)) {
                                    ForEach(activitiesArray, id:\.self.title) {activity in
                                        NavigationLink(destination: ReadActivityView(activity: activity, activityArray: activities)) {
                                            VStack {
                                                HStack (alignment: .firstTextBaseline) {
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
                                            Button(action: {duplicateActivityComplete(activity: activity)}) {
                                                Label("", systemImage: "doc.on.doc")
                                            }
                                            Button(action: {duplicateActivityIncomplete(activity: activity)}) {
                                                Label("", systemImage: "doc.on.doc.fill")
                                            }
                                        }
                                        .listRowSeparator(.hidden)
                                    }
                                }
                            }
                        }.listStyle(SidebarListStyle())
                        
                        
                    }.navigationBarTitle("Activities", displayMode: .inline)
                    
                        .background(main3)
                        .foregroundColor(main1)
                        .foregroundColor(Color(UIColor.white))
                        .navigationBarItems(trailing: NavigationLink(destination: SearchBar(activities: activities)) {
                            Text(
                                Image("search")
                            )
                            
                        }
                        )
                    /////////////////////////////////////// default
                }}
            else {
                Text("Double Check")
            }
            
        }.foregroundColor(main1)
            .onOpenURL(perform: {url in
                newImport = importActivityAsObject(link: url.absoluteString)
                if newImport != nil {
                    prevActivity = true
                }
            }).alert("invalid url", isPresented: $invalidLink) {
                Button("ok", role:.cancel, action: {invalidLink = false})
            }
            .onAppear {
                // 6.
                DispatchQueue.main.asyncAfter(deadline: .now() + 2.5) {
                    // 7.
                    withAnimation {
                        isActive = true
                    }
                }
            }
        
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
    
    private func duplicateActivityIncomplete(activity: Activity){
        withAnimation {
            var ct: Int = 0
            let activityCopy = Activity(context: viewContext)
            activityCopy.title = activity.title
            PersistenceController.shared.saveContext()
            for a in activities {
                if ct == 0 && a.title == activity.title && a.date == activity.date && a.items == activity.items {
                    for i in a.itemsArray {
                        let itemCopy = Item(context: viewContext)
                        itemCopy.title = i.title
                        itemCopy.activityTitle = i.activityTitle
                        activityCopy.addToItems(itemCopy)
                        PersistenceController.shared.saveContext()
                    }
                    for l in a.linkItemsArray {
                        let linkItemCopy = LinkItem(context: viewContext)
                        linkItemCopy.title = l.title
                        linkItemCopy.link = l.link
                        activityCopy.addToLinkitems(linkItemCopy)
                        PersistenceController.shared.saveContext()
                    }
                    
                    ct += 1
                    PersistenceController.shared.saveContext()
                }
            }
        }
    }
    
    private func duplicateActivityComplete(activity: Activity){
        withAnimation {
            var ct: Int = 0
            let activityCopy = Activity(context: viewContext)
            activityCopy.title = activity.title
            PersistenceController.shared.saveContext()
            for a in activities {
                if ct == 0 && a.title == activity.title && a.date == activity.date && a.items == activity.items {
                    for i in a.itemsArray {
                        if !i.check {
                            let itemCopy = Item(context: viewContext)
                            itemCopy.title = i.title
                            itemCopy.activityTitle = i.activityTitle
                            activityCopy.addToItems(itemCopy)
                            PersistenceController.shared.saveContext()
                        }
                    }
                    for l in a.linkItemsArray {
                        let linkItemCopy = LinkItem(context: viewContext)
                        linkItemCopy.title = l.title
                        linkItemCopy.link = l.link
                        activityCopy.addToLinkitems(linkItemCopy)
                        PersistenceController.shared.saveContext()
                    }
                    
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
    
    
    ///////////////////// import
    ///
    
    private func groupItems() -> [(String?,[Item])] {
        //        let activity = activity
        var items: Dictionary = Dictionary(grouping: newImport!.itemsArray, by: {$0.activityTitle})
        let current: [Item]? = items[newImport!.unwrappedTitle]
        items.removeValue(forKey: newImport!.unwrappedTitle)
        var listItems = [(String?,[Item])]()
        let strs = items.keys.compactMap {
            $0
        }
        if (current != nil) {
            listItems.append((newImport!.unwrappedTitle, current!))
        }
        for key in strs.sorted() {
            listItems.append((key, items[key]!))
        }
        return listItems
        
    }
    
    private func importActivityAsObject(link: String) -> Activity? {
        
        let b64 = String(link.dropFirst("doublechecked://".count))
        let data = Data(base64Encoded: b64)
        guard let b64Decoded = String(data: data!, encoding: .utf8) else { invalidLink = true; return nil }
        let jsonData = (b64Decoded.data(using:.utf8))! // string
        let attempt = try! JSONDecoder().decode(ActivityShared.self, from: jsonData)  // ActivityShared struct
        let importedActivity = Activity(context: viewContext)
        importedActivity.title = attempt.title
        for i in attempt.items {
            let itemCopy = Item(context: viewContext)
            itemCopy.title = i[0]
            itemCopy.activityTitle = i[1]
            importedActivity.addToItems(itemCopy)
        }
        for l in attempt.linkItems {
            let linkItemCopy = LinkItem(context: viewContext)
            linkItemCopy.title = l[0]
            linkItemCopy.link = l[1]
            importedActivity.addToLinkitems(linkItemCopy)
        }
        return importedActivity
        
    }
    
    
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView().environment(\.managedObjectContext,
                                   PersistenceController.preview.container.viewContext)
    }
}
