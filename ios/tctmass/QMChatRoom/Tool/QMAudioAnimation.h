//
//  QMAudioAnimation.h
//  IMSDK-OC
//
//  Created by haochongfeng on 2017/5/18.
//  Copyright © 2017年 HCF. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface QMAudioAnimation : NSObject

+ (QMAudioAnimation *)sharedInstance;

- (void)setAudioAnimationPlay: (BOOL)sender and:(UIImageView *)imageView;

- (void)stopAudioAnimation;

- (void)startAudioAnimation: (UIImageView *)imageView;

- (void)stopAudioAnimation: (UIImageView *)imageView;

@end
