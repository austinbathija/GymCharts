import SwiftUI
import Combine

struct DebounceView<Content: View>: View {
    private let content: Content
    private let dueTime: DispatchQueue.SchedulerTimeType.Stride
    private let action: () -> Void
    
    init(
        dueTime: DispatchQueue.SchedulerTimeType.Stride,
        action: @escaping () -> Void,
        @ViewBuilder content: () -> Content
    ) {
        self.dueTime = dueTime
        self.action = action
        self.content = content()
    }
    
    var body: some View {
        content
            .onReceive(debouncePublisher, perform: action)
    }
    
    private var debouncePublisher: AnyPublisher<Void, Never> {
        let source = PassthroughSubject<Void, Never>()
        return source
            .debounce(for: dueTime, scheduler: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
}
