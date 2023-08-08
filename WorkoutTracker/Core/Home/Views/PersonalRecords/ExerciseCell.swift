//
//  ExerciseCell.swift
//  WorkoutTracker
//
//  Created by Austin  on 8/3/23.
//

import SwiftUI

struct ExerciseCell: View {
    var exercise: ExerciseEntity
    
    // Dark/Light mode color scheme
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        let isDarkMode = colorScheme == .dark
        let backgroundColor = isDarkMode ? Color.clear : Color(.systemBackground)
        
        var backgroundView: AnyView
        
        if isDarkMode {
            // Dark mode background gradient
            backgroundView = AnyView(
                LinearGradient(gradient: Gradient(stops: [.init(color: Color.blue.opacity(1.0), location: 0),
                                                          .init(color: Color.clear, location: 1.1)]), startPoint: .top, endPoint: .bottom)
            )
        } else {
            // Light mode background color
            backgroundView = AnyView(backgroundColor)
        }
        
        return VStack(alignment: .leading, spacing: 8) {
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text(exercise.name ?? "")
                        .padding(.top, 10)
                        .font(.title2)
                        .fontWeight(.semibold)
                        .foregroundColor(isDarkMode ? .white : .black)
                    
                    if let prDate = exercise.personalRecordDate {
                        Text("PR Date: \(formattedDate(prDate))")
                            .font(.subheadline)
                            .foregroundColor(isDarkMode ? .white : .black)
                    }
                }
                
                Spacer() // To push the PR weight and reps to the right
            }
            
            if !isDarkMode {
                // Divider for light mode
                Divider()
                    .background(Color.black.opacity(0.3))
                    .padding(.vertical, 8)
            } else {
                // Spacer for dark mode
                Spacer()
                    .frame(height: 10)
            }
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    // Personal record weight label
                    Text("PR Weight")
                        .font(.subheadline)
                        .foregroundColor(isDarkMode ? .white : .black)
                    // Personal record weight value
                    Text("\(exercise.personalRecordWeight)")
                        .font(.title3)
                        .foregroundColor(isDarkMode ? .white : .black)
                }
                Spacer()
                VStack(alignment: .trailing, spacing: 4) {
                    // Personal record reps label
                    Text("PR Reps")
                        .font(.subheadline)
                        .foregroundColor(isDarkMode ? .white : .black)
                    // Personal record reps value
                    Text("\(exercise.personalRecordReps)")
                        .font(.title3)
                        .foregroundColor(isDarkMode ? .white : .black)
                }
            }
        }
        .padding()
        .padding(.horizontal)
        .background(backgroundView)
        .cornerRadius(20)
        .shadow(color: isDarkMode ? Color.clear : Color.blue.opacity(0.3), radius: 5, x: 0, y: 2) // Add subtle shadow for light mode
    }
    
    // Function to format date as string
    private func formattedDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        formatter.timeStyle = .none
        return formatter.string(from: date)
    }
}
