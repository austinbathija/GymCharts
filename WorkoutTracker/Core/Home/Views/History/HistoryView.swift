import SwiftUI

struct HistoryView: View {
    
    @Environment(\.managedObjectContext) private var viewContext
    @FetchRequest(sortDescriptors: [NSSortDescriptor(keyPath: \WorkoutEntity.date, ascending: false)], animation: .default)
    private var workoutEntities: FetchedResults<WorkoutEntity>

    // Define a custom struct to represent an entry in the history list
    struct HistoryEntry {
        let date: String
        let time: String
        let workout: Workout
    }
    
    // Create a computed property to convert fetched workout entities to Workout model
    var workouts: [Workout] {
        workoutEntities.map { workoutEntity in
            // Convert the fetched WorkoutEntity to Workout model
            Workout(
                title: workoutEntity.title ?? "Untitled Workout",
                exercises: workoutEntity.exercisesArray,
                date: workoutEntity.date ?? Date()
            )
        }
    }


    // Create a computed property to generate the sorted list of history entries
    var sortedWorkouts: [HistoryEntry] {
        // Flatten the nested dictionary and organize data into HistoryEntry structs using compactMap
        return workouts.compactMap { workout in
            // Map each workout to a HistoryEntry struct
            return HistoryEntry(date: workout.formattedDate, time: workout.formattedTime, workout: workout)
        }
    }

    var body: some View {
        NavigationView {
            VStack {
                if sortedWorkouts.isEmpty {
                    // Display a message if no history entries are available
                    Text("No History Yet")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                } else {
                    // Show a list of workouts organized by date and time
                    List {
                        // Loop through the sorted history entries and display them in sections
                        ForEach(sortedWorkouts, id: \.workout.id) { entry in
                            Section(header: sectionHeaderView(text: "\(entry.date) \(entry.time)")) {
                                // Show each workout within a section
                                NavigationLink(destination: WorkoutDetailView(workout: entry.workout)) {
                                    Text(entry.workout.title)
                                }
                            }
                        }
                    }
                    .listStyle(PlainListStyle())
                }
            }
        }
    }

    // Function to create a section header view with the given text
    private func sectionHeaderView(text: String) -> some View {
        Text(text)
            .foregroundColor(.gray)
            .font(.headline)
            .padding(.vertical, 8)
    }
}
