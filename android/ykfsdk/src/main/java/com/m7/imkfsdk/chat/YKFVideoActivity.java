package com.m7.imkfsdk.chat;

import android.content.Context;
import android.media.MediaPlayer;
import android.net.Uri;
import android.os.Bundle;
import androidx.annotation.Nullable;
import androidx.appcompat.app.AppCompatActivity;
import android.util.Log;
import android.view.View;
import android.widget.ImageView;
import android.widget.MediaController;
import android.widget.RelativeLayout;
import android.widget.VideoView;

import com.m7.imkfsdk.R;
import com.m7.imkfsdk.constant.Constants;


//视频播放页面
public class YKFVideoActivity extends AppCompatActivity {

    private Context mContext;
    private VideoView ykf_videoview;
    private ImageView iv_closevideo;
    private String video_url;
    private RelativeLayout rl_video_progress;

    @Override
    protected void onCreate(@Nullable Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        mContext=this;

        setContentView(R.layout.ykf_videoactivity);
        ykf_videoview=findViewById(R.id.ykf_videoview);
        iv_closevideo=findViewById(R.id.iv_closevideo);
        rl_video_progress=findViewById(R.id.rl_video_progress);

        video_url=getIntent().getStringExtra(Constants.YKFVIDEOPATHURI);

        initVideo(video_url);

        iv_closevideo.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                finish();
            }
        });

    }

    private void initVideo(String  url) {
        Uri uri = Uri.parse( url );
        //设置视频控制器
        ykf_videoview.setMediaController(new MediaController(this));

        ykf_videoview.setOnPreparedListener(new MediaPlayer.OnPreparedListener() {
            @Override
            public void onPrepared(MediaPlayer mp) {
                mp.setOnInfoListener(new MediaPlayer.OnInfoListener() {
                    @Override
                    public boolean onInfo(MediaPlayer mp, int what, int extra) {
                        //视频显示出第一帧隐藏 progress
                        if (what == MediaPlayer.MEDIA_INFO_VIDEO_RENDERING_START){
                            rl_video_progress.setVisibility(View.GONE);
                        }

                        return true;
                    }
                });
            }

        });


        //播放完成回调
        ykf_videoview.setOnCompletionListener( new MyPlayerOnCompletionListener());

        //设置视频路径
        ykf_videoview.setVideoURI(uri);

        //开始播放视频
        ykf_videoview.start();
        ykf_videoview.requestFocus();
    }

    class MyPlayerOnCompletionListener implements MediaPlayer.OnCompletionListener {

        @Override
        public void onCompletion(MediaPlayer mp) {
            ykf_videoview.start();

        }
    }

    @Override
    protected void onDestroy() {
        if(ykf_videoview.isPlaying()){
            ykf_videoview.stopPlayback();
        }
        super.onDestroy();
    }
}
