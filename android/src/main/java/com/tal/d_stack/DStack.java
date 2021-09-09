package com.tal.d_stack;

import android.content.Context;
import android.content.Intent;

import java.util.Map;

import io.flutter.embedding.engine.FlutterEngine;
import io.flutter.embedding.engine.FlutterEngineCache;
import io.flutter.embedding.engine.dart.DartExecutor;

public class DStack {
    public static final String ENGINE_ID = "d_stack_engine";

    /*package*/ FlutterEngine flutterEngine;
    private boolean running;

    private DStack() {
    }

    private interface Holder {
        DStack instance = new DStack();
    }

    public static DStack getInstance() {
        return Holder.instance;
    }

    public void init(Context context) {
        if (!running) {
            DNavigationManager.getInstance().init(context);
            flutterEngine = new FlutterEngine(context);
            flutterEngine.getDartExecutor().executeDartEntrypoint(
                    DartExecutor.DartEntrypoint.createDefault()
            );
            FlutterEngineCache.getInstance().put(ENGINE_ID, flutterEngine);
            running = true;
        }
    }

    public interface NativeRoute {
        Intent build(Context context);
    }

    public void registerRoute(Map<String, NativeRoute> routeMap) {
        DNavigationManager.getInstance().registerRoute(routeMap);
    }

    public void pushRoute(String routeName) {
        DNavigationManager.getInstance().pushRoute(routeName);
    }

    public void pop() {
        DNavigationManager.getInstance().pop();
    }
}
