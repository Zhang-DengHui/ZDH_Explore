package com.example.main_touch;

import android.os.Bundle;

import androidx.appcompat.app.AppCompatActivity;
import androidx.recyclerview.widget.LinearLayoutManager;
import androidx.recyclerview.widget.RecyclerView;

import java.util.ArrayList;
import java.util.List;

public class ScrollActivity extends AppCompatActivity {

    RecyclerView recyclerView;
    MyAdapter myAdapter;
    List<String> list;
    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_scroll);
        initView();
    }

    private void initView(){
        recyclerView = findViewById(R.id.recyclerview);

        list = new ArrayList<>();
        for(int i=0; i<100; i++){
            String item = "item:"+i;
            list.add(item);
        }
        recyclerView.setLayoutManager(new LinearLayoutManager(this));
        myAdapter = new MyAdapter(list);
        //recyclerView.addItemDecoration(new MyItemDecoration(this));
        recyclerView.setAdapter(myAdapter);
    }
}
