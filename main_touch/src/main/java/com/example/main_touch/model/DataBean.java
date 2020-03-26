package com.example.main_touch.model;

import java.util.List;

public class DataBean {
    public int type; //0 默认得列表条目 1 嵌套得列表
    public String title;
    public List<ChildDataBean> list;
    public static class ChildDataBean{
        public String name;

    }
}
