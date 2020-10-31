package com.m7.imkfsdk.chat.chatrow;

import android.content.Context;
import android.graphics.Color;
import android.view.ContextMenu;
import android.view.LayoutInflater;
import android.view.View;

import com.bumptech.glide.Glide;
import com.bumptech.glide.load.resource.bitmap.RoundedCorners;
import com.bumptech.glide.request.RequestOptions;
import com.m7.imkfsdk.R;
import com.m7.imkfsdk.chat.ChatActivity;
import com.m7.imkfsdk.chat.holder.BaseHolder;
import com.m7.imkfsdk.chat.holder.LogisticsInfoRxHolder;
import com.m7.imkfsdk.chat.holder.LogisticsInfoTxHolder;
import com.m7.imkfsdk.chat.holder.ViewHolderTag;
import com.m7.imkfsdk.chat.model.OrderBaseBean;
import com.m7.imkfsdk.chat.model.OrderBaseDataBean;
import com.m7.imkfsdk.chat.model.OrderInfoBean;
import com.m7.imkfsdk.utils.DensityUtil;
import com.moor.imkf.gson.Gson;
import com.moor.imkf.gson.reflect.TypeToken;
import com.moor.imkf.model.entity.FromToMessage;
import com.moor.imkf.model.entity.NewCardInfo;
import com.moor.imkf.utils.NullUtil;

import java.lang.reflect.Type;

/**
 * @author R-D
 * @Description 发送的订单信息类型
 * @date 2019/12/01
 */
public class LogisticsInfoTxChatRow extends BaseChatRow {
    public LogisticsInfoTxChatRow(int type) {
        super(type);
    }

    @Override
    public boolean onCreateRowContextMenu(ContextMenu contextMenu, View targetView, FromToMessage detail) {
        return false;
    }

    @Override
    protected void buildChattingData(final Context context, BaseHolder baseHolder, final FromToMessage detail, int position) {
        LogisticsInfoTxHolder holder = (LogisticsInfoTxHolder) baseHolder;
        if (detail != null && detail.newCardInfo != null) {
            Type token = new TypeToken<NewCardInfo>() {
            }.getType();
            final NewCardInfo orderInfoBean = new Gson().fromJson(detail.newCardInfo, token);
            if (NullUtil.checkNULL(orderInfoBean.getTitle())) {
                holder.tv_logistics_tx_title.setText(orderInfoBean.getTitle());
            }
            if (NullUtil.checkNULL(orderInfoBean.getSub_title())) {
                holder.tv_logistics_tx_.setText(orderInfoBean.getSub_title());
            }
            if (NullUtil.checkNULL(orderInfoBean.getAttr_one().getColor())) {
                String color = orderInfoBean.getAttr_one().getColor();
                if (color.contains("#")) {
                    try {
                        holder.tv_logistics_tx_num.setTextColor(Color.parseColor(color));
                    } catch (Exception e) {

                    }
                }
            }
            if (NullUtil.checkNULL(orderInfoBean.getAttr_two().getColor())) {
                String color = orderInfoBean.getAttr_two().getColor();
                if (color.contains("#")) {
                    try {
                        holder.tv_logistics_tx_state.setTextColor(Color.parseColor(color));
                    } catch (Exception e) {

                    }
                }
            }
            if (NullUtil.checkNULL(orderInfoBean.getAttr_one().getContent())) {
                holder.tv_logistics_tx_num.setText(orderInfoBean.getAttr_one().getContent());
            }
            if (NullUtil.checkNULL(orderInfoBean.getAttr_two().getContent())) {
                holder.tv_logistics_tx_state.setText(orderInfoBean.getAttr_two().getContent());
            }
            if (NullUtil.checkNULL(orderInfoBean.getPrice())) {
                holder.tv_logistics_tx_price.setText(orderInfoBean.getPrice());
            }


            if (NullUtil.checkNULL(orderInfoBean.getOther_title_three())) {
                holder.tv_logistics_tx_second.setText(orderInfoBean.getOther_title_three());
            }
            if (NullUtil.checkNULL(orderInfoBean.getOther_title_two())) {
                holder.tv_logistics_tx_second.setText(orderInfoBean.getOther_title_two());
            }
            if (NullUtil.checkNULL(orderInfoBean.getOther_title_one())) {
                holder.tv_logistics_tx_second.setText(orderInfoBean.getOther_title_one());
            }

            Glide.with(context).load(orderInfoBean.getImg())
                    .apply(RequestOptions.bitmapTransform(new RoundedCorners(DensityUtil.dip2px(2f))).error(R.drawable.image_download_fail_icon))
                    .into(holder.iv_logistics_tx_img);
            View.OnClickListener listener = ((ChatActivity) context).getChatAdapter().getOnClickListener();
            getMsgStateResId(position, holder, detail, listener);

            ViewHolderTag holderTag = ViewHolderTag.createTag(orderInfoBean.getTarget(), ViewHolderTag.TagType.TAG_CLICK_LOGISTICS_RX_CARD);
            holder.kf_chat_rich_lin.setTag(holderTag);
            holder.kf_chat_rich_lin.setOnClickListener(listener);
        }

    }

    @Override
    public View buildChatView(LayoutInflater inflater, View convertView) {
        if (convertView == null) {
            convertView = inflater.inflate(R.layout.kf_chat_row_logistics_tx, null);
            LogisticsInfoTxHolder holder = new LogisticsInfoTxHolder(mRowType);
            convertView.setTag(holder.initBaseHolder(convertView, false));
        }
        return convertView;
    }

    @Override
    public int getChatViewType() {
        return ChatRowType.LOGISTICS_INFORMATION_ROW_TRANSMIT.ordinal();
    }
}

