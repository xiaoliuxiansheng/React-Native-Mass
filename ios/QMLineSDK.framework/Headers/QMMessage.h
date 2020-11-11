//
//  QMMessage.h
//  QMLineSDK
//
//  Created by haochongfeng on 2018/10/23.
//  Copyright © 2018年 haochongfeng. All rights reserved.
//

#import <Foundation/Foundation.h>

#pragma mark -- 消息类型枚举 --
typedef enum: NSInteger {
    /** 文本 */
    QMMessageTypeText = 0,
    /** 语音 */
    QMMessageTypeAudio = 1,
    /** 图片 */
    QMMessageTypeImage = 2,
    /** 文件 */
    QMMessageTypeFile = 3,
    /** 评价 */
    QMMessageTypeInvestigate = 4,
    /** 网页 */
    QMMessageTypeIframe = 5,
    /** 视频 */
    QMMessageTypeVideo = 6,
    /** 富文本 */
    QMMessageTypeRichText = 7,
    /** 卡片 */
    QMMessageTypeCard = 8,
    /** 卡片 */
    QMMessageTypeCardInfo = 9,
    /** 撤销 */
    QMMessageTypeWithdraw = 10,
}QMMessageType;

typedef enum : NSUInteger {
    QMMessageCardTypeNone = 0,
    QMMessageCardTypeReaded,
    QMMessageCardTypeSeleced,
    QMMessageCardTypeHidden,
} QMMessageCardReadType;

#pragma mark -- 消息状态枚举 --
typedef enum: NSInteger {
    /** 发送成功 */
    QMMessageStatusSendSuccess = 0,
    /** 发送失败 */
    QMMessageStatusSendFailure = 1,
    /** 发送中 */
    QMMessageStatusSending = 2,
}QMMessageStatus;


#pragma mark -- 文件下载状态枚举 --
typedef enum: NSInteger {
    /** 下载成功 */
    QMDownloadStateSuccess = 0,
    /** 下载失败 */
    QMDownloadStateFailure = 1,
    /** 下载中 */
    QMDownloadStateDownloading = 2,
}QMDownloadState;

#pragma mark -- 富文本消息 --
@interface CustomRichText: NSObject

/**
 点击跳转地址
 */
@property (nonatomic, copy)NSString *url;

/**
 图片地址
 */
@property (nonatomic, copy)NSString *imageUrl;

/**
 标题
 */
@property (nonatomic, copy)NSString *title;

/**
 描述内容
 */
@property (nonatomic, copy)NSString *description;

@end

#pragma mark -- 卡片消息 --
@interface CustomCardMessage: NSObject

/**
 图片地址
 */
@property (nonatomic, copy)NSString *imageUrl;

/**
 标题
 */
@property (nonatomic, copy)NSString *title;

/**
 描述内容
 */
@property (nonatomic, copy)NSString *description;

/**
 价格
 */
@property (nonatomic, copy)NSString *price;

/**
 点击跳转地址
 */
@property (nonatomic, copy)NSString *url;

@end

#pragma mark -- 消息 --
@interface CustomMessage : NSObject

/**
 消息id
 */
@property (nonatomic, copy)NSString *_id;

/**
 消息内容
 */
@property (nonatomic, copy)NSString *message;

/**
 消息类型
 */
@property (nonatomic, copy)NSString *messageType;

/**
 平台信息 iOS Android
 */
@property (nonatomic, copy)NSString *platform;

/**
 设备型号
 */
@property (nonatomic, copy)NSString *device;

/**
 会话id(查询数据库消息)
 */
@property (nonatomic, copy)NSString *sessionId;

/**
 访客id(查询数据库消息)
 */
@property (nonatomic, copy)NSString *userId;

/**
 接入会话的渠道id(查询数据库消息)
 */
@property (nonatomic, copy)NSString *accessid;

/**
 消息创建时间
 */
@property (nonatomic, copy)NSString *createdTime;

/**
 消息来源 访客 or 坐席@"1"
 */
@property (nonatomic, copy)NSString *fromType;

/**
 消息发送状态 成功 or 失败 or 发送中 0/发送成功。1/发送失败。2/发送中
 */
@property (nonatomic, copy)NSString *status;

/**
 语音消息时长
 */
@property (nonatomic, copy)NSString *recordSeconds;

/**
 本地文件缓存相对路径
 */
@property (nonatomic, copy)NSString *localFilePath;

/**
 文件网络地址
 */
@property (nonatomic, copy)NSString *remoteFilePath;

/**
 文件名称
 */
@property (nonatomic, copy)NSString *fileName;

/**
 文件大小
 */
@property (nonatomic, copy)NSString *fileSize;

/**
 mp3文件大小
 */
@property (nonatomic, copy)NSString *mp3FileSize;

/**
 文件下载状态
 */
@property (nonatomic, copy)NSString *downloadState;

/**
 iframe消息宽度
 */
@property (nonatomic, copy)NSString *width;

/**
 iframe消息高度
 */
@property (nonatomic, copy)NSString *height;

/**
 客服工号
 */
@property (nonatomic, copy)NSString *agentExten;

/**
 客服名称
 */
@property (nonatomic, copy)NSString *agentName;

/**
 客服头像
 */
@property (nonatomic, copy)NSString *agentIcon;

/**
 消息是否来源于机器人  机器人@"1" 非机器人@"2"
 */
@property (nonatomic, copy)NSString *isRobot;

/**
 消息类型，系统消息-system、机器人消息-robot、人工消息-UUID、我自己发的消息-my
 */
@property (nonatomic, copy)NSString *userType;

/**
  消息是否展示以及副标题消息权限(目前用于语音转文本) 不展示@"0"  展示@"1"
 */
@property (nonatomic, copy)NSString *messageStatus;

/**
 消息是否已读 已读@"1" 未读@"0"
 */
@property (nonatomic, copy)NSString *isRead;

/**
 机器人回复是否有帮助 不是机器人@"none" 有帮助@"useful" 无帮助@"useless"
 */
@property (nonatomic, copy)NSString *isUseful;

/**
 机器人问题id
 */
@property (nonatomic, copy)NSString *questionId;

/**
 账户信息
 */
@property (nonatomic, copy)NSString *account;

/**
 机器人id
 */
@property (nonatomic, copy)NSString *robotId;

/**
 机器人类型
 */
@property (nonatomic, copy)NSString *robotType;

/**
 机器人回复语id
 */
@property (nonatomic, copy)NSString *robotMsgId;

/**
 xbot机器人置信度
 */
@property (nonatomic, copy)NSString *confidence;

/**
 xbot机器人访客问题
 */
@property (nonatomic, copy)NSString *ori_question;

/**
 xbot机器人标准问题
 */
@property (nonatomic, copy)NSString *std_question;

/**
 xbot机器人sessionid
 */
@property (nonatomic, copy)NSString *robotSessionId;

/**
 xbot机器人任务场景问答-答案
 */
@property (nonatomic, copy)NSString *robotFlowList;

/**
 xbot机器人任务场景问答-标题
 */
@property (nonatomic, copy)NSString *robotFlowTip;

/**
 xbot机器人任务场景问答-标题
 */
@property (nonatomic, copy)NSString *robotFlowType;

/**
 xbot机器人点选样式
 */
@property (nonatomic, copy)NSString *robotFlowsStyle;

/**
 富文本消息
 */
@property (nonatomic, strong)CustomRichText *richText;

/**
 富文本消息 建议使用 CustomRichText
 richTextUrl        : 点击跳转地址
 richTextPicUrl     : 图片地址
 richTextTitle      : 标题
 richTextDescription: 描述内容
 */
@property (nonatomic, copy)NSString *richTextUrl;
@property (nonatomic, copy)NSString *richTextPicUrl;
@property (nonatomic, copy)NSString *richTextTitle;
@property (nonatomic, copy)NSString *richTextDescription;

/**
 卡片消息
 */
@property (nonatomic, strong)CustomCardMessage *cardMessage;

/**
 卡片消息 建议使用 CustomCardMessage
 cardImage      : 图片地址
 cardHeader     : 标题
 cardSubhead    : 描述内容
 cardPrice      : 价格
 cardUrl        : 点击跳转地址
 */
@property (nonatomic, copy)NSString *cardImage;
@property (nonatomic, copy)NSString *cardHeader;
@property (nonatomic, copy)NSString *cardSubhead;
@property (nonatomic, copy)NSString *cardPrice;
@property (nonatomic, copy)NSString *cardUrl;

/**
 新卡片消息
 */
@property (nonatomic, copy)NSString *cardInfo_New;

/**
 新卡片详情
 */
@property (nonatomic, copy)NSString *cardMessage_New;

/**
 新卡片详情
 */
@property (nonatomic, strong)NSDictionary *cardMsg_NewDict;

/*
 读取状态（目前在xbotcard先使用）
 **/
@property (nonatomic, assign) QMMessageCardReadType cardType;

/*
 xbot机器人点赞文案
 **/
@property (nonatomic, copy)NSString *fingerUp;

/*
xbot机器人点赞文案
**/
@property (nonatomic, copy)NSString *fingerDown;

//@property (nonatomic, copy)NSString *from;
//
//@property (nonatomic, copy)NSString *tonotify;
//
//@property (nonatomic, copy)NSString *type;
//
//@property (nonatomic, copy)NSString *hideTime;

- (void)setValue:(id)value forUndefinedKey:(NSString *)key;

@end
