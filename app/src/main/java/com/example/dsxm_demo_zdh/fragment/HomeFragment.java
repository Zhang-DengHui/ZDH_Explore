package com.example.dsxm_demo_zdh.fragment;

import android.content.Context;
import android.util.Log;
import android.widget.ImageView;

import androidx.recyclerview.widget.DividerItemDecoration;
import androidx.recyclerview.widget.GridLayoutManager;
import androidx.recyclerview.widget.LinearLayoutManager;
import androidx.recyclerview.widget.RecyclerView;

import com.bumptech.glide.Glide;
import com.example.dsxm_demo_zdh.R;
import com.example.dsxm_demo_zdh.adapter.CcAdapter;
import com.example.dsxm_demo_zdh.adapter.HomeAdapter;
import com.example.dsxm_demo_zdh.adapter.JjAdapter;
import com.example.dsxm_demo_zdh.adapter.JxAdapter;
import com.example.dsxm_demo_zdh.adapter.RqAdapter;
import com.example.dsxm_demo_zdh.adapter.XpAdapter;
import com.example.dsxm_demo_zdh.base.BaseFragment;
import com.example.dsxm_demo_zdh.contract.HomeContract;
import com.example.dsxm_demo_zdh.models.api.bean.IndexBean;
import com.example.dsxm_demo_zdh.persenter.HomePresenter;
import com.google.android.material.tabs.TabLayout;
import com.youth.banner.Banner;
import com.youth.banner.loader.ImageLoader;

import java.util.ArrayList;
import java.util.List;

import butterknife.BindView;

public class HomeFragment extends BaseFragment<HomeContract.View,HomeContract.Presenter> implements HomeContract.View {
    @BindView(R.id.banner)
    Banner mBanner;
    @BindView(R.id.tabLayout)
    TabLayout mTabLayout;
    @BindView(R.id.home_Rec)
    RecyclerView mRecHome;
    @BindView(R.id.xpRec)
    RecyclerView mXpRec;
    @BindView(R.id.rqRec)
    RecyclerView mZtRec;
    @BindView(R.id.jxRec)
    RecyclerView mJxRec;
    @BindView(R.id.jjRec)
    RecyclerView mJjRec;
    @BindView(R.id.ccRec)
    RecyclerView mCcRec;

    private HomeAdapter homeAdapter;
    List<IndexBean.DataBean.BrandListBean> brandList;

    private List<IndexBean.DataBean.NewGoodsListBean> newGoodsListBeanList;
    private XpAdapter xpAdapter;

    private List<IndexBean.DataBean.HotGoodsListBean> hotGoodsListBeans;
    private RqAdapter rqAdapter;

    private List<IndexBean.DataBean.TopicListBean> topicListBeans;
    private JxAdapter jxAdapter;

    private List<IndexBean.DataBean.CategoryListBean.GoodsListBean> goodsListBeans;
    private JjAdapter jjAdapter;

    private CcAdapter ccAdapter;

    @Override
    protected void initData() {
        persenter.getHomeData();
    }

    @Override
    protected void initView() {

        GridLayoutManager gridLayoutManager = new GridLayoutManager(getActivity(), 2) {
            @Override
            public boolean canScrollVertically() {
                return false;
            }
        };
        mRecHome.setLayoutManager(gridLayoutManager);
        brandList = new ArrayList<>();
        homeAdapter = new HomeAdapter(brandList,context);
        mRecHome.setAdapter(homeAdapter);



        GridLayoutManager gridManager = new GridLayoutManager(getActivity(), 2) {
            @Override
            public boolean canScrollVertically() {
                return false;
            }
        };
        mXpRec.setLayoutManager(gridManager);
        newGoodsListBeanList = new ArrayList<>();
        xpAdapter = new XpAdapter(newGoodsListBeanList,context);
        mXpRec.setAdapter(xpAdapter);



        LinearLayoutManager linearLayoutManager = new LinearLayoutManager(getActivity()) {
            @Override
            public boolean canScrollVertically() {
                return false;
            }
        };
        mZtRec.setLayoutManager(linearLayoutManager);
        mZtRec.addItemDecoration(new DividerItemDecoration(getActivity(), DividerItemDecoration.VERTICAL));
        hotGoodsListBeans = new ArrayList<>();
        rqAdapter = new RqAdapter(hotGoodsListBeans,context);
        mZtRec.setAdapter(rqAdapter);



        LinearLayoutManager manager = new LinearLayoutManager(getActivity());
        manager.setOrientation(LinearLayoutManager.HORIZONTAL);
        mJxRec.setLayoutManager(manager);
        topicListBeans = new ArrayList<>();
        jxAdapter = new JxAdapter(topicListBeans,context);
        mJxRec.setAdapter(jxAdapter);



        GridLayoutManager layoutManager = new GridLayoutManager(getActivity(), 2) {
            @Override
            public boolean canScrollVertically() {
                return false;
            }
        };
        mJjRec.setLayoutManager(layoutManager);
        goodsListBeans = new ArrayList<>();
        jjAdapter = new JjAdapter(goodsListBeans,context);
        mJjRec.setAdapter(jjAdapter);



        GridLayoutManager ccManager = new GridLayoutManager(getActivity(), 2) {
            @Override
            public boolean canScrollVertically() {
                return false;
            }
        };
        mCcRec.setLayoutManager(ccManager);
        List<IndexBean.DataBean.CategoryListBean.GoodsListBean> listBeans = new ArrayList<>();
        ccAdapter = new CcAdapter(listBeans,context);
        mCcRec.setAdapter(ccAdapter);
    }

    @Override
    protected HomeContract.Presenter createPersenter() {
        return new HomePresenter();
    }


    @Override
    protected int getLayout() {
        return R.layout.home_fragment;
    }

    @Override
    public void homeData(IndexBean bean) {
        Log.d("IndexBean", "homeData: "+bean.toString());
        List<IndexBean.DataBean.BannerBean> bannerBeanList = bean.getData().getBanner();
        final List<String> list = new ArrayList<>();
        for (int i = 0; i < bannerBeanList.size(); i++) {
            String url = bannerBeanList.get(i).getImage_url();
            list.add(url);
        }
        mBanner.setImages(list).setImageLoader(new ImageLoader() {
            @Override
            public void displayImage(Context context, Object path, ImageView imageView) {
                Glide.with(context).load((String) path).into(imageView);
            }
        }).start();

        List<IndexBean.DataBean.ChannelBean> channel = bean.getData().getChannel();
        for (int i = 0; i < channel.size(); i++) {
            mTabLayout.addTab(mTabLayout.newTab().setText(channel.get(i).getName()));
        }

        homeAdapter.updata(bean.getData().getBrandList());
        xpAdapter.updata(bean.getData().getNewGoodsList());
        rqAdapter.updata(bean.getData().getHotGoodsList());
        jxAdapter.updata(bean.getData().getTopicList());
        jjAdapter.updata(bean.getData().getCategoryList().get(0).getGoodsList());
        ccAdapter.updata(bean.getData().getCategoryList().get(1).getGoodsList());
    }
}