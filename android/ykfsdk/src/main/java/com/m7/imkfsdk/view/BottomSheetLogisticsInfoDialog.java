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
import android.widget.ImageView;

import com.m7.imkfsdk.R;
import com.m7.imkfsdk.chat.adapter.LogisticsInfoRxListAdapter;
import com.m7.imkfsdk.chat.model.OrderInfoBean;
import com.m7.imkfsdk.utils.DensityUtil;

import java.util.ArrayList;
import java.util.List;

/**
 * @FileName: BottomSheetLogisticsInfoDialog
 * @Description: 查看更多订单信息弹出框
 * @Author:R-D
 * @CreatDate: 2019-12-02 16:27
 * @Reviser:
 * @Modification Time:2019-12-02 16:27
 */
@SuppressLint("ValidFragment")
public class BottomSheetLogisticsInfoDialog extends BottomSheetDialogFragment {
    private List<OrderInfoBean> list;
    //    private BottomSheetBehavior<View> mBottomSheetBehavior;
    protected Context mContext;
    protected View rootView;
    protected BottomSheetDialog dialog;
    protected BottomSheetBehavior mBehavior;
    private String current;
    private String _id;

    public BottomSheetLogisticsInfoDialog(List<OrderInfoBean> list, String current,String _id) {
        this.list = list;
        this.current = current;
        this._id = _id;
    }


    @NonNull
    @Override
    public Dialog onCreateDialog(Bundle savedInstanceState) {
        dialog = (BottomSheetDialog) super.onCreateDialog(savedInstanceState);
        if (rootView == null) {
            rootView = View.inflate(mContext, R.layout.layout_bottomsheet, null);
            ImageView ivBottomClose = rootView.findViewById(R.id.iv_bottom_close);
            ivBottomClose.setOnClickListener(new View.OnClickListener() {
                @Override
                public void onClick(View v) {
                    dialog.dismiss();
                }
            });

            RecyclerView rv_switch = rootView.findViewById(R.id.rv_switch);
            rv_switch.setLayoutManager(new LinearLayoutManager(mContext));

            LogisticsInfoRxListAdapter adapter = new LogisticsInfoRxListAdapter(list, current, true,_id);
            rv_switch.setAdapter(adapter);

        }

        dialog.setContentView(rootView);
        mBehavior = BottomSheetBehavior.from((View) rootView.getParent());
        mBehavior.setSkipCollapsed(true);
        mBehavior.setHideable(true);
        //重置高度
        if (dialog != null) {
            View bottomSheet = dialog.findViewById(R.id.design_bottom_sheet);
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

