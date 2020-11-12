//
//  QMChatRoomInputView.h
//  IMSDK-OC
//
//  Created by HCF on 16/3/9.
//  Copyright © 2016年 HCF. All rights reserved.
//


#import <UIKit/UIKit.h>

@interface QMChatRoomInputView : UIView<UITextViewDelegate>

@property (nonatomic ,strong)UITextView *inputView; // 输入栏
@property (nonatomic ,strong)UIButton * voiceButton; // 声音按钮
@property (nonatomic ,strong)UIButton * RecordBtn; // 录音按钮
@property (nonatomic ,strong)UIButton * faceButton; // 表情按钮
@property (nonatomic ,strong)UIButton * addButton; // 扩展按钮
@property (nonatomic ,strong)UIView *coverView; // 限制出入蒙版

/**
    录音按钮显示切换
 */
- (void)showRecordButton: (BOOL)show;

/**
    表情面板显示切换
 */
- (void)showEmotionView: (BOOL)show;


/**
    扩展面板显示切换
 */
- (void)showMoreView: (BOOL)show;

@end
