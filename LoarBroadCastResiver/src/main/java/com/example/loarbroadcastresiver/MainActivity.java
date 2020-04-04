package com.example.loarbroadcastresiver;

import android.content.Intent;
import android.content.IntentFilter;
import android.os.Bundle;
import android.view.View;
import android.widget.Button;

import androidx.appcompat.app.AppCompatActivity;
import androidx.localbroadcastmanager.content.LocalBroadcastManager;

public class MainActivity extends AppCompatActivity implements View.OnClickListener {
    /*public static final String NOTIFICATION_NORMAL_MYBROADCAST_ACTION = "com.example.loarbroadcastresiver";*/
    private MyBroadCastResiver myBroadCastResiver;
    private LocalBroadcastManager instance;
    private Intent intent;
    private Button mQuanjuBtn;
    private Button mJubuBtn;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_main);
        initView();

    }

    /*public void senddBroadCast() {
        intent = new Intent("aaa");
        intent.putExtra("key", "嗨！佩奇");
        instance.sendBroadcast(intent);


    }*/

    /*public void setNotifiCation(){
        PendingIntent activity = PendingIntent.getActivity(this, 11, intent, PendingIntent.FLAG_UPDATE_CURRENT);
        NotificationManager notificationManager = (NotificationManager) getSystemService(NOTIFICATION_SERVICE);
        Notification notification = new Notification.Builder(this)
                .setContentIntent(activity)
                .setSmallIcon(R.drawable.ic_launcher_background)
                .setContentTitle("通知")
                .setContentText("嗨!佩奇")
                .build();
        notificationManager.notify(100,notification);
    }*/
    private void initView() {
        mQuanjuBtn = (Button) findViewById(R.id.btn_quanju);
        mQuanjuBtn.setOnClickListener(this);
        mJubuBtn = (Button) findViewById(R.id.btn_jubu);
        mJubuBtn.setOnClickListener(this);
        instance = LocalBroadcastManager.getInstance(this);
        myBroadCastResiver = new MyBroadCastResiver();
        IntentFilter intentFilter = new IntentFilter("AAA");
        /*intentFilter.addAction(NOTIFICATION_NORMAL_MYBROADCAST_ACTION);*/
        instance.registerReceiver(myBroadCastResiver, intentFilter);

        OverallBroadCast overallBroadCast = new OverallBroadCast();
        IntentFilter bbb = new IntentFilter("BBB");
        registerReceiver(overallBroadCast,bbb);
    }

    @Override
    public void onClick(View v) {
        switch (v.getId()) {

            case R.id.btn_quanju:// TODO 20/04/01
                Intent intent = new Intent("BBB");
                intent.putExtra("key","A应用全局广播");
                sendBroadcast(intent);
                break;
            case R.id.btn_jubu:// TODO 20/04/01
                Intent intent1 = new Intent("AAA");
                intent1.putExtra("key","A应用局部广播");
                instance.sendBroadcast(intent1);
                break;
            default:
                break;
        }
    }

    @Override
    protected void onDestroy() {
        super.onDestroy();
        unregisterReceiver(myBroadCastResiver);
    }
}
