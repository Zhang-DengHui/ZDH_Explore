package com.example.dsxm_demo_zdh.fragment;

import android.content.Intent;
import android.graphics.Color;
import android.text.TextUtils;
import android.widget.ImageView;
import android.widget.TextView;

import androidx.recyclerview.widget.GridLayoutManager;
import androidx.recyclerview.widget.RecyclerView;

import com.bumptech.glide.Glide;
import com.example.dsxm_demo_zdh.R;
import com.example.dsxm_demo_zdh.adapter.FenLeiAdapter;
import com.example.dsxm_demo_zdh.base.BaseAdapter;
import com.example.dsxm_demo_zdh.base.BaseFragment;
import com.example.dsxm_demo_zdh.contract.FenLeiContract;
import com.example.dsxm_demo_zdh.models.api.bean.CatalogItem;
import com.example.dsxm_demo_zdh.models.api.bean.CatalogListBean;
import com.example.dsxm_demo_zdh.models.api.bean.CatalogTabBean;
import com.example.dsxm_demo_zdh.persenter.FenLeiPresenter;

import java.util.ArrayList;
import java.util.List;

import butterknife.BindView;
import q.rorbin.verticaltablayout.VerticalTabLayout;
import q.rorbin.verticaltablayout.adapter.TabAdapter;
import q.rorbin.verticaltablayout.widget.ITabView;
import q.rorbin.verticaltablayout.widget.QTabView;
import q.rorbin.verticaltablayout.widget.TabView;

public class FenLeiFragment extends BaseFragment<FenLeiContract.View, FenLeiContract.Presenter> implements FenLeiContract.View, VerticalTabLayout.OnTabSelectedListener, BaseAdapter.ItemClickHandler {
    @BindView(R.id.tab)
    VerticalTabLayout mTab;
    @BindView(R.id.titleImg)
    ImageView mTitleImg;
    @BindView(R.id.fenleiName)
    TextView mFenleiName;
    @BindView(R.id.fenleiRec)
    RecyclerView mFenleiRec;
    private GridLayoutManager gridLayoutManager;
    private List<CatalogItem> list;
    private List<String> titles;
    private FenLeiAdapter fenLeiAdapter;
    //竖导航的列表
    List<CatalogTabBean.DataBean.CategoryListBean> categoryList;

    @Override
    protected void initData() {
        persenter.getsort();
    }

    @Override
    protected void initView() {
        gridLayoutManager = new GridLayoutManager(getActivity(), 3) {
            @Override
            public boolean canScrollVertically() {
                return false;
            }
        };
        mFenleiRec.setLayoutManager(gridLayoutManager);
        list = new ArrayList<>();
        titles = new ArrayList<>();
        fenLeiAdapter = new FenLeiAdapter(list,context);
        fenLeiAdapter.setItemClickHandler(this);
        mTab.addOnTabSelectedListener(this);
    }

    @Override
    protected FenLeiContract.Presenter createPersenter() {
        return new FenLeiPresenter();
    }





    TabAdapter tabAdapter = new TabAdapter() {
        @Override
        public int getCount() {
            return titles.size();
        }

        @Override
        public ITabView.TabBadge getBadge(int position) {
            return null;
        }

        @Override
        public ITabView.TabIcon getIcon(int position) {
            return null;
        }

        @Override
        public ITabView.TabTitle getTitle(int position) {
            QTabView.TabTitle title = new QTabView.TabTitle.Builder()
                    .setContent(titles.get(position))//设置数据   也有设置字体颜色的方法
                    .build();
            return title;
        }

        @Override
        public int getBackground(int position) {
            return Color.parseColor("#D81B60");
        }
    };

    @Override
    protected int getLayout() {
        return R.layout.fenlei_fragment;
    }

    @Override
    public void getsortData(CatalogTabBean result) {
        categoryList = result.getData().getCategoryList();
        titles.clear();
        //筛选竖导航的标题数据
        for (CatalogTabBean.DataBean.CategoryListBean item : result.getData().getCategoryList()) {
            titles.add(item.getName());
        }
        mTab.setTabAdapter(tabAdapter);

        updateInfo(result.getData().getCurrentCategory().getWap_banner_url(), result.getData().getCurrentCategory().getFront_desc(),
                result.getData().getCurrentCategory().getName() + "分类");
        //刷新列表
        list.clear();
        for (CatalogTabBean.DataBean.CurrentCategoryBean.SubCategoryListBean item : result.getData().getCurrentCategory().getSubCategoryList()) {
            CatalogItem catalogItem = new CatalogItem();
            catalogItem.id = item.getId();
            catalogItem.img = item.getWap_banner_url();
            catalogItem.name = item.getName();
            list.add(catalogItem);
        }
        fenLeiAdapter.notifyDataSetChanged();
    }

    @Override
    public void getFenLei(CatalogListBean result) {
        updateInfo(result.getData().getCurrentCategory().getWap_banner_url(), result.getData().getCurrentCategory().getFront_desc(),
                result.getData().getCurrentCategory().getName() + "分类");

        list.clear();
        for (CatalogListBean.DataBean.CurrentCategoryBean.SubCategoryListBean item : result.getData().getCurrentCategory().getSubCategoryList()) {
            CatalogItem catalogItem = new CatalogItem();
            catalogItem.id = item.getId();
            catalogItem.img = item.getWap_banner_url();
            catalogItem.name = item.getName();
            list.add(catalogItem);
        }
        fenLeiAdapter.notifyDataSetChanged();
    }

    //刷新右边的界面
    private void updateInfo(String imgUrl, String des, String title) {
        if (!TextUtils.isEmpty(imgUrl)) {
            Glide.with(getActivity()).load(imgUrl).into(mTitleImg);
        }
//        txtDesc.setText(des);
        mFenleiName.setText(title);
    }

    @Override
    public void onTabSelected(TabView tab, int position) {
        if (categoryList != null) {
            int id = categoryList.get(position).getId();
            //请求id对应的列表数据
            persenter.getFenLeiData(id);
        }
    }

    @Override
    public void onTabReselected(TabView tab, int position) {

    }


    @Override
    public void itemClick(int position, BaseAdapter.BaseViewHolder holder) {
        int id = list.get(position).id;
        Intent intent = new Intent(getActivity(), SortDetailActivity.class);
        intent.putExtra("id", id);
        startActivity(intent);
    }
}
