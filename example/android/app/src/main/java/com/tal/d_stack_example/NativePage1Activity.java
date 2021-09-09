package com.tal.d_stack_example;

import android.app.Activity;
import android.os.Bundle;
import android.view.View;

import androidx.annotation.Nullable;

import com.tal.d_stack.DStack;

public class NativePage1Activity extends Activity {
    @Override
    protected void onCreate(@Nullable Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_native_page1);
        setTitle("NativePage1");

        findViewById(R.id.push_flutter_1).setOnClickListener((View v) -> {
            DStack.getInstance().pushRoute("flutterPage1");
        });

        findViewById(R.id.push_flutter_2).setOnClickListener((View v) -> {
            DStack.getInstance().pushRoute("flutterPage2");
        });

        findViewById(R.id.push_native_1).setOnClickListener((View v) -> {
            DStack.getInstance().pushRoute("nativePage1");
        });

        findViewById(R.id.push_native_2).setOnClickListener((View v) -> {
            DStack.getInstance().pushRoute("nativePage2");
        });

        findViewById(R.id.pop).setOnClickListener((View v) -> {
            DStack.getInstance().pop();
        });
    }
}
