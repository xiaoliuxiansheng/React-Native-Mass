//
//  QMAudioAnimation.m
//  IMSDK-OC
//
//  Created by haochongfeng on 2017/5/18.
//  Copyright © 2017年 HCF. All rights reserved.
//

#import "QMAudioAnimation.h"

@interface QMAudioAnimation() {
    UIImageView *_animationView;
}

@end

@implementation QMAudioAnimation

static QMAudioAnimation * instance = nil;

+ (QMAudioAnimation *)sharedInstance {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[self alloc] init];
    });
    return instance;
}

+ (id)allocWithZone:(struct _NSZone *)zone {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [super allocWithZone:zone];
    });
    return instance;
}

- (void)setAudioAnimationPlay:(BOOL)sender and:(UIImageView *)imageView {
    NSArray *images;
    if (sender) {
        images = [NSArray arrayWithObjects:[UIImage imageNamed:@"SenderVoiceNodePlaying001"],[UIImage imageNamed:@"SenderVoiceNodePlaying002"],[UIImage imageNamed:@"SenderVoiceNodePlaying003"], nil];
        imageView.image = [UIImage imageNamed:@"SenderVoiceNodePlaying"];
    }else {
        images = [NSArray arrayWithObjects:[UIImage imageNamed:@"ReceiverVoiceNodePlaying001"],[UIImage imageNamed:@"ReceiverVoiceNodePlaying002"],[UIImage imageNamed:@"ReceiverVoiceNodePlaying003"], nil];
        imageView.image = [UIImage imageNamed:@"ReceiverVoiceNodePlaying"];
    }
    imageView.animationImages = images;
}

- (void)stopAudioAnimation {
    if (_animationView) {
        [_animationView stopAnimating];
    }
}

- (void)startAudioAnimation:(UIImageView *)imageView {
    _animationView = imageView;
    imageView.isAnimating ? [imageView stopAnimating] : [imageView startAnimating];
}

- (void)stopAudioAnimation:(UIImageView *)imageView {
    if (imageView) {
        [imageView stopAnimating];
    }else {
        [_animationView stopAnimating];
    }
}

@end
