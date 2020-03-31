package com.example.main_slither;

import androidx.annotation.NonNull;
import androidx.annotation.Nullable;
import androidx.fragment.app.Fragment;
import androidx.fragment.app.FragmentManager;
import androidx.fragment.app.FragmentPagerAdapter;

import java.util.List;

public class RestartAdapter extends FragmentPagerAdapter {
    private List<String> stringList;
    private List<Fragment> fragmentList;


    public RestartAdapter(@NonNull FragmentManager fm, List<String> stringList, List<Fragment> fragmentList) {
        super(fm);
        this.stringList=stringList;
        this.fragmentList=fragmentList;
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

    @Nullable
    @Override
    public CharSequence getPageTitle(int position) {
        return stringList.get(position);
    }
}
