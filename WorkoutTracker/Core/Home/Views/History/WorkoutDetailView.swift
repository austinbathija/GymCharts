import SwiftUI

// View to display the details of a workout
struct WorkoutDetailView: View {
    var workout: Workout // The workout to display
    
    var body: some View {
        List {
            // Loop through each exercise in the workout
            ForEach(workout.exercises) { exercise in
                // Vertical stack for exercise information
                VStack(alignment: .leading, spacing: 10) {
                    // Display exercise name
                    Text(exercise.name)
                        .font(.title3)
                        .foregroundColor(.primary)
                        .padding(.horizontal)

                    // Loop through each set in the exercise
                    ForEach(exercise.weightAndReps) { set in
                        // Horizontal stack for set details (weight and reps)
                        HStack {
                            Text("Weight: \(set.weight)")
                                .foregroundColor(.secondary)
                            Spacer() // Add space between Weight and Reps
                            Text("Reps: \(set.reps)")
                                .foregroundColor(.secondary)
                        }
                        .padding(.horizontal)
                    }
                }
                .padding(.vertical, 20)
                .padding(.horizontal)
                .listRowInsets(EdgeInsets())
            }
        }
        .listStyle(PlainListStyle())
        .navigationBarTitle(workout.title) // Set navigation bar title to workout title
        .padding(.top, 30)
        .padding(.horizontal, 20)
    }
}
