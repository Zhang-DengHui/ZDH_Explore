package com.example.dsxm_demo_zdh.adapter;

import android.content.Context;
import android.view.View;
import android.widget.ImageView;
import android.widget.PopupWindow;
import android.widget.TextView;

import androidx.annotation.NonNull;
import androidx.recyclerview.widget.RecyclerView;

import com.bumptech.glide.Glide;
import com.example.dsxm_demo_zdh.R;
import com.example.dsxm_demo_zdh.base.BaseAdapter;
import com.example.dsxm_demo_zdh.models.api.bean.DetilListBean;


import java.util.List;

public class DetilAdapter extends BaseAdapter {


    public DetilAdapter(List mDatas, Context mContext) {
        super(mDatas, mContext);
    }

    @Override
    protected void bindData(BaseViewHolder holder, Object o, int position) {
        ImageView img = (ImageView) holder.getView(R.id.detilImg);
        TextView title = (TextView) holder.getView(R.id.detilTitle);
        TextView price = (TextView) holder.getView(R.id.detilPrice);
        DetilListBean.DataBeanX.GoodsListBean list = (DetilListBean.DataBeanX.GoodsListBean) this.mDatas.get(position);
        Glide.with(mContext).load(list.getList_pic_url()).into(img);
        title.setText(list.getName());
        price.setText(list.getRetail_price()+"元起");
    }

    @Override
    protected int getLayout() {
        return R.layout.detil_adapter;
    }


}
