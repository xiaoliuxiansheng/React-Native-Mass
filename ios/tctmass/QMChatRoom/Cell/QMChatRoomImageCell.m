//
//  QMChatRoomImageCell.m
//  IMSDK-OC
//
//  Created by HCF on 16/3/10.
//  Copyright © 2016年 HCF. All rights reserved.
//

#import "QMChatRoomImageCell.h"
#import "QMTapGestureRecognizer.h"
#import "QMChatRoomShowImageController.h"
#import <QMLineSDK/QMLineSDK.h>

/**
    图片消息
 */
@implementation QMChatRoomImageCell
{
    UIImageView *_imageView;
    
    NSString *_messageId;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self createUI];
    }
    return self;
}

- (void)createUI {
    _imageView = [[UIImageView alloc] init];
    _imageView.userInteractionEnabled = YES;
    _imageView.contentMode = UIViewContentModeScaleAspectFill;
    _imageView.clipsToBounds = YES;
    [self.contentView addSubview:_imageView];
    
    UILongPressGestureRecognizer * longPressGesture = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressTapGesture:)];
    [_imageView addGestureRecognizer:longPressGesture];
}

- (void)setData:(CustomMessage *)message avater:(NSString *)avater {
    _messageId = message._id;
    self.message = message;
    [super setData:message avater:avater];
    
    if ([message.fromType isEqualToString:@"0"]) {
        NSString *filePath = [NSString stringWithFormat:@"%@/%@/%@",NSHomeDirectory(),@"Documents",message.message];
        _imageView.image = [UIImage imageWithContentsOfFile:filePath];
        
        CGSize imgSize = _imageView.image.size;
        CGFloat imgWidth = 0.0;
        CGFloat imgHeight = 0.0;
        if (imgSize.height > imgSize.width) {
            imgHeight = 160;
            imgWidth = imgHeight *imgSize.width/imgSize.height;
        } else {
            imgWidth = 160;
            imgHeight = imgWidth *imgSize.height/imgSize.width;
        }
        _imageView.frame = CGRectMake(CGRectGetMinX(self.iconImage.frame)-5-imgWidth, CGRectGetMaxY(self.timeLabel.frame)+10, imgWidth, imgHeight);
        UIImageView *maskImageView = [[UIImageView alloc] initWithFrame:_imageView.frame];
        maskImageView.image = [[UIImage imageNamed:@"SenderTextNodeBkg"] stretchableImageWithLeftCapWidth:20 topCapHeight:16];
        CALayer *layer = maskImageView.layer;
        layer.frame = CGRectMake(0, 0, maskImageView.frame.size.width, maskImageView.frame.size.height);
        _imageView.layer.mask = layer;
        self.sendStatus.frame = CGRectMake(CGRectGetMinX(_imageView.frame)-25, CGRectGetMinY(_imageView.frame)+5, 20, 20);
        
    } else {

        [_imageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@?imageView2/0/w/200/interlace/1/q/80",message.message]] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
            
            CGSize imgSize = image.size;
            
            CGFloat imgWidth = 0.0;
            CGFloat imgHeight = 0.0;
            imgHeight = 140;
            imgWidth = imgHeight *imgSize.width/imgSize.height;
            imgWidth = imgWidth == 0 ? imgHeight : imgWidth;
            if (imgWidth > 2* imgHeight) {
                imgWidth = 2 * imgHeight;
            }

            _imageView.frame = CGRectMake(CGRectGetMaxX(self.iconImage.frame)+5, CGRectGetMaxY(self.timeLabel.frame)+5, imgWidth, imgHeight);
            UIImageView *maskImageView = [[UIImageView alloc] initWithFrame:_imageView.frame];
            maskImageView.image = [[UIImage imageNamed:@"ReceiverTextNodeBkg"] stretchableImageWithLeftCapWidth:20 topCapHeight:16];
            CALayer *layer = maskImageView.layer;
            layer.frame = CGRectMake(0, 0, maskImageView.frame.size.width, maskImageView.frame.size.height);
            _imageView.layer.mask = layer;
            
        }];
    }
    
    QMTapGestureRecognizer * tapPressGesture = [[QMTapGestureRecognizer alloc] initWithTarget:self action:@selector(imagePressGesture:)];
    tapPressGesture.picName = message.message;
    tapPressGesture.picType = message.fromType;
    tapPressGesture.image = _imageView.image;
    [_imageView addGestureRecognizer:tapPressGesture];
}

- (void)longPressTapGesture:(UILongPressGestureRecognizer *)sender {
    if (sender.state == UIGestureRecognizerStateBegan) {
        [self becomeFirstResponder];
        UIMenuController *menu = [UIMenuController sharedMenuController];
        UIMenuItem *removeMenu = [[UIMenuItem alloc] initWithTitle:@"删除" action:@selector(removeMenu:)];
        [menu setMenuItems:[NSArray arrayWithObjects:removeMenu, nil]];
        [menu setTargetRect:_imageView.frame inView:self];
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
    if (action == @selector(removeMenu:)) {
        return YES;
    }else {
        return  NO;
    }
}

- (void)imagePressGesture:(QMTapGestureRecognizer *)gestureRecognizer {
    QMChatRoomShowImageController * showPicVC = [[QMChatRoomShowImageController alloc] init];
    showPicVC.picName = gestureRecognizer.picName;
    showPicVC.picType = gestureRecognizer.picType;
    showPicVC.image = gestureRecognizer.image;
    [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:showPicVC animated:true completion:nil];
}

- (void)removeMenu:(id)sender {
    // 删除语音(只能删除本地数据库消息)
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


- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
