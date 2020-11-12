//
//  QMManager.m
//  IMSDK-OC
//
//  Created by lishuijiao on 2018/5/23.
//  Copyright © 2018年 HCF. All rights reserved.
//

#import "QMManager.h"

@implementation QMManager

+ (instancetype)defaultManager {
    static QMManager *manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [QMManager new];
    });
    return manager;
}

@end
