//
//  QMWeiXinDateManager.h
//  IMSDK-OC
//
//  Created by lishuijiao on 2019/5/17.
//  Copyright © 2019年 HCF. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface QMWeiXinDateManager : NSObject

/**
  * 仿照微信中的消息时间显示逻辑，将时间戳（单位：毫秒）转换为友好的显示格式.
  * 1）7天之内的日期显示逻辑是：今天、昨天(-1d)、前天(-2d)、星期？（只显示总计7天之内的星期数，即<=-4d）；
  * 2）7天之外（即>7天）的逻辑：直接显示完整日期时间。
  * @param dt 日期时间对象（本次被判断对象）
  * @param includeTime YES表示输出的格式里一定会包含“时间:分钟”，否则不包含（参考微信，不包含时分的情况，用于首页“消息”中显示时）
  * @return 输出格式形如：“刚刚”、“10:30”、“昨天 12:04”、“前天 20:51”、“星期二”、“2019/2/21 12:09”等形式
  * @since 1.3
  */
+ (NSString*)getTimeStringAutoShort2:(NSDate*)dt mustIncludeTime:(BOOL)includeTime;

+ (NSString*)getTimeString:(NSDate*)dt format:(NSString*)fmt;
/**
  * 获得指定NSDate对象iOS时间戳（格式遵从ios的习惯，以秒为单位）。
  */
+ (NSTimeInterval) getIOSTimeStamp:(NSDate*)dat;

/**
  * 获得指定NSDate对象iOS时间戳的long形式（格式遵从ios的习惯，以秒为单位，形如：1485159493）。
  */
+ (long) getIOSTimeStamp_l:(NSDate*)dat;

@end

