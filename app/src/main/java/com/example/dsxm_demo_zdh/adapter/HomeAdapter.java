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

public class HomeAdapter extends BaseAdapter {


    public HomeAdapter(List mDatas, Context mContext) {
        super(mDatas, mContext);
    }

    @Override
    protected void bindData(BaseViewHolder holder, Object o, int position) {
        IndexBean.DataBean.BrandListBean list = (IndexBean.DataBean.BrandListBean) mDatas.get(position);
        ImageView img = (ImageView) holder.getView(R.id.home_img);
        TextView price = (TextView) holder.getView(R.id.home_price);
        TextView name = (TextView) holder.getView(R.id.home_name);
        price.setText(list.getFloor_price()+"元起");
        name.setText(list.getName());
        Glide.with(mContext).load(list.getNew_pic_url()).into(img);
    }

    @Override
    protected int getLayout() {
        return R.layout.home_adapter;
    }


}
