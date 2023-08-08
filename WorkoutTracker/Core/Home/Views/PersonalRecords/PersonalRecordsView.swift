import SwiftUI
import CoreData

struct PersonalRecordsView: View {
    // Core Data managed object context
    @Environment(\.managedObjectContext) private var viewContext
    
    // Dark/Light mode color scheme
    @Environment(\.colorScheme) var colorScheme
    
    // Fetching ExerciseEntity records with sorting
    @FetchRequest(sortDescriptors: [NSSortDescriptor(keyPath: \ExerciseEntity.name, ascending: true)])
    private var exercises: FetchedResults<ExerciseEntity>
    
    var body: some View {
        // Filter and sort exercises
        let filteredExercises = filterExercises(exercises: exercises)
        
        if filteredExercises.isEmpty {
            Text("No Personal Records Yet")
                .font(.title)
                .fontWeight(.bold)
        } else {
            // Display filtered exercises in a list
            List(filteredExercises) { exercise in
                ExerciseCell(exercise: exercise)
                    .padding(.vertical, 10)
                    .background(Color.clear)
                    .listRowBackground(Color.clear)
            }
            .cornerRadius(20)
        }
    }
    
    // Filter and select personal records for each exercise
    private func filterExercises(exercises: FetchedResults<ExerciseEntity>) -> [ExerciseEntity] {
        var exerciseDict: [String: ExerciseEntity] = [:]
        
        for exercise in exercises {
            guard let name = exercise.name else { continue }
            
            // Higher than 0 reps
            if exercise.personalRecordReps > 0 {
                if let existingExercise = exerciseDict[name] {
                    // Check if the current exercise has a higher weight and reps
                    let currentWeight = exercise.personalRecordWeight
                    let existingWeight = existingExercise.personalRecordWeight
                    let currentReps = exercise.personalRecordReps
                    let existingReps = existingExercise.personalRecordReps
                    
                    if currentWeight > existingWeight || (currentWeight == existingWeight && currentReps > existingReps) {
                        exerciseDict[name] = exercise
                    }
                    
                } else {
                    exerciseDict[name] = exercise
                }
            }
        }
        
        // Convert the dictionary back to an array and sort it by exercise name
        let sortedExercises = exerciseDict.values.sorted { $0.name ?? "" < $1.name ?? "" }
        return sortedExercises
    }

}
