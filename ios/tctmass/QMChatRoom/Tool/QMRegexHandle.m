//
//  QMRegexHandle.m
//  IMSDK-OC
//
//  Created by zcz on 2019/12/25.
//  Copyright © 2019 HCF. All rights reserved.
//

#import "QMRegexHandle.h"

@implementation QMRegexHandle

+ (NSArray <NSTextCheckingResult *>*)getMobileNumberLoc:(NSString *)sourcStr {
    if (sourcStr.length == 0) {
        return nil;
    }
    NSString *regStr = @"1(3[0-9]|4[56789]|5[0-9]|6[6]|7[0-9]|8[0-9]|9[189])[0-9]{8}";
    NSRegularExpression *regular = [[NSRegularExpression alloc] initWithPattern:regStr options:NSRegularExpressionCaseInsensitive error:nil];
    NSArray *arr = [regular matchesInString:sourcStr options:NSMatchingReportProgress range:NSMakeRange(0, sourcStr.length)];
    
    return arr;
}

@end
