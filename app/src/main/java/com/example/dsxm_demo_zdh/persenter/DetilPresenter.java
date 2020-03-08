package com.example.dsxm_demo_zdh.persenter;

import com.example.dsxm_demo_zdh.base.BasePresenter;
import com.example.dsxm_demo_zdh.common.CommonSubscriber;
import com.example.dsxm_demo_zdh.contract.SortDetilContract;
import com.example.dsxm_demo_zdh.models.api.HttpManager;
import com.example.dsxm_demo_zdh.models.api.bean.DetilListBean;
import com.example.dsxm_demo_zdh.models.api.bean.DetilTabBean;
import com.example.dsxm_demo_zdh.utils.RxUtils;

public class DetilPresenter extends BasePresenter<SortDetilContract.View> implements SortDetilContract.Presenter {
    @Override
    public void getDetilTab(int id) {
        addSubscribe(HttpManager.getInstance().getShopApi().getDetilTab(id)
                .compose(RxUtils.<DetilTabBean>rxScheduler())
                .subscribeWith(new CommonSubscriber<DetilTabBean>(mView){
                    @Override
                    public void onNext(DetilTabBean detilTabBean) {
                        mView.getDetilTabReturn(detilTabBean);
                    }
                }));
    }

    @Override
    public void getDetilList(int categoryId, int page, int size) {
        addSubscribe(HttpManager.getInstance().getShopApi().getDetilList(categoryId,page,size)
                .compose(RxUtils.<DetilListBean>rxScheduler())
                .subscribeWith(new CommonSubscriber<DetilListBean>(mView){
                    @Override
                    public void onNext(DetilListBean detilListBean) {
                        mView.getDetilReturn(detilListBean);
                    }
                }));
    }

    @Override
    public void datachView() {

    }
}
