//
//  Task+CoreDataProperties.swift
//  DemoToDoList
//
//  Created by Nguyen Quang Huy on 08/06/2022.
//
//

import Foundation
import CoreData


extension Task {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Task> {
        return NSFetchRequest<Task>(entityName: "Task")
    }

    @NSManaged public var isDone: Bool
    @NSManaged public var title: String?
    @NSManaged public var index: Int32

}

extension Task : Identifiable {

}
