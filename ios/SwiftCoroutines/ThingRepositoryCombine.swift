//
//  ThingRepositorySwift.swift
//  SwiftCoroutines
//
//  Created by Russell Wolf on 4/29/21.
//  Copyright © 2021 Touchlab. All rights reserved.
//

import shared
import Combine

class ThingRepositoryCombine {
    private let delegate: ThingRepository
    
    init() {
        delegate = ThingRepository()
    }
    
    func getThing(succeed: Bool) -> AnyPublisher<Thing, Error> {
        createFuture(for: delegate.getThingNative(succeed: succeed))
    }

    func getThingStream(count: Int32, succeed: Bool) -> AnyPublisher<Thing, Error> {
        createPublisher(for: delegate.getThingStreamNative(count: count, succeed: succeed))
    }

    func getOptionalThing(succeed: Bool) -> AnyPublisher<Thing?, Error> {
        createFuture(for: delegate.getNullableThingNative(succeed: succeed))
    }

    func getOptionalThingStream(count: Int32, succeed: Bool) -> AnyPublisher<Thing?, Error> {
        createPublisher(for: delegate.getNullableThingStreamNative(count: count, succeed: succeed))
    }
    
    func countActiveJobs() -> Int32 {
        delegate.countActiveJobs()
    }
    
    deinit {
        delegate.dispose()
    }
}
