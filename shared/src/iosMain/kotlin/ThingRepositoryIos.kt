package co.touchlab.example

import co.touchlab.swiftcoroutines.*
import kotlinx.coroutines.Job
import kotlinx.coroutines.cancelChildren

// Helps verify cancellation in tests
fun ThingRepository.countActiveJobs() =
    nativeCoroutineScope.coroutineContext[Job]?.children?.filter { it.isActive }?.count() ?: 0

fun ThingRepository.dispose() =
    nativeCoroutineScope.coroutineContext[Job]?.cancelChildren()

fun ThingRepository.getThingNative(succeed: Boolean) =
    nativeSuspend(nativeCoroutineScope) { getThing(succeed) }

fun ThingRepository.getThingStreamNative(count: Int, succeed: Boolean) =
    getThingStream(count, succeed).asNativeFlow(nativeCoroutineScope)

fun ThingRepository.getNullableThingNative(succeed: Boolean) =
    nativeSuspend(nativeCoroutineScope) { getNullableThing(succeed) }

fun ThingRepository.getNullableThingStreamNative(count: Int, succeed: Boolean) =
    getNullableThingStream(count, succeed).asNativeFlow(nativeCoroutineScope)