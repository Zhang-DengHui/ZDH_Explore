package com.example.main_touch;

import androidx.appcompat.app.AppCompatActivity;

import android.os.Bundle;
import android.util.Log;
import android.view.MotionEvent;
import android.view.View;

import com.example.main_touch.utils.MyUtils;

public class MainActivity extends AppCompatActivity {

    private static String TAG;

    private MainViewGroup myViewGroup;
    private MainView myView;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_main);
        TAG = this.getClass().getName();
        initView();
    }

    private void initView(){
        myViewGroup = findViewById(R.id.myVG);
        myView = findViewById(R.id.myVW);

        myViewGroup.setOnTouchListener(new View.OnTouchListener() {
            @Override
            public boolean onTouch(View v, MotionEvent event) {
                return true;
            }
        });

        myViewGroup.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                Log.i("click","onclick");
            }
        });

        myView.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                v.getId();
                Log.i("view click","click");
            }
        });
        myView.setLongClickable(true);
        myView.setOnLongClickListener(new View.OnLongClickListener() {
            @Override
            public boolean onLongClick(View v) {
                return false;
            }
        });
        myView.setOnTouchListener(new View.OnTouchListener() {
            @Override
            public boolean onTouch(View v, MotionEvent event) {
                return false;
            }
        });

    }

    @Override
    public boolean dispatchTouchEvent(MotionEvent ev) {
        MyUtils.show_events(TAG,ev,"dispatchTouchEvent");
        return super.dispatchTouchEvent(ev);
        //return false;
    }

    @Override
    public boolean onTouchEvent(MotionEvent event) {
        MyUtils.show_events(TAG,event,"onTouchEvent");
        /*myView.performClick();
        myViewGroup.performClick();*/
        //return super.onTouchEvent(event);
        return true;
    }
}
