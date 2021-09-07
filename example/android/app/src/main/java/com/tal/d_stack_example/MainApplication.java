package com.tal.d_stack_example;

import android.app.Application;
import android.content.Intent;

import com.tal.d_stack.DStack;

import java.util.HashMap;

public class MainApplication extends Application {
    @Override
    public void onCreate() {
        super.onCreate();
        DStack.getInstance().init(this);
        DStack.getInstance().registerRoute(new HashMap() {{
            put("nativePage1", (DStack.NativeRoute) context -> new Intent(context, NativePage1Activity.class));
            put("nativePage2", (DStack.NativeRoute) context -> new Intent(context, NativePage2Activity.class));
        }});
    }
}
