//
//  QMTextModel.h
//  IMSDK-OC
//
//  Created by haochongfeng on 2018/1/23.
//  Copyright © 2018年 HCF. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface QMTextModel : NSObject

@property (nonatomic, copy)NSString *content;

@property (nonatomic, copy)NSString *type;
/// 第几次出现的标识（区别type相同的情况）
@property (nonatomic, copy)NSString *rangeValue;

@property (nonatomic, copy)NSString *status;

+ (CGFloat)calcRobotHeight: (NSString *)htmlString;

+ (CGFloat)calcTextHeight: (NSString *)text width:(CGFloat)width;

+ (CGFloat)calculateRowHeight:(NSString *)string fontSize:(NSInteger)fontSize width:(CGFloat)width;

+ (NSMutableArray *)dictionaryWithJsonString:(NSString *)jsonString;

+ (CGFloat)calcxbotRobotHeight: (NSString *)htmlString textWidth:(CGFloat)textWidth;

@end
