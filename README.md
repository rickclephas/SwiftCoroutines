### Swift/Coroutines interop

> :memo: checkout [KMP-NativeCoroutines](https://github.com/rickclephas/KMP-NativeCoroutines)! A Library to use Kotlin Coroutines from Swift code in KMP apps.  
> It uses the same principles to provide interoperability with RxSwift, Combine and Swift 5.5 Async/Await.

Slightly modified version of [the code](https://github.com/touchlab/SwiftCoroutines) from [@russhwolf](https://github.com/russhwolf) 
his [blog post](https://dev.to/touchlab/kotlin-coroutines-and-swift-revisited-j5h) 
on Coroutines and Swift interop. 

It uses generics and closures to decouple the Swift code from the Kotlin code.

The `shared` directory contains Kotlin code, including the common `ThingRepository` and the extension functions 
for iOS in `ThingRepositoryIos.kt`, which makes use of interop utilities in `SwiftCoroutines.kt`.

To use the `ThingRepository.getThingStream` function with Swift Combine the following 
extension function is available in the iOS Kotlin source:
```kotlin
fun ThingRepository.getThingStreamNative(count: Int, succeed: Boolean) =
    getThingStream(count, succeed).asNativeFlow(nativeCoroutineScope)
```
Ideally these native extension functions would be autogenerated 😇.

Then from Swift (to get a Combine publisher) it's almost as simple as calling the extension function:
```swift
createPublisher(for: repository.getThingStreamNative(count: 10, succeed: true))
```
