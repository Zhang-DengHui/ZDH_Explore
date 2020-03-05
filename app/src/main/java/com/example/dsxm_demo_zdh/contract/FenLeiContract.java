package com.example.dsxm_demo_zdh.contract;


import com.example.dsxm_demo_zdh.interfaces.IBasePersenter;
import com.example.dsxm_demo_zdh.interfaces.IBaseView;
import com.example.dsxm_demo_zdh.models.api.bean.CatalogListBean;
import com.example.dsxm_demo_zdh.models.api.bean.CatalogTabBean;

public interface FenLeiContract {
    interface View extends IBaseView {
        void getsortData(CatalogTabBean catalogTabBean);
        void getFenLei(CatalogListBean catalogListBean);
    }

    interface Presenter extends IBasePersenter<View> {
        void getsort();
        void getFenLeiData(int id);
    }
}
