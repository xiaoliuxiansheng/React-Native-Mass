package com.m7.imkfsdk.receiver;

import android.app.ActivityManager;
import android.app.Notification;
import android.app.NotificationChannel;
import android.app.NotificationManager;
import android.app.PendingIntent;
import android.content.BroadcastReceiver;
import android.content.Context;
import android.content.Intent;
import android.os.Build;
import androidx.core.app.NotificationCompat;

import com.m7.imkfsdk.R;
import com.m7.imkfsdk.chat.ChatActivity;
import com.m7.imkfsdk.constant.NotifyConstants;
import com.m7.imkfsdk.utils.NotificationUtils;
import com.moor.imkf.IMChatManager;
import com.moor.imkf.utils.MoorUtils;

import java.util.List;

/**
 * 新消息接收器
 */
public class NewMsgReceiver extends BroadcastReceiver {


    @Override
    public void onReceive(Context context, Intent intent) {
        if (intent.getAction().equals(IMChatManager.NEW_MSG_ACTION)) {

            context.sendBroadcast(new Intent("com.m7.imkfsdk.msgreceiver"));
            //看应用是否在前台
            if (!isAppForground(context)) {
                NotificationUtils.getInstance(context)
                        .setClass(ChatActivity.class)
                        .setFlags(Intent.FLAG_ACTIVITY_NEW_TASK)
                        .setContentIntent("peedId")
                        .setTicker(NotifyConstants.TICKER_NEWMSG)
                        .setWhen(System.currentTimeMillis())
                        .setFullScreen(true)
                        .setPriority(Notification.PRIORITY_HIGH)
                        .setOngoing(true)
                        .sendNotification(NotifyConstants.NOTIFYID_CHAT,NotifyConstants.TITLE_NEWMSG, NotifyConstants.CONTENT_NEWMSG, R.drawable.kf_ic_launcher);
            }
        }
    }

    /**
     * 判断聊天界面是否在前台
     * (如果是需要退出聊天页就要弹出，那么需要存一个sp，初始化成功后存为true，然后每次退出设置false)
     * @param mContext
     * @return
     */
    public boolean isAppForground(Context mContext) {
        ActivityManager activityManager = (ActivityManager) mContext.getSystemService(Context.ACTIVITY_SERVICE);
        List<ActivityManager.RunningAppProcessInfo> appProcesses = activityManager.getRunningAppProcesses();
        if (appProcesses == null) {
            return false;
        }
        for (ActivityManager.RunningAppProcessInfo appProcess : appProcesses) {
            if (mContext.getPackageName().equals(appProcess.processName)
                    && appProcess.importance == ActivityManager.RunningAppProcessInfo.IMPORTANCE_FOREGROUND) {
                return true;
            }
        }
        return false;
    }
}
