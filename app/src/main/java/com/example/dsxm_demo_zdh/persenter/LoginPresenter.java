package com.example.dsxm_demo_zdh.persenter;


import com.example.dsxm_demo_zdh.base.BasePresenter;
import com.example.dsxm_demo_zdh.common.CommonSubscriber;
import com.example.dsxm_demo_zdh.contract.LoginContract;
import com.example.dsxm_demo_zdh.models.api.HttpManager;
import com.example.dsxm_demo_zdh.models.api.bean.UserBean;
import com.example.dsxm_demo_zdh.utils.RxUtils;

public class LoginPresenter extends BasePresenter<LoginContract.View> implements LoginContract.Presenter {
    @Override
    public void login(String nickname, String password) {
        addSubscribe(HttpManager.getInstance().getShopApi().login(nickname,password)
                .compose(RxUtils.<UserBean>rxScheduler())
                .subscribeWith(new CommonSubscriber<UserBean>(mView){

                    @Override
                    public void onNext(UserBean userBean) {
                        if(userBean.getErrno() == 0){
                            mView.loginReturn(userBean);
                        }
                    }
                }));
    }

    @Override
    public void datachView() {

    }
}
