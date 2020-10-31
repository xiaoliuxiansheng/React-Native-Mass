package com.m7.imkfsdk.chat;

import android.Manifest;
import android.annotation.SuppressLint;
import android.app.Activity;
import android.app.ActivityManager;
import android.app.AlertDialog;
import android.content.BroadcastReceiver;
import android.content.Context;
import android.content.DialogInterface;
import android.content.Intent;
import android.content.IntentFilter;
import android.content.SharedPreferences;
import android.content.pm.PackageManager;
import android.content.pm.ResolveInfo;
import android.graphics.Color;
import android.graphics.drawable.ColorDrawable;
import android.net.Uri;
import android.os.Build;
import android.os.Bundle;
import android.os.CountDownTimer;
import android.os.Handler;
import android.os.Message;
import android.provider.MediaStore;
import android.provider.Settings;
import androidx.annotation.NonNull;
import androidx.core.app.ActivityCompat;
import androidx.core.content.ContextCompat;
import androidx.viewpager.widget.ViewPager;
import androidx.viewpager.widget.ViewPager.OnPageChangeListener;
import androidx.recyclerview.widget.LinearLayoutManager;
import androidx.recyclerview.widget.RecyclerView;
import android.text.Editable;
import android.text.SpannableString;
import android.text.Spanned;
import android.text.TextUtils;
import android.text.TextWatcher;
import android.text.style.ForegroundColorSpan;
import android.util.Log;
import android.view.Gravity;
import android.view.MotionEvent;
import android.view.View;
import android.view.View.OnClickListener;
import android.view.View.OnFocusChangeListener;
import android.view.View.OnTouchListener;
import android.view.ViewGroup;
import android.view.Window;
import android.view.WindowManager;
import android.view.inputmethod.InputMethodManager;
import android.widget.AdapterView;
import android.widget.AdapterView.OnItemClickListener;
import android.widget.Button;
import android.widget.EditText;
import android.widget.GridView;
import android.widget.ImageView;
import android.widget.LinearLayout;
import android.widget.RelativeLayout;
import android.widget.RelativeLayout.LayoutParams;
import android.widget.TextView;
import android.widget.Toast;

import com.m7.imkfsdk.MoorWebCenter;
import com.m7.imkfsdk.R;
import com.m7.imkfsdk.chat.adapter.ChatAdapter;
import com.m7.imkfsdk.chat.adapter.ChatTagLabelsAdapter;
import com.m7.imkfsdk.chat.model.MsgTaskBean;
import com.m7.imkfsdk.chat.model.MsgTaskItemBean;
import com.m7.imkfsdk.chat.model.OrderBaseBean;
import com.m7.imkfsdk.chat.model.OrderInfoBean;
import com.m7.imkfsdk.chat.model.OrderInfoParams;
import com.m7.imkfsdk.constant.Constants;
import com.m7.imkfsdk.recordbutton.AudioManager;
import com.m7.imkfsdk.recordbutton.AudioRecorderButton;
import com.m7.imkfsdk.utils.AntiShake;
import com.m7.imkfsdk.utils.FaceConversionUtil;
import com.m7.imkfsdk.utils.FileUtils;
import com.m7.imkfsdk.utils.PickUtils;
import com.m7.imkfsdk.utils.ToastUtils;

import com.m7.imkfsdk.view.ActionSheetDialog;
import com.m7.imkfsdk.view.BottomSheetLogisticsInfoDialog;
import com.m7.imkfsdk.view.BottomSheetLogisticsProgressDialog;
import com.m7.imkfsdk.view.ChatListView;
import com.m7.imkfsdk.view.TcpExitDiaglog;
import com.moor.imkf.listener.AcceptOtherAgentListener;
import com.moor.imkf.listener.ChatListener;
import com.moor.imkf.listener.GetGlobleConfigListen;
import com.moor.imkf.listener.GetPeersListener;
import com.moor.imkf.IMChat;
import com.moor.imkf.IMChatManager;
import com.moor.imkf.IMMessage;
import com.moor.imkf.listener.OnConvertManualListener;
import com.moor.imkf.db.dao.GlobalSetDao;
import com.moor.imkf.db.dao.InfoDao;
import com.moor.imkf.db.dao.MessageDao;
import com.moor.imkf.eventbus.EventBus;
import com.moor.imkf.gson.Gson;
import com.moor.imkf.gson.reflect.TypeToken;
import com.moor.imkf.http.HttpManager;
import com.moor.imkf.http.HttpResponseListener;
import com.moor.imkf.listener.PushVideoListener;
import com.moor.imkf.listener.onResponseListener;
import com.moor.imkf.model.construct.JsonBuild;
import com.moor.imkf.model.entity.CardInfo;
import com.moor.imkf.model.entity.ChatEmoji;
import com.moor.imkf.model.entity.ChatMore;
import com.moor.imkf.model.entity.FlowBean;
import com.moor.imkf.model.entity.FromToMessage;
import com.moor.imkf.model.entity.GlobalSet;
import com.moor.imkf.model.entity.NewCardInfo;
import com.moor.imkf.model.entity.Peer;
import com.moor.imkf.model.entity.ScheduleConfig;
import com.moor.imkf.model.parser.HttpParser;
import com.moor.imkf.tcpservice.event.LoginOffEvent;
import com.moor.imkf.tcpservice.event.MsgEvent;
import com.moor.imkf.tcpservice.event.MsgunReadToReadEvent;
import com.moor.imkf.tcpservice.event.QuestionEvent;
import com.moor.imkf.tcpservice.event.QuitVideoEvent;
import com.moor.imkf.tcpservice.event.ReSendMessage;
import com.moor.imkf.tcpservice.event.TcpBreakEvent;
import com.moor.imkf.tcpservice.event.TransferAgent;
import com.moor.imkf.tcpservice.event.UnAssignEvent;
import com.moor.imkf.tcpservice.event.VoiceToTextEvent;
import com.moor.imkf.tcpservice.service.TcpManager;
import com.moor.imkf.utils.LogUtils;
import com.moor.imkf.utils.MoorUtils;
import com.moor.imkf.utils.NullUtil;
import com.m7.imkfsdk.chat.listener.ChatListClickListener;
import com.moor.imkf.websocket.WebSocketHandler;

import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

import java.io.File;
import java.io.IOException;
import java.io.UnsupportedEncodingException;
import java.lang.ref.WeakReference;
import java.lang.reflect.Type;
import java.net.URLEncoder;
import java.util.ArrayList;
import java.util.HashSet;
import java.util.Iterator;
import java.util.List;
import java.util.Set;
import java.util.Timer;
import java.util.TimerTask;
import java.util.UUID;

/**
 * 聊天界面
 *
 * @author LongWei
 */
public class ChatActivity extends MyBaseActivity implements OnClickListener,
        OnItemClickListener, ChatListView.OnRefreshListener, AudioRecorderButton.RecorderFinishListener {
    private boolean isFront=false;//记录当前应用是否在前台
    private ChatListView mChatList;
    private Button mChatSend, mChatMore, mChatSetModeVoice,
            mChatSetModeKeyboard;
    TextView chat_tv_back, chat_tv_convert;
    private EditText mChatInput;
    private ChatAdapter chatAdapter;
    private RelativeLayout mChatEdittextLayout,
            mChatMoreContainer;
    private LinearLayout mMore;
    private AudioRecorderButton mRecorderButton;
    //	private SpeechRecorderButton mRecorderButton;
    private RelativeLayout mChatFaceContainer,rl_emoji_layout;
    private ImageView mChatEmojiNormal, mChatEmojiChecked;
    private InputMethodManager manager;
    private TextView mOtherName;
    private OnCorpusSelectedListener mListener;
    private ViewPager mChatEmojiVPager, mChatMoreVPager;
    private ArrayList<View> facePageViews;
    private ArrayList<View> morePageViews;
    private LinearLayout mChatIvImageMore, mChatIvImageFace;
    private ArrayList<ImageView> pointViewsFace, pointViewsMore;
    private List<List<ChatEmoji>> emojis;
    private List<FaceAdapter> faceAdapters;
    private List<MoreAdapter> moreAdapters;
    private int current = 0;
    private ArrayList<ChatMore> moreList;
    private TcpExitDiaglog singleButtonDialog;
    private TcpExitDiaglog.Builder builder;
    // 表情分页的结果集合
    public List<List<ChatMore>> moreLists = new ArrayList<List<ChatMore>>();
    private List<FromToMessage> fromToMessage;
    private Boolean JZflag = true;
    private boolean isZXResply = false;//坐席是否回复过访客，默认没有回复过（tcp推送变为true，接口校验也变为true ）
    private View header;
    private int pageSize = 2;
    private int height;
    private List<FromToMessage> descFromToMessage = new ArrayList<FromToMessage>();
    private static final String tag = "ChatActivity";
    private static final int PICK_IMAGE_ACTIVITY_REQUEST_CODE = 200;
    private static final int PICK_FILE_ACTIVITY_REQUEST_CODE = 300;
    private String picFileFullName;
    MsgReceiver msgReceiver;
    KeFuStatusReceiver keFuStatusReceiver;
    private String peerId = "";
    LinearLayout chat_queue_ll;
    TextView chat_queue_tv;
    LinearLayout bar_bottom;
    private LoadingFragmentDialog loadingDialog;
    private static final int HANDLER_MSG = 1;
    private static final int HANDLER_MSG_MORE = 2;
    private static final int HANDLER_ROBOT = 0x111;
    private static final int HANDLER_ONLINE = 0x222;
    private static final int HANDLER_OFFNLINE = 0x333;
    private static final int HANDLER_INVESTIGATE = 0x444;
    private static final int HANDLER_QUEUENUM = 0x555;
    private static final int HANDLER_CLIAM = 0x666;
    private static final int HANDLER_FINISH = 0x777;
    private static final int HANDLER_BREAK = 0x888;
    private static final int HANDLER_BREAK_TIP = 0x999;
    private static final int HANDLER_VIPASSIGNFAIL = 0x1000;
    private static final int HANDLER_LEAVEMSG = 0x1100;
    private static final int HANDLER_WRITING = 0x1200;
    private static final int HANDLER_NO_WRITING = 0x1300;
    private String left_text;//注销按钮文案
    private boolean show_emoji=true;//是否显示emoji按钮
    private boolean isRobot = false;
    private String type = "";
    private String scheduleId = "";
    private String processId = "";
    private String currentNodeId = "";
    private String schedule_id = "";
    private String schedule_topeer = "";
    private String processType = "";
    private String titleName = "";
    private String entranceId = "";

    //    访客不能主动发评价//false 展示 true隐藏
    private boolean NotAllowCustomerPushCsr=false;
    //   点击注销  窗口弹出满意度评价//false弹   true不弹出
    private boolean NotAllowCustomerCloseCsr=false;
    //小陌机器人评价是否完成
    private Boolean robotEvaluationFinish = false;

    //是否和机器人发送过消息
    private boolean hasSendRobotMsg = false;
    //是否和人工坐席发过消息
    private boolean hasSendPersonMsg = false;

    ChatMore chatMore2, chatMore3, chatMore4, chatMore5;

    private int permisssionType;
    private boolean isQueue = false;

    private InvestigateDialog dialog;
    private String id;
    private boolean isInvestigate = true;//是否已经评价过了 true代表没有评价过，false代表评价过了
    private boolean convesationIsLive = true;// 会话是有存在或者有效。 true代表存在，false代表不存在
    private boolean hasSet = true;//是否配置了满意度列表
    private boolean conversationOver = false;//pc是否已经关闭会话 true关闭了
    private boolean INVITATION_INVESTIGATE = false;//坐席邀请评价;true：邀请了

    private LinearLayout ll_hintView;
    private RecyclerView rvTagLabel;
    private ChatTagLabelsAdapter tagLabeAdapter;
    private List<FlowBean> flowBeanList = new ArrayList<>();
    private ChatHandler handler;
    private AntiShake shake = new AntiShake();
    private SharedPreferences spData;

    Timer break_timer;
    Timer break_tip_timer;
    long breakTime = 0;
    long breakTipTime = 0;
    String break_tips;
    BreakTimerTask breakTimerTask;
    BreakTipTimerTask breakTipTimerTask;
    private BottomSheetLogisticsInfoDialog moreOrderInfoDialog;
    private Set<String> mHashSet = new HashSet<String>();//用来存储订单消息的_id，在onDestroy()中将 showOrderInfo 字段全部置为“2”

    private CountDownTimer mCountDownTimer;


    /**
     * Handler改为静态内部类
     */
    private static class ChatHandler extends Handler {
        private final WeakReference<ChatActivity> mActivty;
        StringBuilder fullResult = new StringBuilder();
        public void clearResult(){
            this.fullResult = new StringBuilder();
        }

        ChatHandler(ChatActivity Activty) {
            this.mActivty = new WeakReference<>(Activty);
        }

        @Override
        public void handleMessage(Message msg) {
            super.handleMessage(msg);
            ChatActivity chatActivity = mActivty.get();
            chatActivity.handleMessage(msg,fullResult);
        }
    }

    /**
     * 处理各类消息
     */
    public void handleMessage(Message msg,StringBuilder fullResult) {
        if (msg.what == HANDLER_MSG) {
            updateMessage();
        } else if (msg.what == HANDLER_MSG_MORE) {
            // 加载更多的时候
            JZMoreMessage();
        } else if (msg.what == HANDLER_ROBOT) {
            //当前是机器人
            ToastUtils.showShort(this,R.string.now_robit);
            if (IMChatManager.getInstance().isShowTransferBtn()) {
                chat_tv_convert.setVisibility(View.VISIBLE);
                LogUtils.dTag("handleMessage==", "当前是机器人-显示按钮");
            } else {
                chat_tv_convert.setVisibility(View.GONE);
                LogUtils.dTag("handleMessage==", "当前是机器人-隐藏按钮");
            }
            bar_bottom.setVisibility(View.VISIBLE);
            isRobot = true;
            // 机器人
            setChatMoreList();
        } else if (msg.what == HANDLER_ONLINE) {
            //当前是客服
            chat_tv_convert.setVisibility(View.GONE);
        } else if (msg.what == HANDLER_WRITING) {
            //对方当前正在输入
            mOtherName.setText(R.string.other_writing);
        } else if (msg.what == HANDLER_NO_WRITING) {
            mOtherName.setText(titleName);
        } else if (msg.what == HANDLER_OFFNLINE) {
            ToastUtils.showShort(this,R.string.people_not_online);
            if (IMChatManager.getInstance().isShowTransferBtn()) {
                chat_tv_convert.setVisibility(View.VISIBLE);
            } else {
                chat_tv_convert.setVisibility(View.GONE);
            }
            if (isRobot) {
                bar_bottom.setVisibility(View.VISIBLE);
            } else {
                bar_bottom.setVisibility(View.VISIBLE);
            }
            showOffLineDialog();
        } else if (msg.what == HANDLER_INVESTIGATE) {
            //坐席邀请访客评价
            INVITATION_INVESTIGATE = true;
            openInvestigateDialog(false);
        } else if (msg.what == HANDLER_QUEUENUM) {
            String queueNem = (String) msg.obj;
            showQueueNumLabel(queueNem);
            isQueue = true;
            //排队
            setChatMoreList();
        } else if (msg.what == HANDLER_CLIAM) {
            chat_queue_ll.setVisibility(View.GONE);
            chat_tv_convert.setVisibility(View.GONE);
            bar_bottom.setVisibility(View.VISIBLE);
            isRobot = false;
            isQueue = false;
            //校验是否有效会话
            checkConverstaion();
//                setChatMoreList();
            Toast.makeText(getApplicationContext(), R.string.people_now, Toast.LENGTH_SHORT).show();
            IMChatManager.getInstance().setIsShowBottomList(false);
            rvTagLabel.setVisibility(View.GONE);
        } else if (msg.what == HANDLER_FINISH) {
            // 如果会话已经不存在了
            if (IMChatManager.getInstance().isFinishWhenReConnect) {
            } else {
                bar_bottom.setVisibility(View.GONE);
            }
            mOtherName.setText(R.string.people_isleave);
            titleName = getString(R.string.people_isleave);
            chat_tv_convert.setVisibility(View.GONE);
            conversationOver = true;
            //点击常见问题的话，不让发送消息
        } else if (msg.what == HANDLER_LEAVEMSG) {
            //跳留言
            Intent intent = new Intent(ChatActivity.this, ScheduleOfflineMessageActivity.class);
            intent.putExtra("LeavemsgNodeId", schedule_id);
            intent.putExtra("ToPeer", schedule_topeer);
            startActivity(intent);
            finish();
        } else if (msg.what == HANDLER_BREAK) {
            LogUtils.dTag("BreakTimer", "HANDLER_BREAK===断开会话");
            //断开会话
            IMChatManager.getInstance().quitSDk();
            finish();
        } else if (msg.what == HANDLER_BREAK_TIP) {
            LogUtils.dTag("BreakTimer", "HANDLER_BREAK_TIP===断开会话前提示");
            //断开会话前提示
            IMChat.getInstance().createBreakTipMsg(break_tips);
            updateMessage();
        } else if (msg.what == HANDLER_VIPASSIGNFAIL) {
            //专属座席不在线
            showVipAssignFailDialog();
        } else if (getString(R.string.chat_img).equals(msg.obj)) {
            //校验权限
            checkPermissoion(0);
        } else if (getString(R.string.chat_evaluate).equals(msg.obj)) {
            openInvestigateDialog(true);
        } else if (getString(R.string.chat_question).equals(msg.obj)) {
            startActivity(new Intent(ChatActivity.this, CommonQuestionsActivity.class));
        } else if (getString(R.string.chat_file).equals(msg.obj)) {
            //校验权限
            checkPermissoion(1);
        }
    }

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        requestWindowFeature(Window.FEATURE_NO_TITLE);
        setContentView(R.layout.kf_activity_chat);
        getIntentData(getIntent());
        handler = new ChatHandler(this);
        spData = this.getSharedPreferences("moordata", 0);
        //将timestamp参数置空；
        SharedPreferences.Editor edit = spData.edit();
        edit.putString("SERVERTIMESTAMP", "").apply();
        left_text=spData.getString(Constants.CHATACTIVITYLEFTTEXT,"");
        show_emoji=spData.getBoolean(Constants.CHATACTIVITYEMOJI,true);
        titleName=getString(R.string.wait_link);
        registerRec();
        EventBus.getDefault().register(this);



        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.M) {
            initPermission();
        }


        //将 语音转文本，显示文本状态 全部重置为 不显示状态,  不调用的话转换过的语音在进入聊天会自动显示文本
        MessageDao.getInstance().updateAllisShowVT();
        //  创建client实例，client只需要创建一次，可以用它多次创建transcriber


        IMChatManager.getInstance().handleSSLHandshake();//对于https的图片地址优化
        initBottomList();
        registerListener();
        initEmojiViewPager();
        initEmojiPoint();
        initEmojiData();
        initMoreViewPager();
        initMorePoint();
        initMoreData();
        updateMessage();
//        //是否配置了满意度
        if (IMChatManager.getInstance().getInvestigate().size() > 0) {
            hasSet = true;
        } else {
            hasSet = false;
        }
        loadingDialog = new LoadingFragmentDialog();
        loadingDialog.setCanceledOnTouchOutside(false);
        loadingDialog.show(this.getSupportFragmentManager(), "");
        if (type.equals("peedId")) {
            beginSession(peerId);
        }
        if (type.equals("schedule")) {
            beginScheduleSession(scheduleId, processId, currentNodeId, entranceId);
        }
        builder = new TcpExitDiaglog.Builder(this);
        //设置全局配置
        setGlobalConfig();


    }
    //注册广播
    private void registerRec(){
        IntentFilter intentFilter = new IntentFilter("com.m7.imkfsdk.msgreceiver");
        msgReceiver = new MsgReceiver();
        registerReceiver(msgReceiver, intentFilter);

        IntentFilter kefuIntentFilter = new IntentFilter();
        kefuIntentFilter.addAction(IMChatManager.ROBOT_ACTION);
        kefuIntentFilter.addAction(IMChatManager.ONLINE_ACTION);
        kefuIntentFilter.addAction(IMChatManager.OFFLINE_ACTION);
        kefuIntentFilter.addAction(IMChatManager.CLIAM_ACTION);
        kefuIntentFilter.addAction(IMChatManager.INVESTIGATE_ACTION);
        kefuIntentFilter.addAction(IMChatManager.QUEUENUM_ACTION);
        kefuIntentFilter.addAction(IMChatManager.LEAVEMSG_ACTION);
        kefuIntentFilter.addAction(IMChatManager.FINISH_ACTION);
        kefuIntentFilter.addAction(IMChatManager.USERINFO_ACTION);
        kefuIntentFilter.addAction(IMChatManager.VIPASSIGNFAIL_ACTION);
        kefuIntentFilter.addAction(IMChatManager.CANCEL_ROBOT_ACCESS_ACTION);
        kefuIntentFilter.addAction(IMChatManager.WITHDRAW_ACTION);
        kefuIntentFilter.addAction(IMChatManager.WRITING_ACTION);
        kefuIntentFilter.addAction(IMChatManager.ROBOT_SWITCH_ACTION);
        kefuIntentFilter.addAction(IMChatManager.TCP_ACTION);
        kefuIntentFilter.addAction(IMChatManager.ZXMSG_ACTION);

        kefuIntentFilter.addAction(IMChatManager.VIDEO_INVITED_ACTION);
        kefuIntentFilter.addAction(IMChatManager.CANCEL_VIDEO_ACTION);
        keFuStatusReceiver = new KeFuStatusReceiver();
        registerReceiver(keFuStatusReceiver, kefuIntentFilter);
    }

    /**
     * 检查权限是否拥有
     */
    private void checkPermissoion(int type) {
        permisssionType = type;
        //读写
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.M) {
            if (PickUtils.PermissionUtils.hasAlwaysDeniedPermission(this, Manifest.permission.WRITE_EXTERNAL_STORAGE)) {
                PickUtils.PermissionUtils.requestPermissions(this, 0x11, new String[]{Manifest.permission.WRITE_EXTERNAL_STORAGE}, new PickUtils.PermissionUtils.OnPermissionListener() {
                    @Override
                    public void onPermissionGranted() {
                        if (permisssionType == 0) {
                            openAlbum();
                        } else if (permisssionType == 1) {
                            openFile();
                        }
                    }

                    @Override
                    public void onPermissionDenied(String[] deniedPermissions) {
                        Toast.makeText(ChatActivity.this, R.string.notpermession, Toast.LENGTH_SHORT).show();

                    }
                });
            }
        } else {
            if (permisssionType == 0) {
                openAlbum();
            } else if (permisssionType == 1) {
                openFile();
            }
        }
    }



    /**
     * 打开文件选择
     */
    private void openFile() {
        Intent intent = new Intent(Intent.ACTION_GET_CONTENT);
        intent.setType("*/*");//设置类型
        intent.addCategory(Intent.CATEGORY_OPENABLE);
        startActivityForResult(intent, PICK_FILE_ACTIVITY_REQUEST_CODE);
    }

    private void showVipAssignFailDialog() {
        new AlertDialog.Builder(this).setTitle(R.string.warm_prompt)
                .setMessage(R.string.doyouneedother)
                .setPositiveButton(R.string.need, new DialogInterface.OnClickListener() {
                    @Override
                    public void onClick(DialogInterface dialogInterface, int i) {
                        IMChatManager.getInstance().acceptOtherAgent(peerId, new AcceptOtherAgentListener() {
                            @Override
                            public void onSuccess() {
                                Toast.makeText(ChatActivity.this, getString(R.string.ykf_notify_otheragent), Toast.LENGTH_SHORT).show();
                                //专属坐席不在线，重新请求会话
                                if (type.equals("peedId")) {
                                    HttpManager.beginNewVipOfflineSession(InfoDao.getInstance().getConnectionId()
                                            , IMChatManager.getInstance().getIsNewVisitor()
                                            , peerId
                                            , ""
                                            , getResponseListener(true));
                                }
                                if (type.equals("schedule")) {
                                    HttpManager.beginNewVipOfflineScheduleChatSession(InfoDao.getInstance().getConnectionId()
                                            , IMChatManager.getInstance().getIsNewVisitor()
                                            , scheduleId
                                            , processId
                                            , currentNodeId
                                            , entranceId
                                            , ""
                                            , getResponseListener(false));
                                }

                            }

                            @Override
                            public void onFailed() {
                                Toast.makeText(ChatActivity.this, getString(R.string.ykf_notify_otheragent_fail), Toast.LENGTH_SHORT).show();
                            }
                        });
                    }
                })
                .setNegativeButton(R.string.noneed, new DialogInterface.OnClickListener() {
                    @Override
                    public void onClick(DialogInterface dialogInterface, int i) {
                        IMChatManager.getInstance().quitSDk();
                        finish();
                    }
                })
                .setCancelable(false)
                .create()
                .show();

    }

    /**
     * 显示排队数
     */
    private void showQueueNumLabel(String queueNum) {
        if (Integer.parseInt(queueNum) > 0) {
            chat_queue_ll.setVisibility(View.VISIBLE);
            try {
                String queueNumText = GlobalSetDao.getInstance().getGlobalSet().queueNumText;
                int beginIndex = queueNumText.indexOf("{");
                int endIndex = queueNumText.indexOf("}");
                String newString = queueNumText.replace(queueNumText.substring(beginIndex, endIndex + 1), queueNum);
                SpannableString ss = new SpannableString(newString);
                ss.setSpan(new ForegroundColorSpan(Color.parseColor("#21b38a")), beginIndex,
                        beginIndex + 1, Spanned.SPAN_EXCLUSIVE_EXCLUSIVE);

                chat_queue_tv.setText(ss);
            } catch (Exception e) {

                chat_queue_tv.setText(getResources().getText(R.string.numbers01) + queueNum + getResources().getText(R.string.number02));
            }
        } else {
            chat_queue_ll.setVisibility(View.GONE);
        }
    }



    private void initPermission() {
        if (PickUtils.PermissionUtils.hasAlwaysDeniedPermission(this, Manifest.permission.RECORD_AUDIO, Manifest.permission.WRITE_EXTERNAL_STORAGE)) {
            PickUtils.PermissionUtils.requestPermissions(this, 0x11, new String[]{Manifest.permission.RECORD_AUDIO, Manifest.permission.WRITE_EXTERNAL_STORAGE}, new PickUtils.PermissionUtils.OnPermissionListener() {
                @Override
                public void onPermissionGranted() {
                }

                @Override
                public void onPermissionDenied(String[] deniedPermissions) {
                    Toast.makeText(ChatActivity.this, R.string.notpermession, Toast.LENGTH_SHORT).show();
                }
            });
        }
    }


    /**
     * 设置断开定时器
     */
    private void setGlobalConfig() {
        GlobalSet globalSet = GlobalSetDao.getInstance().getGlobalSet();
        if (globalSet != null) {
            String break_len = globalSet.break_len;
            String break_tips_len = globalSet.break_tips_len;
            break_tips = globalSet.break_tips;
            try {
                breakTime = Integer.parseInt(break_len) * 60 * 1000;
                LogUtils.dTag("BreakTimer", "breakTime===" + break_len);
            } catch (Exception e) {
            }
            try {
                breakTipTime = breakTime - Integer.parseInt(break_tips_len) * 60 * 1000;
                LogUtils.dTag("BreakTimer", "breakTipTime===" + break_tips_len);
            } catch (Exception e) {
            }
            if (breakTime > 0) {
                break_timer = new Timer();
                breakTimerTask = new BreakTimerTask();
                break_timer.schedule(breakTimerTask, breakTime);
            }
            if (breakTipTime > 0) {
                break_tip_timer = new Timer();
                breakTipTimerTask = new BreakTipTimerTask();
                break_tip_timer.schedule(breakTipTimerTask, breakTipTime);
            }
        }
    }


    /**
     * xbot发送文本消息
     *
     * @param msgStr
     */
    public void sendXbotTextMsg(String msgStr) {

        if (!isRobot) {
            ToastUtils.showShort(this,getString(R.string.ykf_not_robot_send));
            return;
        }
        //访客没发过消息，显示评论按。 2访客发过消息后，就不再校验了。
        if (isRobot && !hasSendRobotMsg) {
            hasSendRobotMsg = true;
            setChatMoreList();
        }
        if (!isRobot && !hasSendPersonMsg) {
            hasSendPersonMsg = true;
            setChatMoreList();
        }
        LogUtils.aTag("send", msgStr);
        FromToMessage fromToMessage = IMMessage.createTxtMessage(msgStr);

        //界面显示
        sendSingleMessage(fromToMessage);
    }

    /**
     * 发送文本消息
     *
     * @param msgStr
     */
    public void sendTextMsg(String msgStr) {
        //如果会话已经结束了，就不让点击常见问题了
        if (conversationOver) {
            return;
        }

        //访客没发过消息，显示评论按。 2 访客发过消息后，就不再校验了。
        if (isRobot && !hasSendRobotMsg) {
            hasSendRobotMsg = true;
            setChatMoreList();
        }
        if (!isRobot && !hasSendPersonMsg) {
            hasSendPersonMsg = true;
            setChatMoreList();
        }
        LogUtils.aTag("send", msgStr);
        FromToMessage fromToMessage = IMMessage.createTxtMessage(msgStr);

        //界面显示
        sendSingleMessage(fromToMessage);
    }

    /**
     * 断开定时器任务
     */
    class BreakTimerTask extends TimerTask {
        @Override
        public void run() {
            handler.sendEmptyMessage(HANDLER_BREAK);
            break_timer.cancel();
        }
    }

    /**
     * 断开前提示定时器任务
     */
    class BreakTipTimerTask extends TimerTask {
        @Override
        public void run() {
            handler.sendEmptyMessage(HANDLER_BREAK_TIP);
            break_tip_timer.cancel();
        }
    }

    /**
     * 重置断开提示定时器
     */
    private void resetBreakTimer() {
        if (break_timer != null) {
            break_timer.cancel();
            break_timer = null;
        }
        if (break_tip_timer != null) {
            break_tip_timer.cancel();
            break_tip_timer = null;
        }

        if (breakTimerTask != null) {
            breakTimerTask.cancel();
        }
        if (breakTipTimerTask != null) {
            breakTipTimerTask.cancel();
        }

        if (breakTime > 0) {
            break_timer = new Timer();
            breakTimerTask = new BreakTimerTask();
            break_timer.schedule(breakTimerTask, breakTime);
        }
        if (breakTipTime > 0) {
            break_tip_timer = new Timer();
            breakTipTimerTask = new BreakTipTimerTask();
            break_tip_timer.schedule(breakTipTimerTask, breakTipTime);
        }
        LogUtils.dTag("BreakTimer", "resetBreakTimer===重置断开提示定时器");
    }

    /**
     * 查询数据库更新页面
     */
    public void updateMessage() {
        fromToMessage = IMChatManager.getInstance().getMessages(1);
        descFromToMessage.clear();
        for (int i = fromToMessage.size() - 1; i >= 0; i--) {
            descFromToMessage.add(fromToMessage.get(i));
        }
        // 是否有数据
        if (IMChatManager.getInstance().isReachEndMessage(descFromToMessage.size())) {
            mChatList.dismiss();
        }
        chatAdapter = new ChatAdapter(ChatActivity.this, descFromToMessage);
        mChatList.setAdapter(chatAdapter);
        chatAdapter.notifyDataSetChanged();
        mChatList.setSelection(fromToMessage.size() + 1);

        //重置未读消息数量
        IMChatManager.getInstance().resetMsgUnReadCount();
        //刷新标题
        mOtherName.setText(titleName);
        if (handler.hasMessages(HANDLER_NO_WRITING)) {
            handler.removeMessages(HANDLER_NO_WRITING);
        }
    }

    // 会话被结束掉了，点击输入框，重新开始会话，
    @Override
    protected void onNewIntent(Intent intent) {
        super.onNewIntent(intent);
        updateMessage();
        //小陌机器人评价是否完成
        robotEvaluationFinish = false;
        conversationOver=false;

        //是否和机器人发送过消息
        hasSendRobotMsg = false;
        hasSendPersonMsg = false;
        isQueue = false;
        JZflag = true;


        resetBreakTimer();

        getIntentData(intent);
        /*临时注释掉*/
        if (type.equals("peedId")) {
            LogUtils.aTag("beginSession", "ChatActivity690行代码");
            beginSession(peerId);
        }
        if (type.equals("schedule")) {
            beginScheduleSession(scheduleId, processId, currentNodeId, entranceId);
        }

    }

    public void getIntentData(Intent intent) {
        //获取技能组id
        if (intent.getStringExtra("PeerId") != null) {
            peerId = intent.getStringExtra("PeerId");
        }
        if (intent.getStringExtra("type") != null) {
            type = intent.getStringExtra("type");
        }
        if (intent.getStringExtra("scheduleId") != null) {
            scheduleId = intent.getStringExtra("scheduleId");
        }
        if (intent.getStringExtra("processId") != null) {
            processId = intent.getStringExtra("processId");
        }
        if (intent.getStringExtra("currentNodeId") != null) {
            currentNodeId = intent.getStringExtra("currentNodeId");
        }
        if (intent.getStringExtra("entranceId") != null) {
            entranceId = intent.getStringExtra("entranceId");
        }
        if (intent.getStringExtra("processType") != null) {
            processType = intent.getStringExtra("processType");
        }
        //初始化成功打标记（引用于调用服务未读消息数）
        MoorUtils.initForUnread(ChatActivity.this);
        IMChatManager.getInstance().isFinishWhenReConnect = false;
    }

    // 分页加载更多
    public void JZMoreMessage() {
        fromToMessage = IMChatManager.getInstance().getMessages(pageSize);

        descFromToMessage.clear();
        for (int i = fromToMessage.size() - 1; i >= 0; i--) {
            descFromToMessage.add(fromToMessage.get(i));
        }

        chatAdapter.notifyDataSetChanged();

        if (mChatList.getHeaderViewsCount() > 0) {
            mChatList.removeHeaderView(header);
        }

        // 是否有数据
        if (IMChatManager.getInstance().isReachEndMessage(
                descFromToMessage.size())) {
            mChatList.setSelectionFromTop(fromToMessage.size() - (pageSize - 1) * 15,
                    height);
            mChatList.dismiss();
        } else {
            mChatList.setSelectionFromTop(fromToMessage.size() - (pageSize - 1) * 15
                    + 1, height);
        }

        mChatList.onRefreshFinished();
        JZflag = true;
        pageSize++;
    }

    // 初始化bottomList
    @SuppressLint("ClickableViewAccessibility")
    public void initBottomList() {


        // 设置进来时间软键盘不弹出的默认状态
        manager = (InputMethodManager) getSystemService(Context.INPUT_METHOD_SERVICE);
        getWindow().setSoftInputMode(
                WindowManager.LayoutParams.SOFT_INPUT_STATE_ALWAYS_HIDDEN);
        //底部推荐标签
        rvTagLabel = findViewById(R.id.rv_tag_label);
        rvTagLabel.setLayoutManager(new LinearLayoutManager(this, LinearLayoutManager.HORIZONTAL, false));
        rl_emoji_layout=findViewById(R.id.rl_emoji_layout);//emoji按钮外层布局
        List<FlowBean> datas = new ArrayList<>();
        tagLabeAdapter = new ChatTagLabelsAdapter(datas);
        rvTagLabel.setAdapter(tagLabeAdapter);
        tagLabeAdapter.setOnItemClickListener(new ChatTagLabelsAdapter.onItemClickListener() {
            @Override
            public void OnItemClick(FlowBean flowBean) {
                sendXbotTextMsg(flowBean.getText());
            }
        });
        rvTagLabel.setVisibility(View.GONE);//默认不展示滑动list

        mChatSend = (Button) this.findViewById(R.id.chat_send);
        chat_tv_back = (TextView) this.findViewById(R.id.chat_tv_back);
        mRecorderButton = (AudioRecorderButton) findViewById(R.id.chat_press_to_speak);
        mRecorderButton.setRecordFinishListener(this);
        mChatInput = (EditText) this.findViewById(R.id.chat_input);
        ll_hintView = (LinearLayout) this.findViewById(R.id.ll_hintView);
        mChatEdittextLayout = (RelativeLayout) this
                .findViewById(R.id.chat_edittext_layout);
        mMore = (LinearLayout) this.findViewById(R.id.more);
        mChatEmojiNormal = (ImageView) this
                .findViewById(R.id.chat_emoji_normal);
        mChatEmojiChecked = (ImageView) this
                .findViewById(R.id.chat_emoji_checked);
        mChatFaceContainer = (RelativeLayout) this
                .findViewById(R.id.chat_face_container);
        mChatMoreContainer = (RelativeLayout) this
                .findViewById(R.id.chat_more_container);
        mChatMore = (Button) this.findViewById(R.id.chat_more);

        mChatSetModeVoice = (Button) this
                .findViewById(R.id.chat_set_mode_voice);
        mChatSetModeKeyboard = (Button) this
                .findViewById(R.id.chat_set_mode_keyboard);

        //转人工服务按钮，判断是否需要显示
        chat_tv_convert = (TextView) this.findViewById(R.id.chat_tv_convert);

        if (type.equals("schedule") && !processType.equals("robot")) {
            chat_tv_convert.setVisibility(View.GONE);
        }
        //可以删除的逻辑
        if (!IMChatManager.getInstance().isShowTransferBtn()) {
            chat_tv_convert.setVisibility(View.GONE);
            LogUtils.dTag("handleMessage==", "可以删除的逻辑-隐藏按钮");
        }

        if(TextUtils.isEmpty(left_text)){
            chat_tv_back.setText(getString(R.string.logout));
        }else{
            chat_tv_back.setText(left_text);
        }

        if(show_emoji){
            rl_emoji_layout.setVisibility(View.VISIBLE);
        }else{
            rl_emoji_layout.setVisibility(View.GONE);
        }

        mOtherName = (TextView) this.findViewById(R.id.other_name);
        mChatInput.setOnFocusChangeListener(new OnFocusChangeListener() {

            @Override
            public void onFocusChange(View v, boolean hasFocus) {
                if (hasFocus) {
                    mChatEdittextLayout
                            .setBackgroundResource(R.drawable.kf_input_bar_bg_active);
                } else {
                    mChatEdittextLayout
                            .setBackgroundResource(R.drawable.kf_input_bar_bg_normal);
                }

            }
        });
        mChatInput.requestFocus();
        mChatInput.setOnClickListener(new OnClickListener() {

            @Override
            public void onClick(View v) {

                if(IMChatManager.USE_TCP){
                    if (!MoorUtils.isNetWorkConnected(IMChatManager.getInstance().getAppContext()) &&
                            TcpManager.TcpStatus.BREAK.equals(TcpManager.getInstance(IMChatManager.getInstance().
                                    getAppContext()).getTcpStatus())) {
//                    Toast.makeText(getApplicationContext(), "检测到您网络异常啦~", Toast.LENGTH_SHORT).show();
                        LogUtils.aTag("第五个地方break");
                        TcpManager.getInstance(IMChatManager.getInstance().getAppContext()).setTcpStatus(TcpManager.TcpStatus.NONET);
                        startReStartDialog3();
                        return;
                    }
                }else{
                    if (!MoorUtils.isNetWorkConnected(IMChatManager.getInstance().getAppContext()) &&
                           !WebSocketHandler.getDefault().isConnect()) {
//                    Toast.makeText(getApplicationContext(), "检测到您网络异常啦~", Toast.LENGTH_SHORT).show();
                        LogUtils.aTag("第五个地方break");
                        startReStartDialog3();
                        return;
                    }
                }



                if (IMChatManager.getInstance().isFinishWhenReConnect) {
                    // beginSession();
                    startReStartDialog();
                } else {
                    mChatEdittextLayout
                            .setBackgroundResource(R.drawable.kf_input_bar_bg_active);
                    mChatEmojiNormal.setVisibility(View.VISIBLE);
                    mChatEmojiChecked.setVisibility(View.GONE);

                    mMore.setVisibility(View.GONE);
                    mChatFaceContainer.setVisibility(View.GONE);
                    mChatMoreContainer.setVisibility(View.GONE);
                }


            }
        });

        // 监听文字框
        mChatInput.addTextChangedListener(new TextWatcher() {

            @Override
            public void onTextChanged(CharSequence s, int start, int before,
                                      int count) {
                if (!TextUtils.isEmpty(s)) {
                    mChatMore.setVisibility(View.GONE);
                    mChatSend.setVisibility(View.VISIBLE);
                } else {
                    mChatMore.setVisibility(View.VISIBLE);
                    mChatSend.setVisibility(View.GONE);
                }
            }

            @Override
            public void beforeTextChanged(CharSequence s, int start, int count,
                                          int after) {
            }

            @Override
            public void afterTextChanged(Editable s) {
                // TODO: 2019-12-02 现在联想输入不区分机器人；
                //如果开启联想功能,xbot机器人
                if (!TextUtils.isEmpty(s)) {
                    if (IMChat.getInstance().getLianXiangOn())
                        HttpManager.queryLianXiangData(InfoDao.getInstance().getConnectionId(), IMChat.getInstance().getRobotType(), s.toString(), new GetLianXiangDataResponeHandler());
                } else {
                    ll_hintView.setVisibility(View.GONE);
                }
            }
        });

        mChatList = (ChatListView) this.findViewById(R.id.chat_list);
        header = View.inflate(this, R.layout.kf_chatlist_header, null);
        int w = View.MeasureSpec.makeMeasureSpec(0,
                View.MeasureSpec.UNSPECIFIED);
        int h = View.MeasureSpec.makeMeasureSpec(0,
                View.MeasureSpec.UNSPECIFIED);
        header.measure(w, h);
        height = header.getMeasuredHeight();

        mChatList.setOnTouchListener(new OnTouchListener() {

            @Override
            public boolean onTouch(View v, MotionEvent event) {
                hideKeyboard(ChatActivity.this, v);
                 mMore.setVisibility(View.GONE);
                mChatEmojiNormal.setVisibility(View.VISIBLE);
                mChatEmojiChecked.setVisibility(View.GONE);
                mChatFaceContainer.setVisibility(View.GONE);
                mChatMoreContainer.setVisibility(View.GONE);
                return false;
            }
        });

        emojis = FaceConversionUtil.getInstace().emojiLists;
        moreList = new ArrayList<ChatMore>();
        chatMore2 = new ChatMore(2, R.drawable.kf_icon_chat_pic + "",
                getString(R.string.chat_img));
        chatMore3 = new ChatMore(3, R.drawable.kf_icon_chat_file + "",
                getString(R.string.chat_file));
        chatMore4 = new ChatMore(4, R.drawable.kf_icon_chat_investigate + "",
                getString(R.string.chat_evaluate));
        chatMore5 = new ChatMore(5, R.drawable.kf_icon_chat_question + "",
                getString(R.string.chat_question));


        moreList.add(chatMore2);
        moreList.add(chatMore3);
        moreList.add(chatMore5);
 //        moreList.add(chatMore4);//默认不展示评价按钮
        int pageCount = (int) Math.ceil(moreList.size() / 8 + 0.1);
        for (int i = 0; i < pageCount; i++) {
            moreLists.add(getData(i));
        }

        mChatEmojiVPager = (ViewPager) findViewById(R.id.chat_emoji_vPager);
        mChatMoreVPager = (ViewPager) findViewById(R.id.chat_more_vPager);
        mChatInput = (EditText) findViewById(R.id.chat_input);
        mChatIvImageFace = (LinearLayout) findViewById(R.id.chat_iv_image_face);
        mChatIvImageMore = (LinearLayout) findViewById(R.id.chat_iv_image_more);
        chat_queue_ll = (LinearLayout) findViewById(R.id.chat_queue_ll);
        chat_queue_tv = (TextView) findViewById(R.id.chat_queue_tv);
        bar_bottom = (LinearLayout) findViewById(R.id.bar_bottom);
    }



    // 注册监听方法
    public void registerListener() {
        mChatSend.setOnClickListener(this);
        chat_tv_back.setOnClickListener(this);
        mChatSetModeVoice.setOnClickListener(this);
        mChatSetModeKeyboard.setOnClickListener(this);
        mChatEmojiNormal.setOnClickListener(this);
        mChatEmojiChecked.setOnClickListener(this);
        mChatMore.setOnClickListener(this);
        mChatList.setOnRefreshListener(this);
        chat_tv_convert.setOnClickListener(this);

    }

    // 获取分页数据
    private List<ChatMore> getData(int page) {
        int startIndex = page * 8;
        int endIndex = startIndex + 8;

        if (endIndex > moreList.size()) {
            endIndex = moreList.size();
        }
        List<ChatMore> list = new ArrayList<ChatMore>();
        list.addAll(moreList.subList(startIndex, endIndex));
        if (list.size() < 8) {
            for (int i = list.size(); i < 8; i++) {
                ChatMore object = new ChatMore();
                list.add(object);
            }
        }
        return list;
    }
// 隐藏软键盘

    public static void hideKeyboard(Context context, View view) {
        InputMethodManager imm = (InputMethodManager) context.getSystemService(
                Context.INPUT_METHOD_SERVICE);
        imm.hideSoftInputFromWindow(view.getWindowToken(), 0);
    }

    @Override
    public void onClick(View v) {
        int i1 = v.getId();
        if (i1 == R.id.chat_tv_back) {//断开长连接
            handleLogOutOrBackPressed();
        } else if (i1 == R.id.chat_tv_convert) {
            if (shake.check()) {
                return;
            }
            onEventMainThread(new TransferAgent());
        } else if (i1 == R.id.chat_send) {
            String txt = mChatInput.getText().toString();
            //以防万一，发送的时候又校验一次啊

            if(IMChatManager.USE_TCP){
                if (!MoorUtils.isNetWorkConnected(IMChatManager.getInstance().getAppContext()) &&
                        TcpManager.TcpStatus.BREAK.equals(TcpManager.getInstance(IMChatManager.getInstance().getAppContext()).getTcpStatus())) {
                    Toast.makeText(getApplicationContext(), getString(R.string.ykf_not_netwokr_error), Toast.LENGTH_SHORT).show();
                    LogUtils.aTag("第四个地方break");
//                IMService.isRelogin = true;
                    TcpManager.getInstance(IMChatManager.getInstance().getAppContext()).setTcpStatus(TcpManager.TcpStatus.NONET);
                    startReStartDialog3();
                    return;
                }
            }else{
                if (!MoorUtils.isNetWorkConnected(IMChatManager.getInstance().getAppContext()) &&
                        !WebSocketHandler.getDefault().isConnect()) {
                    Toast.makeText(getApplicationContext(), getString(R.string.ykf_not_netwokr_error), Toast.LENGTH_SHORT).show();
                    LogUtils.aTag("第四个地方break");
//                IMService.isRelogin = true;
                    startReStartDialog3();
                    return;
                }

            }


            if (IMChatManager.getInstance().isFinishWhenReConnect) {
                startReStartDialog();//并且弹框提示开始新会话
//            }
            } else {
                ll_hintView.setVisibility(View.GONE);
                sendTextMsg(txt);
            }
        } else if (i1 == R.id.chat_set_mode_voice) {
            if (Build.VERSION.SDK_INT < 23) {
                showVoice(v);
            } else {
                //6.0
                if (ContextCompat.checkSelfPermission(ChatActivity.this, Manifest.permission.RECORD_AUDIO) == PackageManager.PERMISSION_GRANTED) {
                    //该权限已经有了
                    showVoice(v);
                } else {
                    //申请该权限
                    ActivityCompat.requestPermissions(ChatActivity.this, new String[]{Manifest.permission.RECORD_AUDIO}, 0x4444);
                }
            }


        } else if (i1 == R.id.chat_set_mode_keyboard) {
            mChatEdittextLayout.setVisibility(View.VISIBLE);
            mChatSetModeKeyboard.setVisibility(View.GONE);
            mChatSetModeVoice.setVisibility(View.VISIBLE);
            mChatInput.requestFocus();
            mRecorderButton.setVisibility(View.GONE);
            mChatFaceContainer.setVisibility(View.GONE);

            if (TextUtils.isEmpty(mChatInput.getText())) {
                mChatMore.setVisibility(View.VISIBLE);
                mChatSend.setVisibility(View.GONE);
            } else {
                mChatMore.setVisibility(View.GONE);
                mChatSend.setVisibility(View.VISIBLE);
            }


        } else if (i1 == R.id.chat_emoji_normal) {
            hideKeyboard(ChatActivity.this, v);
            mMore.setVisibility(View.VISIBLE);
            mChatEmojiNormal.setVisibility(View.GONE);
            mChatEmojiChecked.setVisibility(View.VISIBLE);
            mChatMoreContainer.setVisibility(View.GONE);
            mChatFaceContainer.setVisibility(View.VISIBLE);
            mChatMoreVPager.setVisibility(View.GONE);
            mChatEmojiVPager.setVisibility(View.VISIBLE);

        } else if (i1 == R.id.chat_emoji_checked) {
            mChatEmojiNormal.setVisibility(View.VISIBLE);
            mChatEmojiChecked.setVisibility(View.GONE);
            mChatMoreContainer.setVisibility(View.GONE);
            mChatFaceContainer.setVisibility(View.GONE);
            mMore.setVisibility(View.GONE);

        } else if (i1 == R.id.chat_more) {
            if (mMore.getVisibility() == View.VISIBLE) {
                mChatMoreVPager.setVisibility(View.GONE);
                mMore.setVisibility(View.GONE);
            } else {
                mChatMoreVPager.setVisibility(View.VISIBLE);
                mMore.setVisibility(View.VISIBLE);
                mChatEmojiNormal.setVisibility(View.VISIBLE);
                mChatEmojiChecked.setVisibility(View.GONE);
                mChatFaceContainer.setVisibility(View.GONE);
                mChatMoreContainer.setVisibility(View.VISIBLE);
                mChatEmojiVPager.setVisibility(View.GONE);
                hideKeyboard(ChatActivity.this, v);
            }

        }
    }

    /**
     * 处理注销和返回键逻辑
     */
    private void handleLogOutOrBackPressed() {
        //人工，开启了评价,坐席发过消息、会话存在，访客发过消息，没有评价过,配置了满意度列表,pc没有结束会话,是否弹出评价框

        NotAllowCustomerCloseCsr=spData.getBoolean("NotAllowCustomerCloseCsr",false);

        if (!isRobot && IMChatManager.getInstance().isInvestigateOn()
                && convesationIsLive && hasSendPersonMsg
                && isZXResply && isInvestigate && hasSet && !conversationOver&&!NotAllowCustomerCloseCsr) {
            showInvestigateDialog(true);
        } else {
            //去掉开关
            IMChat.getInstance().setLianXiangOn(false);
            IMChat.getInstance().setBotsatisfaOn(false);
            IMChatManager.getInstance().quitSDk();
            finish();
        }
        IMChatManager.getInstance().setIsShowBottomList(false);
    }

    private void showVoice(View v) {
        hideKeyboard(ChatActivity.this, v);
        mChatEdittextLayout.setVisibility(View.GONE);
        mMore.setVisibility(View.GONE);
        mChatSetModeVoice.setVisibility(View.GONE);
        mChatSetModeKeyboard.setVisibility(View.VISIBLE);
        mChatSend.setVisibility(View.GONE);
        mChatMore.setVisibility(View.VISIBLE);
        mRecorderButton.setVisibility(View.VISIBLE);
        mChatEmojiNormal.setVisibility(View.VISIBLE);
        mChatEmojiChecked.setVisibility(View.GONE);
        mChatMoreContainer.setVisibility(View.VISIBLE);
        mChatFaceContainer.setVisibility(View.GONE);
    }

    // 表情选择监听器
    public interface OnCorpusSelectedListener {

        void onCorpusSelected(ChatEmoji emoji);

        void onCorpusDeleted();
    }

    // 初始化文件的viewpager
    private void initMoreViewPager() {

        morePageViews = new ArrayList<View>();
        // 左侧添加空页
        View nullView1 = new View(this);
        // 设置透明背景
        nullView1.setBackgroundColor(Color.TRANSPARENT);
        morePageViews.add(nullView1);

        // 中间添加表情页
        moreAdapters = new ArrayList<MoreAdapter>();
        for (int i = 0; i < moreLists.size(); i++) {
            GridView view = new GridView(this);
            MoreAdapter adapter = new MoreAdapter(this, moreLists.get(i),
                    handler);
            view.setAdapter(adapter);
            moreAdapters.add(adapter);
            view.setOnItemClickListener(this);
            view.setNumColumns(4);
            view.setBackgroundColor(Color.TRANSPARENT);
            view.setHorizontalSpacing(1);
            view.setVerticalSpacing(1);
            view.setStretchMode(GridView.STRETCH_COLUMN_WIDTH);
            view.setCacheColorHint(0);
            view.setPadding(5, 0, 5, 0);
            view.setSelector(new ColorDrawable(Color.TRANSPARENT));
            view.setLayoutParams(new LayoutParams(LayoutParams.FILL_PARENT,
                    LayoutParams.WRAP_CONTENT));
            view.setGravity(Gravity.CENTER);
            morePageViews.add(view);

        }

        // 右侧添加空页面
        View nullView2 = new View(this);
        // 设置透明背景
        nullView2.setBackgroundColor(Color.TRANSPARENT);
        morePageViews.add(nullView2);

    }

    // 初始化游标
    private void initMorePoint() {

        pointViewsMore = new ArrayList<ImageView>();
        ImageView imageView;
        mChatIvImageMore.removeAllViews();
        for (int i = 0; i < morePageViews.size(); i++) {
            imageView = new ImageView(this);
            imageView.setBackgroundResource(R.drawable.kf_d1);
            LinearLayout.LayoutParams layoutParams = new LinearLayout.LayoutParams(
                    new ViewGroup.LayoutParams(LayoutParams.WRAP_CONTENT,
                            LayoutParams.WRAP_CONTENT));
            layoutParams.leftMargin = 10;
            layoutParams.rightMargin = 10;
            layoutParams.width = 8;
            layoutParams.height = 8;
            mChatIvImageMore.addView(imageView, layoutParams);
            if (i == 0 || i == morePageViews.size() - 1) {
                imageView.setVisibility(View.GONE);
            }
            if (i == 1) {
                imageView.setBackgroundResource(R.drawable.kf_d2);
            }
            pointViewsMore.add(imageView);
        }
    }

    // 填充数据
    private void initMoreData() {
        mChatMoreVPager.setAdapter(new ViewPagerAdapter(morePageViews));

        mChatMoreVPager.setCurrentItem(1);
        current = 0;
        mChatMoreVPager.setOnPageChangeListener(new OnPageChangeListener() {

            @Override
            public void onPageSelected(int arg0) {
                current = arg0 - 1;
                // 描绘分页点
                drawMorePoint(arg0);
                // 如果是第一屏或者是最后一屏禁止滑动，其实这里实现的是如果滑动的是第一屏则跳转至第二屏，如果是最后一屏则跳转到倒数第二屏.
                if (arg0 == pointViewsMore.size() - 1 || arg0 == 0) {
                    if (arg0 == 0) {
                        mChatMoreVPager.setCurrentItem(arg0 + 1);// 第二屏
                        // 会再次实现该回调方法实现跳转.
                        pointViewsMore.get(1).setBackgroundResource(
                                R.drawable.kf_d2);
                    } else {
                        mChatMoreVPager.setCurrentItem(arg0 - 1);// 倒数第二屏
                        pointViewsMore.get(arg0 - 1).setBackgroundResource(
                                R.drawable.kf_d2);
                    }
                }
            }

            @Override
            public void onPageScrolled(int arg0, float arg1, int arg2) {

            }

            @Override
            public void onPageScrollStateChanged(int arg0) {

            }
        });

    }

    // 绘制游标背景
    public void drawMorePoint(int index) {
        for (int i = 1; i < pointViewsMore.size(); i++) {
            if (index == i) {
                pointViewsMore.get(i).setBackgroundResource(R.drawable.kf_d2);
            } else {
                pointViewsMore.get(i).setBackgroundResource(R.drawable.kf_d1);
            }
        }
    }

    // 初始化显示表情的viewpager
    private void initEmojiViewPager() {
        facePageViews = new ArrayList<View>();
        // 左侧添加空页
        View nullView1 = new View(this);
        // 设置透明背景
        nullView1.setBackgroundColor(Color.TRANSPARENT);
        facePageViews.add(nullView1);
        // 中间添加表情页
        faceAdapters = new ArrayList<FaceAdapter>();
        for (int i = 0; i < emojis.size(); i++) {
            GridView view = new GridView(this);
            FaceAdapter adapter = new FaceAdapter(this, emojis.get(i));
            view.setAdapter(adapter);
            faceAdapters.add(adapter);
            view.setOnItemClickListener(this);
            view.setNumColumns(7);
            view.setBackgroundColor(Color.TRANSPARENT);
            view.setHorizontalSpacing(1);
            view.setVerticalSpacing(1);
            view.setStretchMode(GridView.STRETCH_COLUMN_WIDTH);
            view.setCacheColorHint(0);
            view.setPadding(5, 0, 5, 0);
            view.setSelector(new ColorDrawable(Color.TRANSPARENT));
            view.setLayoutParams(new LayoutParams(LayoutParams.FILL_PARENT,
                    LayoutParams.WRAP_CONTENT));
            view.setGravity(Gravity.CENTER);
            facePageViews.add(view);
        }

        // 右侧添加空页面
        View nullView2 = new View(this);
        // 设置透明背景
        nullView2.setBackgroundColor(Color.TRANSPARENT);
        facePageViews.add(nullView2);

    }

    // 初始化游标
    private void initEmojiPoint() {
        pointViewsFace = new ArrayList<ImageView>();
        ImageView imageView;
        for (int i = 0; i < facePageViews.size(); i++) {
            imageView = new ImageView(this);
            imageView.setBackgroundResource(R.drawable.kf_d1);
            LinearLayout.LayoutParams layoutParams = new LinearLayout.LayoutParams(
                    new ViewGroup.LayoutParams(LayoutParams.WRAP_CONTENT,
                            LayoutParams.WRAP_CONTENT));
            layoutParams.leftMargin = 10;
            layoutParams.rightMargin = 10;
            layoutParams.width = 8;
            layoutParams.height = 8;
            mChatIvImageFace.addView(imageView, layoutParams);
            if (i == 0 || i == facePageViews.size() - 1) {
                imageView.setVisibility(View.GONE);
            }
            if (i == 1) {
                imageView.setBackgroundResource(R.drawable.kf_d2);
            }
            pointViewsFace.add(imageView);
        }
    }

    // 填充数据
    private void initEmojiData() {
        mChatEmojiVPager.setAdapter(new ViewPagerAdapter(facePageViews));

        mChatEmojiVPager.setCurrentItem(1);
        current = 0;
        mChatEmojiVPager.setOnPageChangeListener(new OnPageChangeListener() {

            @Override
            public void onPageSelected(int arg0) {
                current = arg0 - 1;
                // 描绘分页点
                drawFacePoint(arg0);
                // 如果是第一屏或者是最后一屏禁止滑动，其实这里实现的是如果滑动的是第一屏则跳转至第二屏，如果是最后一屏则跳转到倒数第二屏.
                if (arg0 == pointViewsFace.size() - 1 || arg0 == 0) {
                    if (arg0 == 0) {
                        mChatEmojiVPager.setCurrentItem(arg0 + 1);// 第二屏
                        // 会再次实现该回调方法实现跳转.
                        pointViewsFace.get(1).setBackgroundResource(
                                R.drawable.kf_d2);
                    } else {
                        mChatEmojiVPager.setCurrentItem(arg0 - 1);// 倒数第二屏
                        pointViewsFace.get(arg0 - 1).setBackgroundResource(
                                R.drawable.kf_d2);
                    }
                }
            }

            @Override
            public void onPageScrolled(int arg0, float arg1, int arg2) {

            }

            @Override
            public void onPageScrollStateChanged(int arg0) {

            }
        });

    }

    // 绘制游标背景
    public void drawFacePoint(int index) {
        for (int i = 1; i < pointViewsFace.size(); i++) {
            if (index == i) {
                pointViewsFace.get(i).setBackgroundResource(R.drawable.kf_d2);
            } else {
                pointViewsFace.get(i).setBackgroundResource(R.drawable.kf_d1);
            }
        }
    }

    @Override
    public void onItemClick(AdapterView<?> arg0, View arg1, int arg2, long arg3) {
        if (mChatFaceContainer.getVisibility() == View.VISIBLE
                && mChatMoreContainer.getVisibility() == View.GONE) {

            ChatEmoji emoji = (ChatEmoji) faceAdapters.get(current).getItem(
                    arg2);
            if (emoji.getId() == R.drawable.kf_face_del_icon) {
                int selection = mChatInput.getSelectionStart();
                String text = mChatInput.getText().toString();
                if (selection > 0) {
                    String text2 = text.substring(selection - 1);
                    if (":".equals(text2)) {
                        String str = text.substring(0, selection - 1);
                        int start = str.lastIndexOf(":");
                        int end = selection;
                        mChatInput.getText().delete(start, end);
                        return;
                    }
                    mChatInput.getText().delete(selection - 1, selection);
                }

            }
            if (!TextUtils.isEmpty(emoji.getCharacter())) {
                if (mListener != null)
                    mListener.onCorpusSelected(emoji);
                SpannableString spannableString = FaceConversionUtil
                        .getInstace().addFace(this, emoji.getId(),
                                emoji.getCharacter(), mChatInput);
                mChatInput.append(spannableString);
            }
        }
    }

    // 打开本地相册
    public void openAlbum() {
        Intent intentFromGallery = new Intent(Intent.ACTION_PICK, null);
        intentFromGallery.setDataAndType(MediaStore.Images.Media.EXTERNAL_CONTENT_URI, "image/*");
        List<ResolveInfo> resolveInfos = getPackageManager().queryIntentActivities(intentFromGallery
                ,PackageManager.MATCH_DEFAULT_ONLY);
        if(resolveInfos.size()!=0){
            startActivityForResult(intentFromGallery, PICK_IMAGE_ACTIVITY_REQUEST_CODE);
        }else{
            ToastUtils.showShort(this,getString(R.string.ykf_no_imagepick));
        }
    }

    /**
     * 打开评价对话框
     */
    private void openInvestigateDialog(boolean isFromButton) {
        //判断是否是机器人
        if (isRobot) {
            openRobotInvestigateDialog();
        } else {//人工
            boolean CSRAging = spData.getBoolean("CSRAging", false);
            String timestamp = spData.getString("SERVERTIMESTAMP", "");
            if (INVITATION_INVESTIGATE && isFromButton && CSRAging && !"".equals(timestamp)) {
                checkImCsrTimeout();
            } else {
                showInvestigateDialog(false);
            }

        }
    }

    /**
     * 判断评价是否超时
     */
    private void checkImCsrTimeout() {
        if (loadingDialog != null) {
            loadingDialog.show(this.getSupportFragmentManager(), "");
        }
        IMChatManager.getInstance().checkImCsrTimeout(new onResponseListener() {
            @Override
            public void onSuccess() {
                if (loadingDialog != null) {
                    loadingDialog.dismiss();
                }
                showInvestigateDialog(false);
            }

            @Override
            public void onFailed() {
                ToastUtils.showShort(ChatActivity.this,getString(R.string.ykf_httpfun_error));
                if (loadingDialog != null) {
                    loadingDialog.dismiss();
                }
            }

            @Override
            public void onTimeOut() {
                ToastUtils.showShort(ChatActivity.this,getString(R.string.ykf_evaluation_timeout));
                if (loadingDialog != null) {
                    loadingDialog.dismiss();
                }
            }
        });

    }


    /**
     * 打开评价框
     * 1.点击注销或者返回键触发
     * 2.主动点击评价按钮
     *
     * @param logOutOrBackPressed true：点击注销或者返回键触发
     */
    private void showInvestigateDialog(final boolean logOutOrBackPressed) {
        if (!hasSet) {
            return;
        }
        if (dialog != null && dialog.getDialog() != null && dialog.getDialog().isShowing()) {
            return;
        }
        dialog = new InvestigateDialog(new InvestigateDialog.SubmitPingjiaListener() {
            @Override
            public void OnSubmitSuccess() {
                if (logOutOrBackPressed) {
                    //去掉开关
                    IMChat.getInstance().setLianXiangOn(false);
                    IMChat.getInstance().setBotsatisfaOn(false);
                    //评价成功
                    IMChatManager.getInstance().quitSDk();
                    finish();
                } else {
                    //评价成功需要标记成已评价，按钮隐藏
                    isInvestigate = false;//已经评价过了
                    setChatMoreList();
                }

            }

            @Override
            public void OnSubmitCancle() {
                if (logOutOrBackPressed) {
                    IMChatManager.getInstance().quitSDk();
                    finish();
                } else if (INVITATION_INVESTIGATE) {
                    getInvestigateTime();
                }


            }

            @Override
            public void OnSubmitFailed() {
                if (logOutOrBackPressed) {
                    IMChatManager.getInstance().quitSDk();
                    finish();
                } else {
                    isInvestigate = true;
                }

            }
        });
        dialog.show(getFragmentManager(), "InvestigateDialog");
    }

    /**
     * 取消评价
     * 1.点击注销/坐席结束会话后若  弹出评价框，点击取消,退出页面；ok
     * 2.主动点击评价按钮/坐席推送的评价，点击取消,请求接口;ok
     */
    private void getInvestigateTime() {
        IMChatManager.getInstance().getServerTime();
    }

    // 打开小莫或者xbot机器人评价
    private void openRobotInvestigateDialog() {
        final String[] items = new String[]{getString(R.string.ykf_solved_ok),
                getString(R.string.ykf_solved_fail),getString(R.string.cancel)};

        AlertDialog builder = new AlertDialog.Builder(ChatActivity.this)
                .setTitle(getString(R.string.ykf_evaluation_robot))

                .setItems(items, new DialogInterface.OnClickListener() {
                    @Override
                    public void onClick(DialogInterface dialog, int which) {
                        if (which == 2) {
                            return;
                        } else {
                            String solve = which == 0 ? "true" : "false";
                            GlobalSet globalSet = GlobalSetDao.getInstance().getGlobalSet();
                            if ("xbot".equals(globalSet.robotType)) {//xobot机器人评价接口
                                HttpManager.getRobotCsrInfo(solve, new HttpResponseListener() {
                                    @Override
                                    public void onSuccess(String responseStr) {
                                        robotEvaluationFinish = true;
                                        ToastUtils.showLong(ChatActivity.this,getString(R.string.ykf_robot_evaluation_ok));
                                        setChatMoreList();

                                    }

                                    @Override
                                    public void onFailed() {
                                        robotEvaluationFinish = false;
                                        ToastUtils.showLong(ChatActivity.this,getString(R.string.ykf_robot_evaluation_fail));
                                    }
                                });
                            } else {
                                HttpManager.getRobotCsrInfo(IMChat.getInstance().getBotId(), solve, new HttpResponseListener() {
                                    @Override
                                    public void onSuccess(String responseStr) {
                                        robotEvaluationFinish = true;
                                        ToastUtils.showLong(ChatActivity.this,getString(R.string.ykf_robot_evaluation_ok));
                                        //机器人不执行是否评价过接口
                                        setChatMoreList();

                                    }

                                    @Override
                                    public void onFailed() {
                                        robotEvaluationFinish = false;
                                        ToastUtils.showLong(ChatActivity.this,getString(R.string.ykf_robot_evaluation_fail));
                                    }
                                });
                            }
                        }
                    }
                }).create();
        builder.show();
    }

    // 拍照回调
    @Override
    protected void onActivityResult(int requestCode, int resultCode, Intent data) {
        super.onActivityResult(requestCode, resultCode, data);
        if (requestCode == PICK_IMAGE_ACTIVITY_REQUEST_CODE) {
            if (resultCode == RESULT_OK) {
                Uri uri = data.getData();
                if (uri != null) {
                    String realPath = PickUtils.getPath(ChatActivity.this, uri);
                    picFileFullName = realPath;
                    Log.d("发送图片消息了", "图片的本地路径是：" + picFileFullName);
                    //准备发送图片消息
                    FromToMessage fromToMessage = IMMessage.createImageMessage(picFileFullName);
                    ArrayList fromTomsgs = new ArrayList<FromToMessage>();
                    fromTomsgs.add(fromToMessage);
                    descFromToMessage.addAll(fromTomsgs);
                    chatAdapter.notifyDataSetChanged();
                    mChatList.setSelection(descFromToMessage.size());
                    resetBreakTimer();
                    IMChat.getInstance().sendMessage(fromToMessage, new ChatListener() {
                        @Override
                        public void onSuccess() {
                            updateMessage();
                        }

                        @Override
                        public void onFailed() {
                            updateMessage();
                        }

                        @Override
                        public void onProgress(int progress) {

                        }
                    });
                } else {
                    Log.e(tag, "从相册获取图片失败");
                }
            }
        } else if (requestCode == PICK_FILE_ACTIVITY_REQUEST_CODE && resultCode == Activity.RESULT_OK) {
            Uri uri = data.getData();//得到uri，后面就是将uri转化成file的过程。
            String path = PickUtils.getPath(ChatActivity.this, uri);
            if (!NullUtil.checkNULL(path)) {
                Toast.makeText(ChatActivity.this, getString(R.string.ykf_not_support_file), Toast.LENGTH_SHORT).show();
                return;
            }
            File file = new File(path);
            String fileSizeStr = "";
            if (file.exists()) {
                long fileSize = file.length();
                if ((fileSize / 1024 / 1024) > 200.0) {
                    //大于200M不能上传
                    Toast.makeText(ChatActivity.this, R.string.sendfiletoobig, Toast.LENGTH_SHORT).show();
                } else {
                    fileSizeStr = FileUtils.formatFileLength(fileSize);
                    String fileName = path.substring(path.lastIndexOf("/") + 1);
                    //发送文件
                    FromToMessage fromToMessage = IMMessage.createFileMessage(path, fileName, fileSizeStr);
                    ArrayList fromTomsgs = new ArrayList<FromToMessage>();
                    fromTomsgs.add(fromToMessage);
                    descFromToMessage.addAll(fromTomsgs);
                    chatAdapter.notifyDataSetChanged();
                    mChatList.setSelection(descFromToMessage.size());
                    resetBreakTimer();
                    IMChat.getInstance().sendMessage(fromToMessage, new ChatListener() {
                        @Override
                        public void onSuccess() {
                            updateMessage();
                        }

                        @Override
                        public void onFailed() {
                            updateMessage();
                        }

                        @Override
                        public void onProgress(int progress) {
                            updateMessage();
                        }
                    });
                }
            }
        }

    }

    // 覆盖手机返回键
    @Override
    public void onBackPressed() {
        if (dialog != null && dialog.getDialog() != null && dialog.getDialog().isShowing()) {
            return;
        }
       if (mMore.getVisibility() == View.VISIBLE) {
            mMore.setVisibility(View.GONE);
            mChatEmojiNormal.setVisibility(View.VISIBLE);
            mChatEmojiChecked.setVisibility(View.INVISIBLE);
        } else {
            handleLogOutOrBackPressed();

        }
    }

    @Override
    protected void onDestroy() {

        if (mHashSet.size() > 0) {
            Iterator<String> iterator = mHashSet.iterator();
            while (iterator.hasNext()) {
                String _id = iterator.next();
                IMChatManager.getInstance().updateOrderInfo(_id, "2");
            }
        }
        if (handler != null) {
            handler.removeCallbacksAndMessages(null);
        }
        unregisterReceiver(msgReceiver);
        unregisterReceiver(keFuStatusReceiver);
        mRecorderButton.cancelListener();
        if (break_timer != null) {
            break_timer.cancel();
            break_timer = null;
        }
        if (break_tip_timer != null) {
            break_tip_timer.cancel();
            break_tip_timer = null;
        }
        if (breakTimerTask != null) {
            breakTimerTask.cancel();
        }
        if (breakTipTimerTask != null) {
            breakTipTimerTask.cancel();
        }
        IMChat.getInstance().setCancel(true);
        //删除卡片信息
        MessageDao.getInstance().delecteCardMsgs();
        MessageDao.getInstance().delecteNewCardMsgs();
        EventBus.getDefault().unregister(this);

        super.onDestroy();
    }

    @Override
    protected void onPause() {
        super.onPause();
        chatAdapter.onPause();
        isFront=false;
    }

    @Override
    public void toRefresh() {
        if (JZflag) {
            JZflag = false;
            new Thread() {
                public void run() {
                    try {
                        sleep(300);
                        handler.sendEmptyMessage(HANDLER_MSG_MORE);
                    } catch (InterruptedException e) {
                        e.printStackTrace();
                    }

                }

                ;
            }.start();
        }
    }

    /**
     * 新消息接收器,用来通知界面进行更新
     */
    class MsgReceiver extends BroadcastReceiver {

        @Override
        public void onReceive(Context context, Intent intent) {
            handler.sendEmptyMessage(HANDLER_MSG);
        }
    }

    /**
     * 客服状态接收器
     */
    class KeFuStatusReceiver extends BroadcastReceiver {
        @Override
        public void onReceive(Context context, Intent intent) {
            String action = intent.getAction();
            if (IMChatManager.ROBOT_ACTION.equals(action)) {
                //当前是机器人
                handler.sendEmptyMessage(HANDLER_ROBOT);
            } else if (IMChatManager.ONLINE_ACTION.equals(action)) {
                //当前是客服在线
                handler.sendEmptyMessage(HANDLER_ONLINE);
            } else if (IMChatManager.OFFLINE_ACTION.equals(action)) {
                //当前是客服离线
                handler.sendEmptyMessage(HANDLER_OFFNLINE);
            } else if (IMChatManager.INVESTIGATE_ACTION.equals(action)) {
                //客服发起了评价
                handler.sendEmptyMessage(HANDLER_INVESTIGATE);
            } else if (IMChatManager.QUEUENUM_ACTION.equals(action)) {
                //技能组排队数
                if (intent.getStringExtra(IMChatManager.QUEUENUM_ACTION) != null) {
                    String queueNum = intent.getStringExtra(IMChatManager.QUEUENUM_ACTION);
                    Message queueMsg = Message.obtain();
                    queueMsg.what = HANDLER_QUEUENUM;
                    queueMsg.obj = queueNum;
                    handler.sendMessage(queueMsg);
                }
            } else if (IMChatManager.CLIAM_ACTION.equals(action)) {
                //客服领取了会话或者转人工
                handler.sendEmptyMessage(HANDLER_CLIAM);
            } else if (IMChatManager.LEAVEMSG_ACTION.equals(action)) {
                //schedule 跳留言
                schedule_id = intent.getStringExtra(IMChatManager.CONSTANT_ID);
                schedule_topeer = intent.getStringExtra(IMChatManager.CONSTANT_TOPEER);
                handler.sendEmptyMessage(HANDLER_LEAVEMSG);
            } else if (IMChatManager.FINISH_ACTION.equals(action)) {
                //客服关闭了会话
                handler.sendEmptyMessage(HANDLER_FINISH);
            } else if (IMChatManager.USERINFO_ACTION.equals(action)) {
                //客服信息
                String type = intent.getStringExtra(IMChatManager.CONSTANT_TYPE);
                String exten = intent.getStringExtra(IMChatManager.CONSTANT_EXTEN);
                String userName = intent.getStringExtra(IMChatManager.CONSTANT_USERNAME);
                String userIcon = intent.getStringExtra(IMChatManager.CONSTANT_USERICON);

                // 转人工
                if ("claim".equals(type)) {
                    mOtherName.setText(NullUtil.checkNull(userName) + getString(R.string.seiveceforyou));
                    titleName = NullUtil.checkNull(userName) + getString(R.string.seiveceforyou);
                }
                // 坐席领取了会话
                if ("activeClaim".equals(type)) {
                    mOtherName.setText(NullUtil.checkNull(userName) + getString(R.string.seiveceforyou));
                    titleName = NullUtil.checkNull(userName) + getString(R.string.seiveceforyou);
                }
                if ("redirect".equals(type)) {
                    mOtherName.setText(NullUtil.checkNull(userName) + getString(R.string.seiveceforyou));
                    titleName = NullUtil.checkNull(userName) + getString(R.string.seiveceforyou);
                }
                if ("robot".equals(type)) {
                    mOtherName.setText(NullUtil.checkNull(userName) + getString(R.string.seiveceforyou));
                    titleName = NullUtil.checkNull(userName) + getString(R.string.seiveceforyou);
                }
            } else if (IMChatManager.VIPASSIGNFAIL_ACTION.equals(action)) {
                //专属座席不在线
                handler.sendEmptyMessage(HANDLER_VIPASSIGNFAIL);
            } else if (IMChatManager.CANCEL_ROBOT_ACCESS_ACTION.equals(action)) {
                //人工干预
                Toast.makeText(ChatActivity.this, R.string.receivepeopleaction, Toast.LENGTH_SHORT).show();
            } else if (IMChatManager.WITHDRAW_ACTION.equals(action)) {
                //消息撤回
                String id = intent.getStringExtra(IMChatManager.WITHDEAW_ID);
                MessageDao.getInstance().updateMsgWithDrawStatus(id);
                handler.sendEmptyMessage(HANDLER_MSG);
            } else if (IMChatManager.WRITING_ACTION.equals(action)) {
                //对方正在输入
                handler.sendEmptyMessage(HANDLER_WRITING);
                handler.sendEmptyMessageDelayed(HANDLER_NO_WRITING, 5000);
            } else if (IMChatManager.ROBOT_SWITCH_ACTION.equals(action)) {
                //robotSwitch
                String status = intent.getStringExtra(IMChatManager.CONSTANT_ROBOT_SWITCH);
                String sessionId = intent.getStringExtra(IMChatManager.CONSTANT_SESSIONID);
            } else if (IMChatManager.TCP_ACTION.equals(action)) {
                //tcp状态
                String tcpstatus = intent.getStringExtra(IMChatManager.TCPSTATUS);
//            } else if (IMChatManager.UNASSIGN_ACTION.equals(action)){
//                //开启 访客说话后再接入会话
//                chat_tv_convert.setVisibility(View.GONE);
            } else if (IMChatManager.ZXMSG_ACTION.equals(action)) { //坐席发了消息
                //如果没有回复过，执行接口校验是否回复过
                if (!isZXResply) {
                    OnlycheckConverstaion();//这个时候校验是否回复过，刷新UI
//                    setChatMoreList();
                }
            }
        }
    }


    /**
     * 人工客服设置更多功能专用
     */
    private void setChatMoreList() {
        moreList.clear();
        moreList.add(chatMore2);
        moreList.add(chatMore3);
        NotAllowCustomerPushCsr=spData.getBoolean("NotAllowCustomerPushCsr",false);
        // TODO: 2019/5/22 访客发过消息存在sp是否更安全，因为用户退出再重新进入会话的时候，可能之前已经发送过了。
        //人工，开启了评价,坐席发过消息、会话存在，访客发过消息，没有评价过,配置了满意度列表
        if (!isRobot && IMChatManager.getInstance().isInvestigateOn() && convesationIsLive && isZXResply &&
                isInvestigate && hasSet && hasSendPersonMsg&&!NotAllowCustomerPushCsr) {
            //展示评价按钮
            if (!moreList.contains(chatMore4)) {
                moreList.add(chatMore4);
            }
        }
        //判断是小莫还是xbot
        GlobalSet globalSet = GlobalSetDao.getInstance().getGlobalSet();
        // 如果是机器人，并且还未评价过,并且已经发送过消息
        if (isRobot && !robotEvaluationFinish && hasSendRobotMsg) {
            if ("xbot".equals(globalSet.robotType)) {
                if (isRobot && !robotEvaluationFinish && hasSendRobotMsg && IMChat.getInstance().getBotsatisfaOn()) {
                    if (!moreList.contains(chatMore4)) {
                        moreList.add(chatMore4);
                    }
                }
            } else {
                // 并且小陌机器人开启了评价
                if (IMChat.getInstance().getBotsatisfaOn()) {
                    if (!moreList.contains(chatMore4)) {
                        moreList.add(chatMore4);
                    }
                }
            }
        }

        //如果在排队
        if (isQueue) {
            if (moreList.contains(chatMore4)) {
                moreList.remove(chatMore4);
            }
        }
        moreList.add(chatMore5);


//        if ("1".equals(NullUtil.checkNull(globalSet.videoChatOn))) {
//            ChatMore chatMore6 = new ChatMore(6, R.drawable.kf_icon_chat_video + "",
//                    "视频");
//            moreList.add(chatMore6);
//        }
        moreLists.clear();
        int pageCount = (int) Math.ceil(moreList.size() / 8 + 0.1);
        for (int i = 0; i < pageCount; i++) {
            moreLists.add(getData(i));
        }


        initMoreViewPager();
        initMorePoint();
        initMoreData();
    }

    /**
     * 只校验会话是否有效（收到坐席发消息推送后调用，刷新评论按钮UI）
     */
    private void OnlycheckConverstaion() {
        //人工会话 校验会话是否有效
        HttpManager.getChatSession(new HttpResponseListener() {

            @Override
            public void onSuccess(String responseStr) {
                LogUtils.eTag("huihua", responseStr);
                JSONObject jsonObject = null;
                try {
                    jsonObject = new JSONObject(responseStr);
                    JSONObject data = jsonObject.getJSONObject("data");
                    if (data != null) {//会话存在
                        convesationIsLive = true;
                        id = data.getString("_id");//会话id
                        if (data.has("replyMsgCount")) {
                            if (data.getInt("replyMsgCount") > 0) {
                                //代表坐席回复过
                                isZXResply = true;
                            } else {
                                isZXResply = false;
                            }
                        } else {
                            isZXResply = false;
                        }

                    } else {
                        //会话不存在
                        convesationIsLive = false;
                    }
                    setChatMoreList();//接口都走完了初始化UI
                } catch (JSONException e) {
                    e.printStackTrace();
                }
                setChatMoreList();
            }

            @Override
            public void onFailed() {
                //判断是否存在会话要是返回失败了，先按照存在该会话,并且可以评论处理。 当我们评论的时候，后台会提示一个评论过了的提示语
//                convesationIsLive = true;
//                isInvestigate = false;
//                setChatMoreList();
            }
        });
    }


    /**
     * 判断是否是有效会话，并且是否评价过
     *
     * @param
     */
    private void checkConverstaion() {
        //人工会话 校验会话是否有效
        HttpManager.getChatSession(new HttpResponseListener() {

            @Override
            public void onSuccess(String responseStr) {
                LogUtils.eTag("huihua", responseStr);
                JSONObject jsonObject = null;
                try {
                    jsonObject = new JSONObject(responseStr);
                    JSONObject data = jsonObject.getJSONObject("data");
                    if (data != null) {//会话存在
                        convesationIsLive = true;
                        id = data.getString("_id");//会话id
                        if (data.has("replyMsgCount")) {
                            if (data.getInt("replyMsgCount") > 0) {
                                //代表坐席回复过
                                isZXResply = true;
                            } else {
                                isZXResply = false;
                            }
                        } else {
                            isZXResply = false;
                        }
                        //校验是否已经评价过
                        HttpManager.checkIsAppraised(id, new HttpResponseListener() {
                            @Override
                            public void onSuccess(String responseStr) {
                                try {
                                    JSONObject jsonObject1 = new JSONObject(responseStr);
                                    isInvestigate = jsonObject1.getBoolean("isInvestigate");
                                    setChatMoreList();//接口都走完了初始化UI
                                } catch (JSONException e) {
                                    ToastUtils.showShort(ChatActivity.this,e.toString());
                                }
                                LogUtils.eTag("piangjia", responseStr);
                            }

                            @Override
                            public void onFailed() {
                                //请求失败的话默认 先按没有评价过处理
//                                isInvestigate = false;
                            }
                        });
                    } else {
                        //会话不存在
                        convesationIsLive = false;
                    }

                } catch (JSONException e) {
                    e.printStackTrace();
                }

            }

            @Override
            public void onFailed() {
                //判断是否存在会话要是返回失败了，先按照存在该会话,并且可以评论处理。 当我们评论的时候，后台会提示一个评论过了的提示语
//                convesationIsLive = true;
//                isInvestigate = false;
            }
        });
    }

    /**
     * 首次进入开启会话
     * {@link #getResponseListener }
     *
     * @param peerId 技能组Id
     */
    private void beginSession(String peerId) {
        if (IMChatManager.getInstance().getAppContext() == null) {
            return;
        }
        //JSONObject j1中可配置您的想要添加的扩展字段,
        //key与value根据需求要自定义。
        JSONObject j1 = new JSONObject();
        //将j1 添加到JSONObject j2中，注意 j2段代码必须是如下配置。
        //不可修改与增加j2 中的key value。直接复制即可。
        JSONObject j2 = new JSONObject();


//            j1.put("vip","true");
//            j1.put("city","beijing");
//            JSONObject j3 = new JSONObject();
//            j3.put("user_labels",j1.toString());
//
//
//            String s="{\"user_labels\":{\"vip\":\"true\",\"city\":\"beijing\"}}";
//            j2.put("customField",URLEncoder.encode(s));

            // TODO: 2019/10/30 这里增加 扩展信息内容，参照文档的传参方式，
        IMChatManager.userId = InfoDao.getInstance().getUserId();
        HttpManager.beginNewChatSession(InfoDao.getInstance().getConnectionId()
                , IMChatManager.getInstance().getIsNewVisitor()
                , peerId
                , ""
                , getResponseListener(true));

    }

    /**
     * 开启日程会话
     * *{@link #getResponseListener }
     *
     * @param scheduleId    日程Id
     * @param processId
     * @param currentNodeId
     * @param entranceId
     */
    private void beginScheduleSession(String scheduleId, String processId, String currentNodeId, String entranceId) {
        if (IMChatManager.getInstance().getAppContext() == null) {
            return;
        }
        IMChatManager.userId = InfoDao.getInstance().getUserId();
        HttpManager.beginNewScheduleChatSession(InfoDao.getInstance().getConnectionId()
                , IMChatManager.getInstance().getIsNewVisitor()
                , scheduleId
                , processId
                , currentNodeId
                , entranceId
                , ""
                , getResponseListener(false));
    }

    /**
     * 首次开启会话和日程会话 接口回调
     *
     * @param fromBeginSession 是否是首次开启会话的回调
     * @return HttpResponseListener
     */
    private HttpResponseListener getResponseListener(final boolean fromBeginSession) {
        return new HttpResponseListener() {
            @Override
            public void onSuccess(String responseString) {
                LogUtils.aTag("开始会话", responseString);
                if (loadingDialog != null) {
                    loadingDialog.dismiss();
                }
                String succeed = HttpParser.getSucceed(responseString);
                if ("true".equals(succeed)) {
                    try {
                        JSONObject jsonObject = new JSONObject(responseString);
                        JSONObject config = jsonObject.getJSONObject("Config");
                        if (config.has("systemMsgLogo")) {
                            spData.edit().putString(Constants.SYSTEMMSGLOGO,config.getString("systemMsgLogo")).apply();
                            String string = spData.getString(Constants.SYSTEMMSGLOGO, "");
                            LogUtils.dTag("systemMsgLogo=",string);

                        }

                        //人工满意度评价
                        IMChatManager.getInstance().setIsInvestigateOn(config.getBoolean("webchat_csr"));
                        //是否显示转人工按钮
                        boolean showTransferBtn = config.getBoolean("showTransferBtn");

                        IMChatManager.getInstance().setIsShowTransferBtn(showTransferBtn);
                        LogUtils.dTag("handleMessage==", "getResponseListener====showTransferBtn===" + showTransferBtn);
                        chat_tv_convert.setVisibility(fromBeginSession && isRobot && showTransferBtn ? View.VISIBLE : View.GONE);
                        if (jsonObject.has("bottomList")) {//有滑动导航;机器人并且有bottomlist数据
                            IMChatManager.getInstance().setIsShowBottomList(true);
                            JSONArray list = jsonObject.getJSONArray("bottomList");
                            IMChatManager.getInstance().setBottomList(list);
                            rvTagLabel.setVisibility(View.VISIBLE);
                            if (list != null) {
                                try {
                                    JSONArray bottomList = IMChatManager.getInstance().getBottomList();
                                    for (int j = 0; j < bottomList.length(); j++) {
                                        JSONObject jb = bottomList.getJSONObject(j);
                                        FlowBean flowBean = new FlowBean();
                                        flowBean.setButton(jb.getString("button"));
                                        flowBean.setText(jb.getString("text"));
                                        flowBeanList.add(flowBean);
                                    }

                                    tagLabeAdapter.refreshData(flowBeanList);
                                } catch (Exception e) {
                                    rvTagLabel.setVisibility(View.GONE);
                                }
                            }

                        } else {
                            rvTagLabel.setVisibility(View.GONE);
                        }
                    } catch (JSONException e) {
                        e.printStackTrace();
                    }

                } else {
                    if (loadingDialog != null) {
                        loadingDialog.dismiss();
                    }
                    ToastUtils.showShort(ChatActivity.this,getString(R.string.ykf_chatbegin_fail));
                    finish();
//                    chat_tv_convert.setVisibility(View.GONE);
//                    rvTagLabel.setVisibility(View.GONE);
//                    showOffLineDialog();
//                    if (fromBeginSession) {
//                        IMChatManager.getInstance().setIsShowBottomList(false);
//                    }
                }
            }

            @Override
            public void onFailed() {
                if (loadingDialog != null) {
                    loadingDialog.dismiss();
                }
                ToastUtils.showShort(ChatActivity.this,getString(R.string.ykf_chatbegin_fail));
                finish();
//                chat_tv_convert.setVisibility(View.GONE);
//                rvTagLabel.setVisibility(View.GONE);
//                showOffLineDialog();
//                if (fromBeginSession) {
//                    IMChatManager.getInstance().setIsShowBottomList(false);
//                }

            }
        };
    }

    private void showOffLineDialog() {

        if (type.equals("schedule")) {
            return;
        }
        GlobalSet globalSet = GlobalSetDao.getInstance().getGlobalSet();

        if (null != globalSet) {
            if (isRobot) {
                bar_bottom.setVisibility(View.VISIBLE);
            } else {
                bar_bottom.setVisibility(View.GONE);
            }

            if ("1".equals(NullUtil.checkNull(globalSet.isLeaveMsg))) {
                Intent intent = new Intent(ChatActivity.this, OfflineMessageActicity.class);
                intent.putExtra("PeerId", peerId);
                intent.putExtra("leavemsgTip", NullUtil.checkNull(globalSet.leavemsgTip));
                intent.putExtra("inviteLeavemsgTip", NullUtil.checkNull(globalSet.inviteLeavemsgTip));
                startActivity(intent);
                finish();
            } else {
                try {
                    new AlertDialog.Builder(this).setTitle(R.string.warm_prompt)
                            .setMessage(NullUtil.checkNull(globalSet.msg))
                            .setPositiveButton(R.string.iknow, new DialogInterface.OnClickListener() {
                                @Override
                                public void onClick(DialogInterface dialogInterface, int i) {
                                    IMChatManager.getInstance().quitSDk();
                                    finish();
                                }
                            })
                            .setCancelable(false)
                            .create()
                            .show();
                } catch (Exception e) {
                    e.printStackTrace();
                }
            }
        }
    }

    public ChatAdapter getChatAdapter() {
        return chatAdapter;
    }

    public void resendMsg(FromToMessage msg, int position) {
        if (IMChatManager.getInstance().isFinishWhenReConnect) {
            startReStartDialog();
        } else {
            resetBreakTimer();
            IMChat.getInstance().reSendMessage(msg, new ChatListener() {
                @Override
                public void onSuccess() {
                    updateMessage();
                }

                @Override
                public void onFailed() {
                    updateMessage();
                }

                @Override
                public void onProgress(int progress) {
                    updateMessage();
                }
            });
        }

    }


    /**
     * 两种卡片类型点击发送时的调用；
     * {@link ChatListClickListener}
     *
     * @param msg
     * @param type 旧卡片：FromToMessage.MSG_TYPE_CARDINFO
     *             新卡片：FromToMessage.MSG_TYPE_NEW_CARD_INFO
     */
    public void sendCardMsg(FromToMessage msg, String type) {
        FromToMessage fromToMessage = new FromToMessage();
        fromToMessage.userType = "0";
        fromToMessage.message = "";
        fromToMessage.msgType = type;
        fromToMessage.when = System.currentTimeMillis();
        fromToMessage.sessionId = IMChat.getInstance().getSessionId();
        fromToMessage.tonotify = IMChat.getInstance().get_id();
        fromToMessage.type = "User";
        fromToMessage.from = IMChat.getInstance().get_id();
        if (msg.cardInfo != null) {
            fromToMessage.cardInfo = msg.cardInfo;
        }
        if (msg.newCardInfo != null) {
            fromToMessage.newCardInfo = msg.newCardInfo;
        }
        sendSingleMessage(fromToMessage);

    }

    /**
     * 共用方法：发送一条消息
     *
     * @param fromToMessage
     */
    private void sendSingleMessage(FromToMessage fromToMessage) {
        //界面显示
        descFromToMessage.add(fromToMessage);
        chatAdapter.notifyDataSetChanged();
        mChatList.setSelection(descFromToMessage.size());
        mChatInput.setText("");

        resetBreakTimer();

        //发送消息
        IMChat.getInstance().sendMessage(fromToMessage, new ChatListener() {
            @Override
            public void onSuccess() {
                //消息发送成功
                updateMessage();
            }

            @Override
            public void onFailed() {
                //消息发送失败
                updateMessage();
            }

            @Override
            public void onProgress(int progress) {

            }
        });
    }

    private void getIsGoSchedule() {
        IMChatManager.getInstance().getWebchatScheduleConfig(new GetGlobleConfigListen() {
            @Override
            public void getSchedule(ScheduleConfig sc) {
                // loadingDialog.dismiss();
                LogUtils.aTag("MainActivity", "日程");
                if (!sc.getScheduleId().equals("") && !sc.getProcessId().equals("") && sc.getEntranceNode() != null && sc.getLeavemsgNodes() != null) {
                    if (sc.getEntranceNode().getEntrances().size() > 0) {
                        if (sc.getEntranceNode().getEntrances().size() == 1) {
                            ScheduleConfig.EntranceNodeBean.EntrancesBean bean = sc.getEntranceNode().getEntrances().get(0);
                            // TODO: 2019-12-24 修改为Builder方式
                            new ChatActivity.Builder()
                                    .setType(Constants.TYPE_SCHEDULE)
                                    .setScheduleId(scheduleId)
                                    .setProcessId(processId)
                                    .setCurrentNodeId(bean.getProcessTo())
                                    .setProcessType(bean.getProcessType())
                                    .setEntranceId(bean.get_id())
                                    .build(ChatActivity.this);
//                            ChatActivity.startActivity(ChatActivity.this, Constants.TYPE_SCHEDULE, sc.getScheduleId(), sc.getProcessId(), bean.getProcessTo(), bean.getProcessType(), bean.get_id());
                        } else {
                            startScheduleDialog(sc.getEntranceNode().getEntrances(), sc.getScheduleId(), sc.getProcessId());
                        }

                    } else {
                        ToastUtils.showShort(ChatActivity.this,R.string.sorryconfigurationiswrong);
                    }
                } else {
                    ToastUtils.showShort(ChatActivity.this,R.string.sorryconfigurationiswrong);
                }
            }

            @Override
            public void getPeers() {
                LogUtils.aTag("start", "技能组");
                startChatActivityForPeer();
            }
        });
    }

    private void startScheduleDialog(final List<ScheduleConfig.EntranceNodeBean.EntrancesBean> entrances, final String scheduleId, final String processId) {
        final String[] items = new String[entrances.size()];
        for (int i = 0; i < entrances.size(); i++) {
            items[i] = entrances.get(i).getName();
        }

        AlertDialog dialog = new AlertDialog.Builder(ChatActivity.this)
                .setTitle(getString(R.string.ykf_select_scu))
                // 设置列表显示，注意设置了列表显示就不要设置builder.setMessage()了，否则列表不起作用。
                .setItems(items, new DialogInterface.OnClickListener() {
                    @Override
                    public void onClick(DialogInterface dialog, int which) {
                        dialog.dismiss();
                        ScheduleConfig.EntranceNodeBean.EntrancesBean bean = entrances.get(which);
                        LogUtils.aTag("选择日程：", bean.getName());
                        // TODO: 2019-12-24 修改为Builder方式
                        new ChatActivity.Builder()
                                .setType(Constants.TYPE_SCHEDULE)
                                .setScheduleId(scheduleId)
                                .setProcessId(processId)
                                .setCurrentNodeId(bean.getProcessTo())
                                .setProcessType(bean.getProcessType())
                                .setEntranceId(bean.get_id())
                                .build(ChatActivity.this);
//                        ChatActivity.startActivity(ChatActivity.this, Constants.TYPE_SCHEDULE, scheduleId, processId, bean.getProcessTo(), bean.getProcessType(), bean.get_id());

                    }
                }).create();
        dialog.show();
    }

    private void startChatActivityForPeer() {
        IMChatManager.getInstance().getPeers(new GetPeersListener() {
            @Override
            public void onSuccess(List<Peer> peers) {

                if (peers.size() > 1) {
                    startPeersDialog(peers, IMChatManager.getInstance().cardInfo);
                } else if (peers.size() == 1) {
                    // TODO: 2019-12-24 修改为Builder方式
                    new ChatActivity.Builder()
                            .setType(Constants.TYPE_PEER)
                            .setPeerId(peers.get(0).getId())
                            .setCardInfo(IMChatManager.getInstance().cardInfo)
                            .setNewCardInfo(IMChatManager.getInstance().newCardInfo)
                            .build(ChatActivity.this);
//                    ChatActivity.startActivity(ChatActivity.this, Constants.TYPE_PEER, peers.get(0).getId(), IMChatManager.getInstance().cardInfo);
                } else {
                    ToastUtils.showShort(ChatActivity.this,R.string.peer_no_number);
                }
                // loadingDialog.dismiss();
            }

            @Override
            public void onFailed() {
                // loadingDialog.dismiss();
            }
        });
    }

    public void startPeersDialog(final List<Peer> peers, final CardInfo mCardInfo) {
        final String[] items = new String[peers.size()];
        for (int i = 0; i < peers.size(); i++) {
            items[i] = peers.get(i).getName();
        }
        AlertDialog builder = new AlertDialog.Builder(ChatActivity.this)
                .setTitle(getString(R.string.ykf_select_peer))
                // 设置列表显示，注意设置了列表显示就不要设置builder.setMessage()了，否则列表不起作用。
                .setItems(items, new DialogInterface.OnClickListener() {
                    @Override
                    public void onClick(DialogInterface dialog, int which) {
                        dialog.dismiss();
                        Peer peer = peers.get(which);
                        LogUtils.aTag("选择技能组：", peer.getName());
                        // TODO: 2019-12-24 修改为Builder方式
                        new ChatActivity.Builder()
                                .setType(Constants.TYPE_PEER)
                                .setPeerId(peer.getId())
                                .setCardInfo(mCardInfo)
                                .setNewCardInfo(IMChatManager.getInstance().newCardInfo)
                                .build(ChatActivity.this);
//                        ChatActivity.startActivity(ChatActivity.this, Constants.TYPE_PEER, peer.getId(), mCardInfo);
                    }
                }).create();
        builder.show();
    }

    public void startReStartDialog() {
        //设置聊天背景
        new ActionSheetDialog(this)
                .builder()
                .setCancelable(true)
                .setCanceledOnTouchOutside(true)
                .setTitle(getString(R.string.ykf_chatfinish_reopen))
                .addSheetItem(
//                        this.getResources().getString(R.string.restartchat),
                        getString(R.string.ykf_chatbegin),
                        ActionSheetDialog.SheetItemColor.Blue, new ActionSheetDialog.OnSheetItemClickListener() {
                            @Override
                            public void onClick(int which) {
                                getIsGoSchedule();
                            }
                        })
                .addSheetItem(
//                        this.getResources().getString(R.string.exitchat),
                        getString(R.string.back),
                        ActionSheetDialog.SheetItemColor.Blue, new ActionSheetDialog.OnSheetItemClickListener() {
                            @Override
                            public void onClick(int which) {
                                IMChatManager.getInstance().quitSDk();
                                finish();
                            }
                        }

                ).show();
    }

    public void startReStartDialog2() {
        singleButtonDialog = builder.setMessage("")
                .setMessageDetail(getString(R.string.ykf_nologin_timeout))
                .setSingleButton(getString(R.string.ykf_chatbegin_reconnect), 0xFF459ae9, new View.OnClickListener() {
                    @Override
                    public void onClick(View view) {
                        singleButtonDialog.dismiss();
                        IMChatManager.getInstance().quitSDk();
                        finish();
                    }
                }).createSingleButtonDialog();
        if (!isFinishing())
            singleButtonDialog.show();
    }

    public void startReStartDialog3() {
        singleButtonDialog = builder.setMessage("")
                .setMessageDetail(getString(R.string.ykf_nonetwork_error))
                .setSingleButton(getString(R.string.back), 0xFF459ae9, new View.OnClickListener() {
                    @Override
                    public void onClick(View view) {
                        singleButtonDialog.dismiss();
                        IMChatManager.getInstance().quitSDk();
                        finish();
                    }
                }).createSingleButtonDialog();
        singleButtonDialog.show();
    }

    public ChatListView getChatListView() {
        return mChatList;
    }


    @Override
    public void onRecordFinished(float mTime, String filePath, String pcmFilePath) {
        if (!FileUtils.isExists(filePath)) {
            ToastUtils.showShort(ChatActivity.this,getString(R.string.ykf_recording_error));
            return;
        }
        //先在界面上显示出来
        FromToMessage fromToMessage = IMMessage.createAudioMessage(mTime, filePath, "");
        descFromToMessage.add(fromToMessage);
        chatAdapter.notifyDataSetChanged();
        mChatList.setSelection(descFromToMessage.size());
        sendVoiceMsg("", fromToMessage);
    }

    /**
     * 发送录音消息
     *
     * @param voiceText
     */
    private void sendVoiceMsg(String voiceText, final FromToMessage fromToMessage) {
        fromToMessage.voiceText = voiceText;
        resetBreakTimer();
        IMChat.getInstance().sendMessage(fromToMessage, new ChatListener() {
            @Override
            public void onSuccess() {
                 updateMessage();
            }

            @Override
            public void onFailed() {
                updateMessage();
            }

            @Override
            public void onProgress(int progress) {

            }
        });
//        if(!IMChatManager.getInstance().isManual) {
//            //机器人 自动转为 文本 在发送
//            fromToMessage.isRobot = true;
//            fromToMessage._id = UUID.randomUUID().toString();
//            fromToMessage.accessId = InfoDao.getInstance().getAccessId();
//            fromToMessage.userId = InfoDao.getInstance().getUserId();
//            fromToMessage.peedId = InfoDao.getInstance().getPeedId();
//        }
//
//            IMChat.getInstance().sendMessage(fromToMessage, new ChatListener() {
//                @Override
//                public void onSuccess() {
////                    ToastUtils.showShort("文件上传成功");
//                    if(!IMChatManager.getInstance().isManual) {
//                        //机器人 自动转为 文本 在发送
//                        getVoiceToText(fromToMessage);
//                    }else{
//                        updateMessage();
//                    }
//                }
//
//                @Override
//                public void onFailed() {
//                    updateMessage();
//                }
//
//                @Override
//                public void onProgress(int progress) {
//
//                }
//            });
//

    }

    /**
     * 处理收到的订单信息-店铺点击事件
     *
     * @param target 链接
     */
    public void handleOnClickOfLogisticsShop(String target) {
        Intent forumIntent = new Intent(this, MoorWebCenter.class);
        forumIntent.putExtra("OpenUrl", target);
        forumIntent.putExtra("titleName", "详情");
        startActivity(forumIntent);
    }

    /**
     * 处理收到的订单信息-item点击事件
     *
     * @param
     */
    public void handleOnClickOfLogisticsItem(String _id, String current, OrderInfoBean orderInfoBean) {
        mHashSet.add(_id);
        IMChatManager.getInstance().updateOrderInfo(_id, "1");
        if (moreOrderInfoDialog != null) {
            if (moreOrderInfoDialog.isShowing()) {
                moreOrderInfoDialog.dismiss();
            }
        }
      /*  "msg_task":{
            "current":"AI-4@3de59031ac5b4d40b309ba0325accd10",
            "item":{
                "target":"next",
                "params":{"orderNo":"3"}
            }
        }*/

        FromToMessage fromToMessage = new FromToMessage();
        fromToMessage.userType = "0";
        fromToMessage.message = "发送卡片信息";
        fromToMessage.msgType = FromToMessage.MSG_TYPE_LOGISTICS_INFO_LIST;
        fromToMessage.when = System.currentTimeMillis();
        fromToMessage.sessionId = IMChat.getInstance().getSessionId();
        fromToMessage.tonotify = IMChat.getInstance().get_id();
        fromToMessage.type = "User";
        fromToMessage.from = IMChat.getInstance().get_id();
        if (orderInfoBean != null) {
            fromToMessage.newCardInfo = new Gson().toJson(orderInfoBean);
        }
        MsgTaskBean bean = new MsgTaskBean()
                .setCurrent(current)
                .setItem(new MsgTaskItemBean()
                        .setTarget("next")
                        .setParams(new OrderInfoParams()
                                .setOrderNo(orderInfoBean.getParams().getOrderNo())));

        fromToMessage.msgTask = new Gson().toJson(bean);
        LogUtils.aTag("MsgTaskBean==", new Gson().toJson(bean));
        sendSingleMessage(fromToMessage);

    }

    /**
     * 处理收到的订单信息-查看更多点击事件
     */
    public void handleOnClickOfLogisticsMore(String current, final String _id) {
        if (loadingDialog != null) {
            loadingDialog.show(this.getSupportFragmentManager(), "");
        }
  /* "msg_task":{
            "current":"AI4@3de59031ac5b4d40b309ba0325accd10",
                    "item":{
                "target":"self",
                        "params":"",
                        "page":"all"
            }
        }*/
        MsgTaskBean bean = new MsgTaskBean()
                .setCurrent(current)
                .setItem(new MsgTaskItemBean()
                        .setTarget("self")
                        .setPage("all"));

        String msgTask = new Gson().toJson(bean);
        HttpManager.getMoreOrderInfo(msgTask, new HttpResponseListener() {
            @Override
            public void onSuccess(String responseStr) {
                if (loadingDialog != null) {
                    loadingDialog.dismiss();
                }
                String succeed = HttpParser.getSucceed(responseStr);
                LogUtils.aTag("查看更多返回===：", responseStr);
                if ("true".equals(succeed)) {
                    try {
                        JSONObject o = new JSONObject(responseStr);
                        String message = o.getString("msgTask");
                        if (NullUtil.checkNULL(message)) {
                            Type token = new TypeToken<OrderBaseBean>() {
                            }.getType();
                            final OrderBaseBean orderBaseBean = new Gson().fromJson(message, token);
                            if (orderBaseBean.getData() != null && orderBaseBean.getData().getList() != null) {
                                moreOrderInfoDialog = new BottomSheetLogisticsInfoDialog(orderBaseBean.getData().getList(), orderBaseBean.getCurrent(), _id);
                                moreOrderInfoDialog.show(getSupportFragmentManager(), "");
                            }
                        }
                    } catch (JSONException e) {
                        e.printStackTrace();
                    }
                } else {
                    ToastUtils.showShort(ChatActivity.this,getString(R.string.ykf_loadmore_fail));
                }
            }

            @Override
            public void onFailed() {
                if (loadingDialog != null) {
                    loadingDialog.dismiss();
                }
                ToastUtils.showShort(ChatActivity.this,getString(R.string.ykf_loadmore_fail));
            }
        });
    }

    /**
     * 处理收到的物流信息-查看完整物流信息点击事件
     */
    public void handleOnClickOfLogisticsProgressMore(FromToMessage message) {

        // TODO: 2019-12-31  查看完整物流信息点击事件
        if (message.msgTask != null && !"".equals(message.msgTask)) {
            Type token = new TypeToken<OrderBaseBean>() {
            }.getType();
            final OrderBaseBean orderBaseBean = new Gson().fromJson(message.msgTask, token);
            if (orderBaseBean.getData() != null && orderBaseBean.getData().getList() != null) {
                BottomSheetLogisticsProgressDialog dialog = new BottomSheetLogisticsProgressDialog(orderBaseBean.getData().getList());
                dialog.show(getSupportFragmentManager(), "");
            }
        }
    }

    @Override
    public void onRequestPermissionsResult(int requestCode, @NonNull String[] permissions, @NonNull int[] grantResults) {
        super.onRequestPermissionsResult(requestCode, permissions, grantResults);
        PickUtils.PermissionUtils.onRequestPermissionsResult(this, 0x11, new String[]{Manifest.permission.RECORD_AUDIO, Manifest.permission.WRITE_EXTERNAL_STORAGE}, grantResults);
        PickUtils.PermissionUtils.onRequestPermissionsResult(this, 0x5555, new String[]{Manifest.permission.CAMERA}, grantResults);
    }

    public void onEventMainThread(UnAssignEvent unAssignEvent) {
        chat_tv_convert.setVisibility(View.GONE);
    }

    public void onEventMainThread(ReSendMessage reSendMessage) {
        updateMessage();
    }


    public void onEventMainThread(QuestionEvent questionEvent) {
        updateMessage();
    }

    /**
     * 每次进入聊天页面重新校验tcp是否已经连接，未连接就重新连接一次
     */
    @Override
    protected void onResume() {
        super.onResume();
        isFront=true;
        onEventMainThread(new MsgEvent());//有新消息了，并且页面可见。消费消息
        LogUtils.aTag("chatActivity", "走到OnResume了" + TcpManager.getInstance(this).getTcpStatus());
        if (MoorUtils.isNetWorkConnected(this)) {
            LogUtils.aTag("onresume", "监测到网络ok");

            if(IMChatManager.USE_TCP){
                if (isServiceRunning(this, "com.moor.imkf.tcpservice.service.IMService")) {
                    if (TcpManager.TcpStatus.BREAK.equals(TcpManager.getInstance(this).getTcpStatus())) {
                        EventBus.getDefault().post(new TcpBreakEvent());//重连
                    }
                } else {
                    //服务挂了
                    startReStartDialog2();
                }
            }  else{
                if (isServiceRunning(this, "com.moor.imkf.websocket.SocketService")) {
                    if (!WebSocketHandler.getDefault().isConnect()) {
                        EventBus.getDefault().post(new TcpBreakEvent());//重连
                    }
                } else {
                    //服务挂了
                    startReStartDialog2();
                }

            }



        } else {
            startReStartDialog3();
            LogUtils.aTag("onresume", "监测到网络not ok");
        }
    }



    /**
     * 判断服务是否还活着
     */
    public static boolean isServiceRunning(Context context, String ServiceName) {
        boolean isWork = false;
        if (TextUtils.isEmpty(ServiceName)) {
            isWork = false;
            LogUtils.aTag("runService", "服务名字是空的");
        }
        ActivityManager myManager = (ActivityManager) context
                .getSystemService(Context.ACTIVITY_SERVICE);
        List<ActivityManager.RunningServiceInfo> runningService = myManager
                .getRunningServices(Integer.MAX_VALUE);
        if (runningService.size() <= 0) {
//            isWork = false;
            LogUtils.aTag("runService", "服务数是0");
        }
        for (int i = 0; i < runningService.size(); i++) {
            if (runningService.get(i).service.getClassName().equals(ServiceName)) {
                isWork = true;
                LogUtils.aTag("runService", "服务还活着" + isWork);
                break;
            }
        }
        return isWork;
    }


    /**
     * 联想输入
     */
    private class GetLianXiangDataResponeHandler implements HttpResponseListener {

        @Override
        public void onFailed() {
            ll_hintView.setVisibility(View.GONE);
        }

        @Override
        public void onSuccess(String responseString) {
            System.out.println(responseString);
            String succeed = HttpParser.getSucceed(responseString);
            if ("true".equals(succeed)) {
                ll_hintView.removeAllViews();
                try {
                    JSONObject jsonObject = new JSONObject(responseString);
                    final JSONArray questions = jsonObject.getJSONArray("questions");
                    if (questions.length() > 0) {
                        //如果含有提示文字
                        ll_hintView.setVisibility(View.VISIBLE);
                        for (int j = 0; j < questions.length(); j++) {
                            //首先引入要添加的View
                            View view = View.inflate(ChatActivity.this, R.layout.item_hint_view, null);
                            TextView textView = (TextView) view.findViewById(R.id.tv_hintView);
                            textView.setText(questions.getString(j));
                            final int position = j;
                            textView.setOnClickListener(new OnClickListener() {
                                @Override
                                public void onClick(View view) {
                                    try {
                                        // 直接发出去，然后清空所有内容。并且隐藏

                                        //是TCP还是 WS
                                        if(IMChatManager.USE_TCP){
                                            if (!MoorUtils.isNetWorkConnected(IMChatManager.getInstance().getAppContext()) &&
                                                    TcpManager.TcpStatus.BREAK.equals(TcpManager.getInstance(IMChatManager.getInstance().getAppContext()).getTcpStatus())) {
                                                Toast.makeText(getApplicationContext(), getString(R.string.ykf_not_netwokr_error), Toast.LENGTH_SHORT).show();
                                                LogUtils.aTag("第四个地方break");
                                                TcpManager.getInstance(IMChatManager.getInstance().getAppContext()).setTcpStatus(TcpManager.TcpStatus.NONET);
                                                startReStartDialog3();
                                                return;
                                            }
                                        }else{
                                            if (!MoorUtils.isNetWorkConnected(IMChatManager.getInstance().getAppContext()) &&
                                                    !WebSocketHandler.getDefault().isConnect()) {
                                                Toast.makeText(getApplicationContext(), getString(R.string.ykf_not_netwokr_error), Toast.LENGTH_SHORT).show();
                                                LogUtils.aTag("第四个地方break");
                                                startReStartDialog3();
                                                return;
                                            }
                                        }

                                        if (IMChatManager.getInstance().isFinishWhenReConnect) {
                                            startReStartDialog();//并且弹框提示开始新会话
//            }
                                        } else {
                                            sendTextMsg(questions.getString(position));
                                            mChatInput.setText("");
                                            ll_hintView.setVisibility(View.GONE);
                                        }

                                    } catch (JSONException e) {
                                        e.printStackTrace();
                                    }
                                }
                            });
                            ll_hintView.addView(view);
                        }


                    } else {
                        ll_hintView.setVisibility(View.GONE);
                    }


                } catch (JSONException e) {
                    e.printStackTrace();
                }
//                ToastUtils.showShort(responseString);
            } else {
                //请求数据不对，隐藏
                ll_hintView.setVisibility(View.GONE);
            }
        }
    }

    //语音转文本
    public void getVoiceToText(final FromToMessage fromToMessage){
        //倒计时三分钟,结束发送超时失败
        mCountDownTimer=new CountDownTimer(1000*60*3,1000) {
            @Override
            public void onTick(long millisUntilFinished) {

            }

            @Override
            public void onFinish() {
                VoiceToTextEvent event=new VoiceToTextEvent();
                event.id=fromToMessage._id;
                event.status_code=VoiceToTextEvent.STATUS_TIMEOUT;
                onEventMainThread(event);
            }
        }.start();
        HttpManager.sendVoiceToText(fromToMessage._id, fromToMessage.message, fromToMessage.when, new HttpResponseListener() {
            @Override
            public void onSuccess(String responseStr) {
                Log.e("语音转文本",responseStr);
                try {
                    JSONObject jsonObject = new JSONObject(responseStr);
                    if(!jsonObject.optBoolean("Succeed")){
                        stopTimer();
                        //提交语音转文本失败
                        if(fromToMessage.isRobot){
                            sendVoiceAutoText(fromToMessage,"",false);
                        }else{
                            fromToMessage.isCacheShowVtoT=false;//将这条信息的 正在转换状态重置
                            MessageDao.getInstance().updateMsgToDao(fromToMessage);
                            chatAdapter.notifyDataSetChanged();
                            ToastUtils.showLong(ChatActivity.this,getText(R.string.voice_to_text_error)+":"+jsonObject.optString("Message"));
                        }
                    }else{
                        //如果接口直接返回messageId  文本内容，那么直接展示 ，不需要等待TCP
                        if(!TextUtils.isEmpty(jsonObject.optString("messageId"))){
                            String text=jsonObject.optString("voiceMessage");
                            String id=jsonObject.optString("messageId");
                            VoiceToTextEvent event=new VoiceToTextEvent();
                            event.id=id;
                            event.toText=text;
                            event.status_code=VoiceToTextEvent.STATUS_OK;
                            onEventMainThread(event);
                        }
                    }
                } catch (JSONException e) {
                    e.printStackTrace();
                }
            }

            @Override
            public void onFailed() {
                stopTimer();
                //提交语音转文本失败
                fromToMessage.isCacheShowVtoT=false;//将这条信息的 正在转换状态重置
                MessageDao.getInstance().updateMsgToDao(fromToMessage);
                chatAdapter.notifyDataSetChanged();
                ToastUtils.showLong(ChatActivity.this,getText(R.string.voice_to_text_error));
            }
        });
    }
    //TcpMessageHandler 中 收到语音转文本回复，EventBus 回调
    public void onEventMainThread(VoiceToTextEvent voiceToTextEvent){
        stopTimer();
        if(voiceToTextEvent!=null){
            if(!"VoiceToTextEvent_nullID".equals(voiceToTextEvent.id)){
                FromToMessage fromToMessage=MessageDao.getInstance().getMessageById(voiceToTextEvent.id);
                if(fromToMessage.isRobot){
                    //是机器人 执行自动转文本，成功发送text，失败发送语音
                    if(VoiceToTextEvent.STATUS_OK.equals(voiceToTextEvent.status_code)){
                        //成功
                        sendVoiceAutoText(fromToMessage,voiceToTextEvent.toText,true);
                    }else{
                        //失败
                        sendVoiceAutoText(fromToMessage,"",false);
                    }

                }else{
                    if(VoiceToTextEvent.STATUS_OK.equals(voiceToTextEvent.status_code)){
                        fromToMessage.voiceToText=voiceToTextEvent.toText;
                        fromToMessage.isShowVtoT=true;
                    }else if(VoiceToTextEvent.STATUS_FAIL.equals(voiceToTextEvent.status_code)){
                        ToastUtils.showLong(ChatActivity.this,getText(R.string.voice_to_text_error)+getString(R.string.ykf_autotext_fail_reclick));
                    }else if(VoiceToTextEvent.STATUS_TIMEOUT.equals(voiceToTextEvent.status_code)){
                        ToastUtils.showLong(ChatActivity.this,getText(R.string.voice_to_text_error)+getString(R.string.ykf_autotext_fail_reclick));
                    }else if(VoiceToTextEvent.STATUS_UNDEFINED.equals(voiceToTextEvent.status_code)){
                        ToastUtils.showLong(ChatActivity.this,getText(R.string.voice_to_text_error)+getString(R.string.ykf_autotext_fail_nocheck));
                    }else if(VoiceToTextEvent.STATUS_TOLONG.equals(voiceToTextEvent.status_code)){
                        ToastUtils.showLong(ChatActivity.this,getString(R.string.ykf_autotext_fail_solong));
                    }
                    fromToMessage.isCacheShowVtoT=false;//将这条信息的 正在转换状态重置
                    MessageDao.getInstance().updateMsgToDao(fromToMessage);
                    //更新adapter数据源
                    for(int i=0;i<descFromToMessage.size();i++){
                        if(!TextUtils.isEmpty(descFromToMessage.get(i)._id)){
                            if(descFromToMessage.get(i)._id.equals(fromToMessage._id)){
                                descFromToMessage.set(i,fromToMessage);
                            }
                        }
                    }
                }

                chatAdapter.notifyDataSetChanged();

            }else{
                ToastUtils.showShort(ChatActivity.this,getText(R.string.voice_to_text_error)+":VoiceToTextEvent_nullID");
            }

        }
    }


    //机器人语音自动转文字失败 发送文本//!IMChatManager.getInstance().isManual false是机器人
    private void sendVoiceAutoText(FromToMessage message,String str,boolean success){
        if(success){
            message.message=str;
            message.msgType = FromToMessage.MSG_TYPE_TEXT;
            message.isRobot=false;
        }else{
            message.msgType = FromToMessage.MSG_TYPE_AUDIO;
            message.isRobot=false;
        }
        //发送消息
        IMChat.getInstance().sendMessage(message, new ChatListener() {
            @Override
            public void onSuccess() {
                //消息发送成功
                updateMessage();
            }

            @Override
            public void onFailed() {
                //消息发送失败
                updateMessage();
            }

            @Override
            public void onProgress(int progress) {

            }
        });

    }

    private void stopTimer(){
        if(mCountDownTimer!=null){
            mCountDownTimer.cancel();
        }
    }


    //未读消息变已读
    public void onEventMainThread(MsgunReadToReadEvent event){
        MessageDao.getInstance().updateUnReadToRead();
        for(int i=0;i<descFromToMessage.size();i++){
            if("false".equals(descFromToMessage.get(i).dealCustomerMsg)){
                descFromToMessage.get(i).dealCustomerMsg="true";
            }
        }
        chatAdapter.notifyDataSetChanged();
    }
    //有新消息了，并且页面可见。消费消息
    public void onEventMainThread(MsgEvent msgEvent) {
            if(isFront){
                HttpManager.sdkDealImMsg(new HttpResponseListener() {
                    @Override
                    public void onSuccess(String responseStr) {
                     }

                    @Override
                    public void onFailed() {
                     }
                });
            }

    }


    //点击转人工。
    public void onEventMainThread(TransferAgent agent){
        //agent.peerid 不为空，传如转人工接口，来自于xbot文本中包含转人工按钮

        //转人工服务
        IMChatManager.getInstance().convertManual(agent.peerid,new OnConvertManualListener() {
            @Override
            public void onLine() {
                if (!type.equals("schedule")) {
                    //有客服在线,隐藏转人工按钮
                    chat_tv_convert.setVisibility(View.GONE);
                    bar_bottom.setVisibility(View.VISIBLE);
                    mOtherName.setText(R.string.wait_link);
                    titleName = getString(R.string.wait_link);
                    Toast.makeText(getApplicationContext(), R.string.topeoplesucceed, Toast.LENGTH_SHORT).show();
                    IMChatManager.getInstance().setIsShowBottomList(false);
                    rvTagLabel.setVisibility(View.GONE);
                }
            }

            @Override
            public void offLine() {
                //当前没有客服在线
                if (!type.equals("schedule")) {

                    showOffLineDialog();
                    IMChatManager.getInstance().setIsShowBottomList(false);
                    rvTagLabel.setVisibility(View.GONE);
                }

            }
        });

    }


    /**
     * Builder模式设置参数
     */
    public static final class Builder {
        private String type;
        private String scheduleId;
        private String processId;
        private String currentNodeId;
        private String processType;
        private String entranceId;
        private String PeerId;
        private CardInfo cardInfo;
        private NewCardInfo newCardInfo;

        public Builder setPeerId(String peerId) {
            PeerId = peerId;
            if (PeerId != null && !"".equals(PeerId)) {
                InfoDao.getInstance().updataPeedID(peerId);
            }

            return this;
        }

        public Builder setType(String type) {
            this.type = type;
            return this;
        }

        public Builder setScheduleId(String scheduleId) {
            this.scheduleId = scheduleId;
            return this;
        }

        public Builder setProcessId(String processId) {
            this.processId = processId;
            return this;
        }

        public Builder setCurrentNodeId(String currentNodeId) {
            this.currentNodeId = currentNodeId;
            return this;
        }

        public Builder setProcessType(String processType) {
            this.processType = processType;
            return this;
        }

        public Builder setEntranceId(String entranceId) {
            this.entranceId = entranceId;
            return this;
        }

        public Builder setCardInfo(CardInfo cardInfo) {
            this.cardInfo = cardInfo;
            //卡片不为空 则传入数据库
            if (cardInfo != null) {
                FromToMessage cardMsg = new FromToMessage();
                cardMsg.msgType = FromToMessage.MSG_TYPE_CARD;
                cardMsg.cardInfo = JsonBuild.getCardInfo(cardInfo);
                cardMsg.userType = "0";
                cardMsg.when = System.currentTimeMillis();
                LogUtils.aTag("cardinfo==", JsonBuild.getCardInfo(cardInfo));
                MessageDao.getInstance().insertSendMsgsToDao(cardMsg);
            }
            return this;
        }

        public Builder setNewCardInfo(NewCardInfo newCardInfo) {
            this.newCardInfo = newCardInfo;
            //新卡片类型不为空 则传入数据库
            if (newCardInfo != null) {
                FromToMessage cardMsg = new FromToMessage();
                cardMsg.msgType = FromToMessage.MSG_TYPE_NEW_CARD;
//                cardMsg.newCardInfo = JsonBuild.getOrderInfo(newCardInfo);
                cardMsg.newCardInfo = new Gson().toJson(newCardInfo);
                cardMsg.userType = "0";
                cardMsg.when = System.currentTimeMillis();
                LogUtils.aTag("newCardInfo==", new Gson().toJson(newCardInfo));
                MessageDao.getInstance().insertSendMsgsToDao(cardMsg);
            }
            return this;
        }

        public Builder() {

        }

        public Intent build(Context mContex) {
            Intent intent = new Intent(mContex, ChatActivity.class);
            intent.putExtra("type", type);
            intent.putExtra("scheduleId", scheduleId);
            intent.putExtra("processId", processId);
            intent.putExtra("currentNodeId", currentNodeId);
            intent.putExtra("processType", processType);
            intent.putExtra("entranceId", entranceId);
            intent.putExtra("PeerId", PeerId);
            intent.setFlags(Intent.FLAG_ACTIVITY_NEW_TASK);
            mContex.startActivity(intent);
            return intent;
        }
    }



}
