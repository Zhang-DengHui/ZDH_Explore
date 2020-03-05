package com.example.dsxm_demo_zdh.fragment;

import android.widget.TextView;

import androidx.recyclerview.widget.LinearLayoutManager;
import androidx.recyclerview.widget.RecyclerView;

import com.example.dsxm_demo_zdh.R;
import com.example.dsxm_demo_zdh.adapter.ZhuanTiAdapter;
import com.example.dsxm_demo_zdh.base.BaseFragment;
import com.example.dsxm_demo_zdh.contract.ZhuanTiContract;
import com.example.dsxm_demo_zdh.models.api.bean.IndexBean;
import com.example.dsxm_demo_zdh.persenter.ZhuanTiPresenter;

import java.util.ArrayList;
import java.util.List;

import butterknife.BindView;

public class ZhuanTiFragment extends BaseFragment<ZhuanTiContract.View, ZhuanTiContract.Presenter> implements ZhuanTiContract.View {
    @BindView(R.id.zhuanti_title)
    TextView mTitleZhuanti;
    @BindView(R.id.zhuantiRec)
    RecyclerView mZhuantiRec;
    private List<IndexBean.DataBean.TopicListBean> listBeans;
    private ZhuanTiAdapter zhuanTiAdapter;

    @Override
    protected void initData() {
        persenter.getZhuanTiData();
    }

    @Override
    protected void initView() {
        mTitleZhuanti.setText("专题精选");
        mZhuantiRec.setLayoutManager(new LinearLayoutManager(getActivity()));
        listBeans = new ArrayList<>();
        zhuanTiAdapter = new ZhuanTiAdapter(listBeans,context);
        mZhuantiRec.setAdapter(zhuanTiAdapter);
    }

    @Override
    protected ZhuanTiContract.Presenter createPersenter() {
        return new ZhuanTiPresenter();
    }




    @Override
    protected int getLayout() {
        return R.layout.zhuanti_fragment;
    }

    @Override
    public void getZhuanTi(IndexBean zhuanti) {
        zhuanTiAdapter.updata(zhuanti.getData().getTopicList());
    }
}