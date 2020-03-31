package com.example.main_nvrs;

import android.content.Context;
import android.os.Bundle;
import android.util.Log;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;

import androidx.annotation.NonNull;
import androidx.annotation.Nullable;
import androidx.fragment.app.Fragment;

public class ThreeFragment extends Fragment {
    private static final String TAG = "ThreeFragment";
    @Nullable
    @Override
    public View onCreateView(@NonNull LayoutInflater inflater, @Nullable ViewGroup container, @Nullable Bundle savedInstanceState) {
        Log.i(TAG, "onCreateView：绘制视图");
        return super.onCreateView(inflater, container, savedInstanceState);
    }

    @Override
    public void onCreate(@Nullable Bundle savedInstanceState) {
        Log.i(TAG, "onCreate: 初始化操作");
        super.onCreate(savedInstanceState);
    }

    @Override
    public void onAttach(@NonNull Context context) {
        Log.i(TAG, "onAttach: 绑定Activity");
        super.onAttach(context);
    }

    @Override
    public void onActivityCreated(@Nullable Bundle savedInstanceState) {
        Log.i(TAG, "onActivityCreated ");
        super.onActivityCreated(savedInstanceState);
    }

    @Override
    public void onStart() {
        Log.i(TAG, "onStart: 启动");
        super.onStart();
    }

    @Override
    public void onResume() {
        Log.i(TAG, "onResume: 重新运行");
        super.onResume();
    }

    @Override
    public void onPause() {
        Log.i(TAG, "onPause: 暂停");
        super.onPause();
    }

    @Override
    public void onStop() {
        Log.i(TAG, "onStop: 停止");
        super.onStop();
    }

    @Override
    public void onDestroyView() {
        Log.i(TAG, "onDestroyView: 销毁视图");
        super.onDestroyView();
    }

    @Override
    public void onDestroy() {
        Log.i(TAG, "onDestroy:销毁Fragment ");
        super.onDestroy();
    }

    @Override
    public void onDetach() {
        Log.i(TAG, "onDetach: 解除绑定");
        super.onDetach();
    }
}
