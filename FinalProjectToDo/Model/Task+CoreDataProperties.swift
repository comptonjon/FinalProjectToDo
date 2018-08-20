//
//  Task+CoreDataProperties.swift
//  FinalProjectToDo
//
//  Created by Jonathan Compton on 8/19/18.
//  Copyright © 2018 Jonathan Compton. All rights reserved.
//
//

import Foundation
import CoreData


extension Task {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Task> {
        return NSFetchRequest<Task>(entityName: "Task")
    }

    @NSManaged public var title: String?
    @NSManaged public var uid: String?
    @NSManaged public var lastUpdated: Double
    @NSManaged public var isPriority: Bool
    @NSManaged public var timeDue: Double
    @NSManaged public var isCompleted: Bool
    @NSManaged public var tbuser: TBUser?

}
