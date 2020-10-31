package com.m7.imkfsdk.utils;

import android.content.ContentResolver;
import android.content.ContentValues;
import android.content.Context;
import android.content.Intent;
import android.graphics.Bitmap;
import android.graphics.Canvas;
import android.graphics.NinePatch;
import android.graphics.Paint;
import android.graphics.PorterDuff;
import android.graphics.PorterDuffXfermode;
import android.graphics.Rect;
import android.graphics.drawable.Drawable;
import android.net.Uri;
import android.os.Build;
import android.os.Environment;
import android.provider.MediaStore;
import android.view.ViewGroup;
import android.widget.ImageView;



import com.bumptech.glide.Glide;
import com.bumptech.glide.load.DataSource;
import com.bumptech.glide.load.engine.DiskCacheStrategy;
import com.bumptech.glide.load.engine.GlideException;
import com.bumptech.glide.request.RequestListener;
import com.bumptech.glide.request.target.CustomTarget;
import com.bumptech.glide.request.target.Target;
import com.bumptech.glide.request.transition.Transition;
import com.moor.imkf.utils.FileUtil;
import com.moor.imkf.utils.LogUtils;
import com.moor.imkf.utils.MoorUtils;

import java.io.BufferedInputStream;
import java.io.File;
import java.io.FileInputStream;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.OutputStream;

/**
 * Created by pangw on 2017/10/23.
 */

public class ImageUtils {


    /**
     * 聊天图片加载 点9 背景
     */
    public static Bitmap getRoundCornerImage(Bitmap bitmap_bg, Bitmap bitmap_in) {
        Bitmap roundConcerImage = Bitmap.createBitmap(500, 500, Bitmap.Config.ARGB_8888);
        Canvas canvas = new Canvas(roundConcerImage);
        Paint paint = new Paint();
        Rect rect = new Rect(0, 0, 500, 500);
        Rect rectF = new Rect(0, 0, bitmap_in.getWidth(), bitmap_in.getHeight());
        paint.setAntiAlias(true);
        NinePatch patch = new NinePatch(bitmap_bg, bitmap_bg.getNinePatchChunk(), null);
        patch.draw(canvas, rect);
        paint.setXfermode(new PorterDuffXfermode(PorterDuff.Mode.SRC_IN));
        canvas.drawBitmap(bitmap_in, rectF, rect, paint);
        return roundConcerImage;
    }

    /**
     * 保存图片到图库，适配Android Q
     *
     * @param context
     * @param bmp
     * @return
     */
    public static boolean saveImageToGallery(Context context, Bitmap bmp) {
//        String storePath;
//        // 首先保存图片
//        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.Q) {
//            assert MoorUtils.getApp() != null;
//            storePath = MoorUtils.getApp().getExternalFilesDir(Environment.DIRECTORY_PICTURES) + File.separator + "moor";
//        } else {
//            storePath = Environment.getExternalStorageDirectory().getAbsolutePath() + File.separator + "Pictures/moor";
//        }
//        LogUtils.dTag("storePath=", storePath);
//        File appDir = new File(storePath);
//        if (!appDir.exists()) {
//            appDir.mkdir();
//        }
        String fileName = System.currentTimeMillis() + ".jpg";
        String mime_type = "image/jpeg";
        try {
            ContentValues values = new ContentValues();
            values.put(MediaStore.Images.Media.DISPLAY_NAME, fileName);
            values.put(MediaStore.Images.Media.MIME_TYPE, mime_type);

            if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.Q) {
                values.put(MediaStore.Images.Media.RELATIVE_PATH, Environment.DIRECTORY_DCIM);
            } else {
                values.put(MediaStore.MediaColumns.DATA
                        , Environment.getExternalStorageDirectory().getPath() + File.separator + Environment.DIRECTORY_DCIM + File.separator + fileName);
            }

            Uri external = MediaStore.Images.Media.EXTERNAL_CONTENT_URI;
            ContentResolver resolver = context.getContentResolver();

            Uri insertUri = resolver.insert(external, values);
            OutputStream os = null;
            boolean result = false;
            try {
                if (insertUri != null) {
                    os = resolver.openOutputStream(insertUri);
                    if (os != null) {
                        result = bmp.compress(Bitmap.CompressFormat.JPEG, 100, os);
                    }
                }
            } catch (IOException e) {
                e.printStackTrace();
            } finally {
                if (os != null) {
                    os.flush();
                    os.close();
                }
            }
            return result;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    //保存文件到指定路径,成功后返回路径
    public static String saveImageBackpath(Context context, Bitmap bmp) {
        String storePath;
        // 首先保存图片
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.Q) {
            assert MoorUtils.getApp() != null;
            storePath = MoorUtils.getApp().getExternalFilesDir(Environment.DIRECTORY_PICTURES) + File.separator + "moor";
        } else {
            storePath = Environment.getExternalStorageDirectory().getAbsolutePath() + File.separator + "Pictures/moor";
        }
        LogUtils.dTag("storePath=", storePath);
        File appDir = new File(storePath);
        if (!appDir.exists()) {
            appDir.mkdir();
        }
        String fileName = System.currentTimeMillis() + ".png";
//        File file = new File(appDir, fileName);

        try {
            ContentValues values = new ContentValues();
            values.put(MediaStore.Images.Media.DESCRIPTION, "This is an image");
            values.put(MediaStore.Images.Media.DISPLAY_NAME, fileName);
            values.put(MediaStore.Images.Media.MIME_TYPE, "image/png");
            values.put(MediaStore.Images.Media.TITLE, "Image.png");
            if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.Q) {
                values.put(MediaStore.Images.Media.RELATIVE_PATH, "Pictures/moor/");
            }

            Uri external = MediaStore.Images.Media.EXTERNAL_CONTENT_URI;
            ContentResolver resolver = context.getContentResolver();

            Uri insertUri = resolver.insert(external, values);
            OutputStream os = null;
            String result = "";
            try {
                if (insertUri != null) {
                    os = resolver.openOutputStream(insertUri);
                }
                if (os != null) {
                    boolean isSuccess = bmp.compress(Bitmap.CompressFormat.PNG, 90, os);
                    if (isSuccess) {
                        result = storePath + File.separator + fileName;
                    }
                }


            } catch (IOException e) {
            } finally {
                try {
                    if (os != null) {
                        os.flush();
                        os.close();
                    }
                } catch (IOException e) {
                    e.printStackTrace();
                }
            }
            return result;


        } catch (Exception e) {
            e.printStackTrace();
        }


        return "";
    }

}
