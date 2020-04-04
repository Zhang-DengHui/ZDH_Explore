package com.example.loarbroadcastresiver;

import android.app.Notification;
import android.app.NotificationManager;
import android.app.PendingIntent;
import android.content.BroadcastReceiver;
import android.content.Context;
import android.content.Intent;
import android.util.Log;

public class OverallBroadCast extends BroadcastReceiver {
    private static final String TAG = "OverallBroadCast";
    @Override
    public void onReceive(Context context, Intent intent) {
        String key = intent.getStringExtra("key");
        Log.i(TAG, "A应用全局广播 "+key);
        PendingIntent activity = PendingIntent.getActivity(context, 11, intent, PendingIntent.FLAG_UPDATE_CURRENT);
        NotificationManager notificationManager = (NotificationManager) context.getSystemService(Context.NOTIFICATION_SERVICE);
        Notification notification = new Notification.Builder(context)
                .setContentIntent(activity)
                .setSmallIcon(R.drawable.ic_launcher_background)
                .setContentTitle("通知")
                .setContentText("嗨!佩奇")
                .build();
        notificationManager.notify(100,notification);
    }
}
