package com.tal.d_stack_example;

import android.app.Activity;
import android.os.Bundle;
import android.view.View;

import androidx.annotation.Nullable;

public class MainActivity extends Activity {
    @Override
    protected void onCreate(@Nullable Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_main);
        setTitle("MainActivity");

        findViewById(R.id.push_flutter_1).setOnClickListener((View v) -> {
            System.out.println("push_flutter_1"); // TODO
        });

        findViewById(R.id.push_flutter_2).setOnClickListener((View v) -> {
            System.out.println("push_flutter_2"); // TODO
        });

        findViewById(R.id.push_native_1).setOnClickListener((View v) -> {
            System.out.println("push_native_1"); // TODO
        });

        findViewById(R.id.push_native_2).setOnClickListener((View v) -> {
            System.out.println("push_native_2"); // TODO
        });
    }
}
