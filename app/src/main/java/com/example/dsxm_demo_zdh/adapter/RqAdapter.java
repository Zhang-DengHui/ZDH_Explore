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

public class RqAdapter extends BaseAdapter {


    public RqAdapter(List mDatas, Context mContext) {
        super(mDatas, mContext);
    }

    @Override
    protected void bindData(BaseViewHolder holder, Object o, int position) {
        ImageView img = (ImageView) holder.getView(R.id.rqImg);
        TextView title = (TextView) holder.getView(R.id.rqTitle);
        TextView type = (TextView) holder.getView(R.id.rqType);
        TextView price = (TextView) holder.getView(R.id.rqPrice);
        IndexBean.DataBean.HotGoodsListBean listBean = (IndexBean.DataBean.HotGoodsListBean) mDatas.get(position);
        Glide.with(mContext).load(listBean.getList_pic_url()).into(img);
        title.setText(listBean.getName());
        type.setText(listBean.getGoods_brief());
        price.setText("￥"+listBean.getRetail_price());
    }

    @Override
    protected int getLayout() {
        return R.layout.rq_adapter;
    }


}
