package com.example.main_slither;

import androidx.appcompat.app.AppCompatActivity;
import androidx.core.widget.NestedScrollView;
import androidx.fragment.app.Fragment;
import androidx.viewpager.widget.ViewPager;

import android.os.Bundle;

import com.google.android.material.tabs.TabLayout;

import java.util.ArrayList;
import java.util.List;

public class MainActivity extends AppCompatActivity {

    private TabLayout mTab;
    private ViewPager mVp;
    private List<Fragment> fragmentList;
    private List<String> stringList;
    private PageFragment pageFragment;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_main);
        initView();
        initData();
    }

    private void initData() {
        fragmentList = new ArrayList<>();
        stringList = new ArrayList<>();
        for (int i = 0; i < 3; i++) {
            pageFragment = new PageFragment();
            stringList.add("榜单"+i);
            fragmentList.add(pageFragment);
        }
        RestartAdapter mPagerAdapter = new RestartAdapter(getSupportFragmentManager(),stringList,fragmentList);
        mVp.setAdapter(mPagerAdapter);
        mTab.setupWithViewPager(mVp);
        // ViewPager切换时NestedScrollView滑动到顶部
        mVp.addOnPageChangeListener(new ViewPager.OnPageChangeListener() {
            @Override
            public void onPageScrolled(int position, float positionOffset, int positionOffsetPixels) {

            }

            @Override
            public void onPageSelected(int position) {
                ((NestedScrollView) findViewById(R.id.nestedScrollView)).scrollTo(0, 0);
            }

            @Override
            public void onPageScrollStateChanged(int state) {

            }
        });
    }

    private void initView() {
        mTab = (TabLayout) findViewById(R.id.tabLayout);
        mVp = (ViewPager) findViewById(R.id.vp);
    }
}
