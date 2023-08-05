//
//  Exercise+CoreDataProperties.swift
//  WorkoutTracker
//
//  Created by Austin  on 7/28/23.
//
//

import Foundation
import CoreData


extension Exercise {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Exercise> {
        return NSFetchRequest<Exercise>(entityName: "Exercise")
    }

    @NSManaged public var name: String?
    @NSManaged public var weightAndReps: NSSet?

}

// MARK: Generated accessors for weightAndReps
extension Exercise {

    @objc(addWeightAndRepsObject:)
    @NSManaged public func addToWeightAndReps(_ value: Exercise)

    @objc(removeWeightAndRepsObject:)
    @NSManaged public func removeFromWeightAndReps(_ value: Exercise)

    @objc(addWeightAndReps:)
    @NSManaged public func addToWeightAndReps(_ values: NSSet)

    @objc(removeWeightAndReps:)
    @NSManaged public func removeFromWeightAndReps(_ values: NSSet)

}

extension Exercise : Identifiable {

}
