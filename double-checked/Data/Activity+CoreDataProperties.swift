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

    @NSManaged public var date: Date?
    @NSManaged public var title: String?
    @NSManaged public var categories: NSSet?
    
    // add formatter here for date ??
    
    
    public var unwrappedTitle: String {
        title ?? "Unknown title"
    }
    
    public var categoriesArray: [Category] {
        let categorySet = categories as? Set<Category> ?? []
        // also send children?
        return categorySet.sorted {
            $0.unwrappedTitle < $1.unwrappedTitle // sorts array alphabetically // do like this with the bool
        }
    }    

}

// MARK: Generated accessors for categories
extension Activity {

    @objc(addCategoriesObject:)
    @NSManaged public func addToCategories(_ value: Category)

    @objc(removeCategoriesObject:)
    @NSManaged public func removeFromCategories(_ value: Category)

    @objc(addCategories:)
    @NSManaged public func addToCategories(_ values: NSSet)

    @objc(removeCategories:)
    @NSManaged public func removeFromCategories(_ values: NSSet)

}

extension Activity : Identifiable {

}
