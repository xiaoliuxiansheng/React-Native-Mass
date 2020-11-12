//
//  QMChatRoomRobotReplyView.h
//  IMSDK-OC
//
//  Created by haochongfeng on 2017/10/19.
//  Copyright © 2017年 HCF. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface QMChatRoomRobotReplyView : UIView

@property (nonatomic, strong) UIButton *helpBtn;

@property (nonatomic, strong) UIButton *noHelpBtn;

@property (nonatomic, strong) UIImageView *verticalLine;

@property (nonatomic, strong) UIImageView *horizonalLine;

@property (nonatomic, strong) UILabel *describeLbl;

@property (nonatomic, copy) NSString *status;

@property (nonatomic, copy) NSString *fingerUp;

@property (nonatomic, copy) NSString *fingerDown;

@end
