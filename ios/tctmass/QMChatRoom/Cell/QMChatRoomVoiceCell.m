//
//  QMChatRoomVoiceCell.m
//  IMSDK-OC
//
//  Created by HCF on 16/3/10.
//  Copyright © 2016年 HCF. All rights reserved.
//

#import "QMChatRoomVoiceCell.h"
#import <AVFoundation/AVFoundation.h>
#import <QMLineSDK/QMLineSDK.h>
#import "QMAudioPlayer.h"
#import "QMAudioAnimation.h"
#import "QMAlert.h"

@interface QMChatRoomVoiceCell() <AVAudioPlayerDelegate, MLEmojiLabelDelegate>

@end

/**
    语音消息
 */
@implementation QMChatRoomVoiceCell {
    
    UIImageView *_voicePlayImageView;
    
    UILabel *_secondsLabel;
        
    AVAudioSession *_audioSession;
    
    NSString *_messageId;
    
    UIImageView *_badgeView;
    
    UIView *_textView;
    
    MLEmojiLabel *_textLabel;
    
    UIActivityIndicatorView *_indicatorView;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self createUI];
    }
    return self;
}

- (void)createUI {    
    _voicePlayImageView = [[UIImageView alloc] init];
    _voicePlayImageView.animationDuration = 1.0;
    _voicePlayImageView.userInteractionEnabled = YES;
    [self.chatBackgroudImage addSubview:_voicePlayImageView];
    
    _secondsLabel = [[UILabel alloc] init];
    _secondsLabel.backgroundColor = [UIColor clearColor];
    _secondsLabel.font = [UIFont systemFontOfSize:16];
    [self.chatBackgroudImage addSubview:_secondsLabel];
    
    _badgeView = [[UIImageView alloc] init];
    _badgeView.backgroundColor = [UIColor redColor];
    _badgeView.layer.cornerRadius = 4;
    _badgeView.layer.masksToBounds = YES;
    [_badgeView setHidden:YES];
    [self.contentView addSubview:_badgeView];
        
    _textView = [[UIView alloc] init];
    _textView.backgroundColor = [UIColor whiteColor];
    [_textView setHidden:YES];
    [self.contentView addSubview:_textView];
    
    _textLabel = [MLEmojiLabel new];
    _textLabel.numberOfLines = 0;
    _textLabel.font = [UIFont systemFontOfSize:14.0f];
    _textLabel.lineBreakMode = NSLineBreakByTruncatingTail;
    _textLabel.delegate = self;
    _textLabel.disableEmoji = NO;
    _textLabel.disableThreeCommon = NO;
    _textLabel.isNeedAtAndPoundSign = YES;
    _textLabel.customEmojiRegex = @"\\:[^\\:]+\\:";
    _textLabel.customEmojiPlistName = @"expressionImage.plist";
    _textLabel.customEmojiBundleName = @"QMEmoticon.bundle";
    _textLabel.textColor = [UIColor blackColor];
    [_textView addSubview:_textLabel];

    _indicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
    _indicatorView.frame = CGRectMake(15, 10, 20, 20);
    _indicatorView.color = [UIColor grayColor];
    [_textView addSubview:_indicatorView];

    
    _audioSession = [AVAudioSession sharedInstance];
    
    UILongPressGestureRecognizer * longPressGesture = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressTapGesture:)];
    [self.chatBackgroudImage addGestureRecognizer:longPressGesture];
    
    // 默认为听筒
    [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayAndRecord error:nil];
}

- (void)setData:(CustomMessage *)message avater:(NSString *)avater {
    _messageId = message._id;
    self.message = message;
    [super setData:message avater:avater];
    
    UITapGestureRecognizer * tapPressGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapPressGesture:)];
    [self.chatBackgroudImage addGestureRecognizer:tapPressGesture];
    
    if ([message.fromType isEqualToString:@"0"]) {
        self.chatBackgroudImage.frame = CGRectMake(CGRectGetMinX(self.iconImage.frame)-5-125, CGRectGetMaxY(self.timeLabel.frame)+10, 125, 40);
        self.sendStatus.frame = CGRectMake(CGRectGetMinX(self.chatBackgroudImage.frame)-20, CGRectGetMaxY(self.chatBackgroudImage.frame)-32, 20, 20);
        
        _voicePlayImageView.frame = CGRectMake(125-30, 11, 13, 17);
        _voicePlayImageView.image = [UIImage imageNamed:@"SenderVoiceNodePlaying"];
                
        if ([message.status isEqualToString:@"0"]) {
            _secondsLabel.textColor = [UIColor whiteColor];
            _secondsLabel.frame = CGRectMake(CGRectGetMinX(_voicePlayImageView.frame)-50, 11, 40, 20);
            _secondsLabel.text = [NSString stringWithFormat:@"%@''",message.recordSeconds];
            _secondsLabel.textAlignment = NSTextAlignmentRight;
            _secondsLabel.hidden = NO;
        }else {
            _secondsLabel.hidden = YES;
        }
        
        self.sendStatus.frame = CGRectMake(CGRectGetMinX(self.chatBackgroudImage.frame)-20, CGRectGetMinY(self.chatBackgroudImage.frame)+10, 20, 20);
        
        [[QMAudioAnimation sharedInstance]setAudioAnimationPlay:YES and:_voicePlayImageView];
        
        [_badgeView setHidden:YES];
    }else {
        self.chatBackgroudImage.frame = CGRectMake(CGRectGetMaxX(self.iconImage.frame)+5, CGRectGetMaxY(self.timeLabel.frame)+10, 125, 40);
        _badgeView.frame = CGRectMake(CGRectGetMaxX(self.chatBackgroudImage.frame)+5, CGRectGetMaxY(self.timeLabel.frame)+15, 8, 8);
        _voicePlayImageView.frame = CGRectMake(22, 11, 13, 17);
        _voicePlayImageView.image = [UIImage imageNamed:@"ReceiverVoiceNodePlaying"];

        _secondsLabel.textColor = [UIColor blackColor];
        _secondsLabel.frame = CGRectMake(CGRectGetMaxX(_voicePlayImageView.frame)+10, 11, 40, 20);
        _secondsLabel.text = [NSString stringWithFormat:@"%@''",message.recordSeconds ? message.recordSeconds : 0];
        _secondsLabel.textAlignment = NSTextAlignmentLeft;
        
        [[QMAudioAnimation sharedInstance]setAudioAnimationPlay:NO and:_voicePlayImageView];
        
        CustomMessage *msg = [QMConnect getOneDataFromDatabase:message._id].firstObject;
        if ([msg.isRead isEqualToString:@"1"]) {
            [_badgeView setHidden:YES];
        }else {
            [_badgeView setHidden:NO];
        }
    }
    
    NSString *fileName;
    if ([self existFile:self.message.message]) {
        fileName = self.message.message;
    }else {
        fileName = self.message._id;
    }

    if ([[QMAudioPlayer sharedInstance] isPlaying:fileName] == true) {
        [[QMAudioAnimation sharedInstance]startAudioAnimation:_voicePlayImageView];
    }
    
    [self showOrNotVoiceText];
}

- (void)showOrNotVoiceText {
    [_textView setHidden:YES];
    NSString *voiceStatus = [QMConnect queryVoiceTextStatusWithmessageId:_messageId];
    CGFloat X = 0;
    NSLog(@"voiceStatus---%@", voiceStatus);
    if ([voiceStatus isEqualToString: @"1"] && self.message.fileName.length > 0) {
        [_textView setHidden:NO];
        [_indicatorView setHidden:YES];
        [_indicatorView stopAnimating];
        [_textLabel setHidden: NO];
        _textLabel.text = self.message.fileName;
        CGSize size = [_textLabel preferredSizeWithMaxWidth: kScreenWidth - 60 - 55 - 5 - 30];

        if ([self.message.fromType isEqualToString:@"0"]) {
            X = kScreenWidth - size.width - 5 - 55 - 30;
        }else {
            X = 5 + 51;
        }
        
        _textView.frame = CGRectMake( X, CGRectGetMaxY(self.chatBackgroudImage.frame) + 5, size.width + 30, size.height + 20);
        _textLabel.frame = CGRectMake(15, 10, size.width, size.height);
    }else if ([voiceStatus isEqualToString:@"2"]) {
        [_textView setHidden:NO];
        [_indicatorView setHidden:NO];
        [_indicatorView startAnimating];
        [_textLabel setHidden:YES];
        
        if ([self.message.fromType isEqualToString:@"0"]) {
            X = kScreenWidth - 125 - 5 - 55;
        }else {
            X = 5 + 51;
        }

        _textView.frame = CGRectMake( X, CGRectGetMaxY(self.chatBackgroudImage.frame) + 5, 125, 40);
    }
    
//    if (status && self.message.fileName.length > 0) {
//        _textLabel.text = self.message.fileName;
//        CGSize size = [_textLabel preferredSizeWithMaxWidth: kScreenWidth - 60 - 55 - 5 - 30];
//
//        if ([self.message.fromType isEqualToString:@"0"]) {
//            X = kScreenWidth - size.width - 5 - 55 - 30;
//        }else {
//            X = 5 + 51;
//        }
//
//        _textView.frame = CGRectMake( X, CGRectGetMaxY(self.chatBackgroudImage.frame) + 5, size.width + 30, size.height + 20);
//        _textLabel.frame = CGRectMake(15, 10, size.width, size.height);
//        [_textView setHidden:NO];
//    }
}

- (void)longPressTapGesture:(UILongPressGestureRecognizer *)sender {
    if (sender.state == UIGestureRecognizerStateBegan) {
        [self becomeFirstResponder];
        UIMenuController *menu = [UIMenuController sharedMenuController];
        UIMenuItem *reciverMenu = [[UIMenuItem alloc] initWithTitle:NSLocalizedString(@"button.receiver", nil) action:@selector(reciverMenu:)];
        UIMenuItem *speakerMenu = [[UIMenuItem alloc] initWithTitle:NSLocalizedString(@"button.speaker", nil) action:@selector(speakerMenu:)];
        UIMenuItem *convertMenu = [[UIMenuItem alloc] initWithTitle:NSLocalizedString(@"button.ConvertText", nil) action:@selector(convertMenu:)];
        UIMenuItem *removeMenu = [[UIMenuItem alloc] initWithTitle:NSLocalizedString(@"button.delete", nil) action:@selector(removeMenu:)];
        NSString *voiceStatus = [QMConnect queryVoiceTextStatusWithmessageId:_messageId];
        if ([voiceStatus isEqualToString:@"0"]) {
            [menu setMenuItems:[NSArray arrayWithObjects:reciverMenu,speakerMenu,convertMenu,removeMenu, nil]];
        }else {
            [menu setMenuItems:[NSArray arrayWithObjects:reciverMenu,speakerMenu,removeMenu, nil]];
        }
        [menu setTargetRect:self.chatBackgroudImage.frame inView:self];
        [menu setMenuVisible:true animated:true];
        
        UIWindow *window = [[[UIApplication sharedApplication] delegate] window];
        if ([window isKeyWindow] == NO) {
            [window becomeKeyWindow];
            [window makeKeyAndVisible];
        }
    }    
}

- (BOOL)canBecomeFirstResponder {
    return YES;
}

- (BOOL)canPerformAction:(SEL)action withSender:(id)sender {
    if (action == @selector(reciverMenu:) || action == @selector(speakerMenu:) || action == @selector(removeMenu:) || action == @selector(convertMenu:)) {
        return YES;
    }else {
        return  NO;
    }
}

- (void)reciverMenu:(id)sendr {
    //听筒
    NSError *error = nil;
    if ([[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayAndRecord error:&error]) {
    }
}

- (void)speakerMenu:(id)sender {
    // 扬声器
    NSError *error = nil;
    [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:&error];
}

- (void)convertMenu:(id)sender {
    //设置消息为已读
    [QMConnect changeAudioMessageStatus:_messageId];
    // 转文字
    [QMConnect sendMsgAudioToText:self.message successBlock:^{
        //刷新cell高度
        dispatch_async(dispatch_get_main_queue(), ^{
            [[NSNotificationCenter defaultCenter] postNotificationName:CUSTOMSRV_VOICETEXT object:@[self.message._id, @""]];
        });
    } failBlock:^{
        dispatch_async(dispatch_get_main_queue(), ^{
            [QMAlert showMessage:NSLocalizedString(@"title.autonText_fail", nil)];
        });
    }];
}

- (void)removeMenu:(id)sender {
    // 删除语音(只能删除本地数据库消息)
    // 删除文本消息
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:NSLocalizedString(@"title.prompt", nil) message:NSLocalizedString(@"title.statement", nil) preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"button.cancel", nil) style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {

    }];
    UIAlertAction *sureAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"button.sure", nil) style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [QMConnect removeDataFromDataBase:_messageId];
        [[NSNotificationCenter defaultCenter] postNotificationName:CHATMSG_RELOAD object:nil];
    }];
    [alertController addAction:cancelAction];
    [alertController addAction:sureAction];
    
    [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:alertController animated:YES completion:nil];
}

- (void)tapPressGesture:(id)sender {
    NSLog(@"点击语音消息");
    [_badgeView setHidden:YES];
    [QMConnect changeAudioMessageStatus:_messageId];
    
    [[QMAudioAnimation sharedInstance] stopAudioAnimation:nil];
    [[QMAudioAnimation sharedInstance] startAudioAnimation:_voicePlayImageView];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)((self.message.recordSeconds).intValue * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [[QMAudioAnimation sharedInstance] stopAudioAnimation:_voicePlayImageView];
    });
    
    NSString *fileName;
    if ([self existFile:self.message.message]) {
        fileName = self.message.message;
    }else if ([self existFile:[NSString stringWithFormat:@"%@", self.message._id]]) {
        fileName = self.message._id;
    }else {
        NSString *playUrl = [NSString stringWithFormat:@"%@/%@/%@", NSHomeDirectory(), @"Documents", [NSString stringWithFormat:@"%@", self.message._id]];
        fileName = self.message._id;
        NSURL *fileUrl = [NSURL URLWithString:self.message.remoteFilePath];
        NSData *data = [NSData dataWithContentsOfURL:fileUrl];
        
        [data writeToFile:playUrl atomically:YES];
    }
    
    // 目前只能发送语音消息 不能接收
    [[QMAudioPlayer sharedInstance] startAudioPlayer:fileName withDelegate:self];
}

- (BOOL)existFile: (NSString *)name {
    NSString * filePath = [NSString stringWithFormat:@"%@/%@/%@", NSHomeDirectory(), @"Documents", name];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if ([fileManager fileExistsAtPath:filePath]) {
        return YES;
    }else {
        return NO;
    }
}

- (void)awakeFromNib {
    // Initialization code
    [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
