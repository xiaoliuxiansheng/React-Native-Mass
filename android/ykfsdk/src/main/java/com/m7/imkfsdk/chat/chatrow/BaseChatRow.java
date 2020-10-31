package com.m7.imkfsdk.chat.chatrow;

import android.content.Context;
import android.content.SharedPreferences;
import android.text.TextUtils;
import android.view.ContextMenu;
import android.view.View;

import com.bumptech.glide.Glide;
import com.m7.imkfsdk.R;
import com.m7.imkfsdk.chat.holder.BaseHolder;
import com.m7.imkfsdk.chat.holder.ViewHolderTag;
import com.m7.imkfsdk.constant.Constants;
import com.moor.imkf.model.entity.FromToMessage;

/**
 * Created by longwei on 2016/3/9.
 * 处理基本的姓名和头像显示，消息发送状态，这些都是相同的
 */
public abstract class BaseChatRow implements IChatRow {

    int mRowType;

    public BaseChatRow(int type) {
        mRowType = type;
    }

    /**
     * 处理消息的发送状态设置
     *
     * @param position 消息的列表所在位置
     * @param holder   消息ViewHolder
     * @param l
     */
    protected static void getMsgStateResId(int position, BaseHolder holder, FromToMessage msg, View.OnClickListener l) {
        if (msg != null && msg.userType.equals("0")) {
            String msgStatus = msg.sendState;
            if (msgStatus.equals("false")) {
                holder.getUploadState().setImageResource(R.drawable.kf_chat_failure_msgs);
                holder.getUploadState().setVisibility(View.VISIBLE);
                holder.getTv_un_read().setVisibility(View.GONE);
                if (holder.getUploadProgressBar() != null) {
                    holder.getUploadProgressBar().setVisibility(View.GONE);
                }
            } else if (msgStatus.equals("true")) {
                holder.getUploadState().setImageResource(0);
                holder.getUploadState().setVisibility(View.GONE);
//                holder.getTv_un_read().setVisibility(View.VISIBLE);
                holder.getTv_un_read().setVisibility(View.GONE);
                if (holder.getUploadProgressBar() != null) {
                    holder.getUploadProgressBar().setVisibility(View.GONE);
                }

            } else if (msgStatus.equals("sending")) {
                holder.getUploadState().setImageResource(0);
                holder.getUploadState().setVisibility(View.GONE);
                holder.getTv_un_read().setVisibility(View.GONE);
                if (holder.getUploadProgressBar() != null) {
                    holder.getUploadProgressBar().setVisibility(View.VISIBLE);
                }

            } else {
                holder.getTv_un_read().setVisibility(View.GONE);
                if (holder.getUploadProgressBar() != null) {
                    holder.getUploadProgressBar().setVisibility(View.GONE);
                }
            }

            ViewHolderTag holderTag = ViewHolderTag.createTag(msg, ViewHolderTag.TagType.TAG_RESEND_MSG, position);
            holder.getUploadState().setTag(holderTag);
            holder.getUploadState().setOnClickListener(l);
        }
    }

    /**
     * @param contextMenu
     * @param targetView
     * @param detail
     * @return
     */
    public abstract boolean onCreateRowContextMenu(ContextMenu contextMenu, View targetView, FromToMessage detail);

    /**
     * 填充数据
     *
     * @param context
     * @param baseHolder
     * @param detail
     * @param position
     */
    protected abstract void buildChattingData(Context context, BaseHolder baseHolder, FromToMessage detail, int position);

    @Override
    public void buildChattingBaseData(Context context, BaseHolder baseHolder, FromToMessage detail, int position) {

        // 处理其他逻辑
        buildChattingData(context, baseHolder, detail, position);

        //设置已读未读
        if(baseHolder.getTv_un_read()!=null){
            if("0".equals(detail.userType)){
                if(TextUtils.isEmpty(detail.dealCustomerMsg)){
                    baseHolder.getTv_un_read().setVisibility(View.GONE);
                }  else {
                    baseHolder.getTv_un_read().setVisibility(View.GONE);
//                    if("true".equals(detail.dealCustomerMsg)){
//                        //已读
//                        baseHolder.getTv_un_read().setText(context.getString(R.string.ykf_read));
//                        baseHolder.getTv_un_read().setTextColor(context.getResources().getColor(R.color.color_999999));
//                    }
//                    if("false".equals(detail.dealCustomerMsg)){
//                        //未读sss
//                        baseHolder.getTv_un_read().setText(context.getString(R.string.ykf_unread));
//                        baseHolder.getTv_un_read().setTextColor(context.getResources().getColor(R.color.unread));
//                    }
                }
            }
        }



        //设置用户头像
        String imgPath = detail.im_icon;
        if (baseHolder.getChattingAvatar() != null) {
            /*
             * detail.userType:1
             * 会话左边
             */
            if ("1".equals(detail.userType)) {
                /*
                 * detail.showHtml
                 * true  ：是机器人头像
                 * null 或者 false ：为客服头像
                 */
                if (detail.showHtml != null && detail.showHtml) {//机器人头像
                    SharedPreferences xiaomoRobotAvator = context.getSharedPreferences("xiaomoorRobot", 0);
                    String xiaomoRobotAvator1 = xiaomoRobotAvator.getString("xiaomoRobotAvator", "");
                    if (!"".equals(xiaomoRobotAvator1)) {
                        Glide.with(context).load(xiaomoRobotAvator1 + "?imageView2/0/w/200/h/200/q/90")
                                .placeholder(R.drawable.kf_head_default_robot)
                                .into(baseHolder.getChattingAvatar());
                    } else {
                        baseHolder.getChattingAvatar().setImageResource(R.drawable.kf_head_default_robot);
                    }
                    /*
                     * imgPath != null && !"".equals(imgPath)  ： 后台客服设置头像
                     */
                } else if (imgPath != null && !"".equals(imgPath) && !"null".equals(imgPath)) {
                    Glide.with(context).load(imgPath + "?imageView2/0/w/100/h/100")
                            .placeholder(R.drawable.kf_head_default_local)
                            .into(baseHolder.getChattingAvatar());

                } else if (!TextUtils.isEmpty(detail.user) && "system".equals(detail.user)) {
                    SharedPreferences spData = context.getSharedPreferences("moordata", 0);
                    String systemMsgLogo = spData.getString(Constants.SYSTEMMSGLOGO, "");
                    if (!TextUtils.isEmpty(systemMsgLogo)) {
                        Glide.with(context).load(systemMsgLogo + "?imageView2/0/w/100/h/100")
                                .placeholder(R.drawable.kf_head_default_local)
                                .error(R.drawable.kf_head_default_local)
                                .into(baseHolder.getChattingAvatar());
                    } else {
                        /*
                         * else : 显示默认头像
                         */

                        baseHolder.getChattingAvatar().setImageResource(R.drawable.kf_head_default_local);
                    }

                } else {
                    baseHolder.getChattingAvatar().setImageResource(R.drawable.kf_head_default_local);
                }

            } else {
                /*
                 * detail.userType:0    会话右边
                 */
                baseHolder.getChattingAvatar().setImageResource(R.drawable.kf_head_default_local);
            }
        }
    }
}
