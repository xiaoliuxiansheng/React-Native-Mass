//
//  QMAudioPlayer.h
//  IMSDK-OC
//
//  Created by haochongfeng on 2017/8/17.
//  Copyright © 2017年 HCF. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>

@interface QMAudioPlayer : NSObject

@property (nonatomic, strong)AVAudioPlayer *player;

@property (nonatomic, copy) NSString *fileName;

+ (QMAudioPlayer *)sharedInstance;

//- (void)startAudioPlayer:(CustomMessage *)message withDelegate:(id)audioPlayerDelegate;
- (void)startAudioPlayer:(NSString *)fileName withDelegate:(id)audioPlayerDelegate;

- (void)stopAudioPlayer;

- (BOOL)isPlaying:(NSString *)fileName;

@end
