package com.example.dsxm_demo_zdh.base;

import com.example.dsxm_demo_zdh.interfaces.IBasePersenter;
import com.example.dsxm_demo_zdh.interfaces.IBaseView;

import java.lang.ref.WeakReference;

import io.reactivex.disposables.CompositeDisposable;
import io.reactivex.disposables.Disposable;

public abstract class BasePresenter<V extends IBaseView>implements IBasePersenter<V> {

    public WeakReference<V> weakReference;
    public V mView;
    public CompositeDisposable compositeDisposable;

    @Override
    public void attachView(V view) {
        weakReference = new WeakReference<>(view);
        mView = weakReference.get();
    }
    public void addSubscribe(Disposable disposable){
        compositeDisposable = new CompositeDisposable();
        if (compositeDisposable==null){
            compositeDisposable.add(disposable);
        }
    }
    public void unSubscribe(){
        if (compositeDisposable!=null){
            compositeDisposable.clear();
        }
    }

}
