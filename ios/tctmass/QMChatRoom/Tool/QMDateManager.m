//
//  QMDateManager.m
//  IMSDK-OC
//
//  Created by haochongfeng on 2017/5/17.
//  Copyright © 2017年 HCF. All rights reserved.
//

#import "QMDateManager.h"

@implementation QMDateManager

+ (NSString *)showChatTime:(NSString *)timeT {
    NSString * str = @"";
    UInt64 msgTime = timeT.longLongValue;
    UInt64 recordTime = [[NSDate date] timeIntervalSince1970]*1000;
    UInt64 dxTime = recordTime - msgTime;
    if (dxTime<60*1000) {
        //几秒前
        str = [NSString stringWithFormat:@"%llu 秒前",dxTime/1000];
    }else if (60*1000<dxTime && dxTime<60*60*1000) {
        //几分钟前
        str = [NSString stringWithFormat:@"%llu 分钟前",dxTime/(60*1000)];
    }else if (dxTime > 60*60*1000) {
        NSString * string = [NSString stringWithFormat:@"%@",timeT];
        NSDate * date = [NSDate dateWithTimeIntervalSince1970:string.doubleValue/1000];
        NSDateFormatter * formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"YYYY-MM-dd HH:mm"];
        formatter.formatterBehavior = NSDateFormatterBehaviorDefault;
        formatter.timeZone= [NSTimeZone timeZoneWithAbbreviation:@"UTC"];
        NSTimeZone * zone = [NSTimeZone systemTimeZone];
        NSInteger inv = [zone secondsFromGMTForDate:date];
        NSTimeInterval  timeInv = inv;
        NSDate * newDate = [date dateByAddingTimeInterval:timeInv];
        str = [formatter stringFromDate:newDate];
    }
    return str;
}

@end
