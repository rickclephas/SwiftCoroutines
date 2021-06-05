import shared

class ThingRepositorySwiftCallbacks {
    private let delegate: ThingRepository
    
    init() {
        self.delegate = ThingRepository()
    }
    
    func getThing(
        succeed: Bool,
        onSuccess: @escaping (Thing) -> Void,
        onThrow: @escaping (Error) -> Void
    ) -> () -> Void {
        let cancel = delegate.getThingNative(succeed: succeed)({ output, result in
            onSuccess(output)
            return result()
        }, { error, result in
            onThrow(error)
            return result()
        })
        return { _ = cancel() }
    }
    
    func getThingStream(
        count: Int32,
        succeed: Bool,
        onEach: @escaping (Thing) -> Void,
        onComplete: @escaping () -> Void,
        onThrow: @escaping (Error) -> Void
    ) -> () -> Void {
        let cancel = delegate.getThingStreamNative(count: count, succeed: succeed)({ item, result in
            onEach(item)
            return result()
        }, { error, result in
            if let error = error {
                onThrow(error)
            } else {
                onComplete()
            }
            return result()
        })
        return { _ = cancel() }
    }

    func getOptionalThing(
        succeed: Bool,
        onSuccess: @escaping (Thing?) -> Void,
        onThrow: @escaping (Error) -> Void
    ) -> () -> Void {
        let cancel = delegate.getNullableThingNative(succeed: succeed)({ output, result in
            onSuccess(output)
            return result()
        }, { error, result in
            onThrow(error)
            return result()
        })
        return { _ = cancel() }
    }
    
    func getOptionalThingStream(
        count: Int32,
        succeed: Bool,
        onEach: @escaping (Thing?) -> Void,
        onComplete: @escaping () -> Void,
        onThrow: @escaping (Error) -> Void
    ) -> () -> Void {
        let cancel = delegate.getNullableThingStreamNative(count: count, succeed: succeed)({ item, result in
            onEach(item)
            return result()
        }, { error, result in
            if let error = error {
                onThrow(error)
            } else {
                onComplete()
            }
            return result()
        })
        return { _ = cancel() }
    }
    
    deinit {
        self.delegate.dispose()
    }
}
