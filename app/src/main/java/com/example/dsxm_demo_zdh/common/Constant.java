package com.example.dsxm_demo_zdh.common;

import com.example.dsxm_demo_zdh.apps.MyApp;

import java.io.File;

public class Constant {
    public static final String BASE_WAN_URL = "https://www.wanandroid.com/"; //wanandroid基础地址

    public static final String BASE_SHOP_URL = "https://cdwan.cn/api/";  //商城的基础地址


    //网络缓存的地址
    public static final String PATH_DATA = MyApp.myApp.getCacheDir().getAbsolutePath() + File.separator + "data";

    public static final String PATH_CACHE = PATH_DATA + "/shop";


    public static final String PRICE_MODEL = "$元起";

    public static String session_id;

    public static String token;
}
