package com.example.dsxm_demo_zdh.persenter;


import com.example.dsxm_demo_zdh.base.BasePresenter;
import com.example.dsxm_demo_zdh.common.CommonSubscriber;
import com.example.dsxm_demo_zdh.contract.LogenContract;
import com.example.dsxm_demo_zdh.models.api.HttpManager;
import com.example.dsxm_demo_zdh.models.api.bean.VerifyBean;
import com.example.dsxm_demo_zdh.utils.RxUtils;

public class RegistPresenter extends BasePresenter<LogenContract.View> implements LogenContract.Presenter {
    @Override
    public void getVerify() {
        addSubscribe(HttpManager.getInstance().getShopApi().getVerify()
                .compose(RxUtils.<VerifyBean>rxScheduler())
                .subscribeWith(new CommonSubscriber<VerifyBean>(mView){

                    @Override
                    public void onNext(VerifyBean verifyBean) {
                        mView.getVerifyReturn(verifyBean);
                    }
                }));
    }

    @Override
    public void datachView() {

    }
}
