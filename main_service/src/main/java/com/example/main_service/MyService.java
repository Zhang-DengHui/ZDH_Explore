package com.example.main_service;

import android.app.Service;
import android.content.Intent;
import android.os.IBinder;
import android.util.Log;

import org.greenrobot.eventbus.EventBus;

public class MyService extends Service {
    private static final String TAG = "MyService";
    public MyService() {
    }

    @Override
    public IBinder onBind(Intent intent) {
        // TODO: Return the communication channel to the service.
        throw new UnsupportedOperationException("Not yet implemented");
    }

    @Override
    public void onDestroy() {
        super.onDestroy();
        Log.d(TAG, "onDestroy: ");
    }

    @Override
    public int onStartCommand(Intent intent, int flags, int startId) {
        EventBus.getDefault().postSticky(new TestBean("嗨！佩奇"));
        return super.onStartCommand(intent, flags, startId);

    }
}
