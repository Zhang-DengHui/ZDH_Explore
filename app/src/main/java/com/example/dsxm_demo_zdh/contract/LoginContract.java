package com.example.dsxm_demo_zdh.contract;


import com.example.dsxm_demo_zdh.interfaces.IBasePersenter;
import com.example.dsxm_demo_zdh.interfaces.IBaseView;
import com.example.dsxm_demo_zdh.models.api.bean.UserBean;

public interface LoginContract {

    interface View extends IBaseView {
        void loginReturn(UserBean result);
    }

    interface Presenter extends IBasePersenter<View> {
        void login(String nickname, String password);
    }
}
