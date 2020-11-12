//
//  QMChatRoomBaseCell.h
//  IMSDK-OC
//
//  Created by HCF on 16/3/10.
//  Copyright © 2016年 HCF. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QMLineSDK/QMLineSDK.h>


@interface QMChatRoomBaseCell : UITableViewCell

@property (nonatomic, strong) UIImageView *iconImage; // 头像

@property (nonatomic, strong) UILabel *timeLabel; // 时间

@property (nonatomic, strong) UIImageView *chatBackgroudImage; // 气泡

@property (nonatomic, strong) UIImageView *sendStatus; // 消息发送状态

@property (nonatomic, strong) CustomMessage *message;

@property (nonatomic, copy) void(^tapSendMessage)(NSString *message, NSString *number);

@property (nonatomic, copy) void(^didBtnAction)(BOOL);

@property (nonatomic, copy) void(^tapNetAddress)(NSString *);

@property (nonatomic, copy) void(^tapNumberAction)(NSString *);

@property (nonatomic, copy) void(^tapArtificialAction)(NSString *);

- (void)setData:(CustomMessage *)message avater:(NSString *)avater;

- (void)longPressTapGesture:(id)sender;

- (void)setProgress:(float)progress;

@end
