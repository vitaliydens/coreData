//
//  Mark+CoreDataProperties.swift
//  PuhliyVitaliy+CoreData
//
//  Created by Developer on 12.01.2020.
//  Copyright © 2020 Developer. All rights reserved.
//
//

import Foundation
import CoreData


extension Mark {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Mark> {
        return NSFetchRequest<Mark>(entityName: "Mark")
    }

    @NSManaged public var clarification: String?
    @NSManaged public var mark: String?
    @NSManaged public var homework: Homework?
    @NSManaged public var student: Student?

}
