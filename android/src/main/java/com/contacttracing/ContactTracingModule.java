package com.contacttracing;

import androidx.annotation.Nullable;

import com.facebook.react.bridge.ReactApplicationContext;
import com.facebook.react.bridge.ReactContextBaseJavaModule;
import com.facebook.react.bridge.ReactMethod;
import com.facebook.react.bridge.Promise;
import com.facebook.react.bridge.WritableMap;

import java.util.HashMap;
import java.util.Map;

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

    @Nullable
    @Override
    public Map<String, Object> getConstants() {
        HashMap<String, Object> constants = new HashMap<>();

        constants.put("supported", false);

        return constants;
    }

    @ReactMethod
    public void start(Promise promise) {
        promise.resolve("TODO");
    }

    @ReactMethod
    public void stop(Promise promise) {
        promise.resolve("TODO");
    }

    @ReactMethod
    public void currentStatus(Promise promise) {
        promise.resolve("TODO");
    }

    @ReactMethod
    public void requestExposureSummary(Promise promise) {
        promise.resolve("TODO");
    }
}
