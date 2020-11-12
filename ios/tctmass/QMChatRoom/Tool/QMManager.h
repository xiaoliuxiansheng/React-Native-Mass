//
//  QMManager.h
//  IMSDK-OC
//
//  Created by lishuijiao on 2018/5/23.
//  Copyright © 2018年 HCF. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface QMManager : NSObject

@property (nonatomic, assign) BOOL selectedPush;

@property (nonatomic, copy) NSDictionary *dic;

@property (nonatomic, assign) BOOL isFinish;

+ (instancetype)defaultManager;

@end
