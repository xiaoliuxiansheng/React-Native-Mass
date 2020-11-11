//
//  QMLineDelegate.h
//  QMLineSDK
//
//  Created by haochongfeng on 2018/10/26.
//  Copyright © 2018年 haochongfeng. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "QMLineError.h"
#import "QMAgent.h"

@protocol QMKRegisterDelegate <NSObject>

- (void)registerSuccess;

- (void)registerFailure:(QMLineError *)reason;

@end

@protocol QMKServiceDelegate <NSObject>

- (void)currentAgentStatus:(QMKStatus)status;

@optional
- (void)currentAgentInfo:(QMAgent *)agent;

@optional
- (void)currentSessionWaitNumber:(int)number;

@optional
- (void)inviteEvaluate;

@end
