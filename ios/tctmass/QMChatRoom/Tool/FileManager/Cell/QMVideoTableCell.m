//
//  QMVideoTableCell.m
//  IMSDK-OC
//
//  Created by HCF on 16/8/11.
//  Copyright © 2016年 HCF. All rights reserved.
//

#import "QMVideoTableCell.h"

@interface QMVideoTableCell() {
    UIImageView *_videoImageView;
    UILabel *_videoName;
    UILabel *_videoSize;
    UILabel *_videoDate;
}

@end

@implementation QMVideoTableCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self createUI];
    }
    return self;
}

-(void)createUI {
    self.contentView.backgroundColor = [UIColor whiteColor];
    
    _videoImageView = [[UIImageView alloc] init];
    _videoImageView.frame = CGRectMake(20, 10, 60, 60);
    _videoImageView.backgroundColor = [UIColor greenColor];
    [self.contentView addSubview:_videoImageView];
    
    _videoName = [[UILabel alloc] init];
    _videoName.frame = CGRectMake(90, 10, kScreenWidth-150, 20);
    _videoName.font = [UIFont systemFontOfSize:16];
    _videoName.textColor = [UIColor blackColor];
    [self.contentView addSubview:_videoName];
    
    _videoSize = [[UILabel alloc] init];
    _videoSize.frame = CGRectMake(90, 30, kScreenWidth-150, 20);
    _videoSize.font = [UIFont systemFontOfSize:14];
    _videoSize.textColor = [UIColor lightGrayColor];
    [self.contentView addSubview:_videoSize];

    _videoDate = [[UILabel alloc] init];
    _videoDate.frame = CGRectMake(90, 50, kScreenWidth-150, 20);
    _videoDate.font = [UIFont systemFontOfSize:14];
    _videoDate.textColor = [UIColor lightGrayColor];
    [self.contentView addSubview:_videoDate];
    
    self.pickedItemImageView = [[UIImageView alloc] init];
    self.pickedItemImageView.frame = CGRectMake(kScreenWidth-50, 25, 30, 30);
    self.pickedItemImageView.image = [UIImage imageNamed:@"ic_checkbox_pressed"];
    [self.contentView addSubview:self.pickedItemImageView];
}

- (void)setImageAsset:(PHAsset *)imageAsset {
    if (imageAsset) {
        PHVideoRequestOptions *voptions = [[PHVideoRequestOptions alloc] init];
        voptions.version = PHVideoRequestOptionsVersionCurrent;
        voptions.deliveryMode = PHVideoRequestOptionsDeliveryModeHighQualityFormat;
        voptions.networkAccessAllowed = YES;
        
        [self.imageManager requestAVAssetForVideo:imageAsset options:voptions resultHandler:^(AVAsset * _Nullable asset, AVAudioMix * _Nullable audioMix, NSDictionary * _Nullable info) {
            
            if (asset && [asset isKindOfClass:[AVURLAsset class]] && [NSString stringWithFormat:@"%@",((AVURLAsset *)asset).URL].length > 0) {
                
                NSURL *videoURL = [(AVURLAsset *)asset URL];
                NSNumber *fileSizeValue = nil;
                [videoURL getResourceValue:&fileSizeValue forKey:NSURLFileSizeKey error:nil];
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    if (fileSizeValue) {
                        if (fileSizeValue.intValue>1024) {
                            _videoSize.text = [NSString stringWithFormat:@"%.f MB", (float)fileSizeValue.intValue/1024/1024];
                        }else {
                            _videoSize.text = [NSString stringWithFormat:@"%.f KB", (float)fileSizeValue.intValue/1024];
                        }
                    }
                });
            }
            
            NSString *filePath = [info objectForKey:@"PHImageFileSandboxExtensionTokenKey"];
            
            NSArray * array = [filePath componentsSeparatedByString:@"/"];
            dispatch_async(dispatch_get_main_queue(), ^{
                _videoName.text = array.lastObject;
            });
        }];
        
        PHImageRequestOptions *options = [[PHImageRequestOptions alloc] init];
        options.synchronous = YES;
        options.version = PHImageRequestOptionsVersionCurrent;
        options.deliveryMode = PHImageRequestOptionsDeliveryModeHighQualityFormat;
        options.resizeMode = PHImageRequestOptionsResizeModeExact;
        options.networkAccessAllowed = YES;
        
        [self.imageManager requestImageForAsset:imageAsset targetSize:CGSizeMake(120, 120) contentMode:PHImageContentModeAspectFill options:options resultHandler:^(UIImage * _Nullable result, NSDictionary * _Nullable info) {
            _videoImageView.image = result;
            
            NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
            formatter.dateFormat = @"MM-dd HH:mm";
            _videoDate.text = [formatter stringFromDate:[imageAsset creationDate]];
        }];
    }
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

}

@end
