package com.m7.imkfsdk.chat.holder;

import android.view.View;
import android.widget.ImageView;
import android.widget.ProgressBar;
import android.widget.TextView;

import com.m7.imkfsdk.R;

/**
 * Created by longwei on 2016/3/9.
 */
public class VideoViewHolder extends BaseHolder {

    private TextView tv_content;
    private ImageView chat_to_video_icon;



    public VideoViewHolder(int type) {
        super(type);
    }

    public BaseHolder initBaseHolder(View baseView, boolean isReceive) {
        super.initBaseHolder(baseView);

        //通过baseview找到对应组件
        tv_content = (TextView) baseView.findViewById(R.id.chat_content_tv);
        chat_to_video_icon = (ImageView) baseView.findViewById(R.id.chat_to_video_icon);
        if(isReceive) {
            type = 17;
            return this;
        }
        progressBar = (ProgressBar) baseView.findViewById(R.id.uploading_pb);
        type = 16;
        return this;
    }

    public TextView getDescTextView() {
        if(tv_content == null) {
            tv_content = (TextView) getBaseView().findViewById(R.id.chat_content_tv);
        }
        return tv_content;
    }

    public ImageView getVideoIcon() {
        if(chat_to_video_icon == null) {
            chat_to_video_icon = (ImageView) getBaseView().findViewById(R.id.chat_to_video_icon);
        }
        return chat_to_video_icon;
    }
}
