//
//  QMChatRoomRobotReplyView.m
//  IMSDK-OC
//
//  Created by haochongfeng on 2017/10/19.
//  Copyright © 2017年 HCF. All rights reserved.
//

#import "QMChatRoomRobotReplyView.h"

@implementation QMChatRoomRobotReplyView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self createView];
    }
    return  self;
}

- (void)setFrame:(CGRect)frame {
    [super setFrame:frame];
    self.noHelpBtn.frame = CGRectMake(self.bounds.size.width - 70, 0, 70, 25);
    self.verticalLine.frame = CGRectMake(CGRectGetMinX(self.noHelpBtn.frame)-5, 5, 0.5, 15);
    self.helpBtn.frame = CGRectMake(CGRectGetMinX(self.verticalLine.frame)-75, 0, 70, 25);
    self.horizonalLine.frame = CGRectMake(0, CGRectGetMaxY(self.noHelpBtn.frame)+5, self.bounds.size.width, 0.5);
    self.describeLbl.frame = CGRectMake(0, CGRectGetMaxY(self.horizonalLine.frame)+5, self.bounds.size.width, self.bounds.size.height - CGRectGetMaxY(self.horizonalLine.frame) - 10);
}

- (void)setStatus:(NSString *)status {
    if ([status isEqualToString:@"none"]) {
        [self.horizonalLine setHidden:YES];
        [self.describeLbl setHidden:YES];
        [self.noHelpBtn setSelected:NO];
        [self.helpBtn setSelected:NO];
    }else if ([status isEqualToString:@"useful"]) {
        [self.horizonalLine setHidden:NO];
        [self.describeLbl setHidden:NO];
        [self.noHelpBtn setSelected:NO];
        [self.helpBtn setSelected:YES];
        self.describeLbl.text = self.fingerUp.length > 0 ? self.fingerUp : NSLocalizedString(@"title.thanks_yes", nil);
    }else if ([status isEqualToString:@"useless"]) {
        [self.horizonalLine setHidden:NO];
        [self.describeLbl setHidden:NO];
        [self.noHelpBtn setSelected:YES];
        [self.helpBtn setSelected:NO];
        self.describeLbl.text = self.fingerDown.length > 0 ? self.fingerDown : NSLocalizedString(@"title.thanks_no", nil);
    }else {
        [self.horizonalLine setHidden:YES];
        [self.describeLbl setHidden:YES];
        [self.noHelpBtn setSelected:NO];
        [self.helpBtn setSelected:NO];
    }
}

- (void)createView {
    self.noHelpBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.noHelpBtn.backgroundColor = [UIColor clearColor];
    [self.noHelpBtn setImage:[UIImage imageNamed:@"qm_useless_nor"] forState:UIControlStateNormal];
    [self.noHelpBtn setImage:[UIImage imageNamed:@"qm_useless_sel"] forState:UIControlStateSelected];
    [self.noHelpBtn setTitle:NSLocalizedString(@"button.nohelp", nil) forState:UIControlStateNormal];
    [self.noHelpBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    [self.noHelpBtn setTitleColor:[UIColor colorWithRed:29/255.0 green:82/255.0 blue:206/255.0 alpha:1] forState:UIControlStateSelected];
    [self.noHelpBtn setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 50)];
    self.noHelpBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    [self addSubview:self.noHelpBtn];
    
    self.verticalLine = [[UIImageView alloc] init];
    self.verticalLine.backgroundColor = [UIColor lightGrayColor];
    [self addSubview:self.verticalLine];

    self.helpBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.helpBtn.backgroundColor = [UIColor clearColor];
    [self.helpBtn setImage:[UIImage imageNamed:@"qm_useful_nor"] forState:UIControlStateNormal];
    [self.helpBtn setImage:[UIImage imageNamed:@"qm_useful_sel"] forState:UIControlStateSelected];
    [self.helpBtn setTitle:NSLocalizedString(@"button.yeshelp", nil) forState:UIControlStateNormal];
    [self.helpBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    [self.helpBtn setTitleColor:[UIColor colorWithRed:29/255.0 green:82/255.0 blue:206/255.0 alpha:1] forState:UIControlStateSelected];
    [self.helpBtn setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 50)];
    self.helpBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    [self addSubview:self.helpBtn];

    self.horizonalLine = [[UIImageView alloc] init];
    self.horizonalLine.backgroundColor = [UIColor lightGrayColor];
    [self addSubview:self.horizonalLine];
    
    self.describeLbl = [[UILabel alloc] init];
    self.describeLbl.backgroundColor = [UIColor clearColor];
    self.describeLbl.font = [UIFont systemFontOfSize:13];
    self.describeLbl.textColor = [UIColor grayColor];
    self.describeLbl.numberOfLines = 0;
    [self addSubview:self.describeLbl];
}
@end
