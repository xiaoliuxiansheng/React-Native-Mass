package com.m7.imkfsdk.chat.adapter;

import androidx.recyclerview.widget.RecyclerView;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.RelativeLayout;
import android.widget.TextView;

import com.m7.imkfsdk.R;
import com.m7.imkfsdk.chat.model.DetailsQuestionBean;
import com.moor.imkf.listener.ChatListener;
import com.moor.imkf.IMChat;
import com.moor.imkf.IMMessage;
import com.moor.imkf.eventbus.EventBus;
import com.moor.imkf.model.entity.FromToMessage;
import com.moor.imkf.tcpservice.event.QuestionEvent;

import java.io.UnsupportedEncodingException;
import java.net.URLEncoder;
import java.util.List;

/**
 * @Description:
 * @Author: R-D
 * @Date: 2019-12-27
 */
public class DetailQuestionAdapter extends RecyclerView.Adapter<DetailQuestionAdapter.SwipeHolder> {
    private List<DetailsQuestionBean> list;

    public DetailQuestionAdapter(List<DetailsQuestionBean> list) {
        this.list = list;
    }

    @Override
    public SwipeHolder onCreateViewHolder(ViewGroup viewGroup, int i) {
        View inflate = LayoutInflater.from(viewGroup.getContext()).inflate(R.layout.item_detail_question, viewGroup, false);
        return new SwipeHolder(inflate);
    }

    @Override
    public void onBindViewHolder(SwipeHolder viewHolder, final int i) {
        viewHolder.tv_detailQuestion.setText(list.get(i).getTitle());
        viewHolder.rl_item.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {
//                ToastUtils.showShort("点击了" + list.get(i).getTitle() + list.get(i).getQuestionId());
                String title = list.get(i).getTitle();
                try {
                    final String content = URLEncoder.encode("【常见问题】" + title, "utf-8");

                    FromToMessage questionMessage = IMMessage.createQuestionMessage(content);
                    IMChat.getInstance().sendQuestionMsg(list.get(i).getQuestionId(), content, questionMessage, new ChatListener() {
                        @Override
                        public void onSuccess() {
//                            ToastUtils.showShort("发送成功了");

                            EventBus.getDefault().post(new QuestionEvent());
                        }

                        @Override
                        public void onFailed() {

                        }

                        @Override
                        public void onProgress(int progress) {

                        }
                    });
                } catch (UnsupportedEncodingException e) {
                    e.printStackTrace();
                }

            }
        });

    }

    @Override
    public int getItemCount() {
        return list.size();
    }

    public class SwipeHolder extends RecyclerView.ViewHolder {

        public final TextView tv_detailQuestion;
        public final RelativeLayout rl_item;

        SwipeHolder(View itemView) {
            super(itemView);
            tv_detailQuestion = itemView.findViewById(R.id.tv_detailQuestion);
            rl_item = itemView.findViewById(R.id.rl_item);
        }

    }
}
