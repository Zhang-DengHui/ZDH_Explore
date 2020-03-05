package com.example.dsxm_demo_zdh.contract;


import com.example.dsxm_demo_zdh.interfaces.IBasePersenter;
import com.example.dsxm_demo_zdh.interfaces.IBaseView;
import com.example.dsxm_demo_zdh.models.api.bean.IndexBean;

public interface ZhuanTiContract {

    interface View extends IBaseView {
        void getZhuanTi(IndexBean zhuanti);
    }

    interface Presenter extends IBasePersenter<View>{
        void getZhuanTiData();
    }

}
