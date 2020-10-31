package com.m7.imkfsdk.chat.adapter;

import android.content.Context;
import androidx.recyclerview.widget.RecyclerView;
import android.view.View;
import android.view.ViewGroup;
import android.widget.TextView;

import com.m7.imkfsdk.R;
import com.moor.imkf.model.entity.FlowBean;

import java.util.List;

/**
 * <p>
 * Package Name:com.m7.imkfsdk.chat.adapter$
 * </p>
 * <p>
 * Class Name:ChatTagLabelsAdapter$
 * <p>
 * Description:聊天页面底部的横向滚动推荐条
 * </p>
 *
 * @Author ChenBo
 * @Version 1.0 2019/9/19$ 11:00$ Release
 * @Reviser:
 * @Modification Time:2019/9/19$ 11:00$
 */
public class ChatTagLabelsAdapter extends RecyclerView.Adapter<ChatTagLabelsAdapter.ChatTagViewHolder> {
    List<FlowBean> datas;

    public ChatTagLabelsAdapter(List<FlowBean> datas) {
        this.datas = datas;
    }

    public void refreshData(List<FlowBean> datas) {
        this.datas.clear();
        this.datas = datas;
        notifyDataSetChanged();
    }

    @Override
    public ChatTagViewHolder onCreateViewHolder(ViewGroup parent, int viewType) {
        View v = View.inflate(parent.getContext(), R.layout.item_chat_tag_label, null);
        return new ChatTagViewHolder(v);
    }

    @Override
    public void onBindViewHolder(ChatTagViewHolder holder, final int position) {
        holder.tvFlowItem.setText(datas.get(position).getButton());
        holder.tvFlowItem.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                if (mListener != null) {
                    mListener.OnItemClick(datas.get(position));
                }
            }
        });
    }

    @Override
    public int getItemCount() {
        return datas == null ? 0 : datas.size();
    }

    class ChatTagViewHolder extends RecyclerView.ViewHolder {
        TextView tvFlowItem;

        public ChatTagViewHolder(View itemView) {
            super(itemView);
            tvFlowItem = itemView.findViewById(R.id.tv_flowItem);
        }
    }

    private onItemClickListener mListener;

    public interface onItemClickListener {
        void OnItemClick(FlowBean flowBean);
    }

    public void setOnItemClickListener(onItemClickListener listener) {
        mListener = listener;
    }
}
