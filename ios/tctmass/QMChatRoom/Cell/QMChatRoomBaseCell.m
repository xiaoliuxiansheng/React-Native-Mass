//
//  QMChatRoomBaseCell.m
//  IMSDK-OC
//
//  Created by HCF on 16/3/10.
//  Copyright © 2016年 HCF. All rights reserved.
//

#import "QMChatRoomBaseCell.h"
#import "QMManager.h"
#import "QMWeiXinDateManager.h"

#define kIconImageViewWidth 45

@implementation QMChatRoomBaseCell
{
    CustomMessage *_message;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = [UIColor colorWithRed:240/255.0 green:240/255.0 blue:240/255.0 alpha:1];
        [self setUI];
    }
    return self;
}

- (void)progressChange:(NSNotification *)notfi {
    if ([notfi.name isEqualToString:_message._id]) {
        float progress = [notfi.object floatValue];
        [self setProgress:progress];
    }
}

- (void)prepareForReuse {
    [super prepareForReuse];
    self.iconImage.image = nil;
    self.chatBackgroudImage.image = nil;
    self.timeLabel.text = nil;
}

- (void)setUI {
    self.iconImage = [[UIImageView alloc] init];
    self.iconImage.backgroundColor = [UIColor whiteColor];
    self.iconImage.contentMode = UIViewContentModeScaleAspectFill;
    self.iconImage.layer.cornerRadius = 20.5;
    self.iconImage.layer.masksToBounds = true;
    self.iconImage.clipsToBounds = YES;
    [self.contentView addSubview:self.iconImage];
    
    self.timeLabel = [[UILabel alloc] init];
    self.timeLabel.hidden = YES;
    self.timeLabel.textAlignment = NSTextAlignmentCenter;
    self.timeLabel.backgroundColor = [UIColor clearColor];
    self.timeLabel.textColor = [UIColor grayColor];
    self.timeLabel.font = [UIFont systemFontOfSize:12];
    [self.contentView addSubview:self.timeLabel];
    
    self.chatBackgroudImage = [[UIImageView alloc] init];
    self.chatBackgroudImage.backgroundColor = [UIColor colorWithRed:240/255.0 green:240/255.0 blue:240/255.0 alpha:1];
    self.chatBackgroudImage.userInteractionEnabled = YES;
    [self.contentView addSubview:self.chatBackgroudImage];
    
    self.sendStatus = [[UIImageView alloc] init];
    self.sendStatus.userInteractionEnabled = YES;
    [self.contentView addSubview:self.sendStatus];
    
    UITapGestureRecognizer *tapResendMessage = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(reSendAction:)];
    [self.sendStatus addGestureRecognizer:tapResendMessage];
}

- (void)setData:(CustomMessage *)message avater:(NSString *)avater {
    _message = message;
    if (self.timeLabel.hidden == YES) {
        self.timeLabel.frame = CGRectZero;
    }else {
        self.timeLabel.frame = CGRectMake(0, 10, kScreenWidth, 20);
    }
//    self.timeLabel.text = [QMDateManager showChatTime:message.createdTime];
    NSString *spString = message.createdTime;
    NSDate *confromTimesp = [NSDate dateWithTimeIntervalSince1970:[spString integerValue]/1000];
    self.timeLabel.text = [QMWeiXinDateManager getTimeStringAutoShort2:confromTimesp mustIncludeTime:true];
    // 重写
    if ([message.fromType isEqualToString:@"0"]) {
        //发送
        if ([NSURL URLWithString:avater]) {
            [self.iconImage sd_setImageWithURL:[NSURL URLWithString:avater] placeholderImage:[UIImage imageNamed:@"qm_default_user"]];
        }else {
            self.iconImage.image = [UIImage imageNamed:@"qm_default_user"];
        }
        self.iconImage.frame = CGRectMake(kScreenWidth-55, CGRectGetMaxY(self.timeLabel.frame)+10, 41, 41);
        
        UIImage *image = [UIImage imageNamed:@"SenderTextNodeBkg"];
        self.chatBackgroudImage.image = image;
        self.chatBackgroudImage.image = [self.chatBackgroudImage.image stretchableImageWithLeftCapWidth:20 topCapHeight:20];
    }else {
        //接收
        if ([message.userType isEqualToString:@"system"]) {
            [self.iconImage sd_setImageWithURL:[NSURL URLWithString:[QMConnect sdkSystemMessageIcon]] placeholderImage:[UIImage imageNamed:@"qm_default_robot"]];
        }else {
            if ([NSURL URLWithString:message.agentIcon]) {
                [self.iconImage sd_setImageWithURL:[NSURL URLWithString:message.agentIcon] placeholderImage:[UIImage imageNamed:@"qm_default_agent"]];
            }else {
                if ([message.isRobot isEqualToString:@"1"]) {
                    self.iconImage.image = [UIImage imageNamed:@"qm_default_robot"];
                }else {
                    self.iconImage.image = [UIImage imageNamed:@"qm_default_agent"];
                }
            }
        }
        
        self.iconImage.frame = CGRectMake(10, CGRectGetMaxY(self.timeLabel.frame)+10, 41, 41);
        
        UIImage *image = [UIImage imageNamed:@"ReceiverTextNodeBkg"];
        self.chatBackgroudImage.image = image;
        self.chatBackgroudImage.image = [self.chatBackgroudImage.image stretchableImageWithLeftCapWidth:20 topCapHeight:20];
        
        self.sendStatus.hidden = YES;
    }
    
    if ([message.fromType isEqualToString:@"0"]) {
        if ([message.status isEqualToString:@"0"]) {
            self.sendStatus.hidden = YES;
        }else if ([message.status isEqualToString:@"1"]) {
            self.sendStatus.hidden = NO;
            self.sendStatus.image = [UIImage imageNamed:@"icon_send_failed"];
            [self removeSendingAnimation];
        } else if ([message.status isEqualToString:@"2"]) {
            self.sendStatus.hidden = NO;
            self.sendStatus.image = [UIImage imageNamed:@"icon_sending"];
            [self showSendingAnimation];
            [[NSNotificationCenter defaultCenter] removeObserver:self]; // 防止cell重用已监听其他id
            [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(progressChange:) name:message._id object:nil];
        }
    }
}

- (void)showSendingAnimation {
    CABasicAnimation * animation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    animation.fromValue = @0.0;
    animation.toValue = @(2*M_PI);
    animation.duration = 1.0;
    animation.repeatCount = MAXFLOAT;
    animation.removedOnCompletion = NO;
    __weak QMChatRoomBaseCell *strongSelf = self;
    dispatch_async(dispatch_get_main_queue(), ^{
        [strongSelf.sendStatus.layer addAnimation:animation forKey:@"transform.rotation.z"];
    });
}

- (void)removeSendingAnimation {
    __weak QMChatRoomBaseCell *strongSelf = self;
    dispatch_async(dispatch_get_main_queue(), ^{
        [strongSelf.sendStatus.layer removeAnimationForKey:@"transform.rotation.z"];
    });
}

- (void)setProgress: (float)progress {
    
}

- (void)longPressTapGesture:(id)sender {
    
}

- (void)reSendAction: (UITapGestureRecognizer *)gesture {
    if ([QMManager defaultManager].isFinish == YES) {
        [[NSNotificationCenter defaultCenter] postNotificationName:CUSTOMSRV_FINISH object:@"tapAction"];
        return;
    }
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"" message:NSLocalizedString(@"button.sendAgain", nil) preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction * doneAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"button.sure", nil) style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        if ([_message.status isEqualToString:@"1"]) {
                    
            [QMConnect resendMessage:_message successBlock:^{
                NSLog(@"消息重发成功");
            } failBlock:^{
                NSLog(@"消息重发失败");
            }];
        }
    }];
    UIAlertAction * cancelAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"button.cancel", nil) style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {

    }];
    [alert addAction:doneAction];
    [alert addAction:cancelAction];
    [[[[UIApplication sharedApplication] keyWindow] rootViewController] presentViewController:alert animated:YES completion:nil];
}

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

@end
