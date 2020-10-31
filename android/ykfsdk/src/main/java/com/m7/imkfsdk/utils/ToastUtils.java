package com.m7.imkfsdk.utils;

import android.content.Context;
import android.graphics.PorterDuff;
import android.graphics.PorterDuffColorFilter;
import android.graphics.drawable.Drawable;
import android.os.Handler;
import android.os.Looper;
import androidx.annotation.ColorInt;
import androidx.annotation.DrawableRes;
import androidx.annotation.LayoutRes;
import androidx.annotation.NonNull;
import androidx.annotation.StringRes;
import androidx.core.widget.TextViewCompat;
import android.view.Gravity;
import android.view.LayoutInflater;
import android.view.View;
import android.widget.TextView;
import android.widget.Toast;

import com.moor.imkf.utils.MoorUtils;

import java.lang.ref.WeakReference;

/**
 * <pre>
 *     author: Blankj
 *     blog  : http://blankj.com
 *     time  : 2016/09/29
 *     desc  : 吐司相关工具类
 * </pre>
 */
public final class ToastUtils {
    private ToastUtils() {
        throw new UnsupportedOperationException("u can't instantiate me...");
    }
    /**
     * 安全地显示短时吐司
     *
     */
    public static void showShort(Context context, final CharSequence text) {
        Toast.makeText(context,text,Toast.LENGTH_SHORT).show();
    }

    /**
     * 安全地显示短时吐司
     *
     * @param resId 资源Id
     */
    public static void showShort(Context context,  final int resId) {
        Toast.makeText(context,context.getString(resId),Toast.LENGTH_SHORT).show();
    }



    /**
     * 安全地显示长时吐司
     *
     * @param text 文本
     */
    public static void showLong(Context context,  final CharSequence text) {
        Toast.makeText(context,text,Toast.LENGTH_LONG).show();
    }





}