import Foundation

// Structure to represent a single exercise record
struct ExerciseRecord: Hashable {
    let weight: String
    let reps: String
    let dateAchieved: String
}

// Structure to represent information about a single set in an exercise
struct SetInfo: Hashable, Identifiable {
    var id = UUID()
    var weight: String
    var reps: String
}

// Structure to represent an exercise
struct Exercise: Identifiable, Equatable {
    let id = UUID()
    var name: String
    var weightAndReps: [SetInfo]
    let personalRecordDate: Date? // Date of achieving personal record
    var personalRecordWeight: Int
    var personalRecordReps: Int
    
    // Equatable conformance to compare exercises based on properties
    static func == (lhs: Exercise, rhs: Exercise) -> Bool {
        return lhs.id == rhs.id
            && lhs.name == rhs.name
            && lhs.weightAndReps == rhs.weightAndReps
    }
    
    // Calculate the highest weight lifted among all sets
    var highestWeight: String {
        let sortedWeights = weightAndReps.map { Int($0.weight) ?? 0 }.sorted(by: >)
        return sortedWeights.first.flatMap { String($0) } ?? ""
    }

    // Calculate the highest reps count among all sets
    var highestReps: String {
        let sortedReps = weightAndReps.map { Int($0.reps) ?? 0 }.sorted(by: >)
        return sortedReps.first.flatMap { String($0) } ?? ""
    }
}

// Structure to represent a workout
struct Workout: Identifiable {
    let id = UUID()
    var title: String
    var exercises: [Exercise]
    var date: Date // Date when the workout was saved

    // Formatted time for the workout
    var formattedTime: String {
        let dateFormatter = DateFormatter()
        dateFormatter.timeStyle = .short
        return dateFormatter.string(from: date)
    }
    
    // Formatted date for the workout
    var formattedDate: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        return dateFormatter.string(from: date)
    }

    // Equatable conformance to compare workouts based on properties
    static func == (lhs: Workout, rhs: Workout) -> Bool {
        return lhs.id == rhs.id
            && lhs.title == rhs.title
            && lhs.exercises == rhs.exercises
            && lhs.date == rhs.date
    }
    
    // Calculate the highest weight and reps achieved across all exercises
    var highestWeightsAndReps: [String: (weight: String, reps: String, dateAchieved: Date)] {
        var highestValues: [String: (weight: String, reps: String, dateAchieved: Date)] = [:]

        for exercise in exercises {
            let highestWeight = exercise.highestWeight
            let highestReps = exercise.highestReps

            if !highestWeight.isEmpty || !highestReps.isEmpty {
                highestValues[exercise.name] = (weight: highestWeight, reps: highestReps, dateAchieved: Date())
            }
        }
        
        return highestValues
    }
}
