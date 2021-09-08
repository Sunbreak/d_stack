package com.tal.d_stack;

import android.app.Activity;
import android.content.Context;
import android.content.Intent;
import android.os.Bundle;
import android.view.View;
import android.view.ViewGroup;

import androidx.annotation.NonNull;
import androidx.annotation.Nullable;

import io.flutter.embedding.android.FlutterActivity;
import io.flutter.embedding.android.FlutterView;
import io.flutter.embedding.engine.FlutterEngine;

public class DFlutterActivity extends FlutterActivity {
    public static final String EXTRA_BACKGROUND_MODE = "background_mode";
    public static final String EXTRA_CACHED_ENGINE_ID = "cached_engine_id";
    public static final String EXTRA_DESTROY_ENGINE_WITH_ACTIVITY = "destroy_engine_with_activity";
    public static final String EXTRA_NODE = "dnode";

    private FlutterView flutterView;

    @Override
    protected void onCreate(@Nullable Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        flutterView = findFlutterView(getWindow().getDecorView());
    }

    private FlutterView findFlutterView(View view) {
        if (view instanceof FlutterView) {
            return (FlutterView) view;
        } else if (view instanceof ViewGroup) {
            ViewGroup group = (ViewGroup) view;
            for (int i = 0; i < group.getChildCount(); i++) {
                FlutterView flutterView = findFlutterView(group.getChildAt(i));
                if (flutterView != null) return flutterView;
            }
        }
        return null;
    }

    @Override
    protected void onDestroy() {
        FlutterEngine flutterEngine = getFlutterEngine();
        super.onDestroy();
        flutterEngine.getLifecycleChannel().appIsResumed();
    }

    @Nullable
    @Override
    public String getCachedEngineId() {
        return DStack.ENGINE_ID;
    }

    @Override
    protected void onResume() {
        super.onResume();
        flutterView.attachToFlutterEngine(getFlutterEngine());
        DNode topNode = DNavigationManager.getInstance().findTopNode(getRootNode());
        DStackPlugin.getInstance().activateFlutterNode(topNode);
    }

    private DNode getRootNode() {
        return getIntent().getParcelableExtra(EXTRA_NODE);
    }

    @Override
    protected void onPause() {
        super.onPause();
        flutterView.detachFromFlutterEngine();
    }

    @Override
    public void detachFromFlutterEngine() {
        /**
         * Override and do nothing.
         * The idea here is to avoid releasing delegate when
         * a new FlutterActivity is attached in Flutter2.0.
         */
        // super.detachFromFlutterEngine();
    }

    public static CachedEngineIntentBuilder withCachedEngineD(@NonNull String cachedEngineId) {
        return new CachedEngineIntentBuilder(DFlutterActivity.class, cachedEngineId);
    }

    public static class CachedEngineIntentBuilder {
        private final Class<? extends Activity> activityClass;
        private final String cachedEngineId;
        private final boolean destroyEngineWithActivity = false;
        private final String backgroundMode = io.flutter.embedding.android.FlutterActivityLaunchConfigs.BackgroundMode.opaque.name();
        private DNode node;

        public CachedEngineIntentBuilder(Class<? extends Activity> activityClass, String cachedEngineId) {
            this.activityClass = activityClass;
            this.cachedEngineId = cachedEngineId;
        }

        public CachedEngineIntentBuilder setNode(DNode node) {
            this.node = node;
            return this;
        }

        public Intent build(Context context) {
            return new Intent(context, activityClass)
                    .putExtra(EXTRA_CACHED_ENGINE_ID, cachedEngineId)
                    .putExtra(EXTRA_DESTROY_ENGINE_WITH_ACTIVITY, destroyEngineWithActivity)
                    .putExtra(EXTRA_BACKGROUND_MODE, backgroundMode)
                    .putExtra(EXTRA_NODE, node);
        }
    }
}
