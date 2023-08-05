import SwiftUI
import CoreData
import Charts

// Custom structure to hold exercise data
struct ExerciseData: Identifiable {
    var id = UUID()
    var date: Date
    var personalRecordWeight: Int16
    @State var animate: Bool = false

    init(date: Date, weight: Int16) {
        self.date = date
        self.personalRecordWeight = weight
    }
}

struct StatisticsView: View {
    // Core Data managed object context
    @Environment(\.managedObjectContext) private var viewContext
    
    // Fetch exercise entities sorted by name
    @FetchRequest(sortDescriptors: [NSSortDescriptor(keyPath: \ExerciseEntity.name, ascending: true)])
    private var exerciseEntities: FetchedResults<ExerciseEntity>
    
    // Filtered data for Bench Press exercise
    var benchPressData: [ExerciseData] {
        exerciseEntities
            .filter { $0.name == "Bench Press" }
            .map { entity in
                ExerciseData(date: entity.personalRecordDate ?? Date(), weight: entity.personalRecordWeight)
            }
    }
    
    // Filtered data for Squat exercise
    var squatData: [ExerciseData] {
        exerciseEntities
            .filter { $0.name == "Squat" }
            .map { entity in
                ExerciseData(date: entity.personalRecordDate ?? Date(), weight: entity.personalRecordWeight)
            }
    }
    
    // Filtered data for Deadlift exercise
    var deadliftData: [ExerciseData] {
        exerciseEntities
            .filter { $0.name == "Deadlift" }
            .map { entity in
                ExerciseData(date: entity.personalRecordDate ?? Date(), weight: entity.personalRecordWeight)
            }
    }
    
    var body: some View {
        ScrollView {
            VStack(spacing: 25) {
                // Display exercise charts with filtered data
                ExerciseChartView(exerciseName: "Bench Press", exerciseData: benchPressData)
                    .padding(.top)
                Divider()
                ExerciseChartView(exerciseName: "Squat", exerciseData: squatData)
                Divider()
                ExerciseChartView(exerciseName: "Deadlift", exerciseData: deadliftData)
            }
        }
    }
}

struct StatisticsView_Previews: PreviewProvider {
    static var previews: some View {
        let context = PersistenceController.shared.container.viewContext
        
        // Create some dummy exercise entities with sample data
        let benchPressEntity = ExerciseEntity(context: context)
        benchPressEntity.name = "Bench Press"
        benchPressEntity.personalRecordDate = Date()
        benchPressEntity.personalRecordWeight = 185
        
        let squatEntity = ExerciseEntity(context: context)
        squatEntity.name = "Squat"
        squatEntity.personalRecordDate = Date()
        squatEntity.personalRecordWeight = 225
        
        let deadliftEntity = ExerciseEntity(context: context)
        deadliftEntity.name = "Deadlift"
        deadliftEntity.personalRecordDate = Date()
        deadliftEntity.personalRecordWeight = 315
        
        // Save the context
        do {
            try context.save()
        } catch {
            // Handle the error
            fatalError("Error saving preview context: \(error)")
        }
        
        return StatisticsView()
            .environment(\.managedObjectContext, context)
            //.preferredColorScheme(.dark) // Set preferred color scheme to Dark Mode
    }
}
