//
//  Activity+CoreDataProperties.swift
//  double-checked
//
//  Created by Karishma Johnson on 2/2/22.
//
//

import Foundation
import CoreData


extension Activity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Activity> {
        return NSFetchRequest<Activity>(entityName: "Activity")
    }

    @NSManaged public var date: Date?
    @NSManaged public var title: String?
    @NSManaged public var items: NSSet?
    @NSManaged public var linkitems: NSSet?
    
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
    
    public var linkItemsArray: [LinkItem] {
        let linkitemSet = linkitems as? Set<LinkItem> ?? []
        return linkitemSet.sorted {
            return $0.unwrappedLink < $1.unwrappedLink

        }
        
    }
    
    public var unwrappedDate: String {
        if date != nil {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "MMM d, YYYY"
            return dateFormatter.string(from: date!)
    
        } else {
            return ""
        }
    }

}

// MARK: Generated accessors for items
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

// MARK: Generated accessors for linkitems
extension Activity {

    @objc(addLinkitemsObject:)
    @NSManaged public func addToLinkitems(_ value: LinkItem)

    @objc(removeLinkitemsObject:)
    @NSManaged public func removeFromLinkitems(_ value: LinkItem)

    @objc(addLinkitems:)
    @NSManaged public func addToLinkitems(_ values: NSSet)

    @objc(removeLinkitems:)
    @NSManaged public func removeFromLinkitems(_ values: NSSet)

}

extension Activity : Identifiable {

}
