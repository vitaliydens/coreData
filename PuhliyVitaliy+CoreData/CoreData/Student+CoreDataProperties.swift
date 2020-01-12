//
//  Student+CoreDataProperties.swift
//  PuhliyVitaliy+CoreData
//
//  Created by Developer on 12.01.2020.
//  Copyright © 2020 Developer. All rights reserved.
//
//

import Foundation
import CoreData


extension Student {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Student> {
        return NSFetchRequest<Student>(entityName: "Student")
    }

    @NSManaged public var name: String?
    @NSManaged public var surName: String?
    @NSManaged public var marks: NSSet?

}

// MARK: Generated accessors for marks
extension Student {

    @objc(addMarksObject:)
    @NSManaged public func addToMarks(_ value: Mark)

    @objc(removeMarksObject:)
    @NSManaged public func removeFromMarks(_ value: Mark)

    @objc(addMarks:)
    @NSManaged public func addToMarks(_ values: NSSet)

    @objc(removeMarks:)
    @NSManaged public func removeFromMarks(_ values: NSSet)

}
