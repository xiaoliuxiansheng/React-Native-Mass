//
//  QMLineSDK.h
//  QMLineSDK
//
//  Created by haochongfeng on 2018/10/23.
//  Copyright © 2018年 haochongfeng. All rights reserved.
//  SDK Version = 3.0.0

#import <UIKit/UIKit.h>

//! Project version number for QMLineSDK.
FOUNDATION_EXPORT double QMLineSDKVersionNumber;

//! Project version string for QMLineSDK.
FOUNDATION_EXPORT const unsigned char QMLineSDKVersionString[];

// In this header, you should import all the public headers of your framework using statements like #import <QMLineSDK/PublicHeader.h>

#import "QMAgent.h"
#import "QMMessage.h"
#import "QMEvaluation.h"
#import "QMConnect.h"
#import "QMLineError.h"
#import "QMLineDelegate.h"
#import "QMSessionOption.h"


/**
 *  注册accessId成功通知
 */
#define CUSTOM_LOGIN_SUCCEED @"customLoginSucceed"

/**
 *  注册accessId失败通知
 */
#define CUSTOM_LOGIN_ERROR_USER @"customLoginErrorUser"

/**
 *  新消息通知
 */
#define CHATMSG_RELOAD @"chatMsgReload"

/**
 *  机器人客服通知
 */
#define ROBOT_SERVICE @"robotService"

/**
 *  客服在线
 */
#define CUSTOMSRV_ONLINE @"CustomOnline"

/**
 *  客服不在线
 */
#define CUSTOMSRV_OFFLINE @"CustomOffline"

/**
 *  在线领取消息
 */
#define CUSTOMSRV_CLAIM @"customClaim"

/**
 *  后台主动推送满意度调查
 */
#define CUSTOMSRV_INVESTIGATE @"customsrvInvestigate"

/**
 *  排队人数通知
 */
#define CUSTOMSRV_QUEUENUM @"customsrvqueuenum"

/**
 *  结束会话通知
 */
#define CUSTOMSRV_FINISH @"customsrvfinish"

/**
 *  坐席信息通知
 */
#define CUSTOMSRV_AGENT @"customagent"

/**
 *  专属坐席通知
 */
#define CUSTOMSRV_VIP @"customvip"

/**
 * 日程管理中的留言通知 (只适用于开启日程管理的坐席)
 */
#define CUSTOMSRV_LEAVEMSG @"leavemsg"

/**
 * 正在输入
 */
#define CUSTOMSRV_IMPORTING @"importing"

/**
 * 撤回消息
 */
#define CUSTOMSRV_DRAWMESSAGE @"drawmessage"

/**
 * 小陌机器人满意度评价通知
 */
#define CUSTOMSRV_SATISFACTION @"satisfaction"

/**
 * xbot机器人开启联想输入
 */
#define CUSTOMSRV_ASSOCIATSINPUT @"associatsinput"

 /**
 *   语音转文本
 */
#define CUSTOMSRV_VOICETEXT @"voiceText"
