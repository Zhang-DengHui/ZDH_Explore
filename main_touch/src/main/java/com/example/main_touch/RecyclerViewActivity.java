package com.example.main_touch;

import android.content.Context;
import android.os.Bundle;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.TextView;

import androidx.annotation.NonNull;
import androidx.annotation.Nullable;
import androidx.appcompat.app.AppCompatActivity;
import androidx.recyclerview.widget.LinearLayoutManager;
import androidx.recyclerview.widget.RecyclerView;

import com.example.main_touch.model.DataBean;
import com.example.main_touch.recyclerviews.ParentRecyclerView;

import java.util.ArrayList;
import java.util.List;

public class RecyclerViewActivity extends AppCompatActivity {
    List<DataBean> list;
    MyAdapter myAdapter;
    Context context;
    private ParentRecyclerView mRecyclerview;

    @Override
    protected void onCreate(@Nullable Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_recycler_view);
        context=this;
        initData();
        initView();
    }

    private void initView() {
        mRecyclerview = (ParentRecyclerView) findViewById(R.id.recyclerview);
        myAdapter=new MyAdapter();
        mRecyclerview.setLayoutManager(new LinearLayoutManager(this));
        mRecyclerview.setAdapter(myAdapter);
    }

    private void initData() {
        list=new ArrayList<>();
        for (int i = 0; i < 100; i++) {
            DataBean dataBean = new DataBean();
            dataBean.type = i % 20 == 0 ? 1 : 0;
            dataBean.title = "徐丰" + i;
            if (dataBean.type==1) {
                dataBean.list = new ArrayList<>();
                for (int j = 0; j < 20; j++) {
                    DataBean.ChildDataBean child = new DataBean.ChildDataBean();
                    child.name = "child" + j;
                    dataBean.list.add(child);
                }
            }
            list.add(dataBean);
            /*if (i%20==0){
                dataBean.type=1;
            }else{
                dataBean.type=0;
            }*/
        }
    }

    class MyAdapter extends RecyclerView.Adapter {

        @NonNull
        @Override
        public RecyclerView.ViewHolder onCreateViewHolder(@NonNull ViewGroup parent, int viewType) {
            View view;
            int type=viewType;
            RecyclerView.ViewHolder vh;
            if (type==0){
                view= LayoutInflater.from(context).inflate(R.layout.layout_item_child,parent,false);
                vh=new ChildVH(view);
            }else{
                view= LayoutInflater.from(context).inflate(R.layout.layout_item_parent,parent,false);
                vh=new ParentVH(view);
            }
            return vh;
        }

        @Override
        public void onBindViewHolder(@NonNull RecyclerView.ViewHolder holder, int position) {
            int type=getItemViewType(position);
            DataBean dataBean1 = list.get(position);
            if (type==1){
                ParentVH parentVH= (ParentVH)holder;
                DataBean dataBean=list.get(position);
                parentVH.txtTitle.setText(dataBean.title);
                ChildAdapter childAdapter=new ChildAdapter(dataBean.list);
                parentVH.itemRecy.setLayoutManager(new LinearLayoutManager(context));
                parentVH.itemRecy.setAdapter(childAdapter);
            }else{
                ChildVH childVH=(ChildVH)holder;
                childVH.txtName.setText(dataBean1.title);
            }
        }

        @Override
        public int getItemCount() {
            return list.size();
        }

        @Override
        public int getItemViewType(int position) {
            return list.get(position).type;
        }

        class ChildAdapter extends RecyclerView.Adapter{
            List<DataBean.ChildDataBean>childList;
            public  ChildAdapter(List<DataBean.ChildDataBean>childList){
                this.childList=childList;
            }
            @NonNull
            @Override
            public RecyclerView.ViewHolder onCreateViewHolder(@NonNull ViewGroup parent, int viewType) {
                View view=LayoutInflater.from(context).inflate(R.layout.layout_list_item,parent,false);
                ChildItemVh vh=new ChildItemVh(view);
                return vh;
            }

            @Override
            public void onBindViewHolder(@NonNull RecyclerView.ViewHolder holder, int position) {
                ChildItemVh vh=(ChildItemVh)holder;
                vh.txtItem.setText(this.childList.get(position).name);
            }

            @Override
            public int getItemCount() {
                return this.childList.size();
            }
        }

        class ParentVH extends RecyclerView.ViewHolder {
            TextView txtTitle;
            RecyclerView itemRecy;
            public ParentVH(@NonNull View itemView) {
                super(itemView);
                txtTitle=itemView.findViewById(R.id.txt_title);
                        itemRecy=itemView.findViewById(R.id.item_recy);
            }
        }
        class ChildVH extends RecyclerView.ViewHolder {
            TextView txtName;
            public ChildVH(@NonNull View itemView) {
                super(itemView);
                txtName=itemView.findViewById(R.id.txt_name);
            }
        }
        class ChildItemVh extends RecyclerView.ViewHolder {
            TextView txtItem;
            public ChildItemVh(@NonNull View itemView) {
                super(itemView);
                txtItem=itemView.findViewById(R.id.txt_item);
            }
        }
    }
}
