//
//  ReadActivityView.swift
//  double-checked
//
//  Created by Karishma Johnson on 1/24/22.
//

import SwiftUI

struct ReadActivityView: View {
    @Environment(\.managedObjectContext) private var viewContext
    
    @StateObject var activity: Activity
    
    @State private var categoryTitle: String = ""
    
    // fetch request categories where activity == activity

    @FetchRequest(sortDescriptors: [NSSortDescriptor(keyPath: \Category.title, ascending: true)],
                  predicate: NSPredicate(format: "activity == %@", "visit gf"))
    private var categories: FetchedResults<Category>
    
    var body: some View {
        VStack {
            NavigationLink(destination: UpdateActivityView(activity: activity)) {
                Text(activity.title ?? "")
            }
//                        HStack {
//                            TextField("new item", text: $itemTitle)
//                                .textFieldStyle(.roundedBorder)
//                            Button(action: addItem) {
//                                Label("", systemImage:"plus")
//                            }
//                        }
            
            // list
            // for each category,
            // display tasks
            List {
                ForEach(categories) { category in
                    Section(header: Text(category.unwrappedTitle)){
//                        Text("a category!")
//                        ForEach(category, id: \.self){ item in
//                            Text(item.unwrappedTitle)
//                        }
                    }
                }
            }
        }
    }
    
    
}





struct ReadActivityView_Previews: PreviewProvider {
    static var previews: some View {
        let viewContext = PersistenceController.preview.container.viewContext
        let newActivity = Activity(context: viewContext)
        newActivity.title = "visit gf"
        newActivity.date = Date()
        
        let category1 = Category(context: viewContext)
        category1.title = "j"
        
        let item1 = Item(context: viewContext)
        item1.title = "1 item"
        
        
        
        let category2 = Category(context: viewContext)
        category2.title = "bottle"
        
        category1.addToItems(item1)
        
        newActivity.addToCategories(category1)
        newActivity.addToCategories(category2)
        
        return ReadActivityView(activity: newActivity)
            .environment(\.managedObjectContext,
                          PersistenceController.preview.container.viewContext)
    }
}


// PARTY IN THE GRAVEYARD

//    @FetchRequest(
//        sortDescriptors: [NSSortDescriptor(keyPath: \Activity.categoriesArray, ascending: true)], // https://www.donnywals.com/fetching-objects-from-core-data-in-a-swiftui-project/
//        animation: .default)
//    private var categories: FetchedResults<Activity>


//private func deleteCategory(at offsets: IndexSet){
//    withAnimation {
//        for index in offsets {
//            let category = activity.categoriesArray[index]
//            viewContext.delete(category)
//            PersistenceController.shared.saveContext()
//        }
//    }
//}


//                        List {
//                            ForEach(activity.categoriesArray) { category in
//                                Section(header: Text(category.unwrappedTitle)){
//                                    //Text(category.unwrappedTitle)
//                                    ForEach(category.itemsArray) { item in
//                                        Text(item.unwrappedTitle)
//
//                                    }//.onDelete(perform: deleteItem)
//                                }//.onDelete(perform: deleteCategory)
//                            }
//                        }


//List {
//    ForEach(categories) { category in
//        Section(header: Text(category.unwrappedTitle)) {
//            //Text(category.unwrappedTitle)
//            ForEach(category.itemsArray) { item in
//                Text(item.unwrappedTitle)
//
//            }//.onDelete(perform: deleteItem)
//            HStack {
//                TextField("new item", text: $itemTitle)
//                    .textFieldStyle(.roundedBorder)
//                Button(action: addItem) {
//                    Label("", systemImage:"plus")
//                }
//            }
//        }//.onDelete(perform: deleteCategory)
//    } // toolbar(EditButton()) or smth
//}


//    private func addItem(at offsets: IndexSet) {
//        withAnimation {
//            for index in offsets {
//                let category = categories[index]
//                category.addToItems(itemTitle)
////                let newItem = Item(context: viewContext)
////                newItem.title = itemTitle
////                newItem.category =
//                PersistenceController.shared.saveContext()
//            }
//        }
//    }



//List {
//    ForEach(activity.categoriesArray) { category in
////                    NavigationLink(destination: UpdateCategoryView(category: category.unwrappedTitle, )) {
//        Text(category.unwrappedTitle)
//        //                    }
//
//    }
//}
