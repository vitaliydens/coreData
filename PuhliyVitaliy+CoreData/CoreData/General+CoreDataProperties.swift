//
//  General+CoreDataProperties.swift
//  PuhliyVitaliy+CoreData
//
//  Created by Developer on 12.01.2020.
//  Copyright © 2020 Developer. All rights reserved.
//
//

import Foundation
import CoreData


extension General {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<General> {
        return NSFetchRequest<General>(entityName: "General")
    }

    @NSManaged public var id: String?

}
