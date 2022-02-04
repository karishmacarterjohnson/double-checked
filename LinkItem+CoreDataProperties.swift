//
//  LinkItem+CoreDataProperties.swift
//  double-checked
//
//  Created by Karishma Johnson on 2/2/22.
//
//

import Foundation
import CoreData


extension LinkItem {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<LinkItem> {
        return NSFetchRequest<LinkItem>(entityName: "LinkItem")
    }

    @NSManaged public var link: String?
    @NSManaged public var title: String?
    @NSManaged public var activity: Activity?

    public var unwrappedTitle: String {
        title ?? ""
    }
    
    public var unwrappedLink: String {
        link ?? ""
    }
}

extension LinkItem : Identifiable {

}
