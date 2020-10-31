package com.m7.imkfsdk.chat;

import android.content.ClipboardManager;
import android.content.Context;
import android.content.Intent;
import android.graphics.Color;
import android.graphics.drawable.BitmapDrawable;
import android.graphics.drawable.ColorDrawable;
import android.net.Uri;
import android.view.Gravity;
import android.view.LayoutInflater;
import android.view.View;
import android.view.WindowManager;
import android.view.animation.AccelerateInterpolator;
import android.view.animation.Animation;
import android.view.animation.TranslateAnimation;
import android.widget.PopupWindow;
import android.widget.TextView;

import com.m7.imkfsdk.R;
import com.m7.imkfsdk.utils.ToastUtils;

public class NumClickWindow {
    private String num;
    private Context mContext;
    PopupWindow window;

    public NumClickWindow(Context mContext,String num){
        this.mContext=mContext;
        this.num=num;
        initPopWindow();
    }

    private void initPopWindow() {
        View contentView= LayoutInflater.from( mContext).inflate(R.layout.ykf_numclicklay, null, false);
        window=new PopupWindow(contentView, WindowManager.LayoutParams.MATCH_PARENT,
                     WindowManager.LayoutParams.WRAP_CONTENT);
         ColorDrawable dw = new ColorDrawable(0x80000000);
        window.setBackgroundDrawable(dw);
        window.setAnimationStyle(R.style.ActionSheetDialogAnimation);
        window.setFocusable(true);
        window.setOutsideTouchable(true);


        TextView tv_num_pop_num=contentView.findViewById(R.id.tv_num_pop_num);
        tv_num_pop_num.setText(num+" "+mContext.getString(R.string.ykf_maybe_telphone));

        TextView tv_callnum=contentView.findViewById(R.id.tv_callnum);
        TextView tv_copynum=contentView.findViewById(R.id.tv_copynum);
        TextView tv_backnum=contentView.findViewById(R.id.tv_backnum);

        tv_callnum.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                Intent intent = new Intent(Intent.ACTION_DIAL,Uri.parse("tel:"+num));
                intent.setFlags(Intent.FLAG_ACTIVITY_NEW_TASK);
                mContext.startActivity(intent);
                if(window.isShowing()){
                    window.dismiss();
                }
            }
        });

        tv_copynum.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                ClipboardManager cm = (ClipboardManager) mContext.getSystemService(Context.CLIPBOARD_SERVICE);
                cm.setText(num);
                ToastUtils.showShort(mContext,mContext.getString(R.string.ykf_copyok));
                if(window.isShowing()){
                    window.dismiss();
                }
            }
        });

        tv_backnum.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                if(window.isShowing()){
                    window.dismiss();
                }
            }
        });

    }

    public void show(){
        if(window!=null){
            if(!window.isShowing()){
                window.showAtLocation(View.inflate(mContext,R.layout.kf_activity_chat,null), Gravity.BOTTOM,0,0);
            }
        }
    }



}
