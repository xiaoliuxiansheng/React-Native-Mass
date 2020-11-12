//
//  QMChatRoomRobotFlowCollectionCell.m
//  IMSDK-OC
//
//  Created by lishuijiao on 2019/8/30.
//  Copyright © 2019 HCF. All rights reserved.
//

#import "QMChatRoomRobotFlowCollectionCell.h"

@implementation QMChatRoomRobotFlowCollectionCell {
    UILabel *_label;
    
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self createUI];
    }
    return self;
}

- (void)createUI {
    _label = [[UILabel alloc] init];
    _label.font = [UIFont systemFontOfSize:12.0f];
    _label.textAlignment = NSTextAlignmentCenter;
    _label.backgroundColor = [UIColor colorWithRed:242/255.0 green:242/255.0 blue:242/255.0 alpha:1];
    _label.numberOfLines = 2;
    [self.contentView addSubview:_label];
}

- (void)showData:(NSDictionary *)dic {
    _label.frame = CGRectMake(0, 0, CGRectGetWidth(self.frame), 40);

    if (dic.count > 0) {
        _label.text = dic[@"button"];
    }else {
        _label.text = @"";
    }    
}

@end
