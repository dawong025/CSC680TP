//
//  TaskItem+CoreDataProperties.swift
//  CSC680 Term Project
//
//  Created by Darren Wong on 11/27/22.
//
//

import Foundation
import CoreData


extension TaskItem {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<TaskItem> {
        return NSFetchRequest<TaskItem>(entityName: "TaskItem")
    }

    @NSManaged public var name: String?
    @NSManaged public var createdAt: Date?
    @NSManaged public var taskDescription: String?
    @NSManaged public var doTaskBy: Date?

}

extension TaskItem : Identifiable {

}
