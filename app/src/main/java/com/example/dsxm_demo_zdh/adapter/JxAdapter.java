package com.example.dsxm_demo_zdh.adapter;

import android.content.Context;
import android.widget.ImageView;
import android.widget.TextView;

import com.bumptech.glide.Glide;
import com.example.dsxm_demo_zdh.R;
import com.example.dsxm_demo_zdh.base.BaseAdapter;
import com.example.dsxm_demo_zdh.models.api.bean.IndexBean;


import java.util.List;

public class JxAdapter extends BaseAdapter {


    public JxAdapter(List mDatas, Context mContext) {
        super(mDatas, mContext);
    }

    @Override
    protected void bindData(BaseViewHolder holder, Object o, int position) {
        ImageView img = (ImageView) holder.getView(R.id.jxImg);
        TextView title = (TextView) holder.getView(R.id.jxTitle);
        TextView type = (TextView) holder.getView(R.id.jxType);
        IndexBean.DataBean.TopicListBean been = (IndexBean.DataBean.TopicListBean) mDatas.get(position);
        Glide.with(mContext).load(been.getItem_pic_url()).into(img);
        title.setText(been.getTitle()+"￥ 0.00元起");
        type.setText(been.getSubtitle());
    }



    @Override
    protected int getLayout() {
        return R.layout.jx_adapter;
    }


}
