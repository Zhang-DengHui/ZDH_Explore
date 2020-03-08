package com.example.dsxm_demo_zdh.persenter;

import com.example.dsxm_demo_zdh.base.BasePresenter;
import com.example.dsxm_demo_zdh.common.CommonSubscriber;
import com.example.dsxm_demo_zdh.contract.ShoppingContract;
import com.example.dsxm_demo_zdh.models.api.HttpManager;
import com.example.dsxm_demo_zdh.models.api.bean.CartBean;
import com.example.dsxm_demo_zdh.models.api.bean.CartGoodsCheckBean;
import com.example.dsxm_demo_zdh.models.api.bean.CartGoodsDeleteBean;
import com.example.dsxm_demo_zdh.models.api.bean.CartGoodsUpdateBean;
import com.example.dsxm_demo_zdh.utils.RxUtils;

import io.reactivex.functions.Function;

public class ShoppingPresenter extends BasePresenter<ShoppingContract.View> implements ShoppingContract.Presenter {

    @Override
    public void getCartIndex() {
        addSubscribe(HttpManager.getInstance().getShopApi().getCartIndex()
                .compose(RxUtils.<CartBean>rxScheduler())
                .map(new Function<CartBean, CartBean>() {
                    @Override
                    public CartBean apply(CartBean cartBean) throws Exception {
                        for(CartBean.DataBean.CartListBean item:cartBean.getData().getCartList()){
                            item.isSelect = item.getChecked() == 0 ? true : false;
                        }
                        return cartBean;
                    }
                })
                .subscribeWith(new CommonSubscriber<CartBean>(mView) {
                    @Override
                    public void onNext(CartBean cartBean) {
                        mView.getCartIndexReturn(cartBean);
                    }
                }));
    }

    @Override
    public void setCartGoodsChecked(String pids, int isChecked) {
        addSubscribe(HttpManager.getInstance().getShopApi().setCartGoodsCheck(pids,isChecked)
                .compose(RxUtils.<CartGoodsCheckBean>rxScheduler())
                .subscribeWith(new CommonSubscriber<CartGoodsCheckBean>(mView) {
                    @Override
                    public void onNext(CartGoodsCheckBean cartBean) {
                        mView.setCartGoodsCheckedReturn(cartBean);
                    }
                }));
    }

    @Override
    public void updateCartGoods(String pids, String goodsId, int number, int id) {
        addSubscribe(HttpManager.getInstance().getShopApi().updateCartGoods(pids,goodsId,number,id)
                .compose(RxUtils.<CartGoodsUpdateBean>rxScheduler())
                .subscribeWith(new CommonSubscriber<CartGoodsUpdateBean>(mView) {
                    @Override
                    public void onNext(CartGoodsUpdateBean updateBean) {
                        mView.updateCartGoodsReturn(updateBean);
                    }
                }));
    }

    @Override
    public void deleteCartGoods(String pids) {
        addSubscribe(HttpManager.getInstance().getShopApi().deleteCartGoods(pids)
                .compose(RxUtils.<CartGoodsDeleteBean>rxScheduler())
                .subscribeWith(new CommonSubscriber<CartGoodsDeleteBean>(mView) {
                    @Override
                    public void onNext(CartGoodsDeleteBean deleteBean) {
                        mView.deleteCartGoodsReturn(deleteBean);
                    }
                }));
    }

    @Override
    public void datachView() {

    }
}
