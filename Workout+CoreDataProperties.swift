//
//  Workout+CoreDataProperties.swift
//  WorkoutTracker
//
//  Created by Austin  on 7/28/23.
//
//

import Foundation
import CoreData


extension Workout {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Workout> {
        return NSFetchRequest<Workout>(entityName: "Workout")
    }

    @NSManaged public var title: String?
    @NSManaged public var date: Date?
    @NSManaged public var exercises: NSSet?

}

// MARK: Generated accessors for exercises
extension Workout {

    @objc(addExercisesObject:)
    @NSManaged public func addToExercises(_ value: Exercise)

    @objc(removeExercisesObject:)
    @NSManaged public func removeFromExercises(_ value: Exercise)

    @objc(addExercises:)
    @NSManaged public func addToExercises(_ values: NSSet)

    @objc(removeExercises:)
    @NSManaged public func removeFromExercises(_ values: NSSet)

}

extension Workout : Identifiable {

}
