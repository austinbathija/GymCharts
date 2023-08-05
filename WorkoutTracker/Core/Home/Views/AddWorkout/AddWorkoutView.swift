import SwiftUI

struct AddWorkoutView: View {
    @Binding var savedWorkouts: [Workout]
    @ObservedObject var viewModel = AddWorkoutViewModel()
    
    @Environment(\.colorScheme) var colorScheme

    var body: some View {
        NavigationView {
            ZStack {
                VStack {
                    HStack {
                        // Text field for entering workout title
                        TextField("Workout Title", text: $viewModel.workoutTitle)
                            .font(.title)
                            .padding()
                            .padding(.horizontal)
                            .padding(.top, 20)
                        Spacer()
                    }

                    // List of exercises and sets
                    List {
                        ForEach(viewModel.exercises.indices, id: \.self) { index in
                            // ExerciseRow displays each exercise's sets
                            ExerciseRow(viewModel: viewModel, index: index, exercises: $viewModel.exercises, exerciseSaved: $viewModel.exerciseSaved)
                        }
                        
                        .onDelete { indexSet in
                            viewModel.exercises.remove(atOffsets: indexSet)
                        }
                        .onMove { indices, newOffset in
                            viewModel.exercises.move(fromOffsets: indices, toOffset: newOffset)
                        }
                        .listStyle(PlainListStyle())
                        .listRowBackground(colorScheme == .dark ? Color(#colorLiteral(red: 0.05311966687, green: 0.05311966687, blue: 0.05311966687, alpha: 1)) : Color.white)
                        
                        // View for adding new exercises and sets
                        VStack {
                            // Text field for entering exercise name
                            TextField("Exercise Name", text: $viewModel.exerciseName)
                                .textFieldStyle(LighterBorderTextFieldStyleTitle()) // Apply the custom style
                                .padding()
                                .fontWeight(.medium) // Set the font size to .title

                            // Loop through sets being added
                            ForEach(viewModel.setsBeingAdded.indices, id: \.self) { index in
                                let _ = print("Index", index)
                                HStack {
                                    // Text field for entering weight
                                    TextField("Weight", text: $viewModel.setsBeingAdded[index].weight)
                                        .textFieldStyle(LighterBorderTextFieldStyle()) // Apply the custom style
                                        .keyboardType(.numberPad)
                                    
                                    // Text field for entering reps
                                    TextField("Reps", text: $viewModel.setsBeingAdded[index].reps)
                                        .textFieldStyle(LighterBorderTextFieldStyle()) // Apply the custom style
                                        .keyboardType(.numberPad)

                                    // Button to delete set
                                    if index > 0 && viewModel.showDeleteButtons {
                                        Button(action: { viewModel.deleteSet(at: index) }) {
                                            Image(systemName: "minus.circle.fill")
                                                .font(.title)
                                                .foregroundColor(.red)
                                        }
                                        .buttonStyle(PlainButtonStyle())
                                    }
                                    let _ = print("G", index)
                                }
                                .padding(.horizontal)
                                .padding(.vertical, 8) // Set a custom vertical padding value
                            }
                            .onChange(of: viewModel.exercises) { _ in
                                viewModel.resetSetsBeingAdded() // Reset the setsBeingAdded array.
                            }
                            
                            // Button to add a new set
                            Button(action: viewModel.addSet) {
                                Text("Add Set")
                                    .foregroundColor(.blue)
                            }
                            .padding()
                            .buttonStyle(PlainButtonStyle())

                            // Button to add a new exercise
                            Button(action: {
                                if viewModel.setsBeingAdded.count == 1 {
                                    // Hide the keyboard if not clicking "Add Set"
                                    UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
                                }
                                viewModel.addExercise()

                            }) {
                                HStack {
                                    Image(systemName: "plus.circle.fill")
                                        .font(.title)
                                        .foregroundColor(.white)
                                    
                                    Text("Add Exercise")
                                        .foregroundColor(.white)
                                        .fontWeight(.bold)
                                }
                                .padding(.horizontal, 16)
                                .padding(.vertical, 8)
                                .background(
                                    RoundedRectangle(cornerRadius: 15)
                                        .fill(Color.blue)
                                )
                                .padding(.bottom, 8)

                            }
                            .buttonStyle(PlainButtonStyle())
                        }
                        .listRowBackground(colorScheme == .dark ? Color(#colorLiteral(red: 0.05311966687, green: 0.05311966687, blue: 0.05311966687, alpha: 1)) : Color.white)
                    }
                    
                    Spacer()

                    // "Save Workout" button
                    if !viewModel.isEditing {
                        Button(action: {
                            viewModel.saveWorkout(savedWorkouts: &savedWorkouts)
                        }) {
                            Text("Save Workout")
                                .font(.title3)
                                .fontWeight(.medium)
                                .foregroundColor(.white)
                                .frame(maxWidth: .infinity)
                                .frame(height: 60)
                                .background(Color.blue)
                                .cornerRadius(20)
                        }
                        .frame(maxWidth: .infinity)
                        .padding()
                        .buttonStyle(BorderlessButtonStyle())
                    }
                }
                .navigationBarTitleDisplayMode(.inline) // Hide navigation bar title
                .navigationBarHidden(true) // Hide navigation bar
                
            }
            
            // Show an alert for input errors
            .alert(isPresented: $viewModel.showAlert) {
                Alert(title: Text("Error"), message: Text("All fields must be entered."), dismissButton: .default(Text("OK"), action: {
                }))
            }
            
            // Listen to keyboard show/hide events
            .onReceive(NotificationCenter.default.publisher(for: UIResponder.keyboardWillShowNotification)) { notification in
                if !viewModel.isEditing {
                    viewModel.isEditing = true
                }
            }

            .onReceive(NotificationCenter.default.publisher(for: UIResponder.keyboardWillHideNotification)) { notification in
                if viewModel.isEditing {
                    viewModel.isEditing = false
                }
            }
        }
        .navigationViewStyle(StackNavigationViewStyle())
    }
}

// Custom text field style with lighter border
struct LighterBorderTextFieldStyle: TextFieldStyle {
    @Environment(\.colorScheme) var colorScheme

    func _body(configuration: TextField<Self._Label>) -> some View {
        configuration
            .padding(.horizontal)
            .padding(.vertical, 8)
            .background(
                RoundedRectangle(cornerRadius: 8)
                    .stroke(colorScheme == .dark ? Color(.systemGray6) : Color(.systemGray6), lineWidth: 1) // Adjust border color
            )
    }
}

// Custom text field style with lighter border (for titles)
struct LighterBorderTextFieldStyleTitle: TextFieldStyle {
    @Environment(\.colorScheme) var colorScheme

    func _body(configuration: TextField<Self._Label>) -> some View {
        configuration
            .padding(.horizontal)
            .padding(.vertical, 15)
            .background(
                RoundedRectangle(cornerRadius: 10)
                    .stroke(colorScheme == .dark ? Color(.systemGray6) : Color(.systemGray6), lineWidth: 1) // Adjust border color
            )
    }
}

struct AddWorkoutView_Previews: PreviewProvider {
    static var previews: some View {
        let dummyBinding: Binding<[Workout]> = Binding.constant([])
        return AddWorkoutView(savedWorkouts: dummyBinding)
            .preferredColorScheme(.dark) // Preview in Dark Mode
    }
}
