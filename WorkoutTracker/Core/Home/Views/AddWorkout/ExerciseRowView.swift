import SwiftUI

struct ExerciseRow: View {
    // State variables to track editing status
    @State private var isEditingExercise = false
    @State private var editedExerciseName = ""
    @State private var editedSetsBeingAdded: [SetInfo] = []

    // Properties
    let index: Int
    @Binding var exercises: [Exercise]
    @Binding var exerciseSaved: Bool

    // Computed property to get the current exercise
    var exercise: Exercise? {
        guard index >= 0 && index < exercises.count else {
            return nil
        }
        return exercises[index]
    }

    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                if isEditingExercise {
                    // Display exercise name and sets in editable text fields
                    TextField("Exercise Name", text: $editedExerciseName)
                        .font(.headline)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .padding(.bottom, 4)

                    ForEach(editedSetsBeingAdded.indices, id: \.self) { setIndex in
                        HStack {
                            Text(editedSetsBeingAdded[setIndex].weight)
                                .textFieldStyle(RoundedBorderTextFieldStyle())
                            
                            Text(editedSetsBeingAdded[setIndex].reps)
                                .textFieldStyle(RoundedBorderTextFieldStyle())
                        }
                        .font(.subheadline)
                        .foregroundColor(.gray)
                    }
                } else {
                    // Display exercise name and sets as text
                    if let exercise = exercise { // Check if exercise is not nil
                        Text(exercise.name)
                            .font(.headline)
                            .padding(.bottom, 4)

                        ForEach(exercise.weightAndReps.indices, id: \.self) { setIndex in
                            HStack {
                                Text("Weight: \(exercise.weightAndReps[setIndex].weight)")
                                Text("Reps: \(exercise.weightAndReps[setIndex].reps)")
                            }
                            .font(.subheadline)
                            .foregroundColor(.gray)
                        }
                    }
                }
            }
            .padding()
            
            Spacer()

            Button(action: {
                if isEditingExercise {
                    saveEditedExercise()
                } else {
                    startEditingExercise()
                }
            }) {
                Image(systemName: isEditingExercise ? "checkmark.circle.fill" : "pencil.circle.fill")
                    .font(.title)
                    .foregroundColor(.white)
                    .padding(6) // Add padding to increase clickable area
                    .background(
                        Circle()
                            .fill(isEditingExercise ? Color.green : Color.blue)
                            .shadow(color: .black.opacity(0.2), radius: 8, x: 0, y: 4) // Add shadow effect
                    )
            }
            .buttonStyle(PlainButtonStyle())
        }
    }
    
    // Function to start editing the exercise
    private func startEditingExercise() {
        guard let exercise = exercise else { return }
        isEditingExercise = true
        editedExerciseName = exercise.name
        editedSetsBeingAdded = exercise.weightAndReps
    }
    
    // Function to save the edited exercise
    private func saveEditedExercise() {
        isEditingExercise = false
        guard var exercise = exercise else { return }
        exercise.name = editedExerciseName
        exercise.weightAndReps = editedSetsBeingAdded
        exercises[index] = exercise
    }
}
