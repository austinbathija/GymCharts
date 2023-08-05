import SwiftUI

// The main view for the app's home screen
struct HomeView: View {
    // State variables for managing the selected tab and saved workouts
    @State private var currentPage: Tab = .history
    @State private var savedWorkouts: [Workout] = []
    
    // Enumeration to represent different tabs in the TabView
    enum Tab {
        case history
        case addWorkout
        case personalRecords
        case statistics
    }
    
    var body: some View {
        // TabView to display different content based on the selected tab
        TabView(selection: $currentPage) {
            // History tab
            HistoryView()
                .tabItem {
                    Label("History", systemImage: "clock")
                }
                .tag(Tab.history)

            // Add Workout tab
            AddWorkoutView(savedWorkouts: $savedWorkouts)
                .tabItem {
                    Label("Add Workout", systemImage: "plus.circle")
                }
                .tag(Tab.addWorkout)

            // Personal Records tab
            PersonalRecordsView()
                .tabItem {
                    Label("Personal Records", systemImage: "chart.bar.xaxis")
                }
                .tag(Tab.personalRecords)

            // Statistics tab
            StatisticsView()
                .tabItem {
                    Label("Statistics", systemImage: "chart.bar.fill")
                }
                .tag(Tab.statistics)
        }
    }
}

// Preview provider for the HomeView
struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
