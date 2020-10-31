package com.m7.imkfsdk.chat.chatrow;

import android.content.Context;
import androidx.recyclerview.widget.LinearLayoutManager;
import android.view.ContextMenu;
import android.view.LayoutInflater;
import android.view.View;

import com.m7.imkfsdk.R;
import com.m7.imkfsdk.chat.ChatActivity;
import com.m7.imkfsdk.chat.adapter.LogisticsInfoRxListAdapter;
import com.m7.imkfsdk.chat.adapter.LogisticsProgressListAdapter;
import com.m7.imkfsdk.chat.holder.BaseHolder;
import com.m7.imkfsdk.chat.holder.LogisticsInfoRxHolder;
import com.m7.imkfsdk.chat.holder.ViewHolderTag;
import com.m7.imkfsdk.chat.model.OrderBaseBean;
import com.m7.imkfsdk.chat.model.OrderInfoBean;
import com.moor.imkf.gson.Gson;
import com.moor.imkf.gson.reflect.TypeToken;
import com.moor.imkf.model.entity.FromToMessage;
import com.moor.imkf.utils.NullUtil;

import java.lang.reflect.Type;
import java.util.List;

/**
 * @author R-D
 * @Description 收到的订单信息和物流信息列表类型
 * @date 2019/12/01
 */
public class LogisticsInfoRxChatRow extends BaseChatRow {

    private int type;
    private ViewHolderTag holderTag;

    public LogisticsInfoRxChatRow(int type) {
        super(type);
    }

    @Override
    public boolean onCreateRowContextMenu(ContextMenu contextMenu, View targetView, FromToMessage detail) {
        return false;
    }

    @Override
    protected void buildChattingData(final Context context, BaseHolder baseHolder, final FromToMessage detail, int position) {
        final LogisticsInfoRxHolder holder = (LogisticsInfoRxHolder) baseHolder;
        if (detail.msgTask != null && !"".equals(detail.msgTask)) {
            Type token = new TypeToken<OrderBaseBean>() {
            }.getType();
            final OrderBaseBean orderBaseBean = new Gson().fromJson(detail.msgTask, token);
            if (orderBaseBean.getData() != null) {
                List<OrderInfoBean> infoBeanList = orderBaseBean.getData().getList();

                //RecyclerView
                holder.rv_logistics_rx.setVisibility(infoBeanList.size() > 0 ? View.VISIBLE : View.GONE);
                //展示无数据的文本，替换RecyclerView
                holder.tv_no_data.setVisibility(infoBeanList.size() > 0 ? View.GONE : View.VISIBLE);
                //标题以下的部分
                holder.ll_order_content.setVisibility(infoBeanList.size() > 0 ? View.VISIBLE : View.GONE);
                //
                holder.tv_no_data.setText(orderBaseBean.getData().getEmpty_message());
                //上部标题
                holder.kf_chat_rich_title.setText(infoBeanList.size() > 0 ? orderBaseBean.getData().getMessage()
                        : orderBaseBean.getData().getEmpty_message());
                boolean isOrderList = "0".equals(orderBaseBean.getResp_type());

                View.OnClickListener listener = ((ChatActivity) context).getChatAdapter().getOnClickListener();
                //下部查看更多控件
                holder.kf_chat_rich_content.setText(isOrderList ? context.getString(R.string.ykf_lookmore)
                        : context.getString(R.string.ykf_look_express));
                holder.rv_logistics_rx.setLayoutManager(new LinearLayoutManager(context));
                holder.rv_logistics_rx.setNestedScrollingEnabled(false);

                if (isOrderList) {
                    holder.tv_logistics_progress_num.setVisibility(View.GONE);
                    holder.tv_logistics_progress_name.setVisibility(View.GONE);
                    holder.rl_progress_top.setVisibility(View.GONE);
                    if ("1".equals(detail.showOrderInfo)) {
                        holder.rv_logistics_rx.setVisibility(View.GONE);
                        holder.kf_chat_rich_content.setText(context.getString(R.string.ykf_reselect));
                        holder.rl_logistics.setVisibility(View.VISIBLE);
                        holder.view_middle.setVisibility(View.VISIBLE);
                        holder.view_top.setVisibility(View.VISIBLE);
                    } else if ("2".equals(detail.showOrderInfo)){
                        holder.rv_logistics_rx.setVisibility(View.GONE);
                        holder.rl_logistics.setVisibility(View.GONE);
                        holder.view_middle.setVisibility(View.GONE);
                        holder.view_top.setVisibility(View.GONE);

                    }else{
                        //订单信息列表
                        holder.rv_logistics_rx.setVisibility(View.VISIBLE);
                        holder.view_top.setVisibility(View.VISIBLE);
                        LogisticsInfoRxListAdapter adapter = new LogisticsInfoRxListAdapter(infoBeanList, orderBaseBean.getCurrent(), false, detail._id);
                        holder.rv_logistics_rx.setAdapter(adapter);
                        holder.view_middle.setVisibility(infoBeanList.size() < 5 ? View.GONE : View.VISIBLE);
                        holder.rl_logistics.setVisibility(infoBeanList.size() < 5 ? View.GONE : View.VISIBLE);
                    }

                    //查看更多-类型
                    type = ViewHolderTag.TagType.TAG_CLICK_LOGISTICS_RX_MORE;
                    holderTag = ViewHolderTag.createTag(orderBaseBean.getCurrent(), detail._id, type);
                } else {
                    holder.tv_logistics_progress_num.setVisibility(View.VISIBLE);
                    holder.tv_logistics_progress_name.setVisibility(View.VISIBLE);
                    //物流信息列表
                    if (infoBeanList.size() > 0) {
                        holder.tv_logistics_progress_name.setText(orderBaseBean.getData().getList_title());
                        holder.tv_logistics_progress_num.setText(context.getString(R.string.ykf_waybill_number) + orderBaseBean.getData().getList_num());
                        holder.kf_chat_rich_title.setText(orderBaseBean.getData().getMessage());
                        //快递名称和运单号部分
                        holder.rl_progress_top.setVisibility(View.VISIBLE);
                        LogisticsProgressListAdapter adapter = new LogisticsProgressListAdapter(infoBeanList, false);
                        holder.rv_logistics_rx.setAdapter(adapter);
                        holder.rl_logistics.setVisibility(infoBeanList.size() < 3 ? View.GONE : View.VISIBLE);
                        //查看完整物流信息-类型
                        type = ViewHolderTag.TagType.TAG_CLICK_LOGISTICS_PROGERSS_MORE;
                        holderTag = ViewHolderTag.createTag(detail, type, position);
                    } else {
                        if (NullUtil.checkNULL(orderBaseBean.getData().getList_num())) {
                            holder.tv_logistics_progress_name.setText(orderBaseBean.getData().getList_title());
                            holder.tv_logistics_progress_num.setText(context.getString(R.string.ykf_waybill_number) + orderBaseBean.getData().getList_num());
                            holder.kf_chat_rich_title.setText(orderBaseBean.getData().getMessage());
                            holder.ll_order_content.setVisibility(View.VISIBLE);
                            holder.rl_progress_top.setVisibility(View.VISIBLE);
                            holder.tv_no_data.setVisibility(View.VISIBLE);
                        } else {
                            holder.ll_order_content.setVisibility(View.GONE);
                            holder.tv_no_data.setVisibility(View.GONE);
                            holder.kf_chat_rich_title.setText(orderBaseBean.getData().getEmpty_message());
                            holder.rl_progress_top.setVisibility(View.GONE);
                            holder.rv_logistics_rx.setVisibility(View.GONE);
                        }

                    }

                }

                holder.rl_logistics.setTag(holderTag);
                holder.rl_logistics.setOnClickListener(listener);
            }

        }
    }

    @Override
    public View buildChatView(LayoutInflater inflater, View convertView) {
        if (convertView == null) {
            convertView = inflater.inflate(R.layout.kf_chat_row_logistics_rx, null);
            LogisticsInfoRxHolder holder = new LogisticsInfoRxHolder(mRowType);
            convertView.setTag(holder.initBaseHolder(convertView, true));
        }
        return convertView;
    }

    @Override
    public int getChatViewType() {
        return ChatRowType.LOGISTICS_INFORMATION_ROW_RECEIVED.ordinal();
    }
}

