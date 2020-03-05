package com.example.dsxm_demo_zdh;

import android.view.MenuItem;
import android.widget.FrameLayout;

import androidx.appcompat.app.AppCompatActivity;
import androidx.fragment.app.FragmentManager;
import androidx.fragment.app.FragmentTransaction;

import com.example.dsxm_demo_zdh.base.BaseActivity;
import com.example.dsxm_demo_zdh.fragment.FenLeiFragment;
import com.example.dsxm_demo_zdh.fragment.HomeFragment;
import com.example.dsxm_demo_zdh.fragment.OwnFragment;
import com.example.dsxm_demo_zdh.fragment.ShoppingFragment;
import com.example.dsxm_demo_zdh.fragment.ZhuanTiFragment;
import com.example.dsxm_demo_zdh.interfaces.IBasePersenter;
import com.google.android.material.bottomnavigation.BottomNavigationView;


public class MainActivity extends BaseActivity {
    private FrameLayout mFrame;
    private BottomNavigationView mNavigationview;
    private FragmentManager fragmentManager;
    private FragmentTransaction transaction;
    private HomeFragment homeFragment;
    private ZhuanTiFragment zhuanTiFragment;
    private FenLeiFragment fenLeiFragment;
    private ShoppingFragment shoppingFragment;
    private OwnFragment ownFragment;

    @Override
    protected void initData() {
        homeFragment = new HomeFragment();
        zhuanTiFragment = new ZhuanTiFragment();
        fenLeiFragment = new FenLeiFragment();
        shoppingFragment = new ShoppingFragment();
        ownFragment = new OwnFragment();
        fragmentManager = getSupportFragmentManager();
        transaction = fragmentManager.beginTransaction();
        transaction.add(R.id.frame,homeFragment).add(R.id.frame,zhuanTiFragment)
                .add(R.id.frame,fenLeiFragment).show(homeFragment).hide(zhuanTiFragment).hide(fenLeiFragment).commit();

        mNavigationview.setOnNavigationItemSelectedListener(new BottomNavigationView.OnNavigationItemSelectedListener() {

            @Override
            public boolean onNavigationItemSelected(MenuItem menuItem) {
                FragmentTransaction ft = fragmentManager.beginTransaction();
                switch (menuItem.getItemId()){
                    case R.id.home:
                        FragmentTransaction fragmentTransaction = fragmentManager.beginTransaction();
                        fragmentTransaction.show(homeFragment).hide(zhuanTiFragment).hide(fenLeiFragment).commit();
                        break;
                    case R.id.zhuanti:
                        FragmentTransaction fragmentTransaction2 = fragmentManager.beginTransaction();
                        fragmentTransaction2.show(zhuanTiFragment).hide(homeFragment).hide(fenLeiFragment).commit();
                        break;
                    case R.id.fenlei:
                        FragmentTransaction fragmentTransaction3 = fragmentManager.beginTransaction();
                        fragmentTransaction3.show(fenLeiFragment).hide(homeFragment).hide(zhuanTiFragment).commit();
                }
                return false;
            }
        });
    }

    @Override
    protected IBasePersenter createPersenter() {
        return null;
    }



    @Override
    protected void initView() {
        mFrame = (FrameLayout) findViewById(R.id.frame);
        mNavigationview = (BottomNavigationView) findViewById(R.id.navigationview);
    }

    @Override
    protected int getLayout() {
        return R.layout.activity_main;
    }

}
