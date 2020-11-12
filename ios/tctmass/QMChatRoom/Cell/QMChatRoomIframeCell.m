//
//  QMChatRoomIframeCell.m
//  IMSDK-OC
//
//  Created by haochongfeng on 16/11/13.
//  Copyright © 2016年 HCF. All rights reserved.
//

#import "QMChatRoomIframeCell.h"
#import <WebKit/WebKit.h>

@interface QMChatRoomIframeCell() {
    WKWebView *_webView;
    NSString *_messageId;
}

@end

@implementation QMChatRoomIframeCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self createUI];
    }
    return self;
}

- (void)createUI {
    _webView = [[WKWebView alloc] init];
    [self.chatBackgroudImage addSubview:_webView];
}

- (void)setData: (CustomMessage *)message avater:(NSString *)avater {
    _messageId = message._id;
    self.message = message;
    [super setData:message avater:avater];

    if ([message.fromType isEqualToString:@"0"]) {
        // 发送
    }else {
        NSURLRequest *reqeust = [NSURLRequest requestWithURL:[NSURL URLWithString:message.message]];
        [_webView loadRequest:reqeust];
        [_webView reload];
        
        _webView.frame = CGRectMake(15, 10, (CGFloat)message.width.intValue, (CGFloat)message.height.intValue);
        self.chatBackgroudImage.frame = CGRectMake(CGRectGetMaxX(self.iconImage.frame)+5, CGRectGetMaxY(self.timeLabel.frame)+10, _webView.frame.size.width+30, _webView.frame.size.height+20);
        _webView.allowsLinkPreview = YES;
        _webView.scrollView.backgroundColor = [UIColor redColor];
    }
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
