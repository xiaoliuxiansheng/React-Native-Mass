package com.tctmass;

import android.content.Intent;

import com.facebook.react.bridge.ReactApplicationContext;
import com.facebook.react.bridge.ReactContextBaseJavaModule;
import com.facebook.react.bridge.ReactMethod;
import com.m7.imkfsdk.KfStartHelper;
import com.moor.imkf.IMChatManager;

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
//        initSdk();
    }
    private void initSdk() {
        IMChatManager.getInstance().init(mContext.getApplicationContext(),
                "receiverAction",
                "7a6926e0-181a-11eb-b15d-054468910f6c",
                "username ",
                "userId");
//        helper.initSdkChat("7a6926e0-181a-11eb-b15d-054468910f6c", "测试xxx", "88888");
    }


}