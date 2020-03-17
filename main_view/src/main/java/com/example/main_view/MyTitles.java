package com.example.main_view;

import android.content.Context;
import android.content.res.TypedArray;
import android.util.AttributeSet;
import android.view.LayoutInflater;
import android.view.View;
import android.widget.Toast;

import androidx.appcompat.app.AppCompatActivity;
import androidx.constraintlayout.widget.ConstraintLayout;

public class MyTitles extends ConstraintLayout implements View.OnClickListener{

    private Context context;
    private String titleReturn;
    private boolean titleVisible;
    private String titleFinish;
    private String title;
    private View txtReturn;
    private View txtFinish;
    private View txtTitle;
    private View txtShared;
    private AppCompatActivity activity;
    private ITitleClick clickFun; //接口回调

    public MyTitles(Context context) {
        super(context);
    }

    public MyTitles(Context context, AttributeSet attrs) {
        super(context, attrs);
        initView(context,attrs);
    }

    public MyTitles(Context context, AttributeSet attrs, int defStyleAttr) {
        super(context, attrs, defStyleAttr);
    }

    public void initView(Context context,AttributeSet attrs){
        this.context=context;
        TypedArray typedArray = context.obtainStyledAttributes(attrs,R.styleable.mytitle);
        titleReturn = typedArray.getString(R.styleable.mytitle_title_return);
        titleVisible = typedArray.getBoolean(R.styleable.mytitle_title_visible, false);
        titleFinish = typedArray.getString(R.styleable.mytitle_titlr_finish);
        title = typedArray.getString(R.styleable.mytitle_title);

        View view= LayoutInflater.from(context).inflate(R.layout.layout_titles,null);
        addView(view,new ConstraintLayout.LayoutParams(LayoutParams.MATCH_PARENT,LayoutParams.WRAP_CONTENT));
        txtReturn = view.findViewById(R.id.txt_return);
        txtFinish = view.findViewById(R.id.txt_finish);
        txtTitle = view.findViewById(R.id.txt_title);
        txtShared = view.findViewById(R.id.txt_shared);

        txtReturn.setOnClickListener(this);
    }

    public void setClick(ITitleClick click){
        this.clickFun = click;
    }

    public void setActivity(AppCompatActivity activity){
        this.activity = activity;
    }

    @Override
    public void onClick(View view) {
        switch (view.getId()){
            case R.id.txt_return:
                if(activity != null && !activity.isFinishing()){
                    activity.finish();
                    activity = null;
                }
                break;
            case R.id.txt_shared:
                //1.把分享的内容传进来，  通过接口回调
                Toast.makeText(context,"点击分享",Toast.LENGTH_SHORT).show();
                //2.通过接口回调把点击事件传出去
                if(clickFun != null){
                    clickFun.titleClick(view);
                }
        }
    }

    //点击事件触发的接口回调
    interface ITitleClick{
        void titleClick(View view);
    }
}
