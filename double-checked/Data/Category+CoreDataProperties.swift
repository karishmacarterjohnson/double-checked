//
//  Category+CoreDataProperties.swift
//  double-checked
//
//  Created by Karishma Johnson on 1/25/22.
//
//

import Foundation
import CoreData


extension Category {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Category> {
        return NSFetchRequest<Category>(entityName: "Category")
    }

    @NSManaged public var title: String?
    @NSManaged public var items: NSSet?
    @NSManaged public var activity: Activity?
    
    public var unwrappedTitle: String { // unwrapped Category? // maybe as NSSet? NSDict? so I can get items from it as well
        title ?? "Unknown title"
    }
    
    //public var 
    
    public var itemsArray: [Item] {
        let itemSet = items as? Set<Item> ?? []
        
        return itemSet.sorted {
            $0.unwrappedTitle < $1.unwrappedTitle // sorts array alphabetically // do like this with the bool
        }
    }
    
    public var unwrappedActivity: String {
        activity?.unwrappedTitle ?? "unknown activity"
    }

}

// MARK: Generated accessors for items
extension Category {

    @objc(addItemsObject:)
    @NSManaged public func addToItems(_ value: Item)

    @objc(removeItemsObject:)
    @NSManaged public func removeFromItems(_ value: Item)

    @objc(addItems:)
    @NSManaged public func addToItems(_ values: NSSet)

    @objc(removeItems:)
    @NSManaged public func removeFromItems(_ values: NSSet)

}

extension Category : Identifiable {

}
