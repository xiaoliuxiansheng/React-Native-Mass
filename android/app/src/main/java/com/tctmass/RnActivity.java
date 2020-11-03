package com.tctmass;

import android.Manifest;
import android.content.res.Configuration;
import android.content.res.Resources;
import android.os.Build;
import android.os.Bundle;
import android.os.Handler;
import android.view.View;
import android.view.Window;
import android.widget.Toast;

import androidx.appcompat.app.AppCompatActivity;

import com.m7.imkfsdk.KfStartHelper;
import com.m7.imkfsdk.utils.PickUtils;
import com.moor.imkf.IMChatManager;
import com.moor.imkf.model.entity.CardInfo;
import com.moor.imkf.model.entity.NewCardInfo;
import com.moor.imkf.model.entity.NewCardInfoAttrs;
import com.moor.imkf.utils.MoorUtils;

import java.net.URLEncoder;
import java.util.Locale;



public class RnActivity extends AppCompatActivity implements View.OnClickListener {

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        requestWindowFeature(Window.FEATURE_NO_TITLE);
        setContentView( R.layout.kf_activity_main);
        //处理权限
        handlePermission();

        findViewById(R.id.button).setOnClickListener(this);
        findViewById(R.id.setting).setOnClickListener(this);
        findViewById(R.id.back).setOnClickListener(this);
    }

    @Override
    public void onClick(View v) {
        if(v.getId()== R.id.button){
            //初始化SDK
            initSdk();
        }else if(v.getId()== R.id.setting){
            //获取未读消息数示例
            getUnReadCount();
        } else if (v.getId() == R.id.back) {
            this.finish();
        }

    }

    /**
     * 初始化SDK
     */
    private void initSdk() {


        //设置sdk 显示语言版本
//        initLanguage("en");
        /*
          第一步:初始化help
         */


        final KfStartHelper helper = new KfStartHelper(this);

        /*
          商品信息实例，若有需要，请参照此方法；
         */

//        handleCardInfo(helper);

         /*
          新卡片类型示例，若有需要，请参照此方法；
         */
//        handleNewCardInfo(helper);

        /*
          第二步:设置参数
          初始化sdk方法，必须先调用该方法进行初始化后才能使用IM相关功能
          @param accessId       接入id（需后台配置获取）
          @param userName       用户名
          @param userId         用户id
         */

        /*
         * 修改会话页面 注销按钮 文案。建议两个 文字
         */
//        helper.setChatActivityLeftText("注销");

        /*
         * 修改会话页面 是否需要 emoji表情 按钮。
         */
//        helper.setChatActivityEmoji(true);


        helper.initSdkChat("7a6926e0-181a-11eb-b15d-054468910f6c", "android用户", "88888");
    }

    /**
     * 获取未读消息数示例
     */
    private void getUnReadCount() {
        if (MoorUtils.isInitForUnread(getApplicationContext())) {

            IMChatManager.getInstance().getMsgUnReadCountFromService(new IMChatManager.HttpUnReadListen() {
                @Override
                public void getUnRead(int acount) {
                    Toast.makeText(RnActivity.this, "未读消息数为：" + acount, Toast.LENGTH_SHORT).show();
                }
            });
        } else {
            //未初始化，消息当然为 ：0
            Toast.makeText(RnActivity.this, "还没初始化", Toast.LENGTH_SHORT).show();
        }
    }

    /**
     * 商品信息示例
     *
     * @param helper
     */
    private void handleCardInfo(KfStartHelper helper) {
        String s = "https://wap.boosoo.com.cn/bobishop/goodsdetail?id=10160&mid=36819";
//        String s = "https://share1.atoshi.cn/#/productdetail?productId=376&userId=100123350544";
        CardInfo ci = new CardInfo("http://seopic.699pic.com/photo/40023/0579.jpg_wh1200.jpg", "我是一个标题当初读书", "我是name当初读书。", "价格 1000-9999", "https://www.baidu.com");
        String icon = "https://www.tianxiadengcang.com//index.php?m=Api&c=Goods&a=goodsThumImages&width=200&height=200&goods_id=168";
        String title = "美式北欧吊灯家居灯卧室客厅书房餐厅灯D1-31008-12头";
        String content = "8头/φ520*H350/96W 天下灯仓包装 黑色";
        String rigth3 = " ¥548.00";
        try {
            ci = new CardInfo(URLEncoder.encode(icon, "utf-8"), URLEncoder.encode(title, "utf-8"),
                    URLEncoder.encode(content, "utf-8"), URLEncoder.encode(rigth3, "utf-8"),
                    URLEncoder.encode(s, "utf-8"));
        } catch (Exception e) {
            e.printStackTrace();
        }
        helper.setCard(ci);
    }

    /**
     * 新卡片类型示例,{@link NewCardInfo.Builder()} Builder中默认添加了一些字段，请在此自行定制
     */
    private void handleNewCardInfo(KfStartHelper helper) {
//        NewCardInfo newCardInfo = new NewCardInfo.Builder()
//                .build();

        NewCardInfo newCardInfo = new NewCardInfo.Builder()
                .setTitle("我是标题")
                .setAttr_one(new NewCardInfoAttrs().setColor("#487903").setContent("x9"))
                .setAttr_two(new NewCardInfoAttrs().setColor("#845433").setContent("未发货"))
                .setOther_title_one("附件信息")
                .setOther_title_two(null)
                .setOther_title_three(null)
                .setSub_title("我是副标题")
                .setPrice("$999")
                .build();


        helper.setNewCardInfo(newCardInfo);
    }


    /**
     * 语言切换
     * 中文 language：""
     * 英文 language："en"
     */
    private void initLanguage(String language) {
        Resources resources = getApplicationContext().getResources();
        Configuration configuration = resources.getConfiguration();
        configuration.locale = new Locale(language);
        resources.updateConfiguration(configuration, resources.getDisplayMetrics());//更新配置
    }

    /**
     * 文件写入权限 （初始化需要写入文件，点击在线客服按钮之前需打开文件写入权限）
     * 读取设备 ID 权限 （初始化需要获取用户的设备 ID）
     */
    private void handlePermission() {
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.M) {
            if (PickUtils.PermissionUtils.hasAlwaysDeniedPermission(this, Manifest.permission.WRITE_EXTERNAL_STORAGE,
                    Manifest.permission.READ_PHONE_STATE, Manifest.permission.READ_EXTERNAL_STORAGE)) {

                PickUtils.PermissionUtils.requestPermissions(this, 0x11, new String[]{Manifest.permission.WRITE_EXTERNAL_STORAGE, Manifest.permission.READ_PHONE_STATE, Manifest.permission.READ_EXTERNAL_STORAGE}, new PickUtils.PermissionUtils.OnPermissionListener() {
                    @Override
                    public void onPermissionGranted() {
                    }

                    @Override
                    public void onPermissionDenied(String[] deniedPermissions) {
                        Toast.makeText(RnActivity.this, com.m7.imkfsdk.R.string.notpermession, Toast.LENGTH_SHORT).show();
                        new Handler().postDelayed(new Runnable() {
                            @Override
                            public void run() {
                                finish();
                            }
                        }, 2000);
                    }
                });
            }
        }
    }




}
