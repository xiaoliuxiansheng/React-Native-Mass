package com.m7.imkfsdk.chat.chatrow;

import android.content.Context;
import android.graphics.Color;
import android.text.TextUtils;
import android.view.ContextMenu;
import android.view.LayoutInflater;
import android.view.View;
import android.widget.TextView;

import com.bumptech.glide.Glide;
import com.bumptech.glide.load.resource.bitmap.RoundedCorners;
import com.bumptech.glide.request.RequestOptions;
import com.m7.imkfsdk.R;
import com.m7.imkfsdk.chat.ChatActivity;
import com.m7.imkfsdk.chat.holder.BaseHolder;
import com.m7.imkfsdk.chat.holder.ReceiveCardInfoRxHolder;
import com.m7.imkfsdk.chat.holder.ViewHolderTag;
import com.m7.imkfsdk.utils.DensityUtil;
import com.moor.imkf.gson.Gson;
import com.moor.imkf.gson.reflect.TypeToken;
import com.moor.imkf.model.entity.FromToMessage;
import com.moor.imkf.model.entity.NewCardInfo;

import java.lang.reflect.Type;
import java.util.ArrayList;
import java.util.List;


/**
 * Description:收到的卡片类型
 *
 * @Author R-D
 * @Modification Time:2019/12/20
 */
public class ReceivedCardInfoRxChatRow extends BaseChatRow {

    public ReceivedCardInfoRxChatRow(int type) {
        super(type);
    }

    @Override
    public boolean onCreateRowContextMenu(ContextMenu contextMenu, View targetView, FromToMessage detail) {
        return false;
    }

    @Override
    protected void buildChattingData(final Context context, BaseHolder baseHolder, final FromToMessage message, int position) {
        ReceiveCardInfoRxHolder holder = (ReceiveCardInfoRxHolder) baseHolder;
        if (message != null && message.newCardInfo != null) {
            Type token = new TypeToken<NewCardInfo>() {
            }.getType();
            final NewCardInfo newCardInfo = new Gson().fromJson(message.newCardInfo, token);

            holder.tv_logistics_tx_title.setText(newCardInfo.getTitle());
            holder.tv_logistics_tx_second.setText(newCardInfo.getSub_title());
            if (newCardInfo.getAttr_one() != null) {
                holder.tv_logistics_tx_num.setText(newCardInfo.getAttr_one().getContent());

                String color = newCardInfo.getAttr_one().getColor();
                if (color.contains("#")) {
                    try {
                        holder.tv_logistics_tx_num.setTextColor(Color.parseColor(color));
                    } catch (Exception e) {

                    }
                }

            }
            if (newCardInfo.getAttr_two() != null) {
                holder.tv_logistics_tx_state.setText(newCardInfo.getAttr_two().getContent());

                String color = newCardInfo.getAttr_two().getColor();
                if (color.contains("#")) {
                    try {
                        holder.tv_logistics_tx_state.setTextColor(Color.parseColor(color));
                    } catch (Exception e) {

                    }
                }
            }
            if (!"".equals(newCardInfo.getPrice())) {
                holder.tv_logistics_tx_price.setVisibility(View.VISIBLE);
                holder.tv_logistics_tx_state.setVisibility(View.VISIBLE);
                holder.tv_logistics_tx_num.setVisibility(View.VISIBLE);
                holder.tv_logistics_tx_price.setText(newCardInfo.getPrice());
                holder.tv_logistics_tx_second.setMaxLines(1);
            } else {
                holder.tv_logistics_tx_price.setVisibility(View.GONE);
                holder.tv_logistics_tx_state.setVisibility(View.GONE);
                holder.tv_logistics_tx_num.setVisibility(View.GONE);
                holder.tv_logistics_tx_second.setMaxLines(2);
            }
            List<String> list = new ArrayList<>();

            if (!"".equals(newCardInfo.getOther_title_one())) {
                list.add(newCardInfo.getOther_title_one());
            }
            if (!"".equals(newCardInfo.getOther_title_two())) {
                list.add(newCardInfo.getOther_title_two());
            }
            if (!"".equals(newCardInfo.getOther_title_three())) {
                list.add(newCardInfo.getOther_title_three());
            }
            if (list.size() > 0) {
                holder.ll_received_new_order_info.removeAllViews();
                holder.ll_received_new_order_info.setVisibility(View.VISIBLE);
                for (String s : list) {
                    TextView textView = new TextView(context);
                    textView.setTextSize(12f);
                    textView.setMaxLines(1);
                    textView.setEllipsize(TextUtils.TruncateAt.END);
                    textView.setTextColor(context.getResources().getColor(R.color.color_666666));
                    textView.setText(s);
                    holder.ll_received_new_order_info.addView(textView);
                }

            } else {
                holder.ll_received_new_order_info.setVisibility(View.GONE);
            }


            String img = newCardInfo.getImg();
            final RequestOptions options = new RequestOptions()
                    .centerCrop()
                    .error(R.drawable.kf_image_download_fail_icon)
                    .placeholder(R.drawable.kf_pic_thumb_bg);
            Glide.with(context).load(img)
                    .apply(options)
                    .apply(RequestOptions.bitmapTransform(new RoundedCorners(DensityUtil.dip2px(2f))))
                    .into(holder.iv_logistics_tx_img);


            View.OnClickListener listener = ((ChatActivity) context).getChatAdapter().getOnClickListener();
            ViewHolderTag clickTag = ViewHolderTag.createTag(newCardInfo.getTarget(), ViewHolderTag.TagType.TAG_CLICK_NEW_CARD);
            holder.kf_chat_rich_lin.setTag(clickTag);
            holder.kf_chat_rich_lin.setOnClickListener(listener);

        }

    }

    @Override
    public View buildChatView(LayoutInflater inflater, View convertView) {
        if (convertView == null) {
            convertView = inflater.inflate(R.layout.kf_chat_row_received_newcardinfo_rx, null);
            ReceiveCardInfoRxHolder holder = new ReceiveCardInfoRxHolder(mRowType);
            convertView.setTag(holder.initBaseHolder(convertView, true));
        }
        return convertView;
    }

    @Override
    public int getChatViewType() {
        return ChatRowType.RECEIVED_ORDER_INFO_ROW_RECEIVED.ordinal();
    }
}

