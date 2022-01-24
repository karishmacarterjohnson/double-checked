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
        newActivity.title = "Visit Nidhi"

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
