package com.tal.d_stack_example;

import android.app.Application;

import com.tal.d_stack.DStack;

public class MainApplication extends Application {
    @Override
    public void onCreate() {
        super.onCreate();
        DStack.getInstance().init(this);
    }
}
