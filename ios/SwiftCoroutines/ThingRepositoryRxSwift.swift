//
//  ThingRepositorySwift.swift
//  SwiftCoroutines
//
//  Created by Russell Wolf on 4/29/21.
//  Copyright © 2021 Touchlab. All rights reserved.
//

import shared
import RxSwift

class ThingRepositoryRxSwift {
    private let delegate: ThingRepository
    
    init() {
        self.delegate = ThingRepository()
    }
    
    func getThing(succeed: Bool) -> Single<Thing> {
        createSingle(for: delegate.getThingNative(succeed: succeed))
    }

    func getThingStream(count: Int32, succeed: Bool) -> Observable<Thing> {
        createObservable(for: delegate.getThingStreamNative(count: count, succeed: succeed))
    }

    func getOptionalThing(succeed: Bool) -> Single<Thing?> {
        createSingle(for: delegate.getNullableThingNative(succeed: succeed))
    }

    func getOptionalThingStream(count: Int32, succeed: Bool) -> Observable<Thing?> {
        createObservable(for: delegate.getNullableThingStreamNative(count: count, succeed: succeed))
    }
    
    func countActiveJobs() -> Int32 {
        delegate.countActiveJobs()
    }
    
    deinit {
        self.delegate.dispose()
    }
}
