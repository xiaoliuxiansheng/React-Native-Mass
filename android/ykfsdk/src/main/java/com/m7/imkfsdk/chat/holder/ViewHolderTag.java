/*
 *  Copyright (c) 2013 The CCP project authors. All Rights Reserved.
 *
 *  Use of this source code is governed by a Beijing Speedtong Information Technology Co.,Ltd license
 *  that can be found in the LICENSE file in the root of the web site.
 *
 *   http://www.yuntongxun.com
 *
 *  An additional intellectual property rights grant can be found
 *  in the file PATENTS.  All contributing project authors may
 *  be found in the AUTHORS file in the root of the source tree.
 */
package com.m7.imkfsdk.chat.holder;

import com.m7.imkfsdk.chat.model.OrderInfoBean;
import com.moor.imkf.model.entity.FromToMessage;
import com.moor.imkf.model.entity.NewCardInfo;

public class ViewHolderTag {

    public int position;
    public FromToMessage detail;
    public NewCardInfo newCardInfo;
    public int type;
    public int rowType;
    public boolean receive;
    public boolean voipcall;
    public VoiceViewHolder holder;
    public String target;
    public String current;
    public Object obj;
    public String _id;
    public OrderInfoBean orderInfoBean;


    public static ViewHolderTag createTag(FromToMessage detail, int type, int position) {
        ViewHolderTag holderTag = new ViewHolderTag();
        holderTag.position = position;
        holderTag.type = type;
        holderTag.detail = detail;
        return holderTag;
    }


    /**
     * 点击订单卡片信息
     *
     * @param type
     * @return
     */
    public static ViewHolderTag createTag(String target, int type) {
        ViewHolderTag holderTag = new ViewHolderTag();
        holderTag.type = type;
        holderTag.target = target;
        return holderTag;
    } public static ViewHolderTag createTag(String target,String _id, int type) {
        ViewHolderTag holderTag = new ViewHolderTag();
        holderTag.type = type;
        holderTag._id=_id;
        holderTag.target = target;
        return holderTag;
    }

    public static ViewHolderTag createTag(String current,String _id, OrderInfoBean orderInfoBean, int type) {
        ViewHolderTag holderTag = new ViewHolderTag();
        holderTag.type = type;
        holderTag.current = current;
        holderTag._id=_id;
        holderTag.orderInfoBean = orderInfoBean;
        return holderTag;
    }

    public static ViewHolderTag createTag(FromToMessage detail, int type, int position, int rowType, boolean receive) {
        ViewHolderTag holderTag = new ViewHolderTag();
        holderTag.position = position;
        holderTag.type = type;
        holderTag.rowType = rowType;
        holderTag.detail = detail;
        holderTag.receive = receive;
        return holderTag;
    }

    public static ViewHolderTag createTag(FromToMessage detail, int type, int position, int rowType, boolean receive, VoiceViewHolder voiceViewHolder) {
        ViewHolderTag holderTag = new ViewHolderTag();
        holderTag.position = position;
        holderTag.type = type;
        holderTag.rowType = rowType;
        holderTag.detail = detail;
        holderTag.receive = receive;
        holderTag.holder = voiceViewHolder;
        return holderTag;
    }

    /**
     * @param detail
     * @param position
     * @return
     */
    public static ViewHolderTag createTag(FromToMessage detail, int position) {
        ViewHolderTag holderTag = new ViewHolderTag();
        holderTag.position = position;
        holderTag.detail = detail;
        holderTag.type = TagType.TAG_PREVIEW;
        return holderTag;
    }

    public static ViewHolderTag createTag(FromToMessage detail, int type, int position, boolean voipcall) {
        ViewHolderTag holderTag = new ViewHolderTag();
        holderTag.position = position;
        holderTag.detail = detail;
        holderTag.type = type;
        holderTag.voipcall = voipcall;
        return holderTag;
    }

    public static ViewHolderTag createObjectTag(Object obj, int type) {
        ViewHolderTag holderTag = new ViewHolderTag();
        holderTag.type = type;
        holderTag.obj = obj;
        return holderTag;
    }

    public static class TagType {
        public static final int TAG_PREVIEW = 0;
        public static final int TAG_VIEW_FILE = 1;
        public static final int TAG_VOICE = 2;
        public static final int TAG_VIEW_PICTURE = 3;
        public static final int TAG_RESEND_MSG = 4;
        public static final int TAG_VIEW_CONFERENCE = 5;
        public static final int TAG_VOIP_CALL = 6;
        public static final int TAG_SEND_MSG = 7;
        public static final int TAG_SEND_NEW_CARD = 8;
        public static final int TAG_CLICK_NEW_CARD = 9;

        public static final int TAG_CLICK_LOGISTICS_RX_ITEM = 10;//收到的订单信息列表-item
        public static final int TAG_CLICK_LOGISTICS_RX_MORE = 11;//收到的订单信息列表-查看更多
        public static final int TAG_CLICK_LOGISTICS_RX_SHOP = 12;//收到的订单信息列表-店铺标题

        public static final int TAG_CLICK_LOGISTICS_PROGERSS_MORE = 13;//收到的物流信息-查看更多
        public static final int TAG_CLICK_LOGISTICS_RX_CARD = 14;//发出的订单信息

    }
}
