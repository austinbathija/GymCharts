import CoreData

class PersistenceController {
    static let shared = PersistenceController()

    // The persistent container for the application
    let container: NSPersistentContainer

    init() {
        container = NSPersistentContainer(name: "WorkoutTrackerModel")
        container.loadPersistentStores { description, error in
            if let error = error {
                fatalError("Error setting up Core Data: \(error.localizedDescription)")
            }
        }
    }
}

import Foundation

class DataManager {
    static let shared = DataManager() // Singleton instance

    let container: NSPersistentContainer

    init() {
        container = NSPersistentContainer(name: "YourDataModelName") // Replace "YourDataModelName" with the actual name of your data model
        container.loadPersistentStores { description, error in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        }
    }

    func saveContext() {
        let context = container.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nsError = error as NSError
                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
            }
        }
    }

    // Add CRUD operations and other methods as needed
    // For example: fetchWorkouts(), createWorkout(), updateWorkout(), deleteWorkout(), etc.
}

extension WorkoutEntity {
    var exercisesArray: [Exercise] {
        let exercises = exercises?.allObjects as? [ExerciseEntity] ?? []
        return exercises.map { exerciseEntity in
            Exercise(
                name: exerciseEntity.name ?? "",
                weightAndReps: exerciseEntity.setsArray,
                personalRecordDate: exerciseEntity.personalRecordDate,
                personalRecordWeight: Int(exerciseEntity.personalRecordWeight),
                personalRecordReps: Int(exerciseEntity.personalRecordReps)
            )
        }
    }
}

extension ExerciseEntity {

    var setsArray: [SetInfo] {
        let sets = sets?.allObjects as? [SetInfoEntity] ?? []
        return sets.map { setEntity in
            SetInfo(weight: setEntity.weight ?? "", reps: setEntity.reps ?? "")
        }
    }
}
