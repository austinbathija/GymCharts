import SwiftUI
import Combine

struct ExerciseRow: View {
    // State variables to track editing status
    @State private var isEditingExercise = false
    @State private var editedExerciseName = ""
    @State private var editedSetsBeingAdded: [SetInfo] = []
    
    @ObservedObject var viewModel: AddWorkoutViewModel

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

    // Computed property to get the edited sets being added
    var currentEditedSets: [SetInfo] {
        if isEditingExercise {
            return editedSetsBeingAdded
        } else if let exercise = exercise {
            return exercise.weightAndReps
        } else {
            return []
        }
    }

    let debouncer = Debouncer(interval: 0.5) {
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

                    ForEach(currentEditedSets.indices, id: \.self) { setIndex in
                        HStack {
                            TextField("Weight", text: $editedSetsBeingAdded[setIndex].weight)
                                .textFieldStyle(RoundedBorderTextFieldStyle())
                                .keyboardType(.numberPad)
                                .onReceive(Just(editedSetsBeingAdded[setIndex].weight)) { _ in
                                    debouncer.debounce()
                                }

                            TextField("Reps", text: $editedSetsBeingAdded[setIndex].reps)
                                .textFieldStyle(RoundedBorderTextFieldStyle())
                                .keyboardType(.numberPad)
                                .onReceive(Just(editedSetsBeingAdded[setIndex].reps)) { _ in
                                    debouncer.debounce()
                                }
                        }
                        .font(.subheadline)
                        .foregroundColor(.gray)
                    }
                } else {
                    // Display exercise name and sets as text
                    if let exercise = exercise {
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
                    .padding(6)
                    .background(
                        Circle()
                            .fill(isEditingExercise ? Color.green : Color.blue)
                            .shadow(color: .black.opacity(0.2), radius: 8, x: 0, y: 4)
                    )
            }
            .buttonStyle(PlainButtonStyle())
        }
        .onAppear {
            if isEditingExercise {
                saveEditedExercise()
            }
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
