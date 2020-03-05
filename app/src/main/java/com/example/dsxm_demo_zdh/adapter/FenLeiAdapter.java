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
import com.example.dsxm_demo_zdh.models.api.bean.CatalogItem;


import java.util.List;

public class FenLeiAdapter extends BaseAdapter {


    public FenLeiAdapter(List mDatas, Context mContext) {
        super(mDatas, mContext);
    }

    @Override
    protected void bindData(BaseViewHolder holder, Object o, int position) {
        ImageView img = (ImageView) holder.getView(R.id.fenleiImg);
        TextView title = (TextView) holder.getView(R.id.fenleiTitle);
        CatalogItem list = (CatalogItem) this.mDatas.get(position);
        Glide.with(mContext).load(list.img).into(img);
        title.setText(list.name);
    }

    @Override
    protected int getLayout() {
        return R.layout.fenlei_adapter;
    }

}
