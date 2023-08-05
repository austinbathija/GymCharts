import Charts
import SwiftUI

struct ExerciseChartView: View {
    let exerciseName: String
    let exerciseData: [ExerciseData]
    
    // UI properties
    @Environment(\.colorScheme) var scheme
    @State var currentActiveItem: ExerciseData?
    @State var plotWidth: CGFloat = 0
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        let isDarkMode = colorScheme == .dark
        
        if exerciseData.count >= 2 {
            
            VStack {
                
                VStack(alignment: .leading, spacing: 12) {
                    HStack {
                        Text(exerciseName)
                            .font(.title)
                            .fontWeight(.semibold)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding(.horizontal)
                    }
                }
                
                // Find the maximum weight for scaling
                let maxWeight = exerciseData.max { item1, item2 in
                    return item2.personalRecordWeight > item1.personalRecordWeight
                }?.personalRecordWeight ?? 0
                
                // Sort exercise data by date
                let sortedExerciseData = exerciseData.sorted { $0.date < $1.date }
                
                Chart {
                    ForEach(sortedExerciseData) { item in
                        // Line mark for weight data
                        LineMark(
                            x: .value("Date", item.date),
                            y: .value("Weight", item.personalRecordWeight)
                        )
                        .symbol(){
                            Circle()
                                .fill(.blue)
                                .frame(width:8, height:8)
                        }
                        .interpolationMethod(.catmullRom)
                        
                        // Area mark for weight data
                        AreaMark(
                            x: .value("Date", item.date),
                            y: .value("Weight", item.personalRecordWeight)
                        )
                        .foregroundStyle(
                            .linearGradient(
                                colors: isDarkMode ? [.blue, .clear] : [.clear, .blue], // Reverse the gradient colors
                                startPoint: .top,
                                endPoint: .bottom
                            )
                        )
                        .interpolationMethod(.catmullRom)
                        
                        // Rule mark to highlight the selected data point
                        if let currentActiveItem = currentActiveItem,
                           currentActiveItem.id == item.id {
                            RuleMark(x: .value("Date", currentActiveItem.date))
                                .lineStyle(.init(lineWidth: 2, miterLimit: 2, dash: [2], dashPhase: 5))
                                // Use the x value from the LineMark for accurate positioning
                                .offset(y: 10)
                                .annotation() {
                                    VStack(alignment: .leading, spacing: 6) {
                                        // Weight label and value
                                        Text("Weight")
                                            .font(.caption)
                                            .foregroundColor(.gray)
                                        Text("\(currentActiveItem.personalRecordWeight)")
                                            .font(.title3.bold())
                                        
                                        // Date label and value
                                        Text("Date")
                                            .font(.caption)
                                            .foregroundColor(.gray)
                                        Text(shortenDate(currentActiveItem.date))
                                            .font(.title3.bold())
                                    }
                                    .padding(.horizontal, 4)
                                    .background {
                                        RoundedRectangle(cornerRadius: 6, style: .continuous)
                                            .fill((scheme == .dark ? Color.black : Color.white).shadow(.drop(radius: 2)))
                                    }
                                    .padding(.bottom, -60)
                                }
                        }
                    }
                }
                .chartYAxis(){
                    AxisMarks(position: .leading)
                }
                .chartXAxis(.hidden)
                .frame(height: 250)
                .padding(.horizontal)
                .chartYScale(domain: 0...(Double(maxWeight) + 50))
                .chartOverlay(content: { proxy in
                    GeometryReader { innerProxy in
                        Rectangle()
                            .fill(.clear).contentShape(Rectangle())
                            .gesture(
                                DragGesture()
                                    .onChanged { value in
                                        // Getting current location
                                        let location = value.location
                                        // Extracting value from the location
                                        if let date: Date = proxy.value(atX: location.x) {
                                            if let currentItem = exerciseData.min(by: { abs($0.date.timeIntervalSince(date)) < abs($1.date.timeIntervalSince(date)) }) {
                                                self.currentActiveItem = currentItem
                                                self.plotWidth = proxy.plotAreaSize.width
                                            }
                                        }
                                    }
                                    .onEnded { value in
                                        self.currentActiveItem = nil
                                    }
                            )
                    }
                })
                .padding()
            }
        } else {
            VStack{
                Text(exerciseName)
                    .font(.title)
                    .fontWeight(.semibold)
                Text("More data required")
                    .font(.caption)
                    .fontWeight(.semibold)
                    .foregroundColor(.gray)
            }
            .frame(height: 200)
        }
    }
    
    // Format date for display
    private func shortenDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        formatter.timeStyle = .none
        return formatter.string(from: date)
    }

}
