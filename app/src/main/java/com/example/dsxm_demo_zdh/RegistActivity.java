package com.example.dsxm_demo_zdh;

import android.view.View;
import android.widget.Button;
import android.widget.EditText;
import android.widget.ImageView;
import android.widget.LinearLayout;

import com.bumptech.glide.Glide;
import com.example.dsxm_demo_zdh.base.BaseActivity;
import com.example.dsxm_demo_zdh.contract.LogenContract;
import com.example.dsxm_demo_zdh.models.api.bean.VerifyBean;
import com.example.dsxm_demo_zdh.persenter.RegistPresenter;

public class RegistActivity extends BaseActivity<LogenContract.Presenter> implements LogenContract.View {

    private EditText mUsernameEdit;
    private EditText mPw1Edit;
    private EditText mPw2Edit;
    private EditText mVerifyEdit;
    private ImageView mVerifyImg;
    private LinearLayout mListLayout;
    private Button mRegisterBtn;

    @Override
    protected void initData() {
        persenter.getVerify();
    }

    @Override
    protected LogenContract.Presenter createPersenter() {
        return new RegistPresenter();
    }



    @Override
    protected void initView() {

        mUsernameEdit = (EditText) findViewById(R.id.edit_username);
        mPw1Edit = (EditText) findViewById(R.id.edit_pw1);
        mPw2Edit = (EditText) findViewById(R.id.edit_pw2);
        mVerifyEdit = (EditText) findViewById(R.id.edit_verify);
        mVerifyImg = (ImageView) findViewById(R.id.img_verify);
        mListLayout = (LinearLayout) findViewById(R.id.layout_list);
        mRegisterBtn = (Button) findViewById(R.id.btn_register);

        mVerifyImg.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {
                persenter.getVerify();
            }
        });
        mRegisterBtn.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {

            }
        });
    }

    @Override
    protected int getLayout() {
        return R.layout.activity_logen;
    }

    @Override
    public void getVerifyReturn(VerifyBean result) {
        updateVerify(result);
    }

    private void updateVerify(VerifyBean bean){
        Glide.with(this).load(bean.getData().getImg()).into(mVerifyImg);
    }
}