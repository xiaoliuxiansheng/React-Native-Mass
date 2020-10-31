package com.m7.imkfsdk.chat.holder;

import android.graphics.Color;
import android.media.MediaPlayer;
import android.text.TextUtils;
import android.view.View;
import android.widget.AdapterView;
import android.widget.ImageView;
import android.widget.LinearLayout;
import android.widget.ProgressBar;
import android.widget.RelativeLayout;
import android.widget.TextView;

import com.m7.imkfsdk.R;
import com.m7.imkfsdk.chat.ChatActivity;
import com.m7.imkfsdk.chat.adapter.ChatAdapter;
import com.m7.imkfsdk.utils.DensityUtil;
import com.m7.imkfsdk.view.PopupWindowList;
import com.m7.imkfsdk.view.VoiceAnimImageView;
import com.moor.imkf.db.dao.MessageDao;
import com.moor.imkf.eventbus.EventBus;
import com.moor.imkf.model.entity.FromToMessage;
import com.moor.imkf.tcpservice.event.VoiceToTextEvent;

import java.util.ArrayList;
import java.util.List;

/**
 * Created by longwei on 2016/3/9.
 */
public class VoiceViewHolder extends BaseHolder {

    public TextView contentTv;
    public TextView voicePlayAnim;
    public VoiceAnimImageView voiceAnim;
    public TextView voiceSecondView;
    //    public FrameLayout voicePlayFrameLayout;
//    public CCPAnimImageView voiceLoading;
    public ProgressBar voiceSending;
    //    public TextView voiceSendigBG;
    public ImageView voiceUnread;
    public TextView tv_vototx;
    public LinearLayout ll_voiceTotext;
    public LinearLayout ll_text_ok;
    public RelativeLayout rl_pb;
    public ProgressBar pb_voice_text;

    /**
     * @param type
     */
    public VoiceViewHolder(int type) {
        super(type);

    }

    public BaseHolder initBaseHolder(View baseView, boolean receive) {
        super.initBaseHolder(baseView);
        chattingTime = ((TextView) baseView.findViewById(R.id.chatting_time_tv));
        voicePlayAnim = ((TextView) baseView.findViewById(R.id.chatting_voice_play_anim_tv));
        uploadState = ((ImageView) baseView.findViewById(R.id.chatting_state_iv));
        contentTv = ((TextView) baseView.findViewById(R.id.chatting_content_itv));
//        voicePlayFrameLayout = ((FrameLayout) baseView.findViewById(R.id.chatto_content_layout));
        voiceAnim = ((VoiceAnimImageView) baseView.findViewById(R.id.chatting_voice_anim));
        voiceAnim.restBackground();
        voiceUnread = (ImageView) baseView.findViewById(R.id.chatting_unread_flag);
        voiceSecondView= (TextView) baseView.findViewById(R.id.chatting_voice_second_tv);

        ll_voiceTotext=(LinearLayout) baseView.findViewById(R.id.ll_voiceTotext);
        ll_text_ok=(LinearLayout)baseView.findViewById(R.id.ll_text_ok);
        tv_vototx=(TextView)baseView.findViewById(R.id.tv_vototx);//语音转文本 text
        rl_pb =(RelativeLayout) baseView.findViewById(R.id.rl_pb);//语音转文本 布局
         pb_voice_text=(ProgressBar) baseView.findViewById(R.id.pb_voice_text);
        if (receive) {
            type = 5;
            voiceAnim.setVoiceFrom(true);
//            voiceLoading = ((CCPAnimImageView) baseView.findViewById(R.id.chatting_voice_loading));
//            voiceLoading.setVoiceFrom(true);
//            voiceLoading.restBackground();
            return this;
        }

//        voiceSending = ((ProgressBar) baseView.findViewById(R.id.chatting_voice_sending));
        progressBar = (ProgressBar) baseView.findViewById(R.id.uploading_pb);
//        voiceSendigBG = ((TextView) baseView.findViewById(R.id.chatting_voice_sending_bg));
        voiceAnim.setVoiceFrom(false);
        type = 6;
        return this;
    }

    /**
     * @param holder
     * @param uploadVisibility
     * @param playVisibility
     * @param receive
     */
    private static void uploadVoiceStatus(VoiceViewHolder holder, int uploadVisibility, int playVisibility, boolean receive) {
        holder.uploadState.setVisibility(View.GONE);
        holder.contentTv.setVisibility(playVisibility);
//        holder.voicePlayFrameLayout.setVisibility(playVisibility);

        if (receive) {
//            holder.voiceLoading.setVisibility(uploadVisibility);
            return;
        }
//        holder.voiceSendigBG.setVisibility(uploadVisibility);
    }

    public static void initVoiceRow(final VoiceViewHolder holder, final FromToMessage detail, int position, final ChatActivity activity, final boolean receive) {
        if (holder == null) {
            return;
        }

        if (detail.voiceSecond != null && !detail.voiceSecond.equals("")) {
            holder.voiceSecondView.setText(detail.voiceSecond + "''");
        } else {
            try {
                int second = 0;
                MediaPlayer mediaPlayer = new MediaPlayer();
                mediaPlayer.setDataSource(detail.filePath);
                mediaPlayer.prepare();
                second = mediaPlayer.getDuration()/1000;
                mediaPlayer.release();
                holder.voiceSecondView.setText(second + "''");
                detail.voiceSecond=second + "";

            } catch (Exception e) {
                e.printStackTrace();
            }
        }
//        false是发送
        if (!receive) {
//            int duration = (detail.recordTime).intValue();

            int duration = 1;
            if (duration < 1) {
                duration = 1;
            }

            holder.voiceAnim.setVisibility(View.GONE);
            ViewHolderTag holderTag = ViewHolderTag.createTag(detail, ViewHolderTag.TagType.TAG_VOICE, position, holder.type, receive, holder);
            holder.voicePlayAnim.setTag(holderTag);
            holder.voicePlayAnim.setOnClickListener(activity.getChatAdapter().getOnClickListener());


            ChatAdapter adapterForce = activity.getChatAdapter();
            if (adapterForce.mVoicePosition == position) {
                uploadVoiceStatus(holder, View.GONE, View.VISIBLE, receive);
                holder.voiceAnim.setVisibility(View.VISIBLE);
                holder.voiceAnim.startVoiceAnimation();
                holder.voiceAnim.setWidth(DensityUtil.fromDPToPix(activity, getTimeWidth(duration)));
                holder.contentTv.setTextColor(Color.parseColor("#7390A0"));
                holder.contentTv.setShadowLayer(2.0F, 1.2F, 1.2F, Color.parseColor("#ffffffff"));
                holder.contentTv.setVisibility(View.VISIBLE);
//                holder.contentTv.setText(Math.round(detail.recordTime) + "\"");

                holder.voicePlayAnim.setWidth(DensityUtil.fromDPToPix(activity, getTimeWidth(duration)));
                return;
            } else {
                holder.voiceAnim.stopVoiceAnimation();
                holder.voiceAnim.setVisibility(View.GONE);

            }
            if (detail.sendState.equals("true")) {
                holder.contentTv.setTextColor(Color.parseColor("#7390A0"));
                holder.contentTv.setShadowLayer(2.0F, 1.2F, 1.2F, Color.parseColor("#ffffffff"));
                holder.contentTv.setVisibility(View.VISIBLE);
//                holder.contentTv.setText(Math.round(detail.recordTime) + "\"");


                holder.voiceAnim.setWidth(DensityUtil.fromDPToPix(activity, getTimeWidth(duration)));
                holder.voicePlayAnim.setWidth(DensityUtil.fromDPToPix(activity, getTimeWidth(duration)));

                uploadVoiceStatus(holder, View.GONE, View.VISIBLE, receive);
            } else {
                holder.contentTv.setShadowLayer(0.0F, 0.0F, 0.0F, 0);

                if (detail.sendState.equals("false")) {
                    uploadVoiceStatus(holder, View.GONE, View.VISIBLE, receive);
                    holder.contentTv.setVisibility(View.GONE);
                } else {
                    uploadVoiceStatus(holder, View.VISIBLE, View.GONE, receive);
                }
                holder.voiceAnim.setWidth(80);
                holder.voicePlayAnim.setWidth(80);

            }


            holder.voiceAnim.setBackgroundResource(R.drawable.kf_chatto_bg_normal);
            holder.voicePlayAnim.setBackgroundResource(R.drawable.kf_chatto_bg_normal);

            holder.contentTv.setBackgroundColor(0);
        } else {
//            int duration = Integer.parseInt(detail.voiceSecond);

            int duration = 1;
            if (duration < 1) {
                duration = 1;
            }

            holder.voiceAnim.setVisibility(View.GONE);
            ViewHolderTag holderTag = ViewHolderTag.createTag(detail, ViewHolderTag.TagType.TAG_VOICE, position, holder.type, receive, holder);
            holder.voicePlayAnim.setTag(holderTag);
            holder.voicePlayAnim.setOnClickListener(activity.getChatAdapter().getOnClickListener());

            holder.contentTv.setTextColor(Color.parseColor("#7390A0"));
            holder.contentTv.setShadowLayer(2.0F, 1.2F, 1.2F, Color.parseColor("#ffffffff"));
            holder.contentTv.setVisibility(View.VISIBLE);
//            holder.contentTv.setText(detail.voiceSecond + "\"");
            holder.voicePlayAnim.setWidth(DensityUtil.fromDPToPix(activity, getTimeWidth(duration)));

            ChatAdapter adapterForce = activity.getChatAdapter();
            if (adapterForce.mVoicePosition == position) {
                holder.voiceAnim.setVisibility(View.VISIBLE);
                holder.voiceAnim.startVoiceAnimation();
                holder.voiceAnim.setWidth(DensityUtil.fromDPToPix(activity, getTimeWidth(duration)));
                holder.contentTv.setTextColor(Color.parseColor("#7390A0"));
                holder.contentTv.setShadowLayer(2.0F, 1.2F, 1.2F, Color.parseColor("#ffffffff"));
                holder.contentTv.setVisibility(View.VISIBLE);
//                holder.contentTv.setText(detail.voiceSecond + "\"");
                holder.voicePlayAnim.setWidth(DensityUtil.fromDPToPix(activity, getTimeWidth(duration)));
                return;
            } else {
                holder.voiceAnim.stopVoiceAnimation();
                holder.voiceAnim.setVisibility(View.GONE);

            }
            holder.voiceAnim.setBackgroundResource(R.drawable.kf_chatfrom_bg_normal);
            holder.voicePlayAnim.setBackgroundResource(R.drawable.kf_chatfrom_bg_normal);
            holder.contentTv.setBackgroundColor(0);
        }


        if( !detail.withDrawStatus){
            //如果 语音转文本 状态为显示，并且 文本不为空，展示View
            if(detail.isShowVtoT&& !TextUtils.isEmpty(detail.voiceToText)){
                holder. ll_voiceTotext.setVisibility(View.VISIBLE);
                holder. tv_vototx.setText(detail.voiceToText);
                hideVoice_to_Text_Pb(true,holder.rl_pb,holder. ll_text_ok);
                holder.voicePlayAnim.setOnLongClickListener(null);
            }else{
                holder. ll_voiceTotext.setVisibility(View.GONE);
                holder.voicePlayAnim.setOnLongClickListener(new View.OnLongClickListener() {
                    @Override
                    public boolean onLongClick(View v) {
                        if(!receive){
                            if (detail.sendState.equals("true")) {
                                //是发送的，并且状态为发送成功 才能转
                                showPopWindows(v,holder,detail,activity);
                            }
                        }else{
                            showPopWindows(v,holder,detail,activity);
                        }
                        return false;
                    }
                });
            }


            //设置正在转换中的 布局 与语音view等宽
            RelativeLayout.LayoutParams params= (RelativeLayout.LayoutParams) holder.rl_pb.getLayoutParams();
            int spec = View.MeasureSpec.makeMeasureSpec(0, View.MeasureSpec.UNSPECIFIED);
            holder.voiceSecondView.measure(spec,spec);
            int measuredWidthTicketNum = holder.voiceSecondView.getMeasuredWidth();
            params.width=DensityUtil.fromDPToPix(activity, getTimeWidth(1))-DensityUtil.fromDPToPix(activity,4)-measuredWidthTicketNum;
            holder.rl_pb.setLayoutParams(params);

            //设置转圈 在 左右
//        RelativeLayout.LayoutParams params_pb= (RelativeLayout.LayoutParams) holder.pb_voice_text.getLayoutParams();
//        if(!receive){
//            params_pb.addRule(RelativeLayout.ALIGN_PARENT_LEFT);
//            holder.pb_voice_text.setLayoutParams(params_pb);
//        }else{
//            params_pb.addRule(RelativeLayout.ALIGN_PARENT_RIGHT);
//            holder.pb_voice_text.setLayoutParams(params_pb);
//        }

            //正在转换中
            if(detail.isCacheShowVtoT){
                holder. ll_voiceTotext.setVisibility(View.VISIBLE);
                hideVoice_to_Text_Pb(false,holder.rl_pb,holder.ll_text_ok);
                holder.voicePlayAnim.setOnLongClickListener(null);
            }
        }


    }

    private static PopupWindowList mPopupWindowList;
    private static void showPopWindows(View view, final VoiceViewHolder holder, final FromToMessage detail, final ChatActivity activity) {
        List<String> dataList = new ArrayList<>();
        dataList.add(activity.getResources().getString(R.string.voice_to_text_btn));
        if (mPopupWindowList == null) {
            mPopupWindowList = new PopupWindowList(view.getContext());
        }
        mPopupWindowList.setAnchorView(view);
        mPopupWindowList.setItemData(dataList);
        mPopupWindowList.setModal(true);
        mPopupWindowList.show();
        mPopupWindowList.setOnItemClickListener(new AdapterView.OnItemClickListener() {
            @Override
            public void onItemClick(AdapterView<?> parent, View view, int position, long id) {
                if(detail!=null){
                    //状态标记已读
                    if (detail.unread2 != null && detail.unread2.equals("1")) {
                        detail.unread2 = "0";
                    }
                    MessageDao.getInstance().updateMsgToDao(detail);

                    if(!TextUtils.isEmpty(detail.voiceSecond)){
                        //语音长度大于60s 不能转换
                        int length=Integer.parseInt(detail.voiceSecond);
                        if(length>60){
                            VoiceToTextEvent event=new VoiceToTextEvent();
                            event.id=detail._id;
                            event.status_code=VoiceToTextEvent.STATUS_TOLONG;
                            EventBus.getDefault().post(event);
                            return;
                        }
                    }

//                    activity.getVoiceToText(detail);
                    holder. ll_voiceTotext.setVisibility(View.VISIBLE);
                    hideVoice_to_Text_Pb(false,holder.rl_pb,holder.ll_text_ok);
                    activity.getChatAdapter().notifyDataSetChanged();
//                    如果数据库中有 转换的文字 直接展示 不请求
                    if(!TextUtils.isEmpty(detail.voiceToText)){
//                        走数据库直接拿
                        VoiceToTextEvent event=new VoiceToTextEvent();
                        event.id=detail._id;
                        event.toText=detail.voiceToText;
                        event.status_code=VoiceToTextEvent.STATUS_OK;
                        EventBus.getDefault().post(event);

                    }else{
                        // 走接口
                        detail.isCacheShowVtoT=true;
                        MessageDao.getInstance().updateMsgToDao(detail);
                        activity.getVoiceToText(detail);
                    }
                }
                mPopupWindowList.hide();
            }
        });
    }
    /**
     * @param time
     * @return
     */
    public static int getTimeWidth(int time) {
        if (time <= 2)
            return 80;
        if (time < 10)
            return (80 + 9 * (time - 2));
        if (time < 60)
            return (80 + 9 * (7 + time / 10));
        return 204;
    }


    //隐藏 转文本 转圈，true为隐藏pb显示tx，false为显示pb隐藏tx
    public static void hideVoice_to_Text_Pb(boolean hide,RelativeLayout layout,LinearLayout textView) {
        if(hide){
            layout.setVisibility(View.GONE);
            textView.setVisibility(View.VISIBLE);
        }else{
            layout.setVisibility(View.VISIBLE);
            textView.setVisibility(View.GONE);
        }
    }

}
