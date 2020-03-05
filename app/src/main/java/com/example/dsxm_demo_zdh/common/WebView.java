package com.example.dsxm_demo_zdh.common;

import android.content.Context;
import android.util.AttributeSet;
import android.webkit.WebSettings;

public class WebView extends android.webkit.WebView {
    private String css_str;
    private Context context;


    public WebView(Context context) {
        super(context);
        initView(context,null);
    }

    public WebView(Context context, AttributeSet attrs) {
        super(context, attrs);
        initView(context,attrs);
    }

    public WebView(Context context, AttributeSet attrs, int defStyleAttr) {
        super(context, attrs, defStyleAttr);
        initView(context,attrs);
    }

    public WebView(Context context, AttributeSet attrs, int defStyleAttr, int defStyleRes) {
        super(context, attrs, defStyleAttr, defStyleRes);
        initView(context,attrs);
    }

    private void initView(Context context,AttributeSet attrs){
        this.context = context;
        WebSettings webSettings = this.getSettings();
        webSettings.setJavaScriptEnabled(true);
        webSettings.setBuiltInZoomControls(true);
    }

    public void loadData(String data){

    }
}
