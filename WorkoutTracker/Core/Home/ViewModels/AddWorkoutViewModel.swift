import SwiftUI

// ViewModel for adding a workout
class AddWorkoutViewModel: ObservableObject {
    // Published properties for managing UI state
    @Published var workoutTitle = "Untitled Workout"
    @Published var exercises: [Exercise] = []
    @Published var exerciseName = ""
    @Published var setsBeingAdded: [SetInfo] = [SetInfo(weight: "", reps: "")]
    @Published var showDeleteButtons = false
    @Published var exerciseSaved = false
    @Published var showAlert = false
    @Published var isEditing = false
    
    private var debouncer: Debouncer?

    
    // Reference to the Core Data persistence controller
    private let persistenceController = PersistenceController.shared

    func addSet() {
        setsBeingAdded.append(SetInfo(weight: "", reps: ""))
        showDeleteButtons = true
    }

    func addExercise() {
        print(setsBeingAdded)
        
        if setsBeingAdded.count == 1 {
            // Hide the keyboard if not clicking "Add Set"
            UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
        }

        if !exerciseName.isEmpty {
            // Create a new exercise
            let newExercise = Exercise(
                name: exerciseName,
                weightAndReps: setsBeingAdded,
                personalRecordDate: Date(),
                personalRecordWeight: 0,
                personalRecordReps: 0
            )
            exercises.append(newExercise)
            exerciseSaved = true
            
            isEditing = true

            // Reset showDeleteButtons when adding an exercise
            showDeleteButtons = false
        }

        // Clear input fields after adding exercise
        exerciseName = ""
        isEditing = false
    }
    
    // Function to reset the setsBeingAdded array
    func resetSetsBeingAdded() {
        setsBeingAdded = [SetInfo(weight: "", reps: "")]
    }

    // Function to delete a set from the exercise
    func deleteSet(at index: Int) {
        setsBeingAdded.remove(at: index)
    }

    // Function to save the workout to Core Data
    func saveWorkout(savedWorkouts: inout [Workout]) {
        let context = persistenceController.container.viewContext
        let workoutEntity = WorkoutEntity(context: context)
        
        if !workoutTitle.isEmpty && !exercises.isEmpty {
            // Create a new workout
            let newWorkout = Workout(title: workoutTitle, exercises: exercises, date: Date())
            savedWorkouts.append(newWorkout)
            
            // Update workoutEntity properties
            workoutEntity.title = workoutTitle
            workoutEntity.date = Date()

            for exercise in exercises {
                let exerciseEntity = ExerciseEntity(context: context)
                exerciseEntity.name = exercise.name

                // Add sets to the exercise entity
                for setInfo in exercise.weightAndReps {
                    let setEntity = SetInfoEntity(context: context)
                    setEntity.weight = setInfo.weight
                    setEntity.reps = setInfo.reps

                    exerciseEntity.addToSets(setEntity)
                }
                
                // Update personal record properties for the exercise entity
                let highestWeight = Int16(exercise.highestWeight) ?? 0
                let highestReps = Int16(exercise.highestReps) ?? 0
                exerciseEntity.personalRecordWeight = highestWeight
                exerciseEntity.personalRecordDate = Date()
                exerciseEntity.personalRecordReps = highestReps

                // Save exercise entity
                do {
                    try exerciseEntity.managedObjectContext?.save()
                    print("Personal record updated successfully!")
                } catch {
                    print("Error updating personal record: \(error.localizedDescription)")
                }
                
                // Add exercise entity to the workout entity
                workoutEntity.addToExercises(exerciseEntity)
            }

            // Save workout entity
            do {
                try context.save()
                print("Workout saved successfully!")
            } catch {
                print("Error saving workout: \(error.localizedDescription)")
            }
            
            // Clear properties after saving
            exercises = []
            exerciseSaved = false
            workoutTitle = "Untitled Workout"
            
        } else {
            showAlert = true
        }
    }
}
