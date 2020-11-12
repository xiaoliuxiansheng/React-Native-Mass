//
//  QMFileTabbarView.h
//  IMSDK-OC
//
//  Created by HCF on 16/8/15.
//  Copyright © 2016年 HCF. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface QMFileTabbarView : UIView

@property (nonatomic, strong)void(^selectAction)(void);

@property (nonatomic, strong)UIButton *doneButton;

@end
