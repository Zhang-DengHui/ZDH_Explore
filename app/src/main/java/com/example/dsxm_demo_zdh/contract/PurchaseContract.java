package com.example.dsxm_demo_zdh.contract;


import com.example.dsxm_demo_zdh.interfaces.IBasePersenter;
import com.example.dsxm_demo_zdh.interfaces.IBaseView;
import com.example.dsxm_demo_zdh.models.api.bean.RelatedBean;

public interface PurchaseContract {

    interface View extends IBaseView {
        void getRelatedDataReturn(RelatedBean result);
    }

    interface Presenter extends IBasePersenter<View> {
        void getRelatedData(int id);
    }
}
