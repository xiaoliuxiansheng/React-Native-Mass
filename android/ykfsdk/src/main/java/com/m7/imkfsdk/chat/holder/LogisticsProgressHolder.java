package com.m7.imkfsdk.chat.holder;

import androidx.recyclerview.widget.RecyclerView;
import android.view.View;
import android.widget.TextView;

import com.m7.imkfsdk.R;

/**
 * @Description:
 * @Author: R-D
 * @Date: 2020-01-06
 */
public class LogisticsProgressHolder extends RecyclerView.ViewHolder {
  public  TextView tvAcceptStation;
  public  View view_topline;
  public  View view_bottomline;
  public  TextView tvAcceptTime;
  public  View view_dot;

    public LogisticsProgressHolder(View itemView) {
        super(itemView);
        tvAcceptStation = (TextView) itemView.findViewById(R.id.tvAcceptStation);
        view_topline = itemView.findViewById(R.id.view_topline);
        view_bottomline = itemView.findViewById(R.id.view_bottomline);
        tvAcceptTime = (TextView) itemView.findViewById(R.id.tvAcceptTime);
        view_dot = itemView.findViewById(R.id.view_dot);
    }
}
