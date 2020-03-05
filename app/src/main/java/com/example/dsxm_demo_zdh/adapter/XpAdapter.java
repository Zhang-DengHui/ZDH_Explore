package com.example.dsxm_demo_zdh.adapter;

import android.content.Context;
import android.view.View;
import android.widget.ImageView;
import android.widget.TextView;

import androidx.annotation.NonNull;
import androidx.recyclerview.widget.RecyclerView;

import com.bumptech.glide.Glide;

import com.example.dsxm_demo_zdh.R;
import com.example.dsxm_demo_zdh.base.BaseAdapter;
import com.example.dsxm_demo_zdh.models.api.bean.IndexBean;

import java.util.List;

public class XpAdapter extends BaseAdapter {


    public XpAdapter(List mDatas, Context mContext) {
        super(mDatas, mContext);
    }

    @Override
    protected void bindData(BaseViewHolder holder, Object o, int position) {
        ImageView img = (ImageView) holder.getView(R.id.xpImg);
        TextView title = (TextView) holder.getView(R.id.xpTitle);
        TextView price = (TextView) holder.getView(R.id.xpPrice);
        IndexBean.DataBean.NewGoodsListBean bean = (IndexBean.DataBean.NewGoodsListBean) mDatas.get(position);
        Glide.with(mContext).load(bean.getList_pic_url()).into(img);
        title.setText(bean.getName());
        price.setText("￥"+bean.getRetail_price());
    }

    @Override
    protected int getLayout() {
        return R.layout.xp_adapter;
    }


}
