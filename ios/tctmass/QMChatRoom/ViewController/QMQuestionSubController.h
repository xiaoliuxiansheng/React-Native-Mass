//
//  QMQuestionSubController.h
//  IMSDK-OC
//
//  Created by zcz on 2020/1/2.
//  Copyright © 2020 HCF. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "QMQuestionModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface QMQuestionSubController : UIViewController
@property(nonatomic, strong) QMQuestionModel *groupModel;
@property(nonatomic, copy) void(^backQuestion)(QMQuestionModel *);

@end

NS_ASSUME_NONNULL_END
