package com.m7.imkfsdk.utils;

import android.annotation.TargetApi;
import android.app.Notification;
import android.app.NotificationChannel;
import android.app.NotificationManager;
import android.app.PendingIntent;
import android.content.Context;
import android.content.ContextWrapper;
import android.content.Intent;
import android.graphics.Color;
import android.net.Uri;
import android.os.Build;
import androidx.annotation.RequiresApi;
import androidx.core.app.NotificationCompat;
import android.widget.RemoteViews;


import com.m7.imkfsdk.constant.NotifyConstants;
import com.moor.imkf.utils.MoorUtils;

import static androidx.core.app.NotificationCompat.PRIORITY_DEFAULT;
import static androidx.core.app.NotificationCompat.VISIBILITY_SECRET;

/**
 * @FileName: NotificationUtils
 * @Description: 通知的封装类
 * @Author:R-D
 * @CreatDate: 2019-10-22 10:27
 * @Reviser:
 * @Modification Time:2019-10-22 10:27
 */
public class NotificationUtils extends ContextWrapper {

    private static volatile NotificationUtils instance;
    private NotificationManager mManager;
    private int[] flags;
    private PendingIntent intent = null;
    private Context mContext;

    public static NotificationUtils getInstance(Context context) {
        if (instance == null) {
            synchronized (NotificationUtils.class) {
                if (instance == null) {
                    instance = new NotificationUtils(context);
                }
            }
        }
        return instance;
    }

    private NotificationUtils(Context base) {
        super(base);
        this.mContext = base;
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
            //android 8.0以上需要特殊处理，也就是targetSDKVersion为26以上
            createNotificationChannel();
        }
    }

    @TargetApi(Build.VERSION_CODES.O)
    private void createNotificationChannel() {
        //第一个参数：channel_id
        //第二个参数：channel_name
        //第三个参数：设置通知重要性级别
        //注意：该级别必须要在 NotificationChannel 的构造函数中指定，总共要五个级别；
        //范围是从 NotificationManager.IMPORTANCE_NONE(0) ~ NotificationManager.IMPORTANCE_HIGH(4)
        NotificationChannel channel = new NotificationChannel(NotifyConstants.CHANNEL_ID, NotifyConstants.CHANNEL_NAME,
                NotificationManager.IMPORTANCE_DEFAULT);
        channel.canBypassDnd();//是否绕过请勿打扰模式
        channel.enableLights(false);//闪光灯
        channel.setLockscreenVisibility(VISIBILITY_SECRET);//锁屏显示通知
        channel.setLightColor(Color.RED);//闪关灯的灯光颜色
        channel.canShowBadge();//桌面launcher的消息角标
        channel.enableVibration(false);//是否允许震动
        channel.getAudioAttributes();//获取系统通知响铃声音的配置
        channel.getGroup();//获取通知取到组
        channel.setBypassDnd(true);//设置可绕过 请勿打扰模式
        channel.setVibrationPattern(new long[]{100, 100, 200});//设置震动模式
        channel.shouldShowLights();//是否会有灯光
        getManager().createNotificationChannel(channel);
    }

    /**
     * 获取创建一个NotificationManager的对象
     *
     * @return NotificationManager对象
     */
    public NotificationManager getManager() {
        if (mManager == null) {
            mManager = (NotificationManager) getSystemService(Context.NOTIFICATION_SERVICE);
        }
        return mManager;
    }

    /**
     * 清空所有的通知
     */
    public void clearNotification() {
        getManager().cancelAll();
    }

    /**
     * 获取Notification
     *
     * @param title   title
     * @param content content
     */
    public Notification getNotification(String title, String content, int icon) {
        Notification build;
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
            //android 8.0以上需要特殊处理，也就是targetSDKVersion为26以上
            //通知用到NotificationCompat()这个V4库中的方法。但是在实际使用时发现书上的代码已经过时并且Android8.0已经不支持这种写法
            Notification.Builder builder = getChannelNotification(title, content, icon);
            build = builder.build();
        } else {
            NotificationCompat.Builder builder = getNotificationCompat(title, content, icon);
            build = builder.build();
        }
        if (flags != null && flags.length > 0) {
            for (int a = 0; a < flags.length; a++) {
                build.flags |= flags[a];
            }
        }
        return build;
    }

    /**
     * 建议使用这个发送通知
     * 调用该方法可以发送通知
     *
     * @param notifyId notifyId
     * @param title    title
     * @param content  content
     */
    public void sendNotification(int notifyId, String title, String content, int icon) {
        Notification build;
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
            //android 8.0以上需要特殊处理，也就是targetSDKVersion为26以上
            //通知用到NotificationCompat()这个V4库中的方法。但是在实际使用时发现书上的代码已经过时并且Android8.0已经不支持这种写法
            Notification.Builder builder = getChannelNotification(title, content, icon);
            build = builder.build();
        } else {
            NotificationCompat.Builder builder = getNotificationCompat(title, content, icon);
            build = builder.build();
        }
        if (flags != null && flags.length > 0) {
            for (int a = 0; a < flags.length; a++) {
                build.flags |= flags[a];
            }
        }
        getManager().notify(notifyId, build);
    }

    /**
     * 调用该方法可以发送通知
     *
     * @param notifyId notifyId
     * @param title    title
     * @param content  content
     */
    public void sendNotificationCompat(int notifyId, String title, String content, int icon) {
        NotificationCompat.Builder builder = getNotificationCompat(title, content, icon);
        Notification build = builder.build();
        if (flags != null && flags.length > 0) {
            for (int a = 0; a < flags.length; a++) {
                build.flags |= flags[a];
            }
        }
        getManager().notify(notifyId, build);
    }


    private NotificationCompat.Builder getNotificationCompat(String title, String content, int icon) {
        NotificationCompat.Builder builder;
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
            builder = new NotificationCompat.Builder(getApplicationContext(), NotifyConstants.CHANNEL_ID);
        } else {
            //注意用下面这个方法，在8.0以上无法出现通知栏。8.0之前是正常的。这里需要增强判断逻辑
            builder = new NotificationCompat.Builder(getApplicationContext());
            builder.setPriority(PRIORITY_DEFAULT);
        }
        builder.setContentTitle(title);
        builder.setContentText(content);
        builder.setSmallIcon(icon);
        builder.setPriority(priority);
        builder.setOnlyAlertOnce(onlyAlertOnce);
        builder.setOngoing(ongoing);
        if (remoteViews != null) {
            builder.setContent(remoteViews);
        }
        if (intent != null) {
            builder.setContentIntent(intent);
        }
        if (ticker != null && ticker.length() > 0) {
            builder.setTicker(ticker);
        }
        if (when != 0) {
            builder.setWhen(when);
        }
        if (sound != null) {
            builder.setSound(sound);
        }
        if (defaults != 0) {
            builder.setDefaults(defaults);
        }
        //点击自动删除通知
        builder.setAutoCancel(cancel);
        return builder;
    }


    @RequiresApi(api = Build.VERSION_CODES.O)
    private Notification.Builder getChannelNotification(String title, String content, int icon) {
        Notification.Builder builder = new Notification.Builder(getApplicationContext(), NotifyConstants.CHANNEL_ID);
        Notification.Builder notificationBuilder = builder
                //设置标题
                .setContentTitle(title)
                //消息内容
                .setContentText(content)
                //设置通知的图标
                .setSmallIcon(icon)
                //让通知左右滑的时候是否可以取消通知
                .setOngoing(ongoing)
                //设置优先级
                .setPriority(priority)
                //是否提示一次.true - 如果Notification已经存在状态栏即使在调用notify函数也不会更新
                .setOnlyAlertOnce(onlyAlertOnce)
                .setAutoCancel(cancel);
        if (remoteViews != null) {
            //设置自定义view通知栏
            notificationBuilder.setContent(remoteViews);
        }
        if (intent != null) {
            notificationBuilder.setContentIntent(intent);
        }
        if (ticker != null && ticker.length() > 0) {
            //设置状态栏的标题
            notificationBuilder.setTicker(ticker);
        }
        if (when != 0) {
            //设置通知时间，默认为系统发出通知的时间，通常不用设置
            notificationBuilder.setWhen(when);
        }
        if (sound != null) {
            //设置sound
            notificationBuilder.setSound(sound);
        }
        if (defaults != 0) {
            //设置默认的提示音
            notificationBuilder.setDefaults(defaults);
        }
        if (pattern != null) {
            //自定义震动效果
            notificationBuilder.setVibrate(pattern);
        }
        return notificationBuilder;
    }


    private boolean ongoing = false;
    private RemoteViews remoteViews = null;

    private String ticker = "";
    private int priority = Notification.PRIORITY_DEFAULT;
    private boolean onlyAlertOnce = false;
    private boolean cancel = true;
    private long when = 0;
    private Uri sound = null;
    private int defaults = 0;
    private long[] pattern = null;

    private Class<?> cls;
    private int[] intentFlags;
    private boolean highPriority = false;

    /**
     * 设置跳转目标类
     *
     * @param cls 跳转目标类
     * @return
     */
    public NotificationUtils setClass(Class<?> cls) {
        this.cls = cls;
        return this;
    }

    /**
     * 设置flag标签
     *
     * @param flags flags
     * @return
     */
    public NotificationUtils setIntentFlags(int... flags) {
        this.intentFlags = flags;
        return this;
    }


    /**
     * 设置跳转目标类
     *
     * @param highPriority
     * @return
     */
    public NotificationUtils setFullScreen(boolean highPriority) {
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.LOLLIPOP) {
            this.highPriority = highPriority;
        }

        return this;
    }


    /**
     * 让通知左右滑的时候是否可以取消通知
     *
     * @param ongoing 是否可以取消通知
     * @return
     */
    public NotificationUtils setOngoing(boolean ongoing) {
        this.ongoing = ongoing;
        return this;
    }

    /**
     * 设置自定义view通知栏布局
     *
     * @param remoteViews view
     * @return
     */
    public NotificationUtils setContent(RemoteViews remoteViews) {
        this.remoteViews = remoteViews;
        return this;
    }

    /**
     * 设置内容点击
     *
     * @return
     */
    public NotificationUtils setContentIntent(String type) {
        Intent contentIntent = new Intent(mContext, cls);
        contentIntent.putExtra("type", type);
        contentIntent.putExtra("PeerId", "");
        if (intentFlags != null && intentFlags.length > 0) {
            for (int intentFlag : intentFlags) {
                contentIntent.addFlags(intentFlag);
            }
        }
        intent = PendingIntent.getActivity(
                MoorUtils.getApp(),
                0,
                contentIntent,
                PendingIntent.FLAG_UPDATE_CURRENT);
        return this;
    }

    /**
     * 设置状态栏的标题
     *
     * @param ticker 状态栏的标题
     * @return
     */
    public NotificationUtils setTicker(String ticker) {
        this.ticker = ticker;
        return this;
    }


    /**
     * 设置优先级
     * 注意：
     * Android 8.0以及上，在 NotificationChannel 的构造函数中指定，总共要五个级别；
     * Android 7.1（API 25）及以下的设备，还得调用NotificationCompat 的 setPriority方法来设置
     *
     * @param priority 优先级，默认是Notification.PRIORITY_DEFAULT
     * @return
     */
    public NotificationUtils setPriority(int priority) {
        this.priority = priority;
        return this;
    }

    /**
     * 是否提示一次.true - 如果Notification已经存在状态栏即使在调用notify函数也不会更新
     *
     * @param onlyAlertOnce 是否只提示一次，默认是false
     * @return
     */
    public NotificationUtils setOnlyAlertOnce(boolean onlyAlertOnce) {
        this.onlyAlertOnce = onlyAlertOnce;
        return this;
    }

    /**
     * 设置通知时间，默认为系统发出通知的时间，通常不用设置
     *
     * @param when when
     * @return
     */
    public NotificationUtils setWhen(long when) {
        this.when = when;
        return this;
    }

    /**
     * 设置sound
     *
     * @param sound sound
     * @return
     */
    public NotificationUtils setSound(Uri sound) {
        this.sound = sound;
        return this;
    }


    /**
     * 设置默认的提示音
     *
     * @param defaults defaults
     * @return
     */
    public NotificationUtils setDefaults(int defaults) {
        this.defaults = defaults;
        return this;
    }

    /**
     * 自定义震动效果
     *
     * @param pattern pattern
     * @return
     */
    public NotificationUtils setVibrate(long[] pattern) {
        this.pattern = pattern;
        return this;
    }

    /**
     * 设置flag标签
     *
     * @param flags flags
     * @return
     */
    public NotificationUtils setFlags(int... flags) {
        this.flags = flags;
        return this;
    }

    /**
     * 设置是否点击关闭
     */
    public NotificationUtils setAutoCancel(boolean cancel) {
        this.cancel = cancel;
        return this;
    }
}
