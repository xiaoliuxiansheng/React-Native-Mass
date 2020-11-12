//
//  QMRecordIndicatorView.m
//  IMSDK-OC
//
//  Created by HCF on 16/7/31.
//  Copyright © 2016年 HCF. All rights reserved.
//

#import "QMRecordIndicatorView.h"

@interface QMRecordIndicatorView() {
    UIImageView *_backImageView;
    
    UIImageView *_recordingbackImage;
    
    UIImageView *_volumeImage;
    
    UIImageView *_backImage;
    
    UIImageView *_markImage;
    
    UILabel *_countLabel;
    
    UILabel *_warningLabel;
}

@end

@implementation QMRecordIndicatorView

-(instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        self.layer.cornerRadius = 5;
        self.layer.masksToBounds = YES;
        self.clipsToBounds = YES;
        [self createUI];
    }
    return self;
}

- (void)setCount:(int)count {
    if (count >= 50 && count <= 60) {
        _countLabel.text = [NSString stringWithFormat:@"%d", 60 - count];
        if (self.isCount == false) {
            self.isCount = true;
            [self changeViewStatus:QMIndicatorStatusNormal];
        }
    }
}

-(void)createUI {
    _backImageView = [[UIImageView alloc] init];
    _backImageView.frame = CGRectMake(0, 0, 150, 150);
    _backImageView.backgroundColor = [UIColor blackColor];
    _backImageView.alpha = 0.8;
    [self addSubview:_backImageView];
    
    ///话筒图片
    _recordingbackImage = [[UIImageView alloc] init];
    _recordingbackImage.frame = CGRectMake(25, 10, 60, 100);
    _recordingbackImage.image = [UIImage imageNamed:@"RecordingBkg"];
    [self addSubview:_recordingbackImage];
    
    ///叹号图片
    _markImage = [[UIImageView alloc] init];
    _markImage.frame = CGRectMake(70, 28, 10, 64);
    _markImage.image = [UIImage imageNamed:@"RecordMark"];
    [self addSubview:_markImage];
    
    _countLabel = [[UILabel alloc] init];
    _countLabel.frame = CGRectMake(0, 27, 150, 65);
    _countLabel.textColor = [UIColor whiteColor];
    _countLabel.textAlignment = NSTextAlignmentCenter;
    _countLabel.font = [UIFont boldSystemFontOfSize:65];
    _countLabel.text = @"50";
    [self addSubview:_countLabel];
    
    ///音量图片
    _volumeImage = [[UIImageView alloc] init];
    _volumeImage.frame = CGRectMake(85, 10, 38, 100);
    _volumeImage.image = [UIImage imageNamed:@"RecordingSignal001"];
    [self addSubview:_volumeImage ];
    
    ///返回图片
    _backImage = [[UIImageView alloc] init];
    _backImage.hidden = true;
    _backImage.frame = CGRectMake(15, 0, 110, 110);
    _backImage.image = [UIImage imageNamed:@"RecordCancel"];
    [self addSubview:_backImage];
    
    ///提示信息
    _warningLabel = [[UILabel alloc] init];
    _warningLabel.frame = CGRectMake(10, 110, 130, 25);
    _warningLabel.layer.cornerRadius = 4;
    _warningLabel.layer.masksToBounds = true;
    _warningLabel.text = NSLocalizedString(@"button.cancelsend", nil);
    _warningLabel.font = [UIFont systemFontOfSize:14];
    _warningLabel.textAlignment = NSTextAlignmentCenter;
    _warningLabel.textColor = [UIColor whiteColor];
    [self addSubview:_warningLabel];
    
    self.isCount = false;
}

-(void)updateImageWithPower:(float)power {
    double lowPassResults = pow(10, power*0.05);
    
    float result = 10.0 * lowPassResults;
    int no = 0;
    if (result>0 && result<=1.3) {
        no = 1;
    }else if (result>1.3 && result<=2) {
        no = 2;
    }else if (result>2.0 && result<=3.0) {
        no = 3;
    }else if (result>3.0 && result<=5.0) {
        no = 4;
    }else if (result>5.0 && result<=10) {
        no = 5;
    }else if (result>10 && result<=40) {
        no = 6;
    }else if (result>40) {
        no = 7;
    }
    _volumeImage.image = [UIImage imageNamed:[NSString stringWithFormat:@"RecordingSignal00%d", no]];
}

- (void)changeViewStatus:(QMIndicatorStatus)status {
    switch (status) {
        case QMIndicatorStatusShort:
            [_markImage setHidden:NO];
            [_volumeImage setHidden:YES];
            [_recordingbackImage setHidden:YES];
            [_backImage setHidden:YES];
            [_countLabel setHidden:YES];
            _warningLabel.backgroundColor = [UIColor clearColor];
            _warningLabel.text = NSLocalizedString(@"title.speakS", nil);
            break;
        case QMIndicatorStatusLong:
            [_markImage setHidden:NO];
            [_volumeImage setHidden:YES];
            [_recordingbackImage setHidden:YES];
            [_backImage setHidden:YES];
            [_countLabel setHidden:YES];
            _warningLabel.backgroundColor = [UIColor clearColor];
            _warningLabel.text = NSLocalizedString(@"title.speakL", nil);
            break;
        case QMIndicatorStatusNormal:
            if (self.isCount) {
                [_volumeImage setHidden:YES];
                [_recordingbackImage setHidden:YES];
                [_countLabel setHidden:NO];
            }else {
                [_volumeImage setHidden:NO];
                [_recordingbackImage setHidden:NO];
                [_countLabel setHidden:YES];
            }
            [_markImage setHidden:YES];
            [_backImage setHidden:YES];
            _warningLabel.backgroundColor = [UIColor clearColor];
            _warningLabel.text = NSLocalizedString(@"button.cancelsend", nil);
            break;
        case QMIndicatorStatusCancel:
            [_markImage setHidden:YES];
            [_volumeImage setHidden:YES];
            [_recordingbackImage setHidden:YES];
            [_backImage setHidden:NO];
            [_countLabel setHidden:YES];
            _warningLabel.backgroundColor = [UIColor colorWithRed:191/255.0 green:79/255.0 blue:68/255.0 alpha:1];
            _warningLabel.text = NSLocalizedString(@"button.recorder_want_cancel", nil);
            break;
    }
}

@end
