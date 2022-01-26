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
    @NSManaged public var activityTitle: String?
    @NSManaged public var check: Bool
    @NSManaged public var activity: Activity?
    
    public var unwrappedTitle: String {
        title ?? "Unknown Title"
    }
    
    public var unwrappedActivityTitle: String {
        activityTitle ?? "Unknown Activity"
    }
    
    // temporary!!
    public var unwrappedCheck: String {
        if check {
            return "True"
        } else {
            return "False"
        }
    }
    
}

extension Item : Identifiable {

}
