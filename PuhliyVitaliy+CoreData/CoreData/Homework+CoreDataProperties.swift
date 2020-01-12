//
//  Homework+CoreDataProperties.swift
//  PuhliyVitaliy+CoreData
//
//  Created by Developer on 12.01.2020.
//  Copyright © 2020 Developer. All rights reserved.
//
//

import Foundation
import CoreData


extension Homework {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Homework> {
        return NSFetchRequest<Homework>(entityName: "Homework")
    }

    @NSManaged public var task: String?
    @NSManaged public var lecture: Lecture?
    @NSManaged public var mark: Mark?

}
