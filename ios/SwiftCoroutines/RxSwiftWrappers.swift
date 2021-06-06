//
//  RxSwiftWrappers.swift
//  SwiftCoroutines
//
//  Created by Russell Wolf on 6/10/20.
//  Copyright © 2020 Touchlab. All rights reserved.
//

import Foundation
import RxSwift

func createSingle<Output, Failure: Error, Unit>(for collect: @escaping NativeSuspend<Output, Failure, Unit>) -> Single<Output> {
    return Single<Output>.create { single in
        let cancel = collect({ output, unit in
            single(.success(output))
            return unit
        }, { error, unit in
            single(.error(error))
            return unit
        })
        return Disposables.create { _ = cancel() }
    }
}

func createObservable<Output, Failure: Error, Unit>(for collect: @escaping NativeFlow<Output, Failure, Unit>) -> Observable<Output> {
    return Observable<Output>.create { observer in
        let cancel = collect({ item, unit in
            observer.on(.next(item))
            return unit
        }, { error, unit in
            if let error = error {
                observer.on(.error(error))
            } else {
                observer.on(.completed)
            }
            return unit
        })
        return Disposables.create { _ = cancel() }
    }
}

