//
//  QMChatRoomRobotCell.m
//  IMSDK-OC
//
//  Created by haochongfeng on 2018/1/23.
//  Copyright © 2018年 HCF. All rights reserved.
//

#import "QMChatRoomRobotCell.h"
#import "QMChatRoomRobotReplyView.h"
#import <QMLineSDK/QMLineSDK.h>
#import "QMTextModel.h"
#import "QMTapGestureRecognizer.h"
#import "QMChatRoomShowImageController.h"

#import <AVFoundation/AVFoundation.h>
#import <AVKit/AVPlayerViewController.h>

@interface QMChatRoomRobotCell() <MLEmojiLabelDelegate>

@property (nonatomic, strong) AVPlayerViewController *moviePlayerView;

@end

@implementation QMChatRoomRobotCell
{
    NSString *_messageId;
    
    QMChatRoomRobotReplyView *_replyView;
    
    // 内容高度
    CGFloat height;
    
    // 内容宽度
    CGFloat width;
    
    // 链接集合
    NSMutableArray *srcArrs;
        
//    AVPlayerViewController *_moviePlayerView;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        srcArrs = [NSMutableArray array];
    }
    return self;
}

- (void)setData:(CustomMessage *)message avater:(NSString *)avater {
    self.message = message;
    _messageId = message._id;
    [super setData:message avater:avater];
    
    [srcArrs removeAllObjects];
    
    
    if ([message.fromType isEqualToString:@"1"]) {
        height = 10;
        width = 0;
        
        for(UIView *view in self.chatBackgroudImage.subviews){
            if(view){
                [view removeFromSuperview];
            }
        }
        
        //html标签替换
        message.message = [message.message stringByReplacingOccurrencesOfString:@"<br>" withString:@"\n"];
        message.message = [message.message stringByReplacingOccurrencesOfString:@"</br>" withString:@"\n"];
        message.message = [message.message stringByReplacingOccurrencesOfString:@"</p>" withString:@"\n"];
        NSMutableArray * srcArr = [self showHtml:message.message];
        
        //获取分段类型 文本 图片
        for (QMTextModel *model in srcArr) {
            if ([model.type isEqualToString:@"text"]) {
                [self createLabel:model.content];
            }else {
                [self createImage:model.content type:model.type];
            }
        }
        
        //机器人评价
        _replyView = [[QMChatRoomRobotReplyView alloc] init];
        _replyView.backgroundColor = [UIColor clearColor];
        [_replyView.helpBtn addTarget:self action:@selector(helpBtnAction:) forControlEvents:UIControlEventTouchUpInside];
        [_replyView.noHelpBtn addTarget:self action:@selector(noHelpBtnAction:) forControlEvents:UIControlEventTouchUpInside];
        CGFloat fingerHeight = 0;
        CGFloat fingDownHeight = 0;
        if (message.fingerUp.length > 0) {
            _replyView.fingerUp = message.fingerUp;
            fingerHeight = [QMTextModel calculateRowHeight:message.fingerUp fontSize:13 width:[UIScreen mainScreen].bounds.size.width-130];
        }
        if (message.fingerDown.length > 0) {
            _replyView.fingerDown = message.fingerDown;
            fingDownHeight = [QMTextModel calculateRowHeight:message.fingerDown fontSize:13 width:[UIScreen mainScreen].bounds.size.width-130];
        }
        [self.chatBackgroudImage addSubview:_replyView];
        if ([message.isRobot isEqualToString:@"1"] && ![message.questionId isEqualToString:@""]) {
            [_replyView setHidden:NO];
            if (message.isUseful) {
                _replyView.status = message.isUseful;
                if ([message.isUseful isEqualToString:@"none"]) {
                    _replyView.frame = CGRectMake(10, height + 5, [UIScreen mainScreen].bounds.size.width - 150, 25);
                    self.chatBackgroudImage.frame = CGRectMake(CGRectGetMaxX(self.iconImage.frame)+5, CGRectGetMaxY(self.timeLabel.frame)+10, [UIScreen mainScreen].bounds.size.width-130, height+15 + 30);
                }else if ([message.isUseful isEqualToString:@"useful"]) {
                    fingerHeight = fingerHeight > 30 ? fingerHeight + 25 : 55;
                    _replyView.frame = CGRectMake(10, height + 5, [UIScreen mainScreen].bounds.size.width - 150, fingerHeight);
                    self.chatBackgroudImage.frame = CGRectMake(CGRectGetMaxX(self.iconImage.frame)+5, CGRectGetMaxY(self.timeLabel.frame)+10, [UIScreen mainScreen].bounds.size.width-130, height+15 + fingerHeight+5);
                }else if ([message.isUseful isEqualToString:@"useless"]) {
                    fingDownHeight = fingDownHeight > 30 ? fingDownHeight + 25 : 55;
                    _replyView.frame = CGRectMake(10, height + 5, [UIScreen mainScreen].bounds.size.width - 150, fingDownHeight);
                    self.chatBackgroudImage.frame = CGRectMake(CGRectGetMaxX(self.iconImage.frame)+5, CGRectGetMaxY(self.timeLabel.frame)+10, [UIScreen mainScreen].bounds.size.width-130, height+15 + fingDownHeight+5);
                }else {
                    _replyView.frame = CGRectMake(10, height + 5, [UIScreen mainScreen].bounds.size.width - 150, 55);
                    self.chatBackgroudImage.frame = CGRectMake(CGRectGetMaxX(self.iconImage.frame)+5, CGRectGetMaxY(self.timeLabel.frame)+10, [UIScreen mainScreen].bounds.size.width-130, height+15 + 60);
                }
            }else {
                _replyView.status = @"none";
                _replyView.frame = CGRectMake(10, height + 5, [UIScreen mainScreen].bounds.size.width - 150, 25);
                self.chatBackgroudImage.frame = CGRectMake(CGRectGetMaxX(self.iconImage.frame)+5, CGRectGetMaxY(self.timeLabel.frame)+10, [UIScreen mainScreen].bounds.size.width-130, height+15 + 30);
            }
        }else {
            [_replyView setHidden:YES];
            _replyView.frame = CGRectZero;
            self.chatBackgroudImage.frame = CGRectMake(CGRectGetMaxX(self.iconImage.frame)+5, CGRectGetMaxY(self.timeLabel.frame)+10, width+30, height+15);
        }
    }
}

// 创建文本
- (void)createLabel: (NSString *)text {
    NSMutableArray *array = [self getAHtml:text];
    NSRegularExpression *regularExpretion = [[NSRegularExpression alloc] initWithPattern:@"<[^>]*>" options:NSRegularExpressionCaseInsensitive error:nil];
    NSString *tempString = [regularExpretion stringByReplacingMatchesInString:text options:NSMatchingReportProgress range:NSMakeRange(0, text.length) withTemplate:@""];
    
    MLEmojiLabel *tLabel = [MLEmojiLabel new];
    tLabel.numberOfLines = 0;
    tLabel.font = [UIFont systemFontOfSize:14.0f];
    tLabel.lineBreakMode = NSLineBreakByTruncatingTail;
    tLabel.delegate = self;
    tLabel.disableEmoji = NO;
    tLabel.disableThreeCommon = NO;
    tLabel.isNeedAtAndPoundSign = YES;
    tLabel.customEmojiRegex = @"\\:[^\\:]+\\:";
    tLabel.customEmojiPlistName = @"expressionImage.plist";
    tLabel.customEmojiBundleName = @"QMEmoticon.bundle";
    [self.chatBackgroudImage addSubview:tLabel];
    
    tLabel.checkResults = array;
    tLabel.checkColor = [UIColor colorWithRed:32/255.0f green:188/255.0f blue:158/255.0f alpha:1];

    tLabel.text = tempString;
    
    // labelFrame
    CGSize size = [tLabel preferredSizeWithMaxWidth: [UIScreen mainScreen].bounds.size.width - 160];
    tLabel.frame = CGRectMake(15, height, size.width, size.height);
    
    // 宽高适配
    height += size.height;
    width = width > size.width ? width : size.width;
}

// 创建图片 图片大小可调整
- (void)createImage: (NSString *)imageUrl type:(NSString *)type {
    
    NSArray *temArray = nil;
    if ([imageUrl rangeOfString:@"src=\""].location != NSNotFound) {
        temArray = [imageUrl componentsSeparatedByString:@"src=\""];
    }else if ([imageUrl rangeOfString:@"src="].location != NSNotFound) {
        temArray = [imageUrl componentsSeparatedByString:@"src="];
    }

    if (temArray.count >= 2) {
        NSString *src = temArray[1];
        
        NSUInteger loc = [src rangeOfString:@"\""].location;
        if (loc != NSNotFound) {
            
            // 图片地址
            src = [src substringToIndex:loc];
            src = [src stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
            UIImageView *imageView = [[UIImageView alloc] init];
            imageView.frame = CGRectMake(15, height, 140, 100);
            imageView.userInteractionEnabled = YES;
            imageView.contentMode = UIViewContentModeScaleAspectFill;
            imageView.clipsToBounds = YES;
            [self.chatBackgroudImage addSubview:imageView];
            NSLog(@"图片地址---%@",src);
            QMTapGestureRecognizer * tapPressGesture = [[QMTapGestureRecognizer alloc] initWithTarget:self action:@selector(imagePressGesture:)];
            
            if ([type isEqualToString:@"image"]) {
                [imageView sd_setImageWithURL:[NSURL URLWithString:src] placeholderImage:[UIImage imageNamed:@"icon"]];
                tapPressGesture.picType = @"1";
            }else {
//                UIImage *image = [self thumbnailImageForVideo:[NSURL URLWithString:@"http://vl.quanjing.com/0278/QM027869587.mp4?Expires=1597248000&OSSAccessKeyId=LTAI4FqmMic4pspuRpLDUAnC&Signature=qIkO%2FIUjtsHnz7YSU%2FgWxHIDTp4%3D"] atTime:300];
                UIImage *image = [self thumbnailImageForVideo:[NSURL URLWithString:src] atTime:300];
                imageView.image = image;
                tapPressGesture.picType = @"video";
                
                UIImageView *videoImage = [[UIImageView alloc] initWithFrame:CGRectMake(50, 30, 40, 40)];
                videoImage.image = [UIImage imageNamed:@"qm_chat_video"];
                [imageView addSubview:videoImage];
            }
            
            tapPressGesture.picName = src;
//            tapPressGesture.picType = @"1";
            tapPressGesture.image = imageView.image;
            [imageView addGestureRecognizer:tapPressGesture];

            height += 100;
            width = width > 140 ? width : 140;
        }
    }
}

- (UIImage *)thumbnailImageForVideo:(NSURL *)videoURL atTime:(NSTimeInterval)time {
    AVURLAsset *asset = [[AVURLAsset alloc] initWithURL:videoURL options:nil];
    NSParameterAssert(asset);
    AVAssetImageGenerator *assetImageGenerator =[[AVAssetImageGenerator alloc] initWithAsset:asset];
    assetImageGenerator.appliesPreferredTrackTransform = YES;
    assetImageGenerator.apertureMode =AVAssetImageGeneratorApertureModeEncodedPixels;
    
    CGImageRef thumbnailImageRef = NULL;
    CFTimeInterval thumbnailImageTime = time;
    NSError *thumbnailImageGenerationError = nil;
    thumbnailImageRef = [assetImageGenerator copyCGImageAtTime:CMTimeMake(thumbnailImageTime, 60)actualTime:NULL error:&thumbnailImageGenerationError];
    
    UIImage *thumbnailImage = thumbnailImageRef ? [[UIImage alloc]initWithCGImage:thumbnailImageRef] : nil;
    return thumbnailImage;
}


#pragma mark 文本处理
- (NSMutableArray *)showHtml: (NSString *)htmlString {

    // 拆分文本和图片
    __block NSString *tempString = htmlString;
    __block NSMutableArray *srcArr = [NSMutableArray array];
    
    NSRegularExpression *regularExpretion = [[NSRegularExpression alloc] initWithPattern:@"<[^>]*>" options:NSRegularExpressionCaseInsensitive error:nil];
    [regularExpretion enumerateMatchesInString:htmlString options:NSMatchingReportProgress range:NSMakeRange(0, [htmlString length]) usingBlock:^(NSTextCheckingResult * _Nullable result, NSMatchingFlags flags, BOOL * _Nonnull stop) {
        if (result.range.length != 0) {
            // 字符串
            NSString *actionString = [NSString stringWithFormat:@"%@",[htmlString substringWithRange:result.range]];
            
            NSLog(@"actionString====%@",actionString);
            // 新的range
            NSRange range = [tempString rangeOfString:actionString];
            
            NSArray *components = nil;
            if ([actionString rangeOfString:@"<img src=\""].location != NSNotFound) {
                components = [actionString componentsSeparatedByString:@"src=\""];
            }else if ([actionString rangeOfString:@"<img src="].location != NSNotFound) {
                components = [actionString componentsSeparatedByString:@"src="];
            }else if ([actionString rangeOfString:@"<video controls src=\""].location != NSNotFound) {
                components = [actionString componentsSeparatedByString:@"src=\""];
            }else if ([actionString rangeOfString:@"<video controls src="].location != NSNotFound) {
                components = [actionString componentsSeparatedByString:@"src="];
            }

            if (components.count >= 2) {
                // 文本内容
                QMTextModel *model1 = [[QMTextModel alloc] init];
                model1.type = @"text";
                model1.content = [tempString substringToIndex:range.location];
                [srcArr addObject:model1];
                
                
                NSString *urlStr = [tempString substringWithRange:range];
                NSLog(@"这是啥===%@", urlStr);

                // 图片内容
                QMTextModel *model2 = [[QMTextModel alloc] init];
                if ([urlStr rangeOfString:@"<img"].location != NSNotFound) {
                    model2.type = @"image";
                }else if ([urlStr rangeOfString:@"<video"].location != NSNotFound) {
                    model2.type = @"video";
                }else {
                    model2.type = @"image";
                }
//                model2.type = @"image";
                model2.content = [tempString substringWithRange:range];
                [srcArr addObject:model2];
                tempString = [tempString substringFromIndex:range.location+range.length];
            }
        }
    }];
    
    QMTextModel *model3 = [[QMTextModel alloc] init];
    model3.type = @"text";
    model3.content = tempString;
    [srcArr addObject:model3];
    return srcArr;
}

- (NSMutableArray *)getAHtml: (NSString *)htmlString {
    // 文本匹配A标签
    __block NSString *tempString = htmlString;
    __block NSMutableArray *srcArr = [NSMutableArray array];
    __block int length = 0;

//    NSRegularExpression *regularExpretion = [[NSRegularExpression alloc] initWithPattern:@"<a(.*?)href=(?:.*?)>(.*?)</a>" options:NSRegularExpressionCaseInsensitive error:nil];
//    NSRegularExpression *regularExpretion = [[NSRegularExpression alloc] initWithPattern:@"(<a(.*?)href=(?:.*?)>(.*?)</a>)|(<a(.*?)>(.*?)</a>)" options:NSRegularExpressionCaseInsensitive error:nil];
    NSRegularExpression *regularExpretion = [[NSRegularExpression alloc] initWithPattern:@"(<a(.*?)>(.*?)</a>)" options:NSRegularExpressionCaseInsensitive error:nil];

    [regularExpretion enumerateMatchesInString:htmlString options:NSMatchingReportProgress range:NSMakeRange(0, [htmlString length]) usingBlock:^(NSTextCheckingResult * _Nullable result, NSMatchingFlags flags, BOOL * _Nonnull stop) {
        
        if (result.range.length != 0) {
            NSRegularExpression *regularExpretion1 = [[NSRegularExpression alloc] initWithPattern:@"<[^>]*>" options:NSRegularExpressionCaseInsensitive error:nil];
            
            QMTextModel *model = [[QMTextModel alloc] init];

            // 获取高亮字符串
            NSString *actionString = [NSString stringWithFormat:@"%@",[htmlString substringWithRange:result.range]];
            NSLog(@"获取高亮字符串--%@",actionString);
            // 获取链接 actionString -> https
            
            NSString *subRag = nil;
            NSString *sepearatStr = nil;
//            if ([actionString containsString:@"href=\""]) {
//                sepearatStr = @"href=\"";
//                subRag = @"\"";
//            } else {
//                sepearatStr = @"href=";
//                subRag = @">";
//            }
            
            if ([actionString containsString:@"href=\""]) {
                sepearatStr = @"href=\"";
                subRag = @"\"";
            }else if ([actionString containsString:@"href="]) {
                sepearatStr = @"href=";
                subRag = @">";
            }else if ([actionString containsString:@"m7_"]) {
                sepearatStr = @"m7_";
                subRag = @">";
            }else {
                sepearatStr = @"";
            }
            
            
            NSArray *components = [actionString componentsSeparatedByString:sepearatStr];
            if (components.count > 1) {
                NSString *peerIdStr = @"";
                BOOL isTrue = NO;
                if ([sepearatStr isEqualToString:@"m7_"]) {
                    for (int i = 0; i < components.count; i ++) {
                        NSString *itemStr = components[i];
                        if ([itemStr containsString:@"robotTransferAgent"]) {
                            isTrue = YES;
                        }
                        if ([itemStr containsString:@"data="]) {
                            peerIdStr = [itemStr substringFromIndex:5];
                            NSLog(@"切割1===%@",peerIdStr);
                            peerIdStr = [peerIdStr stringByReplacingOccurrencesOfString:@"\"" withString:@""];
                            NSLog(@"切割2===%@",peerIdStr);
                        }
                    }
                }
                
                if (peerIdStr.length > 0 && isTrue) {
                    model.status = peerIdStr;
                }else {
                    model.status = @"";
                }
                
                
                NSString *telString = components[0];
                if ([telString containsString:@"data-phone"]) {
                    model.status = @"data-phone";
                }
            
                NSString *src = components[1];
                NSUInteger loc = [src rangeOfString:subRag].location;
                if (loc != NSNotFound) {
                    // 地址
                    src = [src substringToIndex:loc];
                    src = [src stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
                    model.content = src;
//                    NSLog(@"走近循环--%@",src);
                }
            }
            
            actionString = [regularExpretion1 stringByReplacingMatchesInString:actionString options:NSMatchingReportProgress range:NSMakeRange(0, actionString.length) withTemplate:@""];

            // 找相同type不同位置的点击
            NSString *regStr = actionString;
            // 找相同type不同位置的点击end

            // 获取高亮range 防止重复
            actionString = [NSString stringWithFormat:@">%@<", actionString];
            model.type = actionString;
            NSRange range = [tempString rangeOfString:actionString];
            
            
            // 找相同type不同位置的点击
            NSString *prexStr = [htmlString substringToIndex:result.range.location];
            NSRegularExpression *regulerA = [NSRegularExpression regularExpressionWithPattern:regStr options:NSRegularExpressionAnchorsMatchLines error:nil];
            NSArray *matchs = [regulerA matchesInString:prexStr options:NSMatchingReportProgress range:NSMakeRange(0, prexStr.length)];
            model.rangeValue = [NSString stringWithFormat:@"%ld",matchs.count];
            // 找相同type不同位置的点击end

            // 拼接标号（目标位置前几个相同字段）
            // 高亮之前的字符串
            if (tempString.length > range.location+1) {
                NSString *preString = [tempString substringToIndex:range.location+1];

                preString = [regularExpretion1 stringByReplacingMatchesInString:preString options:NSMatchingReportProgress range:NSMakeRange(0, preString.length) withTemplate:@""];
            
                actionString = [NSString stringWithFormat:@"at->%@",actionString];
                NSTextCheckingResult *aResult = [NSTextCheckingResult correctionCheckingResultWithRange:NSMakeRange(preString.length+length, range.length-2) replacementString:actionString];
            
                // 截取掉a标签前的字符串（防止a标签名称重复）
                tempString = [tempString substringFromIndex:range.location+1];
            
                // 字符串截取部分的长度
                length += preString.length;
                
//                model.rangeValue = [NSValue valueWithRange:nsra];

                [srcArr addObject:aResult];
                [srcArrs addObject:model];
            }
        }
    }];
    
    return srcArr;
}

#pragma mark MLEmojiLabelDelegate
- (void)mlEmojiLabel:(MLEmojiLabel *)emojiLabel didSelectLink:(NSString *)link withType:(MLEmojiLabelLinkType)type {
    switch (type) {
        case 1:
            self.tapNetAddress(link);
            break;
        case 3:
            for (QMTextModel *model in srcArrs) {
                if (model.rangeValue.length > 0) {
                    NSString *matchStr = [NSString stringWithFormat:@"%@%@",model.type,model.rangeValue];
                    if ([matchStr isEqualToString:link]) {
                        if (model.status.length > 0) {
                            if ([model.status isEqualToString:@"data-phone"]) {
                                link = [link stringByReplacingOccurrencesOfString:@">" withString:@""];
                                NSArray *array = [link componentsSeparatedByString:@"<"];
                                if (array.count > 0) {
                                    self.tapNumberAction(array[0]);
                                }
                            }else {
                                self.tapArtificialAction(model.status);
                            }
                        }else {
                            self.tapNetAddress(model.content);
                        }
                    }
                } else if ([model.type isEqualToString:link]) {
                    NSLog(@"model.rangeValue = %@",model.rangeValue);
                    if (model.status.length > 0) {
                        if ([model.status isEqualToString:@"data-phone"]) {
                            link = [link stringByReplacingOccurrencesOfString:@">" withString:@""];
                            NSArray *array = [link componentsSeparatedByString:@"<"];
                            if (array.count > 0) {
                                self.tapNumberAction(array[0]);
                            }
                        }else {
                            self.tapArtificialAction(model.status);
                        }
                    }else {
                        self.tapNetAddress(model.content);
                    }
                    break;
                }
            }
            break;
        case 2:
            if (link) {
                self.tapNumberAction(link);                
            }
        default:{
            NSString *newLink = [link stringByReplacingOccurrencesOfString:@"\n" withString:@""];
            NSArray *array = [newLink componentsSeparatedByString:@"："];
            if (array.count > 1) {
                self.tapSendMessage(array[1], array[0]);
            }
            break;
        }
    }
}

#pragma mark 点击图片GestureRecognizer
- (void)imagePressGesture:(QMTapGestureRecognizer *)gestureRecognizer {
    
    if ([gestureRecognizer.picType isEqualToString:@"video"]) {
        _moviePlayerView = [[AVPlayerViewController alloc] init];
//        AVPlayer *player = [AVPlayer playerWithURL:[NSURL URLWithString:@"http://vl.quanjing.com/0278/QM027869587.mp4?Expires=1597248000&OSSAccessKeyId=LTAI4FqmMic4pspuRpLDUAnC&Signature=qIkO%2FIUjtsHnz7YSU%2FgWxHIDTp4%3D"]];
//        AVPlayer *player = [AVPlayer playerWithURL:[NSURL URLWithString:@"https://aidev2.7moor.com/oss/objs/5f3b41735555460008babb76"]];
        AVPlayer *player = [AVPlayer playerWithURL:[NSURL URLWithString:gestureRecognizer.picName]];
        _moviePlayerView.player = player;
        _moviePlayerView.videoGravity = AVLayerVideoGravityResizeAspect;
        [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:_moviePlayerView animated:true completion:nil];
        [_moviePlayerView.player play];
    }else {
        QMChatRoomShowImageController * showPicVC = [[QMChatRoomShowImageController alloc] init];
        showPicVC.picName = gestureRecognizer.picName;
        showPicVC.picType = gestureRecognizer.picType;
        showPicVC.image = gestureRecognizer.image;
        [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:showPicVC animated:true completion:nil];
    }
}

#pragma mark 机器人答案反馈点击事件
- (void)helpBtnAction: (UIButton *)sender {
    self.didBtnAction(YES);
}

- (void)noHelpBtnAction: (UIButton *)sender {
    self.didBtnAction(NO);
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
