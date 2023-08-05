//
//  ExerciseEntity+CoreDataProperties.swift
//  WorkoutTracker
//
//  Created by Austin  on 8/1/23.
//
//

import Foundation
import CoreData


extension ExerciseEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<ExerciseEntity> {
        return NSFetchRequest<ExerciseEntity>(entityName: "ExerciseEntity")
    }

    @NSManaged public var name: String?
    @NSManaged public var personalRecordDate: Date?
    @NSManaged public var personalRecordReps: Int16
    @NSManaged public var personalRecordWeight: Int16
    @NSManaged public var oneRepMax: Int16
    @NSManaged public var sets: NSSet?
    @NSManaged public var workout: WorkoutEntity?

}

// MARK: Generated accessors for sets
extension ExerciseEntity {

    @objc(addSetsObject:)
    @NSManaged public func addToSets(_ value: SetInfoEntity)

    @objc(removeSetsObject:)
    @NSManaged public func removeFromSets(_ value: SetInfoEntity)

    @objc(addSets:)
    @NSManaged public func addToSets(_ values: NSSet)

    @objc(removeSets:)
    @NSManaged public func removeFromSets(_ values: NSSet)

}

extension ExerciseEntity : Identifiable {

}
