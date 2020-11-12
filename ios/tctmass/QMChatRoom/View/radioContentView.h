//
//  RadioContentView.h
//  IMSDK-OC
//
//  Created by lishuijiao on 2019/1/10.
//  Copyright © 2019年 HCF. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface  RadioContentView : UIView

@property (nonatomic, copy) void(^selectRadio)(NSArray *);

- (void)loadData:(NSArray *)reason;

@end

