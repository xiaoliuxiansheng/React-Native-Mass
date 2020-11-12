//
//  QMQuestionController.h
//  IMSDK-OC
//
//  Created by zcz on 2019/12/31.
//  Copyright © 2019 HCF. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "QMQuestionModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface QMQuestionController : UIViewController
@property(nonatomic, copy) void(^backQuestion)(QMQuestionModel *);
@end

NS_ASSUME_NONNULL_END
