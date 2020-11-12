//
//  QMAudioRecorder.h
//  IMSDK-OC
//
//  Created by haochongfeng on 2017/8/10.
//  Copyright © 2017年 HCF. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>

@protocol QMAudioRecorderDelegate <NSObject>

- (void)audioRecorderStart;

- (void)audioRecorderCompletion:(NSString *)fileName duration:(NSString *)duration;

- (void)audioRecorderCancel;

- (void)audioRecorderFail;

- (void)audioRecorderChangeInTimer:(NSTimeInterval)power total:(int)count;

@end

@interface QMAudioRecorder : NSObject

+ (QMAudioRecorder *)sharedInstance;

- (void)startAudioRecord:(NSString *)fileName maxDuration:(NSTimeInterval)duration delegate:(id<QMAudioRecorderDelegate>)delegate;

- (void)stopAudioRecord;

- (void)cancelAudioRecord;

@end
