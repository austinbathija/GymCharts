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
    
    // Function to add a new set
    private func addSet() {
        editedSetsBeingAdded.append(SetInfo(weight: "", reps: ""))
    }
    
    // Function to remove a set
    private func removeSet(at index: Int) {
        guard editedSetsBeingAdded.indices.contains(index) else {
            return
        }
        editedSetsBeingAdded.remove(at: index)
    }

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
                    
                    HStack{
                        // Display exercise name and sets in editable text fields
                        TextField("Exercise Name", text: $editedExerciseName)
                            .font(.headline)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .padding(.bottom, 4)
                    }

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

                    // Add Set Button
                    Button(action: {
                        addSet()
                    }) {
                        Text("Add Set")
                            .foregroundColor(.blue)
                    }
                    .buttonStyle(PlainButtonStyle())
                    .frame(maxWidth: .infinity, alignment: .center) // Center the button horizontally
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

            }
    }
}
