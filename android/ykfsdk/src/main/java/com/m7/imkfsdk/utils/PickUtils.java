package com.m7.imkfsdk.utils;

import android.annotation.SuppressLint;
import android.annotation.TargetApi;
import android.app.Activity;
import android.content.ContentUris;
import android.content.Context;
import android.content.pm.PackageManager;
import android.database.Cursor;
import android.net.Uri;
import android.os.Build;
import android.os.Environment;
import android.provider.DocumentsContract;
import android.provider.MediaStore;
import android.provider.OpenableColumns;
import androidx.core.app.ActivityCompat;
import androidx.core.content.ContextCompat;
import android.text.TextUtils;
import android.util.Log;

import java.io.File;
import java.io.FileOutputStream;
import java.io.InputStream;
import java.util.ArrayList;
import java.util.List;

/**
 * Created by pangw on 2018/5/23.
 */

public class PickUtils {
    public static String TEMP_DIR_PATH = Environment.getExternalStorageDirectory().getPath() + "/YourAppName";
    private static String name;
    private int cut;

    @SuppressLint("NewApi")
    public static String getPath(final Context context, final Uri uri) {

        final boolean isKitKat = Build.VERSION.SDK_INT >= Build.VERSION_CODES.KITKAT;

        //Android Q 文件 URI-file单独处理
        if(Build.VERSION.SDK_INT==Build.VERSION_CODES.Q){
            return FileUtils.getFilePathFromURI(context,uri);
        }
        // DocumentProvider
        if (isKitKat && DocumentsContract.isDocumentUri(context, uri)) {
            // ExternalStorageProvider
            if (isExternalStorageDocument(uri)) {
                final String docId = DocumentsContract.getDocumentId(uri);
                final String[] split = docId.split(":");
                final String type = split[0];

                if ("primary".equalsIgnoreCase(type)) {
                    return Environment.getExternalStorageDirectory() + "/" + split[1];
                }
            } else if (isDownloadsDocument(uri)) {

                String id = DocumentsContract.getDocumentId(uri);
                if (!TextUtils.isEmpty(id)) {
                    if (id.startsWith("raw:")) {
                        final String path = id.replaceFirst("raw:", "");
                        return path;
                    }

                    try {
                        Uri contentUri = uri;
//                        if (Build.VERSION.SDK_INT < Build.VERSION_CODES.O) {
                        contentUri = ContentUris.withAppendedId(
                                Uri.parse("content://downloads/public_downloads"), Long.valueOf(id));
//                        }
                        return getDataColumn(context, contentUri, null, null);
                    } catch (Exception e) {
//                        return getFilePathForN(uri, context);
                        ToastUtils.showShort(context,"暂不支持此类文件");
                    }

                }
            }
            // MediaProvider
            else if (isMediaDocument(uri)) {
                final String docId = DocumentsContract.getDocumentId(uri);
                final String[] split = docId.split(":");
                final String type = split[0];

                Uri contentUri = null;
                if ("image".equals(type)) {
                    contentUri = MediaStore.Images.Media.EXTERNAL_CONTENT_URI;
                } else if ("video".equals(type)) {
                    contentUri = MediaStore.Video.Media.EXTERNAL_CONTENT_URI;
                } else if ("audio".equals(type)) {
                    contentUri = MediaStore.Audio.Media.EXTERNAL_CONTENT_URI;
                }

                final String selection = "_id=?";
                final String[] selectionArgs = new String[]{split[1]};

                return getDataColumn(context, contentUri, selection, selectionArgs);
            }
        }
        // MediaStore (and general)
        else if ("content".equalsIgnoreCase(uri.getScheme())) {
            if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.N) {
                return getFilePathForN(uri, context);
            } else {
                return getDataColumn(context, uri, null, null);
            }
        }
        // File
        else if ("file".equalsIgnoreCase(uri.getScheme())) {
            return uri.getPath();
        }
        return null;
    }




    /**
     * @param uri The Uri to check.
     * @return Whether the Uri authority is ExternalStorageProvider.
     */
    public static boolean isExternalStorageDocument(Uri uri) {
        return "com.android.externalstorage.documents".equals(uri.getAuthority());
    }

    /**
     * @param uri The Uri to check.
     * @return Whether the Uri authority is DownloadsProvider.
     */
    public static boolean isDownloadsDocument(Uri uri) {
        return "com.android.providers.downloads.documents".equals(uri.getAuthority());
    }

    /**
     * @param uri The Uri to check.
     * @return Whether the Uri authority is MediaProvider.
     */
    public static boolean isMediaDocument(Uri uri) {
        return "com.android.providers.media.documents".equals(uri.getAuthority());
    }

    public static String getDataColumn(Context context, Uri uri, String selection,
                                       String[] selectionArgs) {

        Cursor cursor = null;
        final String column = "_data";
        final String[] projection = {column};

        try {
            cursor = context.getContentResolver().query(uri, projection, selection, selectionArgs,
                    null);
            if (cursor != null && cursor.moveToFirst()) {
                final int column_index = cursor.getColumnIndexOrThrow(column);
                return cursor.getString(column_index);
            }
        } finally {
            if (cursor != null)
                cursor.close();
        }
        return "";
    }
    //     方案三'
    private static String getFilePathForN(Uri uri, Context context) {
        Uri returnUri = uri;
        Cursor returnCursor = context.getContentResolver().query(returnUri, null, null, null, null);
        /*
         * Get the column indexes of the data in the Cursor,
         *     * move to the first row in the Cursor, get the data,
         *     * and display it.
         * */
        try{
            if(returnCursor!=null&&returnCursor.moveToFirst()){
                int nameIndex = returnCursor.getColumnIndex(OpenableColumns.DISPLAY_NAME);
                name = (returnCursor.getString(nameIndex));
            }
        }finally {
            returnCursor.close();
        }

        if(name==null){
            name = uri.getPath();
            int cut = name.lastIndexOf('/');
            if (cut != -1) {
                name = name.substring(cut + 1);
            }
        }
        File file = new File(context.getFilesDir(), name);
        try {
            InputStream inputStream = context.getContentResolver().openInputStream(uri);
            FileOutputStream outputStream = new FileOutputStream(file);
            int read = 0;
            int maxBufferSize = 1 * 1024 * 1024;
            int bytesAvailable = inputStream.available();

            //int bufferSize = 1024;
            int bufferSize = Math.min(bytesAvailable, maxBufferSize);

            final byte[] buffers = new byte[bufferSize];
            while ((read = inputStream.read(buffers)) != -1) {
                outputStream.write(buffers, 0, read);
            }
            Log.e("File Size", "Size " + file.length());
            inputStream.close();
            outputStream.close();
            Log.e("File Path", "Path " + file.getPath());
            Log.e("File Size", "Size " + file.length());
        } catch (Exception e) {
            Log.e("Exception", e.getMessage());
        }
        return file.getPath();
    }

    public static final class PermissionUtils {

        private static int mRequestCode = -1;

        private static OnPermissionListener mOnPermissionListener;

        public interface OnPermissionListener {

            void onPermissionGranted();

            void onPermissionDenied(String[] deniedPermissions);
        }

        public abstract static class RationaleHandler {
            private Context context;
            private int requestCode;
            private String[] permissions;

            protected abstract void showRationale();

            void showRationale(Context context, int requestCode, String[] permissions) {
                this.context = context;
                this.requestCode = requestCode;
                this.permissions = permissions;
                showRationale();
            }

            @TargetApi(Build.VERSION_CODES.M)
            public void requestPermissionsAgain() {
                ((Activity) context).requestPermissions(permissions, requestCode);
            }
        }

        @TargetApi(Build.VERSION_CODES.M)
        public static void requestPermissions(Context context, int requestCode
                , String[] permissions, OnPermissionListener listener) {
            requestPermissions(context, requestCode, permissions, listener, null);
        }

        @TargetApi(Build.VERSION_CODES.M)
        public static void requestPermissions(Context context, int requestCode
                , String[] permissions, OnPermissionListener listener, RationaleHandler handler) {
            if (context instanceof Activity) {
                mRequestCode = requestCode;
                mOnPermissionListener = listener;
                String[] deniedPermissions = getDeniedPermissions(context, permissions);
                if (deniedPermissions.length > 0) {
                    boolean rationale = shouldShowRequestPermissionRationale(context, deniedPermissions);
                    if (rationale && handler != null) {
                        handler.showRationale(context, requestCode, deniedPermissions);
                    } else {
                        ((Activity) context).requestPermissions(deniedPermissions, requestCode);
                    }
                } else {
                    if (mOnPermissionListener != null)
                        mOnPermissionListener.onPermissionGranted();
                }
            } else {
                throw new RuntimeException("Context must be an Activity");
            }
        }

        /**
         * 请求权限结果，对应Activity中onRequestPermissionsResult()方法。
         */
        public static void onRequestPermissionsResult(Activity context, int requestCode, String[] permissions, int[]
                grantResults) {
            if (mRequestCode != -1 && requestCode == mRequestCode) {
                if (mOnPermissionListener != null) {
                    String[] deniedPermissions = getDeniedPermissions(context, permissions);
                    if (deniedPermissions.length > 0) {
                        mOnPermissionListener.onPermissionDenied(deniedPermissions);
                    } else {
                        mOnPermissionListener.onPermissionGranted();
                    }
                }
            }
        }

        /**
         * 获取请求权限中需要授权的权限
         */
        private static String[] getDeniedPermissions(final Context context, final String[] permissions) {
            List<String> deniedPermissions = new ArrayList<>();
            for (String permission : permissions) {
                if (ContextCompat.checkSelfPermission(context, permission) == PackageManager.PERMISSION_DENIED) {
                    deniedPermissions.add(permission);
                }
            }
            return deniedPermissions.toArray(new String[deniedPermissions.size()]);
        }

        /**
         * 是否彻底拒绝了某项权限
         */
        public static boolean hasAlwaysDeniedPermission(final Context context, final String... deniedPermissions) {
            for (String deniedPermission : deniedPermissions) {
                if (!shouldShowRequestPermissionRationale(context, deniedPermission)) {
                    return true;
                }
            }
            return false;
        }

        /**
         * 是否有权限需要说明提示
         */
        private static boolean shouldShowRequestPermissionRationale(final Context context, final String... deniedPermissions) {
            if (Build.VERSION.SDK_INT < Build.VERSION_CODES.M) return false;
            boolean rationale;
            for (String permission : deniedPermissions) {
                rationale = ActivityCompat.shouldShowRequestPermissionRationale((Activity) context, permission);
                if (rationale) return true;
            }
            return false;
        }
    }
}
