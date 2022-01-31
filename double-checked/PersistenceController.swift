//
//  PersistenceController.swift
//  double-checked
//
//  Created by Karishma Johnson on 1/24/22.
//

import CoreData

struct PersistenceController {
    let container: NSPersistentContainer

    static let shared = PersistenceController()

    var viewContext: NSManagedObjectContext {
        return container.viewContext
    }

    static var preview: PersistenceController = {
        let result = PersistenceController(inMemory: true)
        let viewContext = result.container.viewContext

        // Activities // make avail in previews
        let newActivity = Activity(context: viewContext)
        newActivity.title = "Visit Cousin"
        
        let newActivity2 = Activity(context: viewContext)
        newActivity2.title = "India trip"
        newActivity2.date = Date()
        //shared.saveContext()
        
        let newItem = Item(context: viewContext)
        newItem.title = "stereo"
        newItem.activityTitle = newActivity.unwrappedTitle
        
        newActivity.addToItems(newItem)
        
        shared.saveContext()
        
        return result
    }()

    init(inMemory: Bool = false) { // true: objects stored in dev/null
        container = NSPersistentContainer(name: "Model") // INTRO == name of db file
        if inMemory {
            container.persistentStoreDescriptions.first!.url = URL(fileURLWithPath: "/dev/null")
        }
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
    }
    
    func saveContext() {
        let context = container.viewContext

        if context.hasChanges {
            do {
                try context.save()
            } catch {
                fatalError("Error: \(error.localizedDescription)")
            }
        }
    }
}
