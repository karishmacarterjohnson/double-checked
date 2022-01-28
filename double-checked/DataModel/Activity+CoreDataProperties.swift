//
//  Activity+CoreDataProperties.swift
//  double-checked
//
//  Created by Karishma Johnson on 1/25/22.
//
//

import Foundation
import CoreData


extension Activity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Activity> {
        return NSFetchRequest<Activity>(entityName: "Activity")
    }

    @NSManaged public var title: String?
    @NSManaged public var date: Date?
    @NSManaged public var items: NSSet?
    
    public var unwrappedTitle: String {
        title ?? "Unknown title"
    }
    
    public var itemsArray: [Item] {
        let itemSet = items as? Set<Item> ?? []
        
        return itemSet.sorted {
            if $0.check == $1.check {
                return $0.unwrappedTitle < $1.unwrappedTitle
            }
            return $1.check && !$0.check
        }
    }
    
    public var unwrappedDate: String {
        if date != nil {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "d MMM YY"
            return dateFormatter.string(from: date!)
    
        } else {
            return ""
        }
    }
}

// MARK: Generated accessors for relationship
extension Activity {

    @objc(addItemsObject:)
    @NSManaged public func addToItems(_ value: Item)

    @objc(removeItemsObject:)
    @NSManaged public func removeFromItems(_ value: Item)

    @objc(addItems:)
    @NSManaged public func addToItems(_ values: NSSet)

    @objc(removeItems:)
    @NSManaged public func removeFromItems(_ values: NSSet)

}

extension Activity : Identifiable {

}
