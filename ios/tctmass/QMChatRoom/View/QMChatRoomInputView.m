//
//  QMChatRoomInputView.m
//  IMSDK-OC
//
//  Created by HCF on 16/3/9.
//  Copyright © 2016年 HCF. All rights reserved.
//

#import "QMChatRoomInputView.h"

@implementation QMChatRoomInputView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        self.layer.borderColor = [[UIColor colorWithRed:229/255.0 green:229/255.0 blue:231/255.0 alpha:1] CGColor];
        self.layer.borderWidth = 0.5;
        [self createView];
    }
    return  self;
}

- (void)createView {
    
    //切换语音按钮
    self.voiceButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.voiceButton.frame = CGRectMake(0, 0, kInputViewHeight, kInputViewHeight);
    [self.voiceButton setImage:[UIImage imageNamed:@"ToolBar_Voice"] forState:UIControlStateNormal];
    [self addSubview: self.voiceButton];
    
    //输入框
    self.inputView = [[UITextView alloc] initWithFrame:CGRectMake(50, 8, kScreenWidth-140, 34)];
    self.inputView.returnKeyType = UIReturnKeySend;
    self.inputView.delegate = self;
    self.inputView.font = [UIFont systemFontOfSize:18];
    self.inputView.backgroundColor = [UIColor whiteColor];
    self.inputView.layer.cornerRadius = 17;
    self.inputView.layer.masksToBounds = YES;
    self.inputView.layer.borderColor = [[UIColor grayColor] CGColor];
    self.inputView.layer.borderWidth = 0.5;
    [self addSubview:self.inputView];
    
    //录音按钮
    self.RecordBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.RecordBtn.frame = CGRectMake(50, 8, kScreenWidth-140, 34);
    self.RecordBtn.backgroundColor = [UIColor whiteColor];
    self.RecordBtn.hidden = YES;
    self.RecordBtn.layer.cornerRadius = 17;
    self.RecordBtn.layer.masksToBounds = YES;
    self.RecordBtn.layer.borderColor = [[UIColor grayColor] CGColor];
    self.RecordBtn.layer.borderWidth = 0.5;
    [self.RecordBtn setTitle:NSLocalizedString(@"button.recorder_normal", nil) forState:UIControlStateNormal];
    [self.RecordBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    [self.RecordBtn setTitleColor:[UIColor colorWithRed:50/255.0f green:167/255.0f blue:255/255.0f alpha:1.0] forState:UIControlStateSelected];
    self.RecordBtn.hidden = YES;
    [self addSubview:self.RecordBtn];
    
    //表情按钮
    self.faceButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.faceButton.frame = CGRectMake(kScreenWidth-kInputViewHeight*2+20, 0, kInputViewHeight-10, kInputViewHeight);
    self.faceButton.tag = 1;
    [self.faceButton setImage:[UIImage imageNamed:@"ToolBar_Emotion"] forState:UIControlStateNormal];
    [self addSubview: self.faceButton];
    
    //扩展功能按钮
    self.addButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.addButton.frame = CGRectMake(kScreenWidth-kInputViewHeight+10, 0, kInputViewHeight-10, kInputViewHeight);
    self.addButton.tag = 3;
    [self.addButton setImage:[UIImage imageNamed:@"ToolBar_Add"] forState:UIControlStateNormal];
    [self addSubview: self.addButton];
    
    self.coverView = [[UIView alloc] init];
    self.coverView.frame = CGRectMake(0, 0, kScreenWidth, kInputViewHeight);
    self.coverView.backgroundColor = UIColor.clearColor;
    [self.coverView setHidden:YES];
    [self addSubview:self.coverView];
    
}

// 开始录音
- (void)startRecord: (UIButton *)sender {
    
}

// 完成录音
- (void)finishRecord: (UIButton *)sender {
    
}

// 取消录音
-(void)cancelRecord: (UIButton *)sender {
    
}

// 显示录音按钮
- (void)showRecordButton: (BOOL)show {
    if (show) {
        self.inputView.hidden = YES;
        self.RecordBtn.hidden = NO;
        [self.RecordBtn setTitle:NSLocalizedString(@"button.recorder_normal", nil) forState:UIControlStateNormal];
        [self.voiceButton setImage:[UIImage imageNamed:@"ToolBar_Keyboard"] forState:UIControlStateNormal];
        [self showEmotionView:NO];
        [self showMoreView:NO];
    }else {
        self.inputView.hidden = NO;
        self.RecordBtn.hidden = YES;
        self.inputView.inputView = nil;
        [self.voiceButton setImage:[UIImage imageNamed:@"ToolBar_Voice"] forState:UIControlStateNormal];
    }
}

// 显示表情面板
- (void)showEmotionView: (BOOL)show {
    if (show) {
        self.faceButton.tag = 2;
        [self.faceButton setImage:[UIImage imageNamed:@"ToolBar_Keyboard"] forState:UIControlStateNormal];
        [self showRecordButton:NO];
        [self showMoreView:NO];
    }else {
        self.faceButton.tag = 1;
        [self.faceButton setImage:[UIImage imageNamed:@"ToolBar_Emotion"] forState:UIControlStateNormal];
    }
}

// 显示扩展面板
- (void)showMoreView: (BOOL)show {
    if (show) {
        self.addButton.tag = 4;
        [self showEmotionView:NO];
        [self showRecordButton:NO];
    }else {
        self.addButton.tag = 3;
        self.inputView.inputView = nil;
    }
}

@end
