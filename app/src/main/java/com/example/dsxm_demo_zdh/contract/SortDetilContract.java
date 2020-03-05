package com.example.dsxm_demo_zdh.contract;

import com.example.dsxm_demo_zdh.interfaces.IBasePersenter;
import com.example.dsxm_demo_zdh.interfaces.IBaseView;
import com.example.dsxm_demo_zdh.models.api.bean.DetilListBean;
import com.example.dsxm_demo_zdh.models.api.bean.DetilTabBean;

public interface SortDetilContract {

    interface View extends IBaseView {
        //加载分类列表的tab数据返回
        void getDetilTabReturn(DetilTabBean result);
        //获取分类类别的tab商品数据返回
        void getDetilReturn(DetilListBean result);
    }

    interface Presenter extends IBasePersenter<View> {
        //加载分类列表的tab数据
        void getDetilTab(int id);
        //获取分类列表tab所对应的商品数据
        void getDetilList(int categoryId,int page,int size);
    }

}
