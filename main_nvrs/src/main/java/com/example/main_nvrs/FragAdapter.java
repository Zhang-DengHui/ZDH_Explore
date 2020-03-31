package com.example.main_nvrs;

import androidx.annotation.NonNull;
import androidx.fragment.app.Fragment;
import androidx.fragment.app.FragmentManager;
import androidx.fragment.app.FragmentPagerAdapter;

import java.util.ArrayList;
import java.util.List;

public class FragAdapter extends FragmentPagerAdapter {
    List<Fragment> fragmentList=new ArrayList<>();
    public FragAdapter(@NonNull FragmentManager fm, List<Fragment> fragmentList) {
        super(fm);
        this.fragmentList.addAll(fragmentList);
    }

    @NonNull
    @Override
    public Fragment getItem(int position) {
        return fragmentList.get(position);
    }

    @Override
    public int getCount() {
        return fragmentList.size();
    }
}
