package com.m7.imkfsdk.utils;

import android.content.ContentUris;
import android.content.Context;
import android.database.Cursor;
import android.net.Uri;
import android.os.Environment;
import android.provider.DocumentsContract;
import android.provider.MediaStore;
import android.text.TextUtils;

import java.io.BufferedInputStream;
import java.io.BufferedOutputStream;
import java.io.File;
import java.io.FileInputStream;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.io.OutputStream;

/**
 * Created by longwei on 16/7/29.
 */
public class FileUtils {


    public static String getFilePathFromURI(Context context, Uri contentUri) {
        File rootDataDir = context.getExternalFilesDir(null);
//        String fileName = getFileName(contentUri);
        String fileName = getFileNameByUri(context,contentUri);
        if (!TextUtils.isEmpty(fileName)) {
            File copyFile = new File(rootDataDir + File.separator + fileName);
            copyFile(context, contentUri, copyFile);
            return copyFile.getAbsolutePath();
        }
        return null;
    }

    private static String  getFileNameByUri(Context context,Uri uri){
        String fileName ="";
        Cursor cursor =context.getContentResolver() .query(uri, null, null, null, null);
        if (cursor != null && cursor.getCount()> 0) {
            cursor.moveToFirst();
            fileName = cursor.getString(cursor.getColumnIndexOrThrow(MediaStore.MediaColumns.DISPLAY_NAME));
            cursor.close();
        }
        return fileName;
    }

    public static String getFileName(Uri uri) {
        if (uri == null) return null;
        String fileName = null;
        String path = uri.getPath();
        int cut = path.lastIndexOf('/');
        if (cut != -1) {
            fileName = path.substring(cut + 1);
        }
        return fileName;
    }
    public static void copyFile(Context context, Uri srcUri, File dstFile) {
        try {
            InputStream inputStream = context.getContentResolver().openInputStream(srcUri);
            if (inputStream == null) return;
            OutputStream outputStream = new FileOutputStream(dstFile);
            copyStream(inputStream, outputStream);
            inputStream.close();
            outputStream.close();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
    public static int copyStream(InputStream input, OutputStream output) throws Exception, IOException {
        final int BUFFER_SIZE = 1024 * 2;
        byte[] buffer = new byte[BUFFER_SIZE];
        BufferedInputStream in = new BufferedInputStream(input, BUFFER_SIZE);
        BufferedOutputStream out = new BufferedOutputStream(output, BUFFER_SIZE);
        int count = 0, n = 0;
        try {
            while ((n = in.read(buffer, 0, BUFFER_SIZE)) != -1) {
                out.write(buffer, 0, n);
                count += n;
            }
            out.flush();
        } finally {
            try {
                out.close();
            } catch (IOException e) {
            }
            try {
                in.close();
            } catch (IOException e) {
            }
        }
        return count;
    }
    public static String formatFileLength(long length) {
        if (length >> 30 > 0L) {
            float sizeGb = Math.round(10.0F * (float) length / 1.073742E+009F) / 10.0F;
            return sizeGb + " GB";
        }
        if (length >> 20 > 0L) {
            return formatSizeMb(length);
        }
        if (length >> 9 > 0L) {
            float sizekb = Math.round(10.0F * (float) length / 1024.0F) / 10.0F;
            return sizekb + " KB";
        }
        return length + " B";
    }

    /**
     * 转换成Mb单位
     *
     * @param length
     * @return
     */
    public static String formatSizeMb(long length) {
        float mbSize = Math.round(10.0F * (float) length / 1048576.0F) / 10.0F;
        return mbSize + " MB";
    }

    public static String getExtension(String uri) {
        if (uri == null) {
            return null;
        }

        int dot = uri.lastIndexOf(".");
        if (dot >= 0) {
            return uri.substring(dot);
        } else {
            // No extension.
            return "";
        }
    }

    public static byte[] readAudioFile(Context context, String filename) {
        File file = new File(filename);
        if(file != null) {
            try {
                InputStream ins = new FileInputStream(file);
                byte[] data = new byte[ins.available()];
                ins.read(data);
                ins.close();

                return data;
            } catch (IOException e) {
                // TODO Auto-generated catch block
                e.printStackTrace();
            }
        }


        return null;
    }


    /**
     *  判断文件是否存在
     *
     * @param strFile
     * @return
     */
    public static boolean isExists(String strFile)
    {
        try
        {
            File f=new File(strFile);
            if(!f.exists())
            {
                return false;
            }

        }
        catch (Exception e)
        {
            return false;
        }

        return true;
    }

}
