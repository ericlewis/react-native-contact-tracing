package com.contacttracing

import com.facebook.react.bridge.Promise
import com.facebook.react.bridge.ReactApplicationContext
import com.facebook.react.bridge.ReactContextBaseJavaModule
import com.facebook.react.bridge.ReactMethod

class ContactTracingModule(reactContext: ReactApplicationContext) :
  ReactContextBaseJavaModule(reactContext) {
  override fun getName() = "ContactTracing"

  override fun getConstants(): MutableMap<String, Any> {
    val constants = mutableMapOf<String, Any>()

    constants["supported"] = false

    return constants
  }

  @ReactMethod
  fun start(promise: Promise) {
    promise.resolve("TODO")
  }

  @ReactMethod
  fun stop(promise: Promise) {
    promise.resolve("TODO")
  }

  @ReactMethod
  fun currentStatus(promise: Promise) {
    promise.resolve("TODO")
  }

  @ReactMethod
  fun requestExposureSummary(promise: Promise) {
    promise.resolve("TODO")
  }
}