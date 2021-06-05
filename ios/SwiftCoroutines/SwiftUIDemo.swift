import SwiftUI
import Combine
import shared

class ThingModel: ObservableObject {
    @Published
    var thing: Thing = Thing(count: -1)
    
    var cancellables = Set<AnyCancellable>()
    
    init(_ repository: ThingRepository) {
        createPublisher(for: repository.getThingStreamNative(count: 100, succeed: true))
            .replaceError(with: Thing(count: -1))
            .receive(on: DispatchQueue.main)
            .sink { [weak self] thing in self?.thing = thing }
            .store(in: &cancellables)
    }
    
    func cancel() {
        cancellables.forEach { $0.cancel() }
    }
}

struct ThingView : View {
    @ObservedObject
    var thingModel: ThingModel
    
    init(_ repository: ThingRepository) {
        thingModel = ThingModel(repository)
    }
    
    var body: some View {
        Text("Count: \(thingModel.thing.count)")
            .onDisappear { thingModel.cancel() }
    }
}
