//
//  QMAgent.h
//  QMLineSDK
//
//  Created by haochongfeng on 2018/10/23.
//  Copyright © 2018年 haochongfeng. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 当前客服状态
 */
typedef enum: NSInteger {
    QMKStatusRobot = 0, // 机器人
    
    QMKStatusOnline = 1, // 坐席在线
    
    QMKStatusOffline = 2, // 坐席离线
    
    QMKStatusClaim = 3, // 会话被领取
    
    QMKStatusFinish = 4, // 会话被结束
    
    QMKStatusVip = 5, // vip专属坐席
}QMKStatus;

#pragma mark -- 坐席信息 --
@interface QMAgent : NSObject

/**
 坐席(客服)工号
 */
@property (nonatomic, copy) NSString * exten;

/**
 坐席(客服)名称
 */
@property (nonatomic, copy) NSString * name;

/**
 坐席(客服)头像
 */
@property (nonatomic, copy) NSString * icon_url;

/**
 坐席(客服)类型
 */
@property (nonatomic, copy) NSString * type;

@end
