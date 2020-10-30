package com.tctmass;

import android.content.Intent;

import com.facebook.react.bridge.ReactApplicationContext;
import com.facebook.react.bridge.ReactContextBaseJavaModule;
import com.facebook.react.bridge.ReactMethod;

public class RNManagerModule extends ReactContextBaseJavaModule {
    private ReactApplicationContext mContext;
    public RNManagerModule(ReactApplicationContext reactContext) {
        super(reactContext);
        mContext = reactContext;
    }

    @Override
    public String getName() {
        return "RNManagerModule";
    }

    //RN调用android Activity
    @ReactMethod
    public void RNActivity(){
        Intent intent = new Intent(mContext,RnActivity.class);
        intent.setFlags(Intent.FLAG_ACTIVITY_NEW_TASK);    //一定要加上这句
        mContext.startActivity(intent);
    }

}