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

public class ZhuanTiAdapter extends BaseAdapter {


    public ZhuanTiAdapter(List mDatas, Context mContext) {
        super(mDatas, mContext);
    }

    @Override
    protected void bindData(BaseViewHolder holder, Object o, int position) {
        ImageView img = (ImageView) holder.getView(R.id.zhuantiImg);
        TextView subtitle = (TextView) holder.getView(R.id.zhuantiSubtitle);
        TextView title = (TextView) holder.getView(R.id.zhuantiTitle);
        TextView price = (TextView) holder.getView(R.id.zhuantiPrice);
        price.setText("0元起");
        IndexBean.DataBean.TopicListBean zhuantiList = (IndexBean.DataBean.TopicListBean) mDatas.get(position);
        subtitle.setText(zhuantiList.getSubtitle());
        title.setText(zhuantiList.getTitle());
        Glide.with(mContext).load(zhuantiList.getItem_pic_url()).into(img);
    }

    @Override
    protected int getLayout() {
        return R.layout.zhuanti_adapter;
    }


}
