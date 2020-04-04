package com.example.secondbroadcastresiver;

import android.content.Intent;
import android.content.IntentFilter;
import android.os.Bundle;
import android.view.View;
import android.widget.Button;

import androidx.appcompat.app.AppCompatActivity;
import androidx.localbroadcastmanager.content.LocalBroadcastManager;

public class MainActivity extends AppCompatActivity implements View.OnClickListener {

    private Button mBtn;
    private LocalBroadcastManager instance;
    private MyBroadCastResiver myBroadCastResiver;
    private Button mQjBt;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_main);
        initView();
    }

    private void initView() {
        mBtn = (Button) findViewById(R.id.btn_bd);
        mBtn.setOnClickListener(this);
        instance = LocalBroadcastManager.getInstance(this);
        myBroadCastResiver = new MyBroadCastResiver();
        IntentFilter intentFilter = new IntentFilter("AAA");
        instance.registerReceiver(myBroadCastResiver, intentFilter);
        mQjBt = (Button) findViewById(R.id.bt_qj);
        mQjBt.setOnClickListener(this);
    }

    @Override
    public void onClick(View v) {
        switch (v.getId()) {
            case R.id.btn_bd:
                // TODO 20/04/01
                Intent intent = new Intent("AAA");
                intent.putExtra("key", "这是B的本地广播");
                instance.sendBroadcast(intent);
                break;
            case R.id.bt_qj:// TODO 20/04/01
                Intent intent1 = new Intent("BBB");
                intent1.putExtra("key","B应用全局广播");
                sendBroadcast(intent1);
                break;
            default:
                break;
        }
    }

    @Override
    protected void onDestroy() {
        super.onDestroy();
        instance.unregisterReceiver(myBroadCastResiver);
    }
}
