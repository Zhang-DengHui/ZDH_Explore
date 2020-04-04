package com.example.secondbroadcastresiver;

import android.content.BroadcastReceiver;
import android.content.Context;
import android.content.Intent;
import android.util.Log;
import android.widget.Toast;

public class MyBroadCastResiver extends BroadcastReceiver {
    private static final String TAG = "MyBroadCastResiver";
    @Override
    public void onReceive(Context context, Intent intent) {
        String str=intent.getStringExtra("key");
        Toast.makeText(context, str, Toast.LENGTH_SHORT).show();
        Log.i(TAG, "这是B的本地广播"+str);
    }
}
