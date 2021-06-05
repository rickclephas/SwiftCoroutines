//
//  CombineWrappers.swift
//  SwiftCoroutines
//
//  Created by Russell Wolf on 2/28/21.
//  Copyright © 2021 Touchlab. All rights reserved.
//

import Foundation
import Combine

typealias NativeFlow<Output, Failure: Error, Unit> = (@escaping (Output, () -> Unit) -> Unit, @escaping (Failure?, () -> Unit) -> Unit) -> () -> Unit

func createPublisher<Output, Failure: Error, Unit>(for collect: @escaping NativeFlow<Output, Failure, Unit>) -> AnyPublisher<Output, Failure> {
    return Deferred<Publishers.HandleEvents<PassthroughSubject<Output, Failure>>> {
        let subject = PassthroughSubject<Output, Failure>()
        let cancel = collect({ item, result in
            subject.send(item)
            return result()
        }, { error, result in
            if let error = error {
                subject.send(completion: .failure(error))
            } else {
                subject.send(completion: .finished)
            }
            return result()
        })
        return subject.handleEvents(receiveCancel: {
            _ = cancel()
        })
    }.eraseToAnyPublisher()
}

typealias NativeSuspend<Output, Failure: Error, Unit> = (@escaping (Output, () -> Unit) -> Unit, @escaping (Failure, () -> Unit) -> Unit) -> () -> Unit

func createFuture<Output, Failure: Error, Unit>(for collect: @escaping NativeSuspend<Output, Failure, Unit>) -> AnyPublisher<Output, Failure> {
    return Deferred<Publishers.HandleEvents<Future<Output, Failure>>> {
        var cancel: (() -> Unit)? = nil
        return Future { promise in
            cancel = collect({ output, result in
                promise(.success(output))
                return result()
            }, { error, result in
                promise(.failure(error))
                return result()
            })
        }.handleEvents(receiveCancel: {
            _ = cancel?()
        })
    }.eraseToAnyPublisher()
}
