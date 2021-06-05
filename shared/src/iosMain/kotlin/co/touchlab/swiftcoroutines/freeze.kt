package co.touchlab.example.co.touchlab.swiftcoroutines

import kotlin.native.concurrent.freeze

actual fun <T> T.freeze(): T = freeze()