package co.touchlab.swiftcoroutines

import kotlinx.coroutines.CoroutineScope
import kotlinx.coroutines.flow.*
import kotlinx.coroutines.launch
import platform.Foundation.NSError
import platform.Foundation.NSLocalizedDescriptionKey
import kotlin.native.concurrent.freeze

typealias NativeFlow<T> = ((T, Unit) -> Unit, (NSError?, Unit) -> Unit) -> () -> Unit

internal fun <T> Flow<T>.asNativeFlow(scope: CoroutineScope): NativeFlow<T> {
    return (collect@{ onItem: (T, Unit) -> Unit, onComplete: (NSError?, Unit) -> Unit ->
        val unit = Unit.freeze()
        val job = scope.launch {
            try {
                collect { onItem(it.freeze(), unit) }
                onComplete(null, unit)
            } catch (e: Exception) {
                onComplete(e.asNSError().freeze(), unit)
            }
        }
        return@collect { job.cancel() }.freeze()
    }).freeze()
}

typealias NativeSuspend<T> = ((T, Unit) -> Unit, (NSError, Unit) -> Unit) -> () -> Unit

internal fun <T> nativeSuspend(scope: CoroutineScope, block: suspend () -> T): NativeSuspend<T> {
    return (collect@{ onResult: (T, Unit) -> Unit, onError: (NSError, Unit) -> Unit ->
        val unit = Unit.freeze()
        val job = scope.launch {
            try {
                onResult(block().freeze(), unit)
            } catch (e: Exception) {
                onError(e.asNSError().freeze(), unit)
            }
        }
        return@collect { job.cancel() }.freeze()
    }).freeze()
}

internal fun Exception.asNSError(): NSError {
    val userInfo = mutableMapOf<Any?, Any>()
    userInfo["KotlinException"] = this
    val message = message
    if (message != null) {
        userInfo[NSLocalizedDescriptionKey] = message
    }
    return NSError.errorWithDomain("KotlinException", 0, userInfo)
}
