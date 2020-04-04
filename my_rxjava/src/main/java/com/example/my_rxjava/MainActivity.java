package com.example.my_rxjava;

import android.os.Bundle;
import android.util.Log;
import android.view.View;
import android.widget.Button;

import androidx.appcompat.app.AppCompatActivity;

import java.util.ArrayList;
import java.util.List;
import java.util.concurrent.TimeUnit;

import io.reactivex.Observable;
import io.reactivex.ObservableEmitter;
import io.reactivex.ObservableOnSubscribe;
import io.reactivex.ObservableSource;
import io.reactivex.Observer;
import io.reactivex.android.schedulers.AndroidSchedulers;
import io.reactivex.disposables.Disposable;
import io.reactivex.functions.BiFunction;
import io.reactivex.functions.Consumer;
import io.reactivex.functions.Function;
import io.reactivex.schedulers.Schedulers;

public class MainActivity extends AppCompatActivity implements View.OnClickListener {
    private static final String TAG = "MainActivity";
    private Button mBtn;
    private Button mMapBtn;
    private Button mYanshiBtn;
    private Button mZipBtn;
    private Button mMaparrayBtn;
    private Button mConcatBtn;
    private Button mConcatarrayBtn;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_main);
        initView();
    }

    private void initView() {
        mBtn = (Button) findViewById(R.id.btn);
        mBtn.setOnClickListener(this);
        mMapBtn = (Button) findViewById(R.id.btn_map);
        mMapBtn.setOnClickListener(this);
        mYanshiBtn = (Button) findViewById(R.id.btn_yanshi);
        mYanshiBtn.setOnClickListener(this);
        mZipBtn = (Button) findViewById(R.id.btn_zip);
        mZipBtn.setOnClickListener(this);
        mMaparrayBtn = (Button) findViewById(R.id.btn_maparray);
        mMaparrayBtn.setOnClickListener(this);
        mConcatBtn = (Button) findViewById(R.id.btn_concat);
        mConcatBtn.setOnClickListener(this);
        mConcatarrayBtn = (Button) findViewById(R.id.btn_concatarray);
        mConcatarrayBtn.setOnClickListener(this);
    }

    @Override
    public void onClick(View v) {
        switch (v.getId()) {
            case R.id.btn:
                // TODO 20/04/02
                //将原先的Obserable对象转换成另外一种或者多种Obserable对象
                flatMap();
                break;
            case R.id.btn_map:
                // TODO 20/04/02
                map();
                break;
            case R.id.btn_yanshi:// TODO 20/04/02
                //两个被观察者发送的事件部分先后顺序 但是确定的是两者并行(同时)发送
                merge();
                break;
            case R.id.btn_zip:// TODO 20/04/02
                //合并操作符 合并 多个被观察者（Observable）发送的事件-------->合并之后形成一个新的事件序列（即组合过后的新的事件序列）------->然后成一个新的被观察者和-------->并最终发送2.以少的被观察者发送的事件为准
                zip();
                break;
            case R.id.btn_maparray:// TODO 20/04/02
                //合并操作符 合并多个观察者然后按照时间线并行执行
                mapArray();
                break;
            case R.id.btn_concat:// TODO 20/04/02
                //组合操作符 组合的被观察者数量小于等于4
                concat();
                break;
            case R.id.btn_concatarray:// TODO 20/04/02
                //组合操作符 组合的被观察者数量大于等于4
                concatArray();
                break;
            default:
                break;
        }
    }

    private void concatArray() {
        Observable.concatArray(Observable.just(1, 2, 3),
                Observable.just(4, 5, 6),
                Observable.just(7, 8, 9),
                Observable.just(10, 11, 12),
                Observable.just(13, 14, 15),
                Observable.just("哈哈", true, 12)).subscribe(new Observer<Object>() {

            @Override
            public void onSubscribe(Disposable d) {
                Log.e("TAG", "disposable");
            }

            @Override
            public void onNext(Object value) {
                Log.e("TAG", "onNext====" + value);
            }

            @Override
            public void onError(Throwable e) {
                Log.e("TAG", "onError====" + e.getMessage());
            }

            @Override
            public void onComplete() {
                Log.e("TAG", "onComplete====");
            }
        });
    }

    private void concat() {
        Observable.concat(Observable.just(1, 2, 3),
                Observable.just(4, 5, 6),
                Observable.just(7, 8, 9),
                Observable.just(10, 11, 12)).subscribe(new Observer<Object>() {

            @Override
            public void onSubscribe(Disposable d) {
                Log.e("TAG", "disposable");
            }

            @Override
            public void onNext(Object value) {
                Log.e("TAG", "onNext====" + value);
            }

            @Override
            public void onError(Throwable e) {
                Log.e("TAG", "onError====" + e.getMessage());
            }

            @Override
            public void onComplete() {
                Log.e("TAG", "onComplete====");
            }
        });


    }
//mergeArray
    private void mapArray() {
        Observable.mergeArray(Observable.intervalRange(0, 3, 1, 1, TimeUnit.SECONDS),
                Observable.intervalRange(5, 3, 1, 1, TimeUnit.SECONDS),
                Observable.intervalRange(10, 3, 1, 1, TimeUnit.SECONDS),
                Observable.intervalRange(20, 3, 1, 1, TimeUnit.SECONDS),
                Observable.intervalRange(30, 3, 1, 1, TimeUnit.SECONDS),
                Observable.intervalRange(40, 3, 1, 1, TimeUnit.SECONDS)
        ).
                subscribe(new Observer<Object>() {
                    @Override
                    public void onSubscribe(Disposable d) {
                        Log.e("TAG", "disposable");
                    }

                    @Override
                    public void onNext(Object value) {
                        Log.e("TAG", "onNext====" + value);
                    }

                    @Override
                    public void onError(Throwable e) {
                        Log.e("TAG", "onError====" + e.getMessage());
                    }

                    @Override
                    public void onComplete() {
                        Log.e("TAG", "onComplete====");
                    }
                });
    }
    //intervalRange
    private void merge() {
        Observable.merge(Observable.intervalRange(0, 3, 1, 1, TimeUnit.SECONDS),
                Observable.intervalRange(2, 3, 1, 1, TimeUnit.SECONDS)).
                subscribe(new Observer<Object>() {
                    @Override
                    public void onSubscribe(Disposable d) {
                        Log.e("TAG", "disposable");
                    }

                    @Override
                    public void onNext(Object value) {
                        Log.e("TAG", "onNext====" + value);
                    }

                    @Override
                    public void onError(Throwable e) {
                        Log.e("TAG", "onError====" + e.getMessage());
                    }

                    @Override
                    public void onComplete() {
                        Log.e("TAG", "onComplete====");
                    }
                });

    }

    private void zip() {
        //创建第1个被观察者
        Observable<Integer> observable1 = Observable.create(new ObservableOnSubscribe<Integer>() {
            @Override
            public void subscribe(ObservableEmitter<Integer> emitter) throws Exception {
                Log.d(TAG, "被观察者1发送了事件1");
                emitter.onNext(1);
                // 为了方便展示效果，所以在发送事件后加入2s的延迟
                Thread.sleep(1000);

                Log.d(TAG, "被观察者1发送了事件2");
                emitter.onNext(2);
                Thread.sleep(1000);

                Log.d(TAG, "被观察者1发送了事件3");
                emitter.onNext(3);
                Thread.sleep(1000);

                emitter.onComplete();
            }
        }).subscribeOn(Schedulers.io());
        // 设置被观察者1在工作线程1中工作


        //创建第二个被观察者
        Observable<String> observable2 = Observable.create(new ObservableOnSubscribe<String>() {
            @Override
            public void subscribe(ObservableEmitter<String> emitter) throws Exception {
                Log.d(TAG, "被观察者2发送了事件A");
                emitter.onNext("A");
                Thread.sleep(1000);

                Log.d(TAG, "被观察者2发送了事件B");
                emitter.onNext("B");
                Thread.sleep(1000);

                Log.d(TAG, "被观察者2发送了事件C");
                emitter.onNext("C");


                Log.d(TAG, "被观察者2发送了事件D");
                emitter.onNext("D");
                Thread.sleep(1000);

                emitter.onComplete();
            }
        }).subscribeOn(Schedulers.newThread());// 设置被观察者2在工作线程2中工作
        // 假设不作线程控制，则该两个被观察者会在同一个线程中工作，即发送事件存在先后顺序，而不是同时发送


        //合并两个被观察者
        Observable.zip(observable1, observable2, new BiFunction<Integer, String, Object>() {
            @Override
            public Object apply(Integer integer, String s) throws Exception {
                return integer + s;
            }
        }).observeOn(AndroidSchedulers.mainThread()).
                subscribe(new Observer<Object>() {
                    @Override
                    public void onSubscribe(Disposable d) {
                        Log.e("TAG", "disposable");
                    }

                    @Override
                    public void onNext(Object value) {
                        Log.e("TAG", "onNext====" + value);
                    }

                    @Override
                    public void onError(Throwable e) {
                        Log.e("TAG", "onError====" + e.getMessage());
                    }

                    @Override
                    public void onComplete() {
                        Log.e("TAG", "onComplete====");
                    }
                });
    }

    private void map() {
        Observable.create(new ObservableOnSubscribe<String>() {
            @Override
            public void subscribe(ObservableEmitter<String> e) throws Exception {
                e.onNext("1");
                e.onNext("2");
                e.onNext("3");
                e.onComplete();
                // e.onError(new IOException("哈哈，这是网络|文件读取异常"));
            }
        }).map(new Function<String, Integer>() {
            @Override
            public Integer apply(String s) throws Exception {
                //  map（）操作符 将发送端的一种类型转换成另外一种类型  然后发送给接收端
                return Integer.parseInt(s);
            }
        }).subscribeOn(Schedulers.io()).observeOn(AndroidSchedulers.mainThread()).
                subscribe(new Observer<Integer>() {
                    @Override
                    public void onSubscribe(Disposable d) {

                    }

                    @Override
                    public void onNext(Integer value) {
                        Log.e("TAG", "接收的事件是：" + value);
                    }

                    @Override
                    public void onError(Throwable e) {
                        Log.e("TAG", e.getMessage() + "=====onError");
                    }

                    @Override
                    public void onComplete() {
                        Log.e("TAG", "onComplete");
                    }
                });
    }
//变换操作符
    private void flatMap() {
        Observable.create(new ObservableOnSubscribe<Integer>() {
            @Override
            public void subscribe(ObservableEmitter<Integer> e) throws Exception {
                e.onNext(1);
                e.onNext(2);
                e.onNext(3);

            }
        }).flatMap(new Function<Integer, ObservableSource<String>>() {
            @Override
            public ObservableSource<String> apply(Integer integer) throws Exception {
                //存储拆分后的子事件
                List<String> list = new ArrayList<String>();
                for (int i = 0; i < 3; i++) {
                    list.add("我是事件" + integer + "拆分后的子事件" + (i + 1));
                }
                return Observable.fromIterable(list);
            }
        }).subscribeOn(Schedulers.io()).observeOn(AndroidSchedulers.mainThread()).
                subscribe(new Consumer<String>() {
                    @Override
                    public void accept(String str) throws Exception {
                        Log.e("TAG", str);
                    }
                });
    }
}
