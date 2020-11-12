//
//  QMLeaveMessageCell.h
//  IMSDK-OC
//
//  Created by haochongfeng on 2017/11/27.
//  Copyright © 2017年 HCF. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface QMLeaveMessageCell : UITableViewCell

@property (nonatomic, strong) UILabel *fieldLabel;

@property (nonatomic, strong) UITextField *textField;

@property (nonatomic, strong) UIView *backView;

- (void)setData: (NSDictionary *)information defaultValue: (NSString *)value;

@property (nonatomic, copy) void(^backInformation)(NSString *);

@end
