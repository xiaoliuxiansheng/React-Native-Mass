//
//  QMEvaluation.h
//  QMLineSDK
//
//  Created by lishuijiao on 2018/11/22.
//  Copyright © 2018年 haochongfeng. All rights reserved.
//

#import <Foundation/Foundation.h>
@class QMEvaluats;

@interface QMEvaluation : NSObject

@property (nonatomic, copy) NSString * title;

@property (nonatomic, copy) NSString * thank;

@property (nonatomic, copy) NSArray<QMEvaluats *> * evaluats;

@property (nonatomic, copy) NSString * timeout;
///满意度评价超时是否开启
@property (nonatomic, assign) BOOL CSRAging;
///访客是否开启满意度权限
@property (nonatomic, assign) BOOL CSRCustomerPush;
///访客离开是否弹出满意度评价权限
@property (nonatomic, assign) BOOL CSRCustomerLeavePush;

@end

@interface QMEvaluats : NSObject

@property (nonatomic, copy) NSString *name;

@property (nonatomic, copy) NSString * value;

@property (nonatomic, copy) NSArray * reason;
/// 标签是否必填
@property (nonatomic, copy) NSString * labelRequired;
/// 标签描述是否必填
@property (nonatomic, copy) NSString * proposalRequired;

@end
