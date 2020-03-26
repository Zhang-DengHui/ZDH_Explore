package com.example.main_touch;

import android.os.Build;
import android.os.Bundle;
import android.widget.TextView;

import androidx.annotation.RequiresApi;
import androidx.appcompat.app.AppCompatActivity;
import androidx.recyclerview.widget.LinearLayoutManager;
import androidx.recyclerview.widget.RecyclerView;

import java.util.ArrayList;
import java.util.List;

public class ScrollViewActivity extends AppCompatActivity {

    List<String> list;
    RecyclerView recyclerView;
    MyAdapter myAdapter;

    TextView txt_header;
    MyScrollView scrollView;

    @RequiresApi(api = Build.VERSION_CODES.LOLLIPOP)
    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_scroll_view);
        recyclerView = findViewById(R.id.recyclerview);
        txt_header = findViewById(R.id.txt_header);
        /*scrollView = findViewById(R.id.scrollView);
        scrollView.header_height = txt_header.getLayoutParams().height;*/

        list = new ArrayList<>();
        for(int i=0; i<50;i++){
            list.add("item"+i);
        }
        myAdapter = new MyAdapter(list);
        recyclerView.setLayoutManager(new LinearLayoutManager(this));
        recyclerView.setAdapter(myAdapter);


    }

    @Override
    protected void onResume() {
        super.onResume();
    }
}