package com.m7.imkfsdk.view;

import android.content.Context;
import android.graphics.Canvas;
import android.graphics.Paint;
import androidx.annotation.Nullable;
import android.util.AttributeSet;
import android.view.View;

import com.m7.imkfsdk.R;
import com.m7.imkfsdk.utils.DensityUtil;

/**
 * @FileName: ProgressLineView
 * @Description: 物流信息---连线View
 * @Author:R-D
 * @CreatDate: 2019-12-19 11:47
 * @Reviser:
 * @Modification Time:2019-12-19 11:47
 */
public class ProgressLineView extends View {
    Paint paint = new Paint(Paint.ANTI_ALIAS_FLAG);
    private int PAINTSTROKEWIDTH = DensityUtil.dip2px(1f);
    private int STARTX = DensityUtil.dip2px(15f);
    private int TOPLINELENGTH = DensityUtil.dip2px(15f);
    private int RADIUS = DensityUtil.dip2px(4f);

    private float mStartLineStartX, mStartLineStartY, mStartLineStopX, mStartLineStopY;
    private float mEndLineStartX, mEndLineStartY, mEndLineStopX, mEndLineStopY;

    public ProgressLineView(Context context, @Nullable AttributeSet attrs) {
        super(context, attrs);
        initSize();
    }

    {
        paint.setColor(getResources().getColor(R.color.color_ebebeb));
        paint.setStrokeWidth(PAINTSTROKEWIDTH);
    }

    @Override
    protected void onMeasure(int widthMeasureSpec, int heightMeasureSpec) {
        super.onMeasure(widthMeasureSpec, heightMeasureSpec);
        int widthSize = MeasureSpec.getSize(getMeasuredWidth());
        int heightSize = MeasureSpec.getSize(getMeasuredHeight());
        setMeasuredDimension(widthSize, heightSize);
        initSize();
    }

    @Override
    protected void onSizeChanged(int w, int h, int oldw, int oldh) {
        super.onSizeChanged(w, h, oldw, oldh);
        initSize();
    }

    private void initSize() {
        mStartLineStartX = STARTX;
        mStartLineStartY = 0;
        mStartLineStopX = STARTX;
        mStartLineStopY = TOPLINELENGTH;

        mEndLineStartX = STARTX;
        mEndLineStartY = TOPLINELENGTH + RADIUS * 2;
        mEndLineStopX = STARTX;
        mEndLineStopY = getHeight() - TOPLINELENGTH - RADIUS * 2;

    }

    @Override
    protected void onDraw(Canvas canvas) {
        super.onDraw(canvas);
        //画上面线
        paint.setStyle(Paint.Style.STROKE);
        canvas.drawLine(mStartLineStartX, mStartLineStartY, mStartLineStopX, mStartLineStopY, paint);

        //画圆圈
        paint.setStyle(Paint.Style.FILL);
        canvas.drawCircle(STARTX, TOPLINELENGTH + RADIUS, RADIUS, paint);
        //画下面的线
        paint.setStyle(Paint.Style.STROKE);
        canvas.drawLine(mEndLineStartX, mEndLineStartY, mEndLineStopX, mEndLineStopY, paint);
    }
}
