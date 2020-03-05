package com.example.dsxm_demo_zdh.persenter;


import com.example.dsxm_demo_zdh.base.BasePresenter;
import com.example.dsxm_demo_zdh.common.CommonSubscriber;
import com.example.dsxm_demo_zdh.contract.FenLeiContract;
import com.example.dsxm_demo_zdh.models.api.HttpManager;
import com.example.dsxm_demo_zdh.models.api.bean.CatalogListBean;
import com.example.dsxm_demo_zdh.models.api.bean.CatalogTabBean;
import com.example.dsxm_demo_zdh.utils.RxUtils;

public class FenLeiPresenter extends BasePresenter<FenLeiContract.View> implements FenLeiContract.Presenter {

    @Override
    public void getsort() {
        addSubscribe(HttpManager.getInstance().getShopApi().getCatalogTabData()
                .compose(RxUtils.<CatalogTabBean>rxScheduler())
                .subscribeWith(new CommonSubscriber<CatalogTabBean>(mView){

                    @Override
                    public void onNext(CatalogTabBean catalogTabBean) {
                        if(catalogTabBean.getErrno() == 0){
                            mView.getsortData(catalogTabBean);
                        }
                    }
                }));
    }

    @Override
    public void getFenLeiData(int id) {
        addSubscribe(HttpManager.getInstance().getShopApi().getCatalogList(id)
                .compose(RxUtils.<CatalogListBean>rxScheduler())
                .subscribeWith(new CommonSubscriber<CatalogListBean>(mView){

                    @Override
                    public void onNext(CatalogListBean catalogListBean) {
                        if(catalogListBean.getErrno() == 0){
                            mView.getFenLei(catalogListBean);
                        }
                    }
                }));
    }

    @Override
    public void datachView() {

    }
}
