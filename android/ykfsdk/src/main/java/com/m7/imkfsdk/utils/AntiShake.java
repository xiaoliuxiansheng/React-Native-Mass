package com.m7.imkfsdk.utils;

import java.util.ArrayList;
import java.util.Calendar;
import java.util.List;

/**
 * @FileName: AntiShake
 * @Description: 点击事件防抖动
 * @Author:R-D
 * @CreatDate: 2019-11-20 18:23
 * @Reviser:
 * @Modification Time:2019-11-20 18:23
 */
public class AntiShake {
    private List<OneClickUtil> utils = new ArrayList<>();

    public boolean check(Object o) {
        String flag = null;
        if (o == null)
            flag = Thread.currentThread().getStackTrace()[2].getMethodName();
        else
            flag = o.toString();
        for (OneClickUtil util : utils) {
            if (util.getMethodName().equals(flag)) {
                return util.check();
            }
        }
        OneClickUtil clickUtil = new OneClickUtil(flag);
        utils.add(clickUtil);
        return clickUtil.check();
    }

    public boolean check() {
        return check(null);
    }

    private class OneClickUtil {
        private String methodName;
        private static final int MIN_CLICK_DELAY_TIME = 500;
        private long lastClickTime = 0;

        private OneClickUtil(String methodName) {
            this.methodName = methodName;
        }

        private String getMethodName() {
            return methodName;
        }

        private boolean check() {
            long currentTime = Calendar.getInstance().getTimeInMillis();
            if (currentTime - lastClickTime > MIN_CLICK_DELAY_TIME) {
                lastClickTime = currentTime;
                return false;
            } else {
                return true;
            }
        }
    }
}
