package com.example.main_service;

import android.content.Intent;
import android.os.Bundle;
import android.view.View;
import android.widget.Button;
import android.widget.TextView;
import android.widget.Toast;

import androidx.appcompat.app.AppCompatActivity;

import org.greenrobot.eventbus.EventBus;
import org.greenrobot.eventbus.Subscribe;
import org.greenrobot.eventbus.ThreadMode;

public class MainActivity extends AppCompatActivity{

    private TextView mTv;
    private Button mBt;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_main);
        initView();
        EventBus.getDefault().register(this);
    }

    private void initView() {
        mTv = (TextView) findViewById(R.id.tv);
        mBt = (Button) findViewById(R.id.bt);
    }

    public void service(View view) {
        Intent intent = new Intent(this, MyService.class);
        startService(intent);
    }

    @Subscribe(threadMode = ThreadMode.MAIN,sticky = true)
    public void onMessEvent(TestBean messEvent){
        mTv.setText(messEvent.getName());
        Toast.makeText(this, "嗨！佩奇", Toast.LENGTH_SHORT).show();
    }

    @Override
    protected void onDestroy() {
        super.onDestroy();
        EventBus.getDefault().unregister(this);
    }


}
