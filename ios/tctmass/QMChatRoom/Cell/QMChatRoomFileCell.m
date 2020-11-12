//
//  QMChatRoomFileCell.m
//  IMSDK-OC
//
//  Created by HCF on 16/8/15.
//  Copyright © 2016年 HCF. All rights reserved.
//

#import "QMChatRoomFileCell.h"
#import "QMChatRoomShowFileController.h"
#import "QMProfileManager.h"

@interface QMChatRoomFileCell () {
    UIImageView *_fileImageView;
    UILabel *_fileName;
    UILabel *_fileSize;
    UILabel *_status;
    
    UIImageView *_trackTintColor;
    UIImageView *_progressTintColor;
}

@end

@implementation QMChatRoomFileCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle: style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self createUI];
    }
    return self;
}

- (void)createUI {
    _fileImageView = [[UIImageView alloc] init];
    [self.chatBackgroudImage addSubview:_fileImageView];
    
    _fileName = [[UILabel alloc] init];
    _fileName.font = [UIFont systemFontOfSize:14];
    _fileName.backgroundColor = [UIColor clearColor];
    _fileName.numberOfLines = 1;
    [self.chatBackgroudImage addSubview:_fileName];
    
    _fileSize = [[UILabel alloc] init];
    _fileSize.font = [UIFont systemFontOfSize:12];
    _fileSize.alpha = 0.7;
    [self.chatBackgroudImage addSubview:_fileSize];
    
    _status = [[UILabel alloc] init];
    _status.font = [UIFont systemFontOfSize:12];
    _status.alpha = 0.7;
    [self.chatBackgroudImage addSubview:_status];
    
    _trackTintColor = [[UIImageView alloc] init];
    _trackTintColor.backgroundColor = [UIColor whiteColor];
    [self.chatBackgroudImage addSubview:_trackTintColor];
    
    _progressTintColor = [[UIImageView alloc] init];
    _progressTintColor.backgroundColor = [UIColor colorWithRed:3/255.0 green:216/255.0 blue:118/255.0 alpha:1];
    [self.chatBackgroudImage addSubview:_progressTintColor];
}

- (void)setData:(CustomMessage *)message avater:(NSString *)avater {
    self.message = message;
    [super setData:message avater:avater];
    
    UITapGestureRecognizer * tapPressGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapPressGesture:)];
    [self.chatBackgroudImage addGestureRecognizer:tapPressGesture];
    
    // 重写
    if ([message.fromType isEqualToString:@"0"]) {
        //发送
        self.chatBackgroudImage.frame = CGRectMake(CGRectGetMinX(self.iconImage.frame)-5-200, CGRectGetMaxY(self.timeLabel.frame)+10, 200, 50);
        self.sendStatus.frame = CGRectMake(CGRectGetMinX(self.chatBackgroudImage.frame)-25, CGRectGetMinY(self.chatBackgroudImage.frame)+15, 20, 20);
        
        _fileImageView.frame = CGRectMake(self.chatBackgroudImage.frame.size.width - 50, 0, 50, 50);
        UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:_fileImageView.bounds byRoundingCorners:UIRectCornerBottomRight cornerRadii:CGSizeMake(16, 16)];
        CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
        maskLayer.frame = _fileImageView.bounds;
        maskLayer.path = maskPath.CGPath;
        _fileImageView.layer.mask = maskLayer;
        
        _fileName.frame = CGRectMake(15, 8, self.chatBackgroudImage.frame.size.width - 15 - 8 - 50, 18);
        _fileName.textAlignment = NSTextAlignmentRight;
        _fileName.textColor = [UIColor whiteColor];
        
        _fileSize.frame = CGRectMake(self.chatBackgroudImage.frame.size.width - 108, CGRectGetMaxY(_fileName.frame) + 3, 50, 13);
        _fileSize.textAlignment = NSTextAlignmentRight;
        _fileSize.textColor = [UIColor whiteColor];
        
        _trackTintColor.frame = CGRectMake(15, 47, 127, 2);
        _progressTintColor.frame = CGRectMake(15, 47, 0, 2);
        
        _status.frame = CGRectMake(15, CGRectGetMaxY(_fileName.frame) + 3, 50, 13);
        _status.textAlignment = NSTextAlignmentLeft;
        _status.textColor = [UIColor whiteColor];
    }else {
        //接收
        self.chatBackgroudImage.frame = CGRectMake(CGRectGetMaxX(self.iconImage.frame)+5, CGRectGetMaxY(self.timeLabel.frame)+10, 200, 50);
        
        _fileImageView.frame = CGRectMake(0, 0, 50, 50);
        UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:_fileImageView.bounds byRoundingCorners:UIRectCornerBottomLeft cornerRadii:CGSizeMake(16, 16)];
        CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
        maskLayer.frame = _fileImageView.bounds;
        maskLayer.path = maskPath.CGPath;
        _fileImageView.layer.mask = maskLayer;
        
        _fileName.frame = CGRectMake(58, 8, self.chatBackgroudImage.frame.size.width - 15 - 8 - 50, 18);
        _fileName.textAlignment = NSTextAlignmentLeft;
        _fileName.textColor = [UIColor blackColor];
        
        _fileSize.frame = CGRectMake(58, CGRectGetMaxY(_fileName.frame) + 3, 50, 13);
        _fileSize.textAlignment = NSTextAlignmentLeft;
        _fileSize.textColor = [UIColor blackColor];
        
        _trackTintColor.frame = CGRectMake(58, 47, 127, 2);
        _progressTintColor.frame = CGRectMake(58, 47, 0, 2);
        
        _status.frame = CGRectMake(self.chatBackgroudImage.frame.size.width - 65, CGRectGetMaxY(_fileName.frame) + 3, 50, 13);
        _status.textAlignment = NSTextAlignmentRight;
        _status.textColor = [UIColor blackColor];
        self.sendStatus.hidden = YES;
    }
    
    NSString *imageName = [self matchImageWithFileNameExtension: message.fileName.pathExtension.lowercaseString];
    _fileImageView.image = [UIImage imageNamed:imageName];
    
    if (message.fileName != nil) {
        _fileName.text = message.fileName;
    }else {
        _fileName.text = message.message;
    }

    if (message.fileSize == nil) {
        _fileSize.text = @"0 K";
    }else {
        _fileSize.text = message.fileSize;
    }
    
    if ([message.fromType isEqualToString:@"0"]) {
        if ([message.status isEqualToString:@"0"]) {
            _progressTintColor.hidden = YES;
            _trackTintColor.hidden = YES;
            _status.text = NSLocalizedString(@"title.uploaded", nil);
        }else if ([message.status isEqualToString:@"1"]) {
            _progressTintColor.hidden = YES;
            _trackTintColor.hidden = YES;
            _status.text = NSLocalizedString(@"title.uploadFailure", nil);
        }else {
            _progressTintColor.hidden = NO;
            _trackTintColor.hidden = NO;
            _status.text = NSLocalizedString(@"title.uploading", nil);
        }
    }else {
        if ([message.downloadState isEqualToString:@"2"]) {
            _progressTintColor.hidden = NO;
            _trackTintColor.hidden = NO;
            _status.text = NSLocalizedString(@"title.downloads", nil);
        }else if ([message.downloadState isEqualToString:@"1"]) {
            _progressTintColor.hidden = YES;
            _trackTintColor.hidden = YES;
            _status.text = NSLocalizedString(@"title.notDownloaded", nil);
        }else if ([message.downloadState isEqualToString:@"0"]) {
            _progressTintColor.hidden = YES;
            _trackTintColor.hidden = YES;
            _status.text = NSLocalizedString(@"title.downloaded", nil);
        }else {
            _progressTintColor.hidden = YES;
            _trackTintColor.hidden = YES;
            _status.text = NSLocalizedString(@"title.downloaded", nil);
        }
    }

}

- (void)setProgress: (float)progress {
    dispatch_async(dispatch_get_main_queue(), ^{
        if ([self.message.fromType isEqualToString:@"0"]) {
            _progressTintColor.frame = CGRectMake(15, 47, progress*127, 2);
        }else {
            _progressTintColor.frame = CGRectMake(58, 47, progress*127, 2);
        }
    });
}

- (void)tapPressGesture:(id)sender {    
    if (self.message.localFilePath == nil) {
        NSString *localPath = [[QMProfileManager sharedInstance] checkFileExtension: self.message.fileName];
        __weak QMChatRoomFileCell *weakSelf = self;
        [QMConnect downloadFileWithMessage:self.message localFilePath:localPath progressHander:^(float progress) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [weakSelf setProgress:progress];
            });
        } successBlock:^{
            // 图片或视频存储至相册
            dispatch_async(dispatch_get_main_queue(), ^{
                _progressTintColor.frame = CGRectMake(15, 94, 0, 3);
            });
            [weakSelf setProgress:0];
        } failBlock:^(NSString * _Nonnull error) {
            [weakSelf setProgress:0];
        }];
    }else {
        // 打开本地文件
        QMChatRoomShowFileController *showFile = [[QMChatRoomShowFileController alloc] init];
        showFile.modalPresentationStyle = UIModalPresentationFullScreen;
        showFile.filePath = self.message.localFilePath;
        UIViewController *vc = [[[UIApplication sharedApplication] keyWindow] rootViewController];
        [vc presentViewController:showFile animated:YES completion:nil];
    }
}

- (NSString *)matchImageWithFileNameExtension: (NSString *)fileName {
    NSString * str;
    if ([fileName isEqualToString:@"doc"]||[fileName isEqualToString:@"docx"]) {
        str = @"doc";
    }else if ([fileName isEqualToString:@"xlsx"]||[fileName isEqualToString:@"xls"]) {
        str = @"xlsx";
    }else if ([fileName isEqualToString:@"ppt"]||[fileName isEqualToString:@"pptx"]) {
        str = @"pptx";
    }else if ([fileName isEqualToString:@"pdf"]) {
        str = @"pdf";
    }else if ([fileName isEqualToString:@"mp3"]) {
        str = @"mp3";
    }else if ([fileName isEqualToString:@"mov"]||[fileName isEqualToString:@"mp4"]) {
        str = @"mov";
    }else if ([fileName isEqualToString:@"png"]||[fileName isEqualToString:@"jpg"]||[fileName isEqualToString:@"bmp"]||[fileName isEqualToString:@"jpeg"]) {
        str = @"bmp";
    }else {
        str = @"other";
    }
    return [NSString stringWithFormat:@"custom_file_%@", str];
}

@end
