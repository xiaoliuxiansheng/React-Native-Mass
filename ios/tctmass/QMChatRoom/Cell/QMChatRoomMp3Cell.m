//
//  QMChatRoomMp3Cell.m
//  IMSDK-OC
//
//  Created by lishuijiao on 2018/4/23.
//  Copyright © 2018年 HCF. All rights reserved.
//

#import "QMChatRoomMp3Cell.h"
#import <AVFoundation/AVFoundation.h>
#import <QMLineSDK/QMLineSDK.h>
#import "QMAudioPlayer.h"
#import "QMAudioAnimation.h"

@interface QMChatRoomMp3Cell() <AVAudioPlayerDelegate>

@end

@implementation QMChatRoomMp3Cell
{
    UIImageView *_voicePlayImageView;
    
    UILabel *_secondsLabel;
    
    AVAudioSession *_audioSession;
    
    NSString *_messageId;
    
    UIImageView *_badgeView;
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
    
    _audioSession = [AVAudioSession sharedInstance];
    
    UILongPressGestureRecognizer * longPressGesture = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressTapGesture:)];
    [_voicePlayImageView addGestureRecognizer:longPressGesture];
    
    // 默认为听筒
    [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayAndRecord error:nil];
}

- (void)setData:(CustomMessage *)message avater:(NSString *)avater {
    _messageId = message._id;
    self.message = message;
    [super setData:message avater:avater];
    
    UITapGestureRecognizer * tapPressGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapPressGesture:)];
    [self.chatBackgroudImage addGestureRecognizer:tapPressGesture];
    
    NSString *playUrl = [NSString stringWithFormat:@"%@/%@/%@", NSHomeDirectory(), @"Documents", [NSString stringWithFormat:@"%@", self.message._id]];
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_async(queue, ^{
        [self downloadFile:playUrl];
        
    });
    
    if ([message.fromType isEqualToString:@"0"]) {
        self.chatBackgroudImage.frame = CGRectMake(CGRectGetMinX(self.iconImage.frame)-10-125, CGRectGetMaxY(self.timeLabel.frame)+10, 125, 40);
        self.sendStatus.frame = CGRectMake(CGRectGetMinX(self.chatBackgroudImage.frame)-25, CGRectGetMaxY(self.chatBackgroudImage.frame)-32, 20, 20);
        
        _voicePlayImageView.frame = CGRectMake(125-35, 11, 13, 17);
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
        
        self.sendStatus.frame = CGRectMake(CGRectGetMinX(self.chatBackgroudImage.frame)-25, CGRectGetMinY(self.chatBackgroudImage.frame)+10, 20, 20);
        
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

}

- (void)longPressTapGesture:(UILongPressGestureRecognizer *)sender {
    if (sender.state == UIGestureRecognizerStateBegan) {
        [self becomeFirstResponder];
        UIMenuController *menu = [UIMenuController sharedMenuController];
        UIMenuItem *reciverMenu = [[UIMenuItem alloc] initWithTitle:NSLocalizedString(@"button.receiver", nil) action:@selector(reciverMenu:)];
        UIMenuItem *speakerMenu = [[UIMenuItem alloc] initWithTitle:NSLocalizedString(@"button.speaker", nil) action:@selector(speakerMenu:)];
        UIMenuItem *removeMenu = [[UIMenuItem alloc] initWithTitle:NSLocalizedString(@"button.delete", nil) action:@selector(removeMenu:)];
        [menu setMenuItems:[NSArray arrayWithObjects:reciverMenu,speakerMenu,removeMenu, nil]];
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
    if (action == @selector(reciverMenu:) || action == @selector(speakerMenu:) || action == @selector(removeMenu:)) {
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
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)((_secondsLabel.text).intValue * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
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

- (void)downloadFile: (NSString *)fileStr {
    
    NSString *timeStr = [QMConnect queryMp3FileMessageSize:self.message._id];
    if ([timeStr isEqualToString:@"0"]) {

        NSString *str = [self.message.remoteFilePath stringByAddingPercentEncodingWithAllowedCharacters:NSCharacterSet.URLQueryAllowedCharacterSet];
        NSURL *fileUrl = [NSURL URLWithString:str];
        NSData *data = [NSData dataWithContentsOfURL:fileUrl];
    
        [data writeToFile:fileStr atomically:YES];
    
        float aaa = [self fileAllTime:str];
    
        dispatch_async(dispatch_get_main_queue(), ^{
            _secondsLabel.text = [NSString stringWithFormat:@"%d", (int)aaa];
            [QMConnect changeMp3FileMessageSize:self.message._id fileSize:[NSString stringWithFormat:@"%d", (int)aaa]];
        });
    }else {
        dispatch_sync(dispatch_get_main_queue(), ^{
            _secondsLabel.text = timeStr;
        });
    }
}

- (float)fileAllTime: (NSString *)str {
    NSURL *fileUrl = [NSURL URLWithString:str];
    NSDictionary *options = @{AVURLAssetPreferPreciseDurationAndTimingKey: @YES};
    AVURLAsset *audioAsset = [AVURLAsset URLAssetWithURL:fileUrl options:options];
    CMTime audioDuration = audioAsset.duration;
    float audioDurationSeconds = CMTimeGetSeconds(audioDuration);
    return audioDurationSeconds;
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
