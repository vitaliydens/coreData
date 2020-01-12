//
//  Lector+CoreDataProperties.swift
//  PuhliyVitaliy+CoreData
//
//  Created by Developer on 12.01.2020.
//  Copyright © 2020 Developer. All rights reserved.
//
//

import Foundation
import CoreData


extension Lector {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Lector> {
        return NSFetchRequest<Lector>(entityName: "Lector")
    }

    @NSManaged public var name: String?
    @NSManaged public var surName: String?
    @NSManaged public var lecture: Lecture?

}
