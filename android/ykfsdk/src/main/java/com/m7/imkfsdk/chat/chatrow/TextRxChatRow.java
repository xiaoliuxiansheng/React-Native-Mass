package com.m7.imkfsdk.chat.chatrow;

import android.content.ClipData;
import android.content.ClipboardManager;
import android.content.Context;
import android.content.Intent;
import android.graphics.BitmapFactory;
import android.graphics.Color;
import android.graphics.drawable.Drawable;
import android.media.ThumbnailUtils;
import android.net.Uri;
import android.provider.MediaStore;
import androidx.annotation.Nullable;
import androidx.recyclerview.widget.RecyclerView;
import android.text.Html;
import android.text.Spannable;
import android.text.SpannableString;
import android.text.SpannableStringBuilder;
import android.text.Spanned;
import android.text.TextUtils;
import android.text.method.LinkMovementMethod;
import android.text.style.ClickableSpan;
import android.text.style.ForegroundColorSpan;
import android.text.style.ImageSpan;
import android.view.ContextMenu;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.AdapterView;
import android.widget.ImageView;
import android.widget.LinearLayout;
import android.widget.TextView;
import android.widget.Toast;

import com.bumptech.glide.Glide;
import com.bumptech.glide.load.DataSource;
import com.bumptech.glide.load.engine.GlideException;
import com.bumptech.glide.request.RequestListener;
import com.bumptech.glide.request.target.Target;
import com.m7.imkfsdk.R;
import com.m7.imkfsdk.chat.ChatActivity;
import com.m7.imkfsdk.chat.ImageViewLookActivity;
import com.m7.imkfsdk.chat.NumClickWindow;
import com.m7.imkfsdk.chat.YKFVideoActivity;
import com.m7.imkfsdk.chat.adapter.FlowAdapter;
import com.m7.imkfsdk.chat.holder.BaseHolder;
import com.m7.imkfsdk.chat.holder.TextViewHolder;
import com.m7.imkfsdk.constant.Constants;
import com.m7.imkfsdk.utils.DensityUtil;
import com.m7.imkfsdk.utils.FaceConversionUtil;
import com.m7.imkfsdk.utils.RegexUtils;
import com.m7.imkfsdk.utils.ToastUtils;

import com.m7.imkfsdk.view.PopupWindowList;
import com.m7.imkfsdk.view.widget.PagerGridLayoutManager;
import com.m7.imkfsdk.view.widget.PagerGridSnapHelper;
import com.moor.imkf.IMChatManager;
import com.moor.imkf.db.dao.MessageDao;
import com.moor.imkf.eventbus.EventBus;
import com.moor.imkf.gson.Gson;
import com.moor.imkf.gson.reflect.TypeToken;
import com.moor.imkf.jsoup.Jsoup;
import com.moor.imkf.jsoup.nodes.Document;
import com.moor.imkf.jsoup.nodes.Element;
import com.moor.imkf.jsoup.select.Elements;
import com.moor.imkf.model.entity.FlowBean;
import com.moor.imkf.model.entity.FromToMessage;
import com.moor.imkf.tcpservice.event.MsgEvent;
import com.moor.imkf.tcpservice.event.TransferAgent;
import com.moor.imkf.utils.AnimatedGifDrawable;
import com.moor.imkf.utils.AnimatedImageSpan;
import com.moor.imkf.utils.LogUtils;
import com.moor.imkf.utils.MoorUtils;
import com.moor.imkf.utils.NullUtil;

import java.io.IOException;
import java.io.InputStream;
import java.lang.reflect.Type;
import java.util.ArrayList;
import java.util.List;
import java.util.regex.Matcher;
import java.util.regex.Pattern;


/**
 * Created by longwei on 2016/3/9.
 */
public class TextRxChatRow extends BaseChatRow {

    private Context context;
    private PopupWindowList mPopupWindowList;
    private int mRows = 4;
    private int mColumns = 2;
    private int mTotal = 0;
    private int mCurrent = 0;
    private PagerGridLayoutManager mLayoutManager;
    private FlowAdapter flowAdapter;

    public TextRxChatRow(int type) {
        super(type);
    }

    @Override
    public boolean onCreateRowContextMenu(ContextMenu contextMenu, View targetView, FromToMessage detail) {
        return false;
    }

    @Override
    protected void buildChattingData(final Context context, BaseHolder baseHolder, final FromToMessage detail, int position) {
        this.context = context;
        final TextViewHolder holder = (TextViewHolder) baseHolder;
        final FromToMessage message = detail;
        if (message != null) {
            holder.getDescLinearLayout().removeAllViews();

            if (message.withDrawStatus) {//消息撤回
                holder.getWithdrawTextView().setVisibility(View.VISIBLE);
                holder.getContainer().setVisibility(View.GONE);
            } else {
                holder.getWithdrawTextView().setVisibility(View.GONE);
                holder.getContainer().setVisibility(View.VISIBLE);
                //xbot2 改造逻辑
                if (message.flowTip != null && !"".equals(message.flowTip)) {//是xbot2新的展示方式
                    //如果是xbot的滑动按钮UI
                    if ("button".equals(message.flowType)) {
                        holder.ll_flow.setVisibility(View.VISIBLE);
                        holder.chat_rl_robot.setVisibility(View.GONE);
                        holder.chat_rl_robot_result.setVisibility(View.GONE);
                        LogUtils.aTag("messageflowlist", message.flowList);
                        initflowImgandText(message,holder);//添加文字和图片
                        if("0".equals(message.flowStyle)||TextUtils.isEmpty(message.flowStyle)
                                ||"null".equals(message.flowStyle)){
                            //双列按钮
                            Type token = new TypeToken<ArrayList<FlowBean>>() {}.getType();
                            ArrayList<FlowBean> flowBeanArrayList = new Gson().fromJson(message.flowList, token);
                            //动态设置整体高度，以及recyclerView的高度
                            if (flowBeanArrayList.size() < 7 && flowBeanArrayList.size() > 4) {//三行
                                ViewGroup.LayoutParams lps;
                                lps = holder.ll_flow.getLayoutParams();
                                lps.height = DensityUtil.dip2px(150);
                                holder.ll_flow.setLayoutParams(lps);
                                mLayoutManager = new PagerGridLayoutManager(4, mColumns, PagerGridLayoutManager.VERTICAL) {
                                    @Override
                                    public RecyclerView.LayoutParams generateDefaultLayoutParams() {
                                        //宽高均设置为100
                                        RecyclerView.LayoutParams lp = new
                                                RecyclerView.LayoutParams(ViewGroup.LayoutParams.MATCH_PARENT, DensityUtil.dip2px(95));
                                        return lp;
                                    }
                                };
                                holder.mRecyclerView.setLayoutManager(mLayoutManager);

                            } else if (flowBeanArrayList.size() < 5 && flowBeanArrayList.size() > 2) {//两行
                                ViewGroup.LayoutParams lps;
                                lps = holder.ll_flow.getLayoutParams();
                                lps.height = DensityUtil.dip2px(120);
                                holder.ll_flow.setLayoutParams(lps);
                                mLayoutManager = new PagerGridLayoutManager(4, mColumns, PagerGridLayoutManager.VERTICAL) {
                                    @Override
                                    public RecyclerView.LayoutParams generateDefaultLayoutParams() {
                                        //宽高均设置为100
                                        RecyclerView.LayoutParams lp = new RecyclerView.LayoutParams(ViewGroup.LayoutParams.MATCH_PARENT,
                                                DensityUtil.dip2px(80));
                                        return lp;
                                    }
                                };
                                holder.mRecyclerView.setLayoutManager(mLayoutManager);
                            } else if (flowBeanArrayList.size() < 3 && flowBeanArrayList.size() > 0) {//一行
                                ViewGroup.LayoutParams lps;
                                lps = holder.ll_flow.getLayoutParams();
                                lps.height = DensityUtil.dip2px(60);
                                holder.ll_flow.setLayoutParams(lps);
                                mLayoutManager = new PagerGridLayoutManager(4, mColumns, PagerGridLayoutManager.VERTICAL) {
                                    @Override
                                    public RecyclerView.LayoutParams generateDefaultLayoutParams() {
                                        //宽高均设置为100
                                        RecyclerView.LayoutParams lp = new RecyclerView.LayoutParams(ViewGroup.LayoutParams.MATCH_PARENT, DensityUtil.dip2px(45));
                                        return lp;
                                    }
                                };
                                holder.mRecyclerView.setLayoutManager(mLayoutManager);
                            } else if (flowBeanArrayList.size() < 9 && flowBeanArrayList.size() > 6) {//四行
                                ViewGroup.LayoutParams lps;
                                lps = holder.ll_flow.getLayoutParams();
                                lps.height = DensityUtil.dip2px(200);
                                holder.ll_flow.setLayoutParams(lps);
                                mLayoutManager = new PagerGridLayoutManager(4, mColumns, PagerGridLayoutManager.VERTICAL) {
                                    @Override
                                    public RecyclerView.LayoutParams generateDefaultLayoutParams() {
                                        //宽高均设置为100
                                        RecyclerView.LayoutParams lp = new RecyclerView.LayoutParams(ViewGroup.LayoutParams.MATCH_PARENT, DensityUtil.dip2px(110));
                                        return lp;
                                    }
                                };
                                holder.mRecyclerView.setLayoutManager(mLayoutManager);
                            } else {
                                //正常的
                                ViewGroup.LayoutParams lps;
                                lps = holder.ll_flow.getLayoutParams();
                                lps.height = DensityUtil.dip2px(236);
                                holder.ll_flow.setLayoutParams(lps);
                                mLayoutManager = new PagerGridLayoutManager(mRows, mColumns, PagerGridLayoutManager.HORIZONTAL) {
                                    @Override
                                    public RecyclerView.LayoutParams generateDefaultLayoutParams() {
                                        //宽高均设置为100
                                        RecyclerView.LayoutParams lp = new RecyclerView.
                                                LayoutParams(ViewGroup.LayoutParams.MATCH_PARENT, DensityUtil.dip2px(200));
                                        return lp;
                                    }
                                };
                                holder.mRecyclerView.setLayoutManager(mLayoutManager);
                            }


                            // 设置滚动辅助工具
                            PagerGridSnapHelper pageSnapHelper = new PagerGridSnapHelper();
                            if (holder.mRecyclerView.getOnFlingListener() == null)
                                pageSnapHelper.attachToRecyclerView(holder.mRecyclerView);

                            flowAdapter = new FlowAdapter(context, flowBeanArrayList, new FlowAdapter.OnItemClickListenr() {
                                @Override
                                public void setOnButtonClickListenr(String msg) {
//                                Toast.makeText(context, "item" + msg + " 被点击了", Toast.LENGTH_SHORT).show();
                                    // TODO: 2019/9/2 发送消息
                                    ChatActivity context1 = (ChatActivity) context;
                                    context1.sendXbotTextMsg(msg);
                                }
                            });
                            LogUtils.aTag("flowlist", flowBeanArrayList.size());
                            holder.mRecyclerView.setAdapter(flowAdapter);
                            int flowSize = flowBeanArrayList.size() / 8;
                            if (flowBeanArrayList.size() % 8 > 0) {
                                flowSize = flowSize + 1;
                            }

                            holder.pointBottomView.setFillColor(context.getResources().getColor(R.color.pointed));//选中的颜色
//                        holder.pointBottomView.setStrokeColor(R.color.pointno);//未选中的颜色
                            holder.pointBottomView.initData(flowSize, 0);


                            // 水平分页布局管理器
                            mLayoutManager.setPageListener(new PagerGridLayoutManager.PageListener() {
                                @Override
                                public void onPageSizeChanged(int pageSize) {
                                    mTotal = pageSize;
                                }

                                @Override
                                public void onPageSelect(int pageIndex) {
                                    mCurrent = pageIndex;
                                    holder.pointBottomView.setCurrentPage(pageIndex);

                                }
                            });


                        }
                        else if("1".equals(message.flowStyle)){
                            //单列按钮
                            LinearLayout.LayoutParams layoutParams= (LinearLayout.LayoutParams) holder.mRecyclerView.getLayoutParams();
                            layoutParams.width=(DensityUtil.dip2px(220));
                            holder.mRecyclerView.setLayoutParams(layoutParams);

                            Type token = new TypeToken<ArrayList<FlowBean>>() {}.getType();
                            ArrayList<FlowBean> flowBeanArrayList = new Gson().fromJson(message.flowList, token);
                            //动态设置整体高度，以及recyclerView的高度
                            if (flowBeanArrayList.size() ==3) {//三行
                                ViewGroup.LayoutParams lps;
                                lps = holder.ll_flow.getLayoutParams();
                                lps.height = DensityUtil.dip2px(150);
                                holder.ll_flow.setLayoutParams(lps);
                                mLayoutManager = new PagerGridLayoutManager(4, 1, PagerGridLayoutManager.VERTICAL) {
                                    @Override
                                    public RecyclerView.LayoutParams generateDefaultLayoutParams() {
                                        //宽高均设置为100
                                        RecyclerView.LayoutParams lp = new
                                                RecyclerView.LayoutParams(ViewGroup.LayoutParams.WRAP_CONTENT,
                                                DensityUtil.dip2px(95));
                                        return lp;
                                    }
                                };
                                holder.mRecyclerView.setLayoutManager(mLayoutManager);
                            } else if (flowBeanArrayList.size() ==2) {//两行
                                ViewGroup.LayoutParams lps;
                                lps = holder.ll_flow.getLayoutParams();
                                lps.height = DensityUtil.dip2px(120);
                                holder.ll_flow.setLayoutParams(lps);
                                mLayoutManager = new PagerGridLayoutManager(4, 1, PagerGridLayoutManager.VERTICAL) {
                                    @Override
                                    public RecyclerView.LayoutParams generateDefaultLayoutParams() {
                                        //宽高均设置为100
                                        RecyclerView.LayoutParams lp = new RecyclerView.LayoutParams
                                                (ViewGroup.LayoutParams.WRAP_CONTENT,
                                                DensityUtil.dip2px(80));
                                        return lp;
                                    }
                                };
                                holder.mRecyclerView.setLayoutManager(mLayoutManager);
                            } else if (flowBeanArrayList.size() ==1) {//一行
                                ViewGroup.LayoutParams lps;
                                lps = holder.ll_flow.getLayoutParams();
                                lps.height = DensityUtil.dip2px(60);
                                holder.ll_flow.setLayoutParams(lps);
                                mLayoutManager = new PagerGridLayoutManager(1, 1, PagerGridLayoutManager.VERTICAL) {
                                    @Override
                                    public RecyclerView.LayoutParams generateDefaultLayoutParams() {
                                        //宽高均设置为100
                                        RecyclerView.LayoutParams lp = new RecyclerView.LayoutParams
                                                (ViewGroup.LayoutParams.WRAP_CONTENT, DensityUtil.dip2px(45));
                                        return lp;
                                    }
                                };
                                holder.mRecyclerView.setLayoutManager(mLayoutManager);
                            } else if (flowBeanArrayList.size() ==4) {//四行
                                ViewGroup.LayoutParams lps;
                                lps = holder.ll_flow.getLayoutParams();
                                lps.height = DensityUtil.dip2px(200);
                                holder.ll_flow.setLayoutParams(lps);
                                mLayoutManager = new PagerGridLayoutManager(4, 1, PagerGridLayoutManager.VERTICAL) {
                                    @Override
                                    public RecyclerView.LayoutParams generateDefaultLayoutParams() {
                                        //宽高均设置为100
                                        RecyclerView.LayoutParams lp = new RecyclerView.LayoutParams
                                                (ViewGroup.LayoutParams.WRAP_CONTENT, DensityUtil.dip2px(110));
                                        return lp;
                                    }
                                };
                                holder.mRecyclerView.setLayoutManager(mLayoutManager);
                            } else {
                                //正常的
                                ViewGroup.LayoutParams lps;
                                lps = holder.ll_flow.getLayoutParams();
                                lps.height = DensityUtil.dip2px(236);
                                holder.ll_flow.setLayoutParams(lps);
                                mLayoutManager = new PagerGridLayoutManager(mRows, 1, PagerGridLayoutManager.HORIZONTAL) {
                                    @Override
                                    public RecyclerView.LayoutParams generateDefaultLayoutParams() {
                                        //宽高均设置为100
                                        RecyclerView.LayoutParams lp = new RecyclerView.
                                                LayoutParams(ViewGroup.LayoutParams.WRAP_CONTENT, DensityUtil.dip2px(200));
                                        return lp;
                                    }
                                };
                                holder.mRecyclerView.setLayoutManager(mLayoutManager);
                            }


                            // 设置滚动辅助工具
                            PagerGridSnapHelper pageSnapHelper = new PagerGridSnapHelper();
                            if (holder.mRecyclerView.getOnFlingListener() == null)
                                pageSnapHelper.attachToRecyclerView(holder.mRecyclerView);

                            flowAdapter = new FlowAdapter(context, flowBeanArrayList, new FlowAdapter.OnItemClickListenr() {
                                @Override
                                public void setOnButtonClickListenr(String msg) {
//                                Toast.makeText(context, "item" + msg + " 被点击了", Toast.LENGTH_SHORT).show();
                                    // TODO: 2019/9/2 发送消息
                                    ChatActivity context1 = (ChatActivity) context;
                                    context1.sendXbotTextMsg(msg);
                                }
                            });
                            LogUtils.aTag("flowlist", flowBeanArrayList.size());
                            holder.mRecyclerView.setAdapter(flowAdapter);
                            int flowSize = flowBeanArrayList.size() / 4;
                            if (flowBeanArrayList.size() % 4 > 0) {
                                flowSize = flowSize + 1;
                            }

                            holder.pointBottomView.setFillColor(context.getResources().getColor(R.color.pointed));//选中的颜色
//                        holder.pointBottomView.setStrokeColor(R.color.pointno);//未选中的颜色
                            holder.pointBottomView.initData(flowSize, 0);


                            // 水平分页布局管理器
                            mLayoutManager.setPageListener(new PagerGridLayoutManager.PageListener() {
                                @Override
                                public void onPageSizeChanged(int pageSize) {
                                    mTotal = pageSize;
                                }

                                @Override
                                public void onPageSelect(int pageIndex) {
                                    mCurrent = pageIndex;
                                    holder.pointBottomView.setCurrentPage(pageIndex);

                                }
                            });


                        }
                        else if("2".equals(message.flowStyle)){
                            //文字列表

                            //"flowType": "list",
                            holder.ll_flow.setVisibility(View.GONE);
                            holder.chat_rl_robot.setVisibility(View.GONE);
                            holder.chat_rl_robot_result.setVisibility(View.GONE);

                            // 添加可点击列表
                            Type token = new TypeToken<ArrayList<FlowBean>>() {
                            }.getType();
                            ArrayList<FlowBean> flowBeanArrayList = new Gson().fromJson(message.flowList, token);
                            for (int i = 0; i < flowBeanArrayList.size(); i++) {
                                TextView xbotView = new TextView(context);
                                String msg = i + 1 + ". " + flowBeanArrayList.get(i).getButton();
                                SpannableString spannableString = new SpannableString(msg);
                                XbotClickSpan clickSpan = new XbotClickSpan(flowBeanArrayList.get(i).getText(), ((ChatActivity) context));
                                spannableString.setSpan(clickSpan, 0, msg.length(), Spanned.SPAN_INCLUSIVE_EXCLUSIVE);
                                ForegroundColorSpan colorSpan = new ForegroundColorSpan(context.getResources().getColor(R.color.lite_blue));
                                spannableString.setSpan(colorSpan, 0, msg.length(), Spanned.SPAN_INCLUSIVE_EXCLUSIVE);
                                xbotView.setText(spannableString);
                                xbotView.setTextSize(14);
                                xbotView.setMovementMethod(LinkMovementMethod.getInstance());
                                holder.getDescLinearLayout().addView(xbotView);
                            }

                        }
                    } else {
                        //"flowType": "list",
                        holder.ll_flow.setVisibility(View.GONE);
                        holder.chat_rl_robot.setVisibility(View.GONE);
                        holder.chat_rl_robot_result.setVisibility(View.GONE);


                        //添加图片
                        initflowImgandText(message,holder);

                        // 添加可点击列表
                        Type token = new TypeToken<ArrayList<FlowBean>>() {
                        }.getType();
                        ArrayList<FlowBean> flowBeanArrayList = new Gson().fromJson(message.flowList, token);
                        for (int i = 0; i < flowBeanArrayList.size(); i++) {
                            TextView xbotView = new TextView(context);
                            String msg = i + 1 + ". " + flowBeanArrayList.get(i).getButton();
                            SpannableString spannableString = new SpannableString(msg);
                            XbotClickSpan clickSpan = new XbotClickSpan(flowBeanArrayList.get(i).getText(), ((ChatActivity) context));
                            spannableString.setSpan(clickSpan, 0, msg.length(), Spanned.SPAN_INCLUSIVE_EXCLUSIVE);
                            ForegroundColorSpan colorSpan = new ForegroundColorSpan(context.getResources().getColor(R.color.lite_blue));
                            spannableString.setSpan(colorSpan, 0, msg.length(), Spanned.SPAN_INCLUSIVE_EXCLUSIVE);
                            xbotView.setText(spannableString);
                            xbotView.setMovementMethod(LinkMovementMethod.getInstance());
                            holder.getDescLinearLayout().addView(xbotView);
                        }
                    }

                } else {
                    holder.ll_flow.setVisibility(View.GONE);
                    if (message.showHtml) {
//                        final List<String> data = getImgStr(message.message);
//                        String content = message.message.replaceAll("<(img|IMG)(.*?)(/>|></img>|>)", "---");
//                        String[] strings = content.split("---");
                        parserImg(message,holder);

                        //添加图片
                        initImgandText(message,holder);


                        if (!"".equals(NullUtil.checkNull(message.questionId))) {
                            holder.chat_rl_robot.setVisibility(View.VISIBLE);
                            if ("useful".equals(NullUtil.checkNull(message.robotPingjia))) {
                                holder.chat_iv_robot_useful.setImageResource(R.drawable.kf_robot_useful_blue);
                                holder.chat_tv_robot_useful.setTextColor(context.getResources().getColor(R.color.robot_blue));
                                holder.chat_iv_robot_useless.setImageResource(R.drawable.kf_robot_useless_grey);
                                holder.chat_tv_robot_useless.setTextColor(context.getResources().getColor(R.color.grey));
                                holder.chat_rl_robot_result.setVisibility(View.VISIBLE);
                                if(TextUtils.isEmpty(message.fingerUp)){
                                    holder.chat_tv_robot_result.setText(R.string.thinks_01);
                                }else{
                                    holder.chat_tv_robot_result.setText(message.fingerUp);
                                }

                            } else if ("useless".equals(NullUtil.checkNull(message.robotPingjia))) {
                                holder.chat_iv_robot_useful.setImageResource(R.drawable.kf_robot_useful_grey);
                                holder.chat_tv_robot_useful.setTextColor(context.getResources().getColor(R.color.grey));
                                holder.chat_iv_robot_useless.setImageResource(R.drawable.kf_robot_useless_blue);
                                holder.chat_tv_robot_useless.setTextColor(context.getResources().getColor(R.color.robot_blue));
                                holder.chat_rl_robot_result.setVisibility(View.VISIBLE);
                                if(TextUtils.isEmpty(message.fingerDown)){
                                    holder.chat_tv_robot_result.setText(R.string.thinks_02);
                                }else{
                                    holder.chat_tv_robot_result.setText(message.fingerDown);
                                }

                            } else {
                                holder.chat_iv_robot_useful.setImageResource(R.drawable.kf_robot_useful_grey);
                                holder.chat_tv_robot_useful.setTextColor(context.getResources().getColor(R.color.grey));
                                holder.chat_iv_robot_useless.setImageResource(R.drawable.kf_robot_useless_grey);
                                holder.chat_tv_robot_useless.setTextColor(context.getResources().getColor(R.color.grey));
                                holder.chat_rl_robot_result.setVisibility(View.GONE);
                                holder.chat_ll_robot_useful.setOnClickListener(new View.OnClickListener() {
                                    @Override
                                    public void onClick(View view) {
                                        message.robotPingjia = "useful";
                                        MessageDao.getInstance().updateMsgToDao(message);
                                        ((ChatActivity) context).updateMessage();
                                        if (!"".equals(NullUtil.checkNull(detail.questionId))) {
                                            if ("xbot".equals(NullUtil.checkNull(detail.robotType))) {//如果是xbot机器人
                                                IMChatManager.getInstance().sendRobotCsr(NullUtil.checkNull(detail.questionId),
                                                        NullUtil.checkNull(detail.std_question),
                                                        NullUtil.checkNull(detail.robotType), NullUtil.checkNull(detail.robotId), "1",
                                                        NullUtil.checkNull(detail.sid), NullUtil.checkNull(detail.ori_question),
                                                        NullUtil.checkNull(detail.std_question), NullUtil.checkNull(detail.message),
                                                        NullUtil.checkNull(detail.confidence), NullUtil.checkNull(detail.sessionId));
                                            } else {
                                                IMChatManager.getInstance().sendRobotCsr(NullUtil.checkNull(detail.questionId), NullUtil.checkNull(detail.robotType), NullUtil.checkNull(detail.robotId), NullUtil.checkNull(detail.robotMsgId), "useful");
                                            }
                                        }
                                    }
                                });
                                //没有帮助
                                holder.chat_ll_robot_useless.setOnClickListener(new View.OnClickListener() {
                                    @Override
                                    public void onClick(View view) {
                                        message.robotPingjia = "useless";
                                        MessageDao.getInstance().updateMsgToDao(message);
                                        ((ChatActivity) context).updateMessage();
                                        if (!"".equals(NullUtil.checkNull(detail.questionId))) {
                                            if ("xbot".equals(NullUtil.checkNull(detail.robotType))) {//如果是xbot机器人
                                                IMChatManager.getInstance().sendRobotCsr(NullUtil.checkNull(detail.questionId),
                                                        NullUtil.checkNull(detail.std_question),
                                                        NullUtil.checkNull(detail.robotType), NullUtil.checkNull(detail.robotId), "0",
                                                        NullUtil.checkNull(detail.sid), NullUtil.checkNull(detail.ori_question),
                                                        NullUtil.checkNull(detail.std_question), NullUtil.checkNull(detail.message),
                                                        NullUtil.checkNull(detail.confidence), NullUtil.checkNull(detail.sessionId));
                                            } else {//小七或者小莫
                                                IMChatManager.getInstance().sendRobotCsr(NullUtil.checkNull(detail.questionId), NullUtil.checkNull(detail.robotType), NullUtil.checkNull(detail.robotId), NullUtil.checkNull(detail.robotMsgId), "useless");
                                            }
                                        }
                                    }
                                });
                            }

                        } else {
                            holder.chat_rl_robot.setVisibility(View.GONE);
                            holder.chat_rl_robot_result.setVisibility(View.GONE);

                        }

                    } else {




                        holder.chat_rl_robot.setVisibility(View.GONE);
                        holder.chat_rl_robot_result.setVisibility(View.GONE);
                        TextView textView = new TextView(context);
                        textView.setTextColor(context.getResources().getColor(R.color.textcolor));
                        textView.setLineSpacing(0f, 1.1f);
                        SpannableStringBuilder content = handler(textView,
                                message.message);

                        String actionmsg=setA_String(content.toString());

                        SpannableStringBuilder spannableString = FaceConversionUtil.getInstace()
                                .getExpressionString(context, actionmsg + "", textView);

                        //        //匹配a标签 自定义 点击️
                        Pattern patten1 = Pattern.compile("\\[(?<text>[^\\]]*)\\]\\((?<link>[^\\)]*)\\)", Pattern.CASE_INSENSITIVE);
                        Matcher matcher1 = patten1.matcher(spannableString);
                        while (matcher1.find()) {
                            String m7_data = matcher1.group(1);
                            String m7_name = matcher1.group(2);
                            spannableString.replace(matcher1.start(), matcher1.end(), m7_data);
                            AClickApan clickSpan=new AClickApan(m7_name);
                            spannableString.setSpan(clickSpan, matcher1.start(), matcher1.start() + m7_data.length(), Spanned.SPAN_INCLUSIVE_EXCLUSIVE);
                            ForegroundColorSpan colorSpan = new ForegroundColorSpan(context.getResources().getColor(R.color.lite_blue));
                            spannableString.setSpan(colorSpan, matcher1.start(), matcher1.start() + m7_data.length(), Spanned.SPAN_INCLUSIVE_EXCLUSIVE);
                            matcher1 = patten1.matcher(spannableString);

                        }


                        Pattern patten2 = Pattern.
                                compile("((http[s]{0,1}|ftp)://[a-zA-Z0-9\\.\\-]+\\.([a-zA-Z]{2,4})(:\\d+)?(/[a-zA-Z0-9\\.\\-~!@#$%^&*+?:_/=<>]*)?)|(www.[a-zA-Z0-9\\.\\-]+\\.([a-zA-Z]{2,4})(:\\d+)?(/[a-zA-Z0-9\\.\\-~!@#$%^&*+?:_/=<>]*)?)|(((http[s]{0,1}|ftp)://|)((?:(?:25[0-5]|2[0-4]\\d|((1\\d{2})|([1-9]?\\d)))\\.){3}(?:25[0-5]|2[0-4]\\d|((1\\d{2})|([1-9]?\\d))))(:\\d+)?(/[a-zA-Z0-9\\.\\-~!@#$%^&*+?:_/=<>]*)?)", Pattern.CASE_INSENSITIVE);
                        Matcher matcher2 = patten2.matcher(spannableString);
                        while (matcher2.find()) {

                            String number = matcher2.group();
                            int end = matcher2.start() + number.length();
                            HttpClickSpan clickSpan = new HttpClickSpan(number);
                            spannableString.setSpan(clickSpan, matcher2.start(), end, Spanned.SPAN_INCLUSIVE_EXCLUSIVE);
                            ForegroundColorSpan colorSpan = new ForegroundColorSpan(context.getResources().getColor(R.color.lite_blue));
                            spannableString.setSpan(colorSpan, matcher2.start(), end, Spanned.SPAN_INCLUSIVE_EXCLUSIVE);
                        }



                        String regex=RegexUtils.isPhoneRegexp();
                        Pattern patten3 = Pattern.
                                compile(regex,
                                        Pattern.CASE_INSENSITIVE);
                        Matcher matcher3 = patten3.matcher(spannableString);
                        while (matcher3.find()) {
                            String number = matcher3.group();
                            int end = matcher3.start() + number.length();
                            NumClickSpan clickSpan = new NumClickSpan(number);
                            spannableString.setSpan(clickSpan, matcher3.start(), end, Spanned.SPAN_INCLUSIVE_EXCLUSIVE);
                            ForegroundColorSpan colorSpan = new ForegroundColorSpan(context.getResources().getColor(R.color.lite_blue));
                            spannableString.setSpan(colorSpan, matcher3.start(), end, Spanned.SPAN_INCLUSIVE_EXCLUSIVE);
                        }

                        textView.setText(spannableString);
                        textView.setMovementMethod(LinkMovementMethod.getInstance());

                        holder.getDescLinearLayout().addView(textView);
                        textView.setOnLongClickListener(new View.OnLongClickListener() {
                            @Override
                            public boolean onLongClick(View view) {
                                showPopWindows(view, message.message);
                                return true;
                            }
                        });
                    }

                }

            }
        }
    }

    private void setNoImgView(TextView tv, String message, List<AString> list) {
        boolean matcher_s=false;//是否有匹配 没有走的最后 文本匹配电话号

        String msg = message.replaceAll("\\n", "\n");
////



        for (int i = 0; i < list.size(); i++) {
            AString aString = list.get(i);
            msg = msg.replaceAll(aString.a, aString.content);
        }

        msg = msg.replaceAll("<p>", "");

        msg = msg.replaceAll("</p>", "\n");

        msg = msg.replaceAll("<p .*?>", "\r\n");
        // <br><br/>替换为换行
        msg = msg.replaceAll("<br\\s*/?>", "\r\n");
        // 去掉其它的<>之间的东西
        msg = msg.replaceAll("\\<.*?>", "");


        SpannableString spannableString = new SpannableString(msg);
        Pattern patten = Pattern.compile("\\d+[：].*+\\n", Pattern.CASE_INSENSITIVE);
        Matcher matcher = patten.matcher(spannableString);
        while (matcher.find()) {
            matcher_s=true;
            String number = matcher.group();
            int end = matcher.start() + number.length();
            RobotClickSpan clickSpan = new RobotClickSpan(number, ((ChatActivity) context));
            spannableString.setSpan(clickSpan, matcher.start(), end, Spanned.SPAN_INCLUSIVE_EXCLUSIVE);
            ForegroundColorSpan colorSpan = new ForegroundColorSpan(context.getResources().getColor(R.color.lite_blue));
            spannableString.setSpan(colorSpan, matcher.start(), end, Spanned.SPAN_INCLUSIVE_EXCLUSIVE);
        }
        //            Pattern patten2 = Pattern.compile("(https?|ftp|file)://[-A-Za-z0-9+&@#/%?=~_|!:,.;]+[-A-Za-z0-9+&@#/%=~_|]", Pattern.CASE_INSENSITIVE);
        Pattern patten2 = Pattern.compile("((http[s]{0,1}|ftp)://[a-zA-Z0-9\\.\\-]+\\.([a-zA-Z]{2,4})(:\\d+)?(/[a-zA-Z0-9\\.\\-~!@#$%^&*+?:_/=<>]*)?)|(www.[a-zA-Z0-9\\.\\-]+\\.([a-zA-Z]{2,4})(:\\d+)?(/[a-zA-Z0-9\\.\\-~!@#$%^&*+?:_/=<>]*)?)|(((http[s]{0,1}|ftp)://|)((?:(?:25[0-5]|2[0-4]\\d|((1\\d{2})|([1-9]?\\d)))\\.){3}(?:25[0-5]|2[0-4]\\d|((1\\d{2})|([1-9]?\\d))))(:\\d+)?(/[a-zA-Z0-9\\.\\-~!@#$%^&*+?:_/=<>]*)?)", Pattern.CASE_INSENSITIVE);
        Matcher matcher2 = patten2.matcher(spannableString);
        while (matcher2.find()) {
            matcher_s=true;
            String number = matcher2.group();
            int end = matcher2.start() + number.length();
            HttpClickSpan clickSpan = new HttpClickSpan(number);
            spannableString.setSpan(clickSpan, matcher2.start(), end, Spanned.SPAN_INCLUSIVE_EXCLUSIVE);
            ForegroundColorSpan colorSpan = new ForegroundColorSpan(context.getResources().getColor(R.color.lite_blue));
            spannableString.setSpan(colorSpan, matcher2.start(), end, Spanned.SPAN_INCLUSIVE_EXCLUSIVE);
        }
        for (int i = 0; i < list.size(); i++) {
            AString aString = list.get(i);
            Pattern patten3 = Pattern.compile(aString.content, Pattern.CASE_INSENSITIVE);
            Matcher matcher3 = patten3.matcher(spannableString);
            while (matcher3.find()) {
                matcher_s=true;
                String number = matcher3.group();
                int end = matcher3.start() + number.length();
                HttpClickSpan clickSpan = new HttpClickSpan(aString.url);
                spannableString.setSpan(clickSpan, matcher3.start(), end, Spanned.SPAN_INCLUSIVE_EXCLUSIVE);
                ForegroundColorSpan colorSpan = new ForegroundColorSpan(context.getResources().getColor(R.color.lite_blue));
                spannableString.setSpan(colorSpan, matcher3.start(), end, Spanned.SPAN_INCLUSIVE_EXCLUSIVE);
            }
        }


        String regex=RegexUtils.isPhoneRegexp();
        Pattern patten3 = Pattern.
                compile(regex,
                Pattern.CASE_INSENSITIVE);
        Matcher matcher3 = patten3.matcher(spannableString);
        while (matcher3.find()) {
            matcher_s=true;
            String number = matcher3.group();
            int end = matcher3.start() + number.length();
            NumClickSpan clickSpan = new NumClickSpan(number);
            spannableString.setSpan(clickSpan, matcher3.start(), end, Spanned.SPAN_INCLUSIVE_EXCLUSIVE);
            ForegroundColorSpan colorSpan = new ForegroundColorSpan(context.getResources().getColor(R.color.lite_blue));
            spannableString.setSpan(colorSpan, matcher3.start(), end, Spanned.SPAN_INCLUSIVE_EXCLUSIVE);
        }


        tv.setText(spannableString);
        tv.setMovementMethod(LinkMovementMethod.getInstance());




    }

    @Override
    public View buildChatView(LayoutInflater inflater, View convertView) {
        if (convertView == null) {
            convertView = inflater.inflate(R.layout.kf_chat_row_text_rx, null);
            TextViewHolder holder = new TextViewHolder(mRowType);
            convertView.setTag(holder.initBaseHolder(convertView, true));
        }
        return convertView;
    }

    @Override
    public int getChatViewType() {
        return ChatRowType.TEXT_ROW_RECEIVED.ordinal();
    }

    private SpannableStringBuilder handler(final TextView gifTextView,
                                           String content) {
        SpannableStringBuilder sb = new SpannableStringBuilder(content);
        String regex = "(\\#\\[face/png/f_static_)\\d{3}(.png\\]\\#)";
        Pattern p = Pattern.compile(regex);
        Matcher m = p.matcher(content);
        while (m.find()) {
            String tempText = m.group();
            try {
                String num = tempText.substring(
                        "#[face/png/f_static_".length(), tempText.length()
                                - ".png]#".length());
                String gif = "face/gif/f" + num + ".gif";
                /**
                 * 如果open这里不抛异常说明存在gif，则显示对应的gif 否则说明gif找不到，则显示png
                 * */
                InputStream is = context.getAssets().open(gif);
                sb.setSpan(new AnimatedImageSpan(new AnimatedGifDrawable(is,
                                new AnimatedGifDrawable.UpdateListener() {
                                    @Override
                                    public void update() {
                                        gifTextView.postInvalidate();
                                    }
                                })), m.start(), m.end(),
                        Spannable.SPAN_EXCLUSIVE_EXCLUSIVE);
                is.close();
            } catch (Exception e) {
                String png = tempText.substring("#[".length(),
                        tempText.length() - "]#".length());
                try {
                    sb.setSpan(
                            new ImageSpan(context,
                                    BitmapFactory.decodeStream(context
                                            .getAssets().open(png))),
                            m.start(), m.end(),
                            Spannable.SPAN_EXCLUSIVE_EXCLUSIVE);
                } catch (IOException e1) {
                    // TODO Auto-generated catch block
                    e1.printStackTrace();
                }
                e.printStackTrace();
            }
        }
        return sb;
    }

    class RobotClickSpan extends ClickableSpan {
        String msg;
        ChatActivity chatActivity;

        public RobotClickSpan(String msg, ChatActivity chatActivity) {
            this.msg = msg;
            this.chatActivity = chatActivity;
        }

        @Override
        public void onClick(View view) {
            String msgStr = "";
            try {
                msgStr = msg.split("：",2)[1].trim();

            } catch (Exception e) {
            }
            chatActivity.sendTextMsg(msgStr);

        }
    }

    class XbotClickSpan extends ClickableSpan {
        String msg;
        ChatActivity chatActivity;

        public XbotClickSpan(String msg, ChatActivity chatActivity) {
            this.msg = msg;
            this.chatActivity = chatActivity;
        }

        @Override
        public void onClick(View view) {
            chatActivity.sendTextMsg(msg);

        }
    }

    class NumClickSpan extends ClickableSpan {
        String msg;

        public NumClickSpan(String msg) {
            this.msg = msg;
        }

        @Override
        public void onClick(View widget) {
            NumClickWindow numClickWindow=new NumClickWindow(context,RegexUtils.regexNumber(msg));
            numClickWindow.show();
        }
    }

    //A标签点击事件
    class AClickApan extends ClickableSpan {
        String msg;

        public AClickApan(String msg) {
            this.msg = msg;
        }

        @Override
        public void onClick(View widget) {
            String action_str=msg+"";
            if (!TextUtils.isEmpty(action_str)){
                if(action_str.startsWith("https://www.m7_action.robotTransferAgent.m7_data:")){
                    //第一种情况 转人工
                    //https://www.m7_action.robotTransferAgent.m7_data:"+技能组id+".com
                    //以 https://www.m7_action.robotTransferAgent.m7_data: 为开头 取技能组id 转人工。
                    action_str=action_str.replace("https://www.m7_action.robotTransferAgent.m7_data:","");
                    action_str=action_str.replace(".com","");
                    TransferAgent transferAgent=new TransferAgent();
                    transferAgent.peerid=action_str;
                    EventBus.getDefault().post(transferAgent);
                }if(action_str.startsWith("https://www.m7_action.data-phone-href.m7-data-tel:")){
                    //第一种情况 电话号
                    //https://www.m7_action.data-phone-href.m7-data-tel:电话号.com
                    //以 https://www.m7_action.data-phone-href.m7-data-tel: 为开头 电话号 弹窗。
                    action_str=action_str.replace("https://www.m7_action.data-phone-href.m7-data-tel:","");
                    action_str=action_str.replace(".com","");
                    NumClickWindow numClickWindow=new NumClickWindow(context,RegexUtils.regexNumber(action_str));
                    numClickWindow.show();
                }


            }



        }
    }
    class HttpClickSpan extends ClickableSpan {
        String msg;

        public HttpClickSpan(String msg) {
            this.msg = msg;
        }

        @Override
        public void onClick(View widget) {
            try {
                if (!msg.contains("http") && !msg.contains("https")) {
                    msg = "http://" + msg;
                } else {
                    if(msg.startsWith("http://tel:")){
                        String tel=msg.replaceAll("http://tel:","");
                        NumClickWindow numClickWindow=new NumClickWindow(context,RegexUtils.regexNumber(tel));
                        numClickWindow.show();
                        return;
                    }
                    Intent intent = new Intent();
                    intent.setAction("android.intent.action.VIEW");
                    Uri content_url = Uri.parse(msg);
                    intent.setData(content_url);
                    context.startActivity(intent);
                }
            } catch (Exception e) {
                Toast.makeText(context, R.string.url_failure, Toast.LENGTH_SHORT).show();
            }
        }
    }

    public static List<String> getImgStr(String htmlStr) {
        List<String> pics = new ArrayList<String>();
        String regEx_img = "(<img.*src\\s*=\\s*(.*?)[^>]*?>|<p><video.*src\\s*=\\s*(.*?)[^>]*?</video></p>)";
//        String regEx_img = "<img.*src\\s*=\\s*(.*?)[^>]*?>";
        Pattern p_image = Pattern.compile
                (regEx_img, Pattern.CASE_INSENSITIVE);
        Matcher m_image = p_image.matcher(htmlStr);
        while (m_image.find()) {
            // 得到<img />或<video数据
            String img = m_image.group();
//            Matcher m = Pattern.compile("(src|SRC)=(\"|\')(.*?)(\"|\')").matcher(img);
            Matcher m = Pattern.compile("(<img.*?src|<img.*?SRC|<video.*?src)=(\"|\')(.*?)(\"|\')").matcher(img);
            while (m.find()) {
                String g=m.group();
                if(g.startsWith("<video")){
                    //如果是
                    pics.add("<video"+m.group(3));
                }else {
                    pics.add(m.group(3));
                }

            }
        }
        return pics;
    }

    class AString {
        public String a;
        public String content;
        public String url;
        public String action;
        public String peerid;
    }

    private List<AString> setAString(String message) {

        SpannableString spannableString = new SpannableString(message);

        List<AString> list = new ArrayList<>();

        Pattern patten = Pattern.compile("<a[^>]*>([^<]*)</a>", Pattern.CASE_INSENSITIVE);
        Matcher matcher = patten.matcher(spannableString);
        while (matcher.find()) {
            AString atring = new AString();
            //a标签
            atring.a = matcher.group();
            //文字
            atring.content = matcher.group(1);
            Matcher m = Pattern.compile("(href|HREF)=(\"|\')(.*?)(\"|\')").matcher(matcher.group());
            //链接
            while (m.find()) {
                atring.url = m.group(3);
            }
            list.add(atring);

            //            int end = matcher.start() + url.length();
            //            HttpClickSpan clickSpan = new HttpClickSpan(url);
            //            spannableString.setSpan(clickSpan, matcher.start(), end, Spanned.SPAN_INCLUSIVE_EXCLUSIVE);
            //            ForegroundColorSpan colorSpan = new ForegroundColorSpan(context.getResources().getColor(R.color.lite_blue));
            //            spannableString.setSpan(colorSpan, matcher.start(), end, Spanned.SPAN_INCLUSIVE_EXCLUSIVE);

        }
        //        tv.setText(spannableString);
        //        tv.setMovementMethod(LinkMovementMethod.getInstance());
        return list;
    }

    /**
     * 展示图片
     */
    private void showImage(final String imageurl, TextViewHolder holder) {
//        ViewGroup.LayoutParams params = new ViewGroup.LayoutParams(DensityUtil.dip2px(200),
//                DensityUtil.dip2px(200));

        if(imageurl.startsWith("<video")){
            addVideo(imageurl,holder);
        }else{
            LinearLayout.LayoutParams params = new LinearLayout.LayoutParams(DensityUtil.dip2px(200),
                    ViewGroup.LayoutParams.WRAP_CONTENT);
            final ImageView iv = new ImageView(context);
            iv.setAdjustViewBounds(true);
            iv.setMaxWidth(DensityUtil.dip2px(200));
            iv.setMaxHeight(DensityUtil.dip2px(200));
            iv.setScaleType(ImageView.ScaleType.FIT_CENTER);
            params.setMargins(0, DensityUtil.dip2px(4), 0, DensityUtil.dip2px(4));

            iv.setLayoutParams(params);
            Glide.with(context).load(imageurl)
//                .fitCenter()
                    .placeholder(R.drawable.kf_pic_thumb_bg)
                    .error(R.drawable.kf_image_download_fail_icon)
//                .override(Target.SIZE_ORIGINAL, Target.SIZE_ORIGINAL)
                    .listener(new RequestListener<Drawable>() {
                        @Override
                        public boolean onLoadFailed(@Nullable GlideException e, Object model, Target<Drawable> target, boolean isFirstResource) {
                            iv.setVisibility(View.GONE);
                            return false;
                        }

                        @Override
                        public boolean onResourceReady(Drawable resource, Object model, Target<Drawable> target, DataSource dataSource, boolean isFirstResource) {
                            return false;
                        }
                    })
                    .into(iv);

            iv.setOnClickListener(new View.OnClickListener() {
                @Override
                public void onClick(View v) {
                    Intent intent = new Intent(context, ImageViewLookActivity.class);
                    intent.putExtra("imagePath", imageurl);
                    context.startActivity(intent);
                }
            });
            holder.getDescLinearLayout().addView(iv);
        }

    }

    private void showPopWindows(View view, final String srcTxt) {
        List<String> dataList = new ArrayList<>();
        dataList.add(context.getString(R.string.ykf_copy));
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
                copyTxt(srcTxt);
                ToastUtils.showShort(context,context.getString(R.string.ykf_copy_success));
                mPopupWindowList.hide();
            }
        });
    }

    /**
     * 复制文本
     */
    public static void copyTxt(String srcTxt) {
        ClipboardManager clipboardManager = (ClipboardManager) MoorUtils.getApp().getSystemService(Context.CLIPBOARD_SERVICE);
        ClipData clipData = ClipData.newPlainText("text", srcTxt);
        clipboardManager.setPrimaryClip(clipData);
    }


    private void parserImg(FromToMessage message,TextViewHolder holder){
        //获取内容的图片src
        final List<String> data = getImgStr(message.message);
        String content = message.message.replaceAll("<(img|IMG|video|VIDEO)(.*?)(/>|></img>|></video>|>)", "---");
        String[] strings = content.split("---");
        if (strings.length == 0) {
            if (data.size() > 0) {
                showImage(data.get(0), holder);
            }
        }
    }

    private void initflowImgandText(final FromToMessage message, TextViewHolder holder){
        if(message.showHtml){
            List<String> data = getImgStr(message.flowTip);
            String content = message.flowTip.replaceAll("<(img|IMG|video|VIDEO)(.*?)(/>|></img>|></video>|>)", "---");
            String[] strings = content.split("---");
            for (int i = 0; i < strings.length; i++) {
                TextView tv1 = new TextView(context);
                tv1.setTextColor(context.getResources().getColor(R.color.textcolor));
                tv1.setLineSpacing(0f, 1.1f);
                if (message.flowTip.contains("</a>") && (!message.flowTip.contains("1："))) {

                    String actionmsg=setA_String(strings[i]);

                    Spanned string=Html.fromHtml(actionmsg);

                    Spanned string_o=new SpannableStringBuilder(MoorUtils.trimTrailingWhitespace(string.toString()));

                    SpannableStringBuilder spannableString = new SpannableStringBuilder(string_o);
                    boolean ismatcher=false;
                    //匹配a标签 自定义 点击️
                    Pattern patten1 = Pattern.compile("\\[(?<text>[^\\]]*)\\]\\((?<link>[^\\)]*)\\)", Pattern.CASE_INSENSITIVE);
                    Matcher matcher1 = patten1.matcher(spannableString);
                    while (matcher1.find()) {
                        ismatcher=true;
                        String m7_data = matcher1.group(1);
                        String m7_name = matcher1.group(2);
                        spannableString.replace(matcher1.start(), matcher1.end(), m7_data);
                        AClickApan clickSpan=new AClickApan(m7_name);
                        spannableString.setSpan(clickSpan, matcher1.start(), matcher1.start() + m7_data.length(), Spanned.SPAN_INCLUSIVE_EXCLUSIVE);
                        ForegroundColorSpan colorSpan = new ForegroundColorSpan(context.getResources().getColor(R.color.lite_blue));
                        spannableString.setSpan(colorSpan, matcher1.start(), matcher1.start() + m7_data.length(), Spanned.SPAN_INCLUSIVE_EXCLUSIVE);
                        matcher1 = patten1.matcher(spannableString);
                    }

                    if(!ismatcher){//手机号
                        String regex=RegexUtils.isPhoneRegexp();
                        Pattern patten3 = Pattern.
                                compile(regex,
                                        Pattern.CASE_INSENSITIVE);
                        Matcher matcher3 = patten3.matcher(spannableString);
                        while (matcher3.find()) {
                            String number = matcher3.group();
                            int end = matcher3.start() + number.length();
                            NumClickSpan clickSpan = new NumClickSpan(number);
                            spannableString.setSpan(clickSpan, matcher3.start(), end, Spanned.SPAN_INCLUSIVE_EXCLUSIVE);
                            ForegroundColorSpan colorSpan = new ForegroundColorSpan(context.getResources().getColor(R.color.lite_blue));
                            spannableString.setSpan(colorSpan, matcher3.start(), end, Spanned.SPAN_INCLUSIVE_EXCLUSIVE);
                        }
                    }

                    tv1.setText(spannableString);
                    tv1.setMovementMethod(LinkMovementMethod.getInstance());
                } else {
                    List<AString> list = setAString(strings[i]);
                    setNoImgView(tv1, strings[i], list);
                }
                holder.getDescLinearLayout().addView(tv1);

                if (data.size() > i) {
                    showImage(data.get(i), holder);
                }

            }
        }
    }

    private void initImgandText(final FromToMessage message, TextViewHolder holder){
        if(message.showHtml){
//            List<String> video_data=getVideoStr(message.message);
//            String no_video_content = message.message.replaceAll("<p><(video|VIDEO)(.*?)(/>|></video></p>|>)", "---");
            List<String> data = getImgStr(message.message);
            String content = message.message.replaceAll("<(img|IMG|video|VIDEO)(.*?)(/>|></img>|></video>|>)", "---");
            String[] strings = content.split("---");
            for (int i = 0; i < strings.length; i++) {
                TextView tv1 = new TextView(context);
                tv1.setTextColor(context.getResources().getColor(R.color.textcolor));
                tv1.setLineSpacing(0f, 1.1f);
                if (message.message.contains("</a>") && (!message.message.contains("1："))) {

                    String actionmsg=setA_String(strings[i]);

                    Spanned string=Html.fromHtml(actionmsg);

                    Spanned string_o=new SpannableStringBuilder(MoorUtils.trimTrailingWhitespace(string.toString()));

                    SpannableStringBuilder spannableString = new SpannableStringBuilder(string_o);
                    boolean ismatcher=false;
                    //匹配a标签 自定义 点击️
                    Pattern patten1 = Pattern.compile("\\[(?<text>[^\\]]*)\\]\\((?<link>[^\\)]*)\\)", Pattern.CASE_INSENSITIVE);
                    Matcher matcher1 = patten1.matcher(spannableString);
                    while (matcher1.find()) {
                        ismatcher=true;
                        String m7_data = matcher1.group(1);
                        String m7_name = matcher1.group(2);
                        spannableString.replace(matcher1.start(), matcher1.end(), m7_data);
                        AClickApan clickSpan=new AClickApan(m7_name);
                        spannableString.setSpan(clickSpan, matcher1.start(), matcher1.start() + m7_data.length(), Spanned.SPAN_INCLUSIVE_EXCLUSIVE);
                        ForegroundColorSpan colorSpan = new ForegroundColorSpan(context.getResources().getColor(R.color.lite_blue));
                        spannableString.setSpan(colorSpan, matcher1.start(), matcher1.start() + m7_data.length(), Spanned.SPAN_INCLUSIVE_EXCLUSIVE);
                        matcher1 = patten1.matcher(spannableString);
                    }

                    if(!ismatcher){
                        //匹配电话
                        String regex=RegexUtils.isPhoneRegexp();
                        Pattern patten3 = Pattern.
                                compile(regex,
                                        Pattern.CASE_INSENSITIVE);
                        Matcher matcher3 = patten3.matcher(spannableString);
                        while (matcher3.find()) {
                            String number = matcher3.group();
                            int end = matcher3.start() + number.length();
                            NumClickSpan clickSpan = new NumClickSpan(number);
                            spannableString.setSpan(clickSpan, matcher3.start(), end, Spanned.SPAN_INCLUSIVE_EXCLUSIVE);
                            ForegroundColorSpan colorSpan = new ForegroundColorSpan(context.getResources().getColor(R.color.lite_blue));
                            spannableString.setSpan(colorSpan, matcher3.start(), end, Spanned.SPAN_INCLUSIVE_EXCLUSIVE);
                        }
                    }
                    tv1.setText(spannableString);
                    tv1.setMovementMethod(LinkMovementMethod.getInstance());
                } else {
                    List<AString> list = setAString(strings[i]);
                    setNoImgView(tv1, strings[i], list);
                }


                holder.getDescLinearLayout().addView(tv1);

                if (data.size() > i) {
                    showImage(data.get(i), holder);
                }
                if (data.size() == 0) {//无图片的情况可以复制
                    holder.getDescLinearLayout().setOnLongClickListener(new View.OnLongClickListener() {
                        @Override
                        public boolean onLongClick(View view) {
                            showPopWindows(view, message.message);
                            return true;
                        }
                    });
                }

            }
        }
    }




    //解析A标签，替换我们要的字符串类型
    private   String  setA_String(String message) {
        SpannableString spannableString = new SpannableString(message);
        Pattern patten = Pattern.compile("<a[^>]*>([^<]*)</a>", Pattern.CASE_INSENSITIVE);
        Matcher matcher = patten.matcher(spannableString);
        while (matcher.find()) {
            AString atring = new AString();
            //a标签
            atring.a = matcher.group();
            //文字
            atring.content = matcher.group(1);

            Document doc = Jsoup.parse(message);
            Elements chatElements=doc.getElementsByTag("a");

            if(chatElements!=null){
                if(chatElements.size()>0){
                    if(chatElements.get(0)!=null){
                       Element chatElement = chatElements.get(0);
                        //m7_action为 transferAgent 响应转人工
                        atring.action=chatElement.attr("m7_action");
                        if(!TextUtils.isEmpty(atring.action)){
                                if("robotTransferAgent".equals(atring.action)|"transferAgent".equals(atring.action)){
                                    atring.peerid=chatElement.attr("m7_data");//m7_action为 transferAgent 响应转人工，m7_data 取出技能组id
                                    message= message.replace(atring.a,
                                            "["+atring.content+"](https://www.m7_action.robotTransferAgent.m7_data:"+atring.peerid+".com)");
                                }
                        }

                        //data-phone href 并且值为tel: 开头 有值为电话号
                        if(TextUtils.isEmpty(atring.action)){
                            atring.action=chatElement.attr("href");
                            if(!TextUtils.isEmpty(atring.action)){
                                if(atring.action.startsWith("tel:")){
                                    message= message.replace(atring.a,
                                            "["+atring.content+"](https://www.m7_action.data-phone-href.m7-data-tel:"+atring.content+".com)");
                                }
                            }
                        }
                    }else{

                    }
                }
            }
        }
        return message;
    }



    private void addVideo(final String videourl, TextViewHolder holder){
        View view=View.inflate(context,R.layout.ykf_textrx_video,null);
        ImageView thumb_one=view.findViewById(R.id.iv_textrx_video);



        final String video_url=videourl.replace("<video","");

        Glide.with(context).load(video_url)
//                .placeholder(R.drawable.kf_pic_thumb_bg)
                .error(R.drawable.kf_image_download_fail_icon)
                .frame(0)//获取视频第一帧
                .into(thumb_one);


        thumb_one.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                Intent intent=new Intent();
                intent.setClass(context, YKFVideoActivity.class);
                intent.putExtra(Constants.YKFVIDEOPATHURI,video_url);
                context.startActivity(intent);
            }
        });

        holder.getDescLinearLayout().addView(view);
    }
}