package com.example.dsxm_demo_zdh.contract;

import com.example.dsxm_demo_zdh.interfaces.IBasePersenter;
import com.example.dsxm_demo_zdh.interfaces.IBaseView;
import com.example.dsxm_demo_zdh.models.api.bean.CartBean;
import com.example.dsxm_demo_zdh.models.api.bean.CartGoodsCheckBean;
import com.example.dsxm_demo_zdh.models.api.bean.CartGoodsDeleteBean;
import com.example.dsxm_demo_zdh.models.api.bean.CartGoodsUpdateBean;

public interface ShoppingContract {
    interface View extends IBaseView {
        void getCartIndexReturn(CartBean result);
        //设置购物车商品数据选中状态的返回
        void setCartGoodsCheckedReturn(CartGoodsCheckBean result);
        //更新购物车类表商品数据返回
        void updateCartGoodsReturn(CartGoodsUpdateBean result);
        //删除商品返回
        void deleteCartGoodsReturn(CartGoodsDeleteBean result);
    }

    interface Presenter extends IBasePersenter<View> {
        void getCartIndex();
        //设置购物车商品数据
        void setCartGoodsChecked(String pids,int isChecked);
        //更新购物车列表的商品数据
        void updateCartGoods(String pids,String goodsId,int number,int id);
        //删除商品
        void deleteCartGoods(String pids);
    }
}
