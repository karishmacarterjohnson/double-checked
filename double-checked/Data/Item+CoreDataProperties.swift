//
//  Item+CoreDataProperties.swift
//  double-checked
//
//  Created by Karishma Johnson on 1/25/22.
//
//

import Foundation
import CoreData


extension Item {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Item> {
        return NSFetchRequest<Item>(entityName: "Item")
    }

    @NSManaged public var title: String?
    @NSManaged public var check: Bool
    @NSManaged public var category: Category?
    
    public var unwrappedTitle: String {
        title ?? "Unknown title"
    }

}

extension Item : Identifiable {

}
