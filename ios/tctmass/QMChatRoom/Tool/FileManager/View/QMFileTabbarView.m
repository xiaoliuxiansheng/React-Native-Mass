//
//  QMFileTabbarView.m
//  IMSDK-OC
//
//  Created by HCF on 16/8/15.
//  Copyright © 2016年 HCF. All rights reserved.
//

#import "QMFileTabbarView.h"

@implementation QMFileTabbarView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self createUI];
    }
    return self;
}

- (void)createUI {
    self.backgroundColor = [UIColor whiteColor];
    self.layer.borderColor = [[UIColor lightGrayColor] CGColor];
    self.layer.borderWidth = 0.5;
    
    self.doneButton = [[UIButton alloc] init];
    self.doneButton.frame = CGRectMake(kScreenWidth-80, 7, 70, 30);
    [self.doneButton setTitle:NSLocalizedString(@"button.complete", nil) forState:UIControlStateNormal];
    self.doneButton.layer.cornerRadius = 5;
    self.doneButton.layer.masksToBounds = YES;
    [self.doneButton setBackgroundImage:[[UIImage imageNamed:@"send_press_no_allow"] stretchableImageWithLeftCapWidth:10 topCapHeight:10] forState:UIControlStateNormal];
    [self.doneButton setBackgroundImage:[[UIImage imageNamed:@"send_press_allow"] stretchableImageWithLeftCapWidth:10 topCapHeight:10] forState:UIControlStateSelected];
    [self.doneButton addTarget:self action:@selector(doneAction) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:self.doneButton];
}


- (void)doneAction {
    self.selectAction();
}

@end
