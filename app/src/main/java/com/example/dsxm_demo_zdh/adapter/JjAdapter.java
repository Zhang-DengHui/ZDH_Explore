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

public class JjAdapter extends BaseAdapter {


    public JjAdapter(List mDatas, Context mContext) {
        super(mDatas, mContext);
    }

    @Override
    protected void bindData(BaseViewHolder holder, Object o, int position) {
        ImageView img = (ImageView) holder.getView(R.id.jjImg);
        TextView title = (TextView) holder.getView(R.id.jjTitle);
        TextView price = (TextView) holder.getView(R.id.jjPrice);
        IndexBean.DataBean.CategoryListBean.GoodsListBean list = (IndexBean.DataBean.CategoryListBean.GoodsListBean) this.mDatas.get(position);
        Glide.with(mContext).load(list.getList_pic_url()).into(img);
        title.setText(list.getName());
        price.setText("￥"+(String) list.getRetail_price());
    }

    @Override
    protected int getLayout() {
        return R.layout.jj_adapter;
    }


}
