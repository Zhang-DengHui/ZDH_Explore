package com.example.main_nvrs;

import android.content.Intent;
import android.os.Bundle;
import android.view.View;
import android.widget.Button;
import android.widget.ImageView;

import androidx.appcompat.app.AppCompatActivity;
import androidx.fragment.app.Fragment;
import androidx.viewpager.widget.ViewPager;

import com.google.android.material.tabs.TabLayout;
import com.scwang.smartrefresh.layout.SmartRefreshLayout;
import com.scwang.smartrefresh.layout.api.RefreshHeader;
import com.scwang.smartrefresh.layout.listener.SimpleMultiPurposeListener;

import java.util.ArrayList;
import java.util.List;

public class MainActivity extends AppCompatActivity{


    private TabLayout mTablayout;
    private ViewPager mViewpager;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_normal);
        initView();

    }

    private void initView() {
        mTablayout = (TabLayout) findViewById(R.id.tablayout);
        mViewpager = (ViewPager) findViewById(R.id.viewpager);




        List<Fragment> fragmentList=new ArrayList<>();
        fragmentList.add(new OneFragment());
        fragmentList.add(new TwoFragment());
        fragmentList.add(new ThreeFragment());

        FragAdapter fragAdapter = new FragAdapter(getSupportFragmentManager(), fragmentList);
        mViewpager.setAdapter(fragAdapter);

        mTablayout.setupWithViewPager(mViewpager);
        mTablayout.addTab(mTablayout.newTab());
        mTablayout.addTab(mTablayout.newTab());
        mTablayout.addTab(mTablayout.newTab());

        mTablayout.getTabAt(0).setText("测试1");
        mTablayout.getTabAt(1).setText("测试2");
        mTablayout.getTabAt(2).setText("测试3");

        mTablayout.setTabMode(TabLayout.MODE_FIXED);
    }
}
