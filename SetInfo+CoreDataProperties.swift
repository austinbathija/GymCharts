//
//  SetInfo+CoreDataProperties.swift
//  WorkoutTracker
//
//  Created by Austin  on 7/28/23.
//
//

import Foundation
import CoreData


extension SetInfo {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<SetInfo> {
        return NSFetchRequest<SetInfo>(entityName: "SetInfo")
    }

    @NSManaged public var weight: String?
    @NSManaged public var reps: String?

}

extension SetInfo : Identifiable {

}
