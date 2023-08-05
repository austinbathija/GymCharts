import Foundation
import CoreData

struct PreviousPersonalRecord: Codable {
    let exerciseName: String
    let personalWeight: Int
}

// Save previous personal records to UserDefaults
func savePreviousPersonalRecords(records: [PreviousPersonalRecord]) {
    let encoder = JSONEncoder()
    if let encodedData = try? encoder.encode(records) {
        UserDefaults.standard.set(encodedData, forKey: "PreviousPersonalRecords")
    }
}

// Retrieve previous personal records from UserDefaults
func getPreviousPersonalRecords() -> [PreviousPersonalRecord] {
    if let data = UserDefaults.standard.data(forKey: "PreviousPersonalRecords") {
        let decoder = JSONDecoder()
        if let records = try? decoder.decode([PreviousPersonalRecord].self, from: data) {
            return records
        }
    }
    return []
}

class PersonalRecordsHelper {
    static func updatePersonalRecords(from savedWorkouts: [Workout]) -> [(exercise: String, highestWeight: String, highestReps: String, dateAchieved: String, history: [ExerciseRecord])] {
        var personalRecordsDict: [String: [(weight: Int, reps: Int, dateAchieved: Date)]] = [:]

        // Iterate through each workout
        for workout in savedWorkouts {
            // Iterate through each exercise in the workout
            for exercise in workout.exercises {
                // Check if the exercise exists in the personalRecordsDict
                if let existingRecords = personalRecordsDict[exercise.name] {
                    // Get the new weight and reps achieved in this workout
                    guard let newWeight = Int(exercise.highestWeight), let newReps = Int(exercise.highestReps) else {
                        continue // Skip this exercise if the data is invalid
                    }

                    // Compare with the existing personal record and update if necessary
                    if let lastRecord = existingRecords.last {
                        if newWeight > lastRecord.weight {
                            personalRecordsDict[exercise.name]?.append((weight: newWeight, reps: newReps, dateAchieved: workout.date))
                        } else if newWeight == lastRecord.weight, newReps > lastRecord.reps {
                            personalRecordsDict[exercise.name]?.append((weight: lastRecord.weight, reps: newReps, dateAchieved: workout.date))
                        }
                    }
                } else {
                    // Add the new exercise and its personal record to the dictionary
                    if let newWeight = Int(exercise.highestWeight), let newReps = Int(exercise.highestReps) {
                        personalRecordsDict[exercise.name] = [(weight: newWeight, reps: newReps, dateAchieved: workout.date)]
                    }
                }
            }
        }

        // Format and return the personal records
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium

        let personalRecordsWithDate: [(exercise: String, highestWeight: String, highestReps: String, dateAchieved: String, history: [ExerciseRecord])] = personalRecordsDict.compactMap { (exerciseName, records) -> (String, String, String, String, [ExerciseRecord])? in
            guard let lastRecord = records.last else {
                return nil // Skip exercises without records
            }

            let history: [ExerciseRecord] = records.map { record in
                return ExerciseRecord(weight: String(record.weight), reps: String(record.reps), dateAchieved: dateFormatter.string(from: record.dateAchieved))
            }

            return (exerciseName, String(lastRecord.weight), String(lastRecord.reps), dateFormatter.string(from: lastRecord.dateAchieved), history)
        }

        return personalRecordsWithDate
    }
}
