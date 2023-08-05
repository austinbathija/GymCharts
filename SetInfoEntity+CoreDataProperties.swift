//
//  SetInfoEntity+CoreDataProperties.swift
//  WorkoutTracker
//
//  Created by Austin  on 7/30/23.
//
//

import Foundation
import CoreData


extension SetInfoEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<SetInfoEntity> {
        return NSFetchRequest<SetInfoEntity>(entityName: "SetInfoEntity")
    }

    @NSManaged public var weight: String?
    @NSManaged public var reps: String?
    @NSManaged public var exercise: ExerciseEntity?

}

extension SetInfoEntity : Identifiable {

}
