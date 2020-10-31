package com.m7.imkfsdk.chat.chatrow;

import com.moor.imkf.model.entity.FromToMessage;

/**
 * Created by longwei on 2016/3/9.
 */
public class ChatRowUtils {

    /**
     * 获取聊天消息类型
     */
    public static int getChattingMessageType(FromToMessage msg) {
        switch (msg.msgType) {
            case FromToMessage.MSG_TYPE_TEXT:
                return 200;
            case FromToMessage.MSG_TYPE_IMAGE:
                return 300;
            case FromToMessage.MSG_TYPE_AUDIO:
                return 400;
            case FromToMessage.MSG_TYPE_INVESTIGATE:
                return 500;
            case FromToMessage.MSG_TYPE_FILE:
                return 600;
            case FromToMessage.MSG_TYPE_IFRAME:
                return 700;
            case FromToMessage.MSG_TYPE_BREAK_TIP:
                return 800;
            case FromToMessage.MSG_TYPE_TRIP:
                return 900;
            case FromToMessage.MSG_TYPE_RICHTEXT:
                return 1300;
            case FromToMessage.MSG_TYPE_CARDINFO:
                return 1400;
            case FromToMessage.MSG_TYPE_CARD:
                return 1500;
            case FromToMessage.MSG_TYPE_VIDEO:
                return 1600;

            case FromToMessage.MSG_TYPE_LOGISTICS_INFO_LIST:
                return 1700;

            case FromToMessage.MSG_TYPE_NEW_CARD:
                return 2000;
            case FromToMessage.MSG_TYPE_NEW_CARD_INFO:
                return 2100;
            default:
                return 0;
        }
    }
}
