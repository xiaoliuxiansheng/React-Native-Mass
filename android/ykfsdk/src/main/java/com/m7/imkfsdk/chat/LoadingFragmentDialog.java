package com.m7.imkfsdk.chat;

import android.app.Dialog;
import android.content.DialogInterface;
import android.os.Bundle;
import androidx.annotation.Nullable;
import androidx.fragment.app.DialogFragment;
import androidx.fragment.app.FragmentManager;
import android.view.KeyEvent;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.TextView;

import com.m7.imkfsdk.R;

/**
 * Created by long on 2015/7/6.
 */
public class LoadingFragmentDialog extends DialogFragment {
    private boolean canTouchOutside = true;

    @Override
    public Dialog onCreateDialog(Bundle savedInstanceState) {
        LayoutInflater inflater = getActivity().getLayoutInflater();
        View view = inflater.inflate(R.layout.kf_dialog_loading, null);
        TextView title = (TextView) view
                .findViewById(R.id.id_dialog_loading_msg);
        title.setText(getActivity().getString(R.string.ykf_wait));
        Dialog dialog = new Dialog(getActivity(), R.style.dialog);
        dialog.setContentView(view);
        dialog.setCanceledOnTouchOutside(canTouchOutside);
        return dialog;
    }

    @Override
    public View onCreateView(LayoutInflater inflater, @Nullable ViewGroup container, @Nullable Bundle savedInstanceState) {
        getDialog().setOnKeyListener(new DialogInterface.OnKeyListener() {
            @Override
            public boolean onKey(DialogInterface dialog, int keyCode, KeyEvent event) {
                if (keyCode == KeyEvent.KEYCODE_BACK) {
                    return true;
                }
                return false;
            }
        });
        return super.onCreateView(inflater, container, savedInstanceState);

    }

    public void setCanceledOnTouchOutside(boolean canTouchOutside) {
        this.canTouchOutside = canTouchOutside;
    }

    @Override
    public void show(FragmentManager manager, String tag) {
        if (!this.isAdded()) {
            try {
                super.show(manager, tag);
            } catch (Exception e) {
            }
        }
    }

    @Override
    public void dismiss() {
        try {
            super.dismiss();
        } catch (Exception e) {
        }

    }

}
