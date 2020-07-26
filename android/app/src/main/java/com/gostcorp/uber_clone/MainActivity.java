package com.gostcorp.uber_clone;

import android.os.Bundle;

import androidx.annotation.NonNull;

import io.flutter.embedding.android.FlutterActivity;

public class MainActivity extends FlutterActivity {
    @Override
    protected void onCreate(Bundle savedInstanceBundle){
        super.onCreate(savedInstanceBundle);
    }


    @NonNull
    @Override
    public String getInitialRoute() {
        String route = getIntent().getStringExtra("route");
        if (route != null) {
            return route;
        } else {
            return "welcome_page";
        }
    }
}
