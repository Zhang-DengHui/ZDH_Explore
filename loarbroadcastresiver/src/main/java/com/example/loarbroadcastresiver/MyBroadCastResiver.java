package com.example.loarbroadcastresiver;

import android.app.Notification;
import android.app.NotificationManager;
import android.app.PendingIntent;
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
        Log.i(TAG, "A应用局部广播: "+str);
            /*PendingIntent activity = PendingIntent.getActivity(context, 11, intent, PendingIntent.FLAG_UPDATE_CURRENT);
            NotificationManager notificationManager = (NotificationManager)context.getSystemService(Context.NOTIFICATION_SERVICE);
            Notification notification = new Notification.Builder(context)
                    .setContentIntent(activity)
                    .setSmallIcon(R.drawable.ic_launcher_background)
                    .setContentTitle("通知")
                    .setContentText("嗨!佩奇")
                    .build();
            notificationManager.notify(100,notification);
*/
    }
}
