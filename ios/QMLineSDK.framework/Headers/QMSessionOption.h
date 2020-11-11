//
//  QMSessionOption.h
//  QMLineSDK
//
//  Created by haochongfeng on 2018/10/29.
//  Copyright © 2018年 haochongfeng. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface QMSessionOption : NSObject

/**
 会话扩展信息
 */
@property (nonatomic, strong) NSDictionary *extend;


/**
 专属坐席id
 */
@property (nonatomic, copy) NSString *vipAgentNum;


/**
 初始会话配置信息

 @param number 专属坐席工号
 @return 实例化对象
 */
+ (instancetype)initWithVipAgentNum:(NSString *)number;


/**
 初始会话配置信息

 @param dicionary 开始会话扩展信息
 @return 实例化对象
 */
+ (instancetype)initWithExtend:(NSDictionary *)dicionary;


/**
 初始会话配置信息

 @param dictionary 开始会话扩展信息
 @param number 专属坐席工号
 @return 实例化对象
 */
+ (instancetype)initWithExtend:(NSDictionary *)dictionary vipAgentNum:(NSString *)number;

@end
