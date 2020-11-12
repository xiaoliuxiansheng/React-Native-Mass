//
//  QMAudioRecorder.m
//  IMSDK-OC
//
//  Created by haochongfeng on 2017/8/10.
//  Copyright © 2017年 HCF. All rights reserved.
//

#import "QMAudioRecorder.h"

@interface QMAudioRecorder()<AVAudioRecorderDelegate>

@property (nonatomic, strong) AVAudioRecorder *audioRecorder;

@property (nonatomic, copy) NSString *recordFileName;

@property (nonatomic, copy) NSString *recordFilePath;

@property (nonatomic, assign) NSTimeInterval recordDuration;

@property (nonatomic, assign) NSTimeInterval maxDuration;

@property (nonatomic, strong) NSDictionary *recordSet;

@property (nonatomic, weak) id<QMAudioRecorderDelegate> delegate;

@property (nonatomic, strong) NSTimer *timer;

@property (nonatomic, assign) BOOL isRecording;

@property (nonatomic, assign) BOOL isCancel;

@end

@implementation QMAudioRecorder

static QMAudioRecorder * instance = nil;

+ (QMAudioRecorder *)sharedInstance {
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

- (instancetype)init {
    self = [super init];
    if (self) {
        NSDictionary * recordSettings = @{
                                          AVFormatIDKey           : [NSNumber numberWithUnsignedInt:kAudioFormatLinearPCM],
                                          AVSampleRateKey         : [NSNumber numberWithFloat:8000],
                                          AVLinearPCMBitDepthKey  : [NSNumber numberWithInt:16],
                                          AVNumberOfChannelsKey   : [NSNumber numberWithInt:2]
                                          };
        self.recordSet = recordSettings;
    }
    return self;
}

- (void)startAudioRecord:(NSString *)fileName maxDuration:(NSTimeInterval)duration delegate:(id<QMAudioRecorderDelegate>)delegate {
    [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayAndRecord error:nil];
    [[AVAudioSession sharedInstance] setActive:YES error:nil];
    
    self.isCancel = false;
    self.delegate = delegate;
    self.recordDuration = 0.0;
    if ([fileName isEqualToString:@""]) {
        [self.delegate audioRecorderCancel];
        return;
    }
    
    self.maxDuration = duration;
    self.recordFileName = fileName;
    self.recordFilePath = [NSString stringWithFormat:@"%@/%@/%@",NSHomeDirectory(),@"Documents",fileName];
    
    if (![NSURL URLWithString:self.recordFilePath]) {
        return;
    }
    
    NSError *error = nil;
    self.audioRecorder = [[AVAudioRecorder alloc] initWithURL:[NSURL URLWithString:self.recordFilePath] settings:self.recordSet error:&error];
    self.audioRecorder.delegate = self;
    if (error) {
        [self.delegate audioRecorderCancel];
        return;
    }
    [self.audioRecorder setMeteringEnabled:YES];
    [self.audioRecorder prepareToRecord];
    [self createTimer];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.01 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        if ([self.audioRecorder recordForDuration:duration]) {
            [self.delegate audioRecorderStart];
        }else {
            [self cancelAudioRecord];
            return;
        }
    });
}

- (void)stopAudioRecord {
    self.isCancel = false;
    if (self.audioRecorder) {
        [self.audioRecorder stop];
    }
    [self removeTimer];
}

- (void)cancelAudioRecord {
    self.isCancel = true;
    if (self.audioRecorder) {
        [self.audioRecorder stop];
        [self.audioRecorder deleteRecording];
    }
    [self removeTimer];
    if (self.delegate) {
        [self.delegate audioRecorderCancel];
    }
}

- (void)createTimer {
    [self removeTimer];
    self.timer = [NSTimer scheduledTimerWithTimeInterval:0.05 target:self selector:@selector(timerAction:) userInfo:nil repeats:YES];
    [[NSRunLoop mainRunLoop] addTimer:self.timer forMode:NSRunLoopCommonModes];
}

- (void)timerAction:(NSTimer *)timer { 
    if (self.delegate && self.audioRecorder) {
        if (self.recordDuration > 50) {
            if (self.audioRecorder.currentTime != 0) {
                self.recordDuration = self.audioRecorder.currentTime;
            }
        }else {
            self.recordDuration = self.audioRecorder.currentTime;
        }
        [self.delegate audioRecorderChangeInTimer:[self peakPower] total:[self totalTime]];
    }
}

- (void)removeTimer {
    if (self.timer) {
        [self.timer invalidate];
        self.timer = nil;
    }
}

- (float)peakPower {
    [self.audioRecorder updateMeters];
    return self.audioRecorder ? [self.audioRecorder peakPowerForChannel:0] : 0;
}

- (int)totalTime {
    return (int)(self.recordDuration*10)%10 > 6 ? (int)self.recordDuration + 1 : (int)self.recordDuration;
}

// MARK: - 代理方法
- (void)audioRecorderEncodeErrorDidOccur:(AVAudioRecorder *)recorder error:(NSError *)error {
    
}

- (void)audioRecorderDidFinishRecording:(AVAudioRecorder *)recorder successfully:(BOOL)flag {
    if (self.isCancel) {
        NSString *filePath = [NSString stringWithFormat:@"%@/%@/%@",NSHomeDirectory(),@"Documents",self.recordFileName];
        NSFileManager *fileManger = [NSFileManager defaultManager];
        if ([fileManger fileExistsAtPath:filePath]) {
            [fileManger removeItemAtPath:filePath error:nil];
        }
        return;
    }
    
    if (self.recordDuration >= 1) {
        [self.delegate audioRecorderCompletion:self.recordFileName duration:[NSString stringWithFormat:@"%d", [self totalTime]]];
        [self removeTimer];
    }else {
        [self.delegate audioRecorderFail];
    }
}

@end
