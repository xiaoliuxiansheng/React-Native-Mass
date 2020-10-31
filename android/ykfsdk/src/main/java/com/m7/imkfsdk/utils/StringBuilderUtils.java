package com.m7.imkfsdk.utils;

import android.content.Context;
import android.text.SpannableStringBuilder;
import android.text.Spanned;
import android.text.style.ForegroundColorSpan;

import com.m7.imkfsdk.R;

import java.util.regex.Matcher;
import java.util.regex.Pattern;

/**
 * @Description:
 * @Author: R-D
 * @Date: 2020-01-06
 */
public class StringBuilderUtils {

    public static SpannableStringBuilder setPhoneNum(Context context, SpannableStringBuilder spannableString) {
        Pattern patten = Pattern.compile("\\d{7,}", Pattern.CASE_INSENSITIVE);
        Matcher matcher = patten.matcher(spannableString);
        while (matcher.find()) {
            String number = matcher.group();
            int end = matcher.start() + number.length();
            ForegroundColorSpan colorSpan = new ForegroundColorSpan(context.getResources().getColor(R.color.color_FF6B6B));
            spannableString.setSpan(colorSpan, matcher.start(), end, Spanned.SPAN_INCLUSIVE_EXCLUSIVE);

        }
        return spannableString;
    }
}
