//
//  QMLogistsMoreView.h
//  IMSDK-OC
//
//  Created by zcz on 2019/12/25.
//  Copyright © 2019 HCF. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "QMLogistcsInfoModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface QMLogistsMoreView : UIView
+ (instancetype)defualtView;
- (void)show:(QMLogistcsInfoModel *)model;
- (void)closeAction;
@end

NS_ASSUME_NONNULL_END
