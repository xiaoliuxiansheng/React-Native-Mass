package com.m7.imkfsdk.view;

import android.annotation.SuppressLint;
import android.app.Dialog;
import android.content.Context;
import android.os.Bundle;
import androidx.annotation.NonNull;
import com.google.android.material.bottomsheet.BottomSheetBehavior;
import com.google.android.material.bottomsheet.BottomSheetDialog;
import com.google.android.material.bottomsheet.BottomSheetDialogFragment;
import androidx.recyclerview.widget.LinearLayoutManager;
import androidx.recyclerview.widget.RecyclerView;
import android.view.View;
import android.view.ViewGroup;
import android.widget.ExpandableListView;
import android.widget.ImageView;
import android.widget.TextView;

import com.m7.imkfsdk.R;
import com.m7.imkfsdk.chat.adapter.LogisticsProgressListAdapter;
import com.m7.imkfsdk.chat.model.OrderInfoBean;
import com.m7.imkfsdk.utils.DensityUtil;

import java.util.ArrayList;
import java.util.List;

/**
 * @Description: 查看完整物流信息弹出框
 * @Author:R-D
 * @CreatDate: 2019-12-25 16:27
 */
@SuppressLint("ValidFragment")
public class BottomSheetLogisticsProgressDialog extends BottomSheetDialogFragment {
    private List<OrderInfoBean> list;
    //    private BottomSheetBehavior<View> mBottomSheetBehavior;
    protected Context mContext;
    protected View rootView;
    protected BottomSheetDialog dialog;
    protected BottomSheetBehavior mBehavior;

    public BottomSheetLogisticsProgressDialog(List<OrderInfoBean> list) {
        this.list = list;
    }


   /* private BottomSheetBehavior.BottomSheetCallback mBottomSheetBehaviorCallback = new BottomSheetBehavior.BottomSheetCallback() {
        @Override
        public void onStateChanged(@NonNull View bottomSheet, int newState) {
            //禁止拖拽
            if (newState == BottomSheetBehavior.STATE_DRAGGING) {
                //设置为收缩状态
                mBottomSheetBehavior.setState(BottomSheetBehavior.STATE_COLLAPSED);
            }
        }
        @Override
        public void onSlide(@NonNull View bottomSheet, float slideOffset) {
        }
    };*/

    @NonNull
    @Override
    public Dialog onCreateDialog(Bundle savedInstanceState) {
        dialog = (BottomSheetDialog) super.onCreateDialog(savedInstanceState);
        if (rootView == null) {
            rootView = View.inflate(mContext, R.layout.layout_bottomsheet_progress, null);
            TextView tv_no_data = rootView.findViewById(R.id.tv_no_data);

            ImageView ivBottomClose = rootView.findViewById(R.id.iv_bottom_close);
            ivBottomClose.setOnClickListener(new View.OnClickListener() {
                @Override
                public void onClick(View v) {
                    dialog.dismiss();
                }
            });

            RecyclerView rv_switch = rootView.findViewById(R.id.rv_switch);
//            rv_switch.addItemDecoration(new DividerItemDecoration(mContext));
            rv_switch.setLayoutManager(new LinearLayoutManager(mContext));

            LogisticsProgressListAdapter adapter = new LogisticsProgressListAdapter(list, true);
            rv_switch.setAdapter(adapter);

            if (list != null && list.size() == 0) {
                tv_no_data.setVisibility(View.VISIBLE);
                rv_switch.setVisibility(View.GONE);
            } else {
                tv_no_data.setVisibility(View.GONE);
                rv_switch.setVisibility(View.VISIBLE);
            }
        }

        dialog.setContentView(rootView);
        mBehavior = BottomSheetBehavior.from((View) rootView.getParent());
        mBehavior.setSkipCollapsed(true);
        mBehavior.setHideable(true);

//        mBottomSheetBehavior = (BottomSheetBehavior) mBehavior;
        //重置高度
        if (dialog != null) {
            View bottomSheet = dialog.findViewById(R.id.design_bottom_sheet);
//            mBehavior.setBottomSheetCallback(mBottomSheetBehaviorCallback);
            bottomSheet.getLayoutParams().height = DensityUtil.getScreenRelatedInformation(getContext()) * 4 / 5;
        }
        rootView.post(new Runnable() {
            @Override
            public void run() {
                mBehavior.setPeekHeight(rootView.getHeight());
            }
        });
        return dialog;
    }

    @Override
    public void onAttach(Context context) {
        super.onAttach(context);
        this.mContext = context;
    }

    @Override
    public void onStart() {
        super.onStart();
        mBehavior.setState(BottomSheetBehavior.STATE_EXPANDED);
    }

    @Override
    public void onDestroy() {
        super.onDestroy();
        ((ViewGroup) (rootView.getParent())).removeView(rootView);
    }


    public boolean isShowing() {
        return dialog != null && dialog.isShowing();
    }

    public void close(boolean isAnimation) {
        if (isAnimation) {
            if (mBehavior != null)
                mBehavior.setState(BottomSheetBehavior.STATE_HIDDEN);
        } else {
            dismiss();
        }
    }

}

