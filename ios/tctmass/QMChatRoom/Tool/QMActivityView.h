//
//  QMActivityView.h
//  IMSDK-OC
//
//  Created by zcz on 2020/1/2.
//  Copyright © 2020 HCF. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface QMActivityView : UIActivityIndicatorView

+ (void)startAnimating;
+ (void)stopAnimating;

@end

NS_ASSUME_NONNULL_END
