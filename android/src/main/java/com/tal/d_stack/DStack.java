package com.tal.d_stack;

import android.content.Context;
import android.content.Intent;

import io.flutter.embedding.engine.FlutterEngine;
import io.flutter.embedding.engine.FlutterEngineCache;
import io.flutter.embedding.engine.dart.DartExecutor;

public class DStack {
    public static final String ENGINE_ID = "d_stack_engine";

    private Context appContext;
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
            appContext = context;
            flutterEngine = new FlutterEngine(context);
            flutterEngine.getDartExecutor().executeDartEntrypoint(
                    DartExecutor.DartEntrypoint.createDefault()
            );
            FlutterEngineCache.getInstance().put(ENGINE_ID, flutterEngine);
            running = true;
        }
    }

    public void pushRoute(String routeName) {
        // TODO routeName
        Intent intent = DFlutterActivity.withCachedEngineD(ENGINE_ID).build(appContext);
        appContext.startActivity(intent.addFlags(Intent.FLAG_ACTIVITY_NEW_TASK));
    }
}
