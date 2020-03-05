package com.example.dsxm_demo_zdh.contract;


import com.example.dsxm_demo_zdh.interfaces.IBasePersenter;
import com.example.dsxm_demo_zdh.interfaces.IBaseView;
import com.example.dsxm_demo_zdh.models.api.bean.VerifyBean;

public interface LogenContract {

    interface View extends IBaseView {
        void getVerifyReturn(VerifyBean result);
    }

    interface Presenter extends IBasePersenter<View> {
        void getVerify();
    }
}
