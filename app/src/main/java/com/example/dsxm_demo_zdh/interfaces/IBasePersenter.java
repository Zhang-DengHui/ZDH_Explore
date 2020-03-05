package com.example.dsxm_demo_zdh.interfaces;

public interface IBasePersenter<V extends IBaseView> {
    void attachView(V view);
    void datachView();

}
