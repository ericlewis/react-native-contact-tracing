package com.reactlibrary;

import com.facebook.react.bridge.ReactApplicationContext;
import com.facebook.react.bridge.ReactContextBaseJavaModule;
import com.facebook.react.bridge.ReactMethod;
import com.facebook.react.bridge.Promise;

public class ContactTracingModule extends ReactContextBaseJavaModule {
    private static final String E_ERROR = "E_ERROR";

    private final ReactApplicationContext reactContext;

    public ContactTracingModule(ReactApplicationContext reactContext) {
        super(reactContext);
        this.reactContext = reactContext;
    }

    @Override
    public String getName() {
        return "ContactTracing";
    }

    @ReactMethod
    public void start(Promise promise) {
        promise.reject(E_ERROR, null);
    }

    @ReactMethod
    public void stop(Promise promise) {
        promise.reject(E_ERROR, null);
    }

    @ReactMethod
    public void requestExposureSummary(Promise promise) {
        promise.reject(E_ERROR, null);
    }
}
