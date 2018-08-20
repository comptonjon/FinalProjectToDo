//
//  TBUser+CoreDataProperties.swift
//  FinalProjectToDo
//
//  Created by Jonathan Compton on 8/19/18.
//  Copyright © 2018 Jonathan Compton. All rights reserved.
//
//

import Foundation
import CoreData


extension TBUser {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<TBUser> {
        return NSFetchRequest<TBUser>(entityName: "TBUser")
    }

    @NSManaged public var name: String?
    @NSManaged public var uid: String?
    @NSManaged public var email: String?
    @NSManaged public var hasAuthenticated: Bool
    @NSManaged public var tasks: NSSet?

}

// MARK: Generated accessors for tasks
extension TBUser {

    @objc(addTasksObject:)
    @NSManaged public func addToTasks(_ value: Task)

    @objc(removeTasksObject:)
    @NSManaged public func removeFromTasks(_ value: Task)

    @objc(addTasks:)
    @NSManaged public func addToTasks(_ values: NSSet)

    @objc(removeTasks:)
    @NSManaged public func removeFromTasks(_ values: NSSet)

}
