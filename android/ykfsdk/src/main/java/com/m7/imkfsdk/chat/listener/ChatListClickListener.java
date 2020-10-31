package com.m7.imkfsdk.chat.listener;

import android.view.View;

import com.m7.imkfsdk.chat.ChatActivity;
import com.m7.imkfsdk.chat.adapter.ChatAdapter;
import com.m7.imkfsdk.chat.holder.ViewHolderTag;
import com.m7.imkfsdk.utils.MediaPlayTools;
import com.moor.imkf.db.dao.MessageDao;
import com.moor.imkf.model.entity.FromToMessage;

/**
 * Created by longwei on 2016/3/10.
 */
public class ChatListClickListener implements View.OnClickListener, View.OnLongClickListener {

    /**
     * 聊天界面
     */
    private ChatActivity mContext;

    public ChatListClickListener(ChatActivity activity, String userName) {
        mContext = activity;
    }

    @Override
    public void onClick(View v) {
        ViewHolderTag holder = (ViewHolderTag) v.getTag();
        FromToMessage iMessage = holder.detail;

        switch (holder.type) {
            case ViewHolderTag.TagType.TAG_RESEND_MSG:
                mContext.resendMsg(iMessage, holder.position);
                break;
            case ViewHolderTag.TagType.TAG_VOICE:
                if (iMessage == null) {
                    return;
                }
                MediaPlayTools instance = MediaPlayTools.getInstance();
                final ChatAdapter adapterForce = mContext.getChatAdapter();
                if (instance.isPlaying()) {
                    instance.stop();
                }
                if (adapterForce.mVoicePosition == holder.position) {
                    adapterForce.mVoicePosition = -1;
                    adapterForce.notifyDataSetChanged();
                    return;
                }
                if (iMessage.unread2 != null && iMessage.unread2.equals("1")) {
                    iMessage.unread2 = "0";
                    holder.holder.voiceUnread.setVisibility(View.GONE);
                }
                MessageDao.getInstance().updateMsgToDao(iMessage);
                adapterForce.notifyDataSetChanged();

                instance.setOnVoicePlayCompletionListener(new MediaPlayTools.OnVoicePlayCompletionListener() {

                    @Override
                    public void OnVoicePlayCompletion() {
                        adapterForce.mVoicePosition = -1;
                        adapterForce.notifyDataSetChanged();
                    }
                });
                String fileLocalPath = holder.detail.filePath;
                instance.playVoice(fileLocalPath, false);
                adapterForce.setVoicePosition(holder.position);
                adapterForce.notifyDataSetChanged();
                break;
            case ViewHolderTag.TagType.TAG_SEND_MSG:
                mContext.sendCardMsg(iMessage, FromToMessage.MSG_TYPE_CARDINFO);
                break;
            case ViewHolderTag.TagType.TAG_SEND_NEW_CARD:
                mContext.sendCardMsg(iMessage, FromToMessage.MSG_TYPE_NEW_CARD_INFO);
                break;
            case ViewHolderTag.TagType.TAG_CLICK_NEW_CARD:
            case ViewHolderTag.TagType.TAG_CLICK_LOGISTICS_RX_SHOP:
            case ViewHolderTag.TagType.TAG_CLICK_LOGISTICS_RX_CARD:
                mContext.handleOnClickOfLogisticsShop(holder.target);
                break;
            case ViewHolderTag.TagType.TAG_CLICK_LOGISTICS_RX_ITEM:
                mContext.handleOnClickOfLogisticsItem(holder._id,holder.current, holder.orderInfoBean);
                break;
            case ViewHolderTag.TagType.TAG_CLICK_LOGISTICS_RX_MORE:
                mContext.handleOnClickOfLogisticsMore(holder.target,holder._id);
                break;
            case ViewHolderTag.TagType.TAG_CLICK_LOGISTICS_PROGERSS_MORE:
                mContext.handleOnClickOfLogisticsProgressMore(holder.detail);
                break;

        }
    }

    /**
     * 处理长点击事件
     *
     * @param view
     * @return
     */
    @Override
    public boolean onLongClick(View view) {
        ViewHolderTag holder = (ViewHolderTag) view.getTag();
        FromToMessage iMessage = holder.detail;


        return true;
    }
}
