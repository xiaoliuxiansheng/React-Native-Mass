package com.m7.imkfsdk.chat;

import android.content.Context;
import android.os.Bundle;
import androidx.appcompat.app.AppCompatActivity;
import androidx.recyclerview.widget.LinearLayoutManager;
import androidx.recyclerview.widget.RecyclerView;
import android.view.View;
import android.widget.ImageView;
import android.widget.TextView;

import com.m7.imkfsdk.R;
import com.m7.imkfsdk.chat.adapter.CommonQuetionAdapter;
import com.m7.imkfsdk.chat.adapter.DetailQuestionAdapter;
import com.m7.imkfsdk.chat.model.CommonQuestionBean;
import com.moor.imkf.eventbus.EventBus;
import com.moor.imkf.http.HttpManager;
import com.moor.imkf.http.HttpResponseListener;
import com.moor.imkf.model.entity.FlowBean;
import com.moor.imkf.tcpservice.event.QuestionEvent;
import com.moor.imkf.utils.LogUtils;

import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

import java.util.ArrayList;

/**
 * @FileName: CommonProblemsActivity
 * @Description: 常见问题页面
 * @Author:R-D
 * @CreatDate: 2019-12-20 15:06
 * @Reviser:
 * @Modification Time:2019-12-20 15:06
 */
public class CommonQuestionsActivity extends AppCompatActivity implements View.OnClickListener {
    private Context mContext;
    private CommonQuetionAdapter adapter;
    private RecyclerView rv_commonQuetions;
    private ArrayList<CommonQuestionBean> questionBeans = new ArrayList<>();

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        mContext = this;
        setContentView(R.layout.activity_commonproblems);
        initView();
        EventBus.getDefault().register(this);
        getMainQuestions();
    }

    private void initView() {
        ImageView iv_back = findViewById(R.id.iv_back);
        TextView tv_back = findViewById(R.id.tv_back);
        iv_back.setOnClickListener(this);
        tv_back.setOnClickListener(this);
        rv_commonQuetions = findViewById(R.id.rl_refresh);
//        View header = View.inflate(mContext, R.layout.layout_header_common_problem, null);
        // 这一版暂时去掉搜索功能
//        final EditText et_search = header.findViewById(R.id.et_search);
//        rv_oneQuetions.addHeaderView(header);
        rv_commonQuetions.setLayoutManager(new LinearLayoutManager(CommonQuestionsActivity.this));
        adapter = new CommonQuetionAdapter(CommonQuestionsActivity.this, questionBeans);
        rv_commonQuetions.setAdapter(adapter);
    }

    /**
     * 获取常见问题
     */
    private void getMainQuestions() {
        new HttpManager().getTabCommonQuestions(new HttpResponseListener() {
            @Override
            public void onSuccess(String responseStr) {
                LogUtils.aTag("常见问题", responseStr);
                try {
                    JSONObject jsonObject = new JSONObject(responseStr);
                    JSONArray catalogList = jsonObject.getJSONArray("catalogList");
                    for (int i = 0; i < catalogList.length(); i++) {
                        JSONObject questionObj = catalogList.getJSONObject(i);
                        CommonQuestionBean commonQuestionBean = new CommonQuestionBean();
                        commonQuestionBean.setTabContent(questionObj.getString("name"));
                        commonQuestionBean.setTabId(questionObj.getString("_id"));
                        questionBeans.add(commonQuestionBean);
                    }
                    adapter.notifyDataSetChanged();
                } catch (JSONException e) {
                    e.printStackTrace();
                }
            }

            @Override
            public void onFailed() {

            }
        });
    }

    public void onEventMainThread(QuestionEvent questionEvent) {
        finish();
    }

    @Override
    public void onClick(View v) {
        if(v.getId()==R.id.iv_back){
            finish();
        }
        if(v.getId()==R.id.tv_back){
            finish();
        }

    }
}
