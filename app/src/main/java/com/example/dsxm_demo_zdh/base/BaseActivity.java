package com.example.dsxm_demo_zdh.base;

import android.os.Bundle;
import android.widget.Toast;

import androidx.annotation.Nullable;
import androidx.appcompat.app.AppCompatActivity;

import com.example.dsxm_demo_zdh.interfaces.IBasePersenter;
import com.example.dsxm_demo_zdh.interfaces.IBaseView;

import butterknife.ButterKnife;
import butterknife.Unbinder;

public abstract class BaseActivity<P extends IBasePersenter> extends AppCompatActivity implements IBaseView {

     Unbinder unbinder;
    protected P persenter;

    @Override
    protected void onCreate(@Nullable Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(getLayout());
        unbinder = ButterKnife.bind(this);
        initView();
        persenter = createPersenter();
        if (persenter!=null){
            persenter.attachView(this);
        }
        initData();
    }

    protected abstract void initData();

    protected abstract P createPersenter();

    protected abstract void initView();

    protected abstract int getLayout();

    public void showTips(String msg){
        Toast.makeText(this, msg, Toast.LENGTH_SHORT).show();
    }

    @Override
    protected void onDestroy() {
        super.onDestroy();
        if (persenter!=null){
            persenter.datachView();
        }if (unbinder!=null){
            unbinder.unbind();
        }
    }
}
