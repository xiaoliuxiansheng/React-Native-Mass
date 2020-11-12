//
//  QMChatRoomEvaluationView.m
//  IMSDK-OC
//
//  Created by lishuijiao on 2019/1/9.
//  Copyright © 2019年 HCF. All rights reserved.
//

#import "QMChatRoomEvaluationView.h"
#import "QMAlert.h"


@interface QMChatRoomEvaluationView()<UITextViewDelegate>

@property (nonatomic, copy) NSArray *radioValue;

@property (nonatomic, copy) NSString *optionName;

@property (nonatomic, copy) NSString *optionValue;

@property (nonatomic, assign) CGFloat optionHeight;

@property (nonatomic, strong) UIView *textBackView;

@property (nonatomic, strong) QMEvaluats *currentEvaluate;


@end

@implementation QMChatRoomEvaluationView

- (void)dealloc {
    NSLog(@"____%s____",__func__);
}

- (void)createUI {
    
    self.coverView = [[UIView alloc] initWithFrame: [UIScreen mainScreen].bounds];

    self.coverView.backgroundColor = [UIColor clearColor];
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction)];
    [self.coverView addGestureRecognizer:tapGesture];

    self.backView = [[UIScrollView alloc] initWithFrame:CGRectMake(30, 65, kScreenWidth - 60, 376*kScale6)];
    self.backView.showsVerticalScrollIndicator = false;
    self.backView.backgroundColor = [UIColor whiteColor];
    UITapGestureRecognizer *backTapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction)];
    [self.coverView addGestureRecognizer:backTapGesture];
    [self.coverView addSubview:self.backView];
    
    self.titleLabel = [[UILabel alloc] init];
    NSString *str = self.evaluation.title ?: NSLocalizedString(@"button.chat_title", nil);
    self.titleLabel.text = str;
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
    self.titleLabel.font = [UIFont systemFontOfSize:14];
    self.titleLabel.numberOfLines = 0;
    self.titleLabel.textColor = [UIColor colorWithRed:51/255.0 green:51/255.0 blue:51/255.0 alpha:1.0];
    CGFloat titleHeight = [QMAlert calculateRowHeight:str fontSize:14];
    self.titleLabel.frame = CGRectMake(25, 25, self.backView.frame.size.width - 50., titleHeight);

    [self.backView addSubview:self.titleLabel];

    CGFloat originX = 15;
    CGFloat originY = CGRectGetMaxY(self.titleLabel.frame)+27;
    CGFloat maxWidth = kScreenWidth - 110;
    CGFloat titleMargin = 20; //圆圈宽度
    CGFloat buttonMargin = 15;//button间距
    CGFloat buttonHeight = 21;//button高度
    
    for (int i = 0; i < self.evaluation.evaluats.count; i++) {
        UIButton *button = [[UIButton alloc] init];
        [button setTitle:[NSString stringWithFormat:@" %@", self.evaluation.evaluats[i].name] forState:UIControlStateNormal];
        [button setImage:[UIImage imageNamed:@"evaluat_icon_nor"] forState:UIControlStateNormal];
        [button setImage:[UIImage imageNamed:@"evaluat_icon_sel"] forState:UIControlStateSelected];
        [button setTitleColor:[UIColor colorWithRed:51/255.0 green:51/255.0 blue:51/255.0 alpha:1.0] forState:UIControlStateNormal];
        button.titleLabel.font = [UIFont systemFontOfSize:14];
        button.tag = 100+i;
        [button addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
                
        button.titleLabel.lineBreakMode = 0;
        CGSize size = [QMAlert calculateText:self.evaluation.evaluats[i].name font:[UIFont systemFontOfSize:14] maxWidth:maxWidth-10 maxHeight:100];
        CGFloat btnHeight = size.height > 21 ? size.height : 21;
        button.frame = CGRectMake(originX + 10, originY, size.width + titleMargin + 5, btnHeight);
        originY += btnHeight + buttonMargin;
        [self.backView addSubview:button];
    }
    
    originY = originY - buttonMargin;
    self.optionHeight = originY;
    
    self.textBackView = [[UIView alloc] initWithFrame:CGRectMake(25, originY + buttonHeight + 20, self.backView.frame.size.width - 50, 89)];
    self.textBackView.backgroundColor = [UIColor clearColor];
    self.textBackView.layer.borderWidth = 0.5;
    self.textBackView.layer.borderColor = QM_Color(179, 179, 179).CGColor;
    self.textBackView.layer.cornerRadius = 2;
    [self.backView addSubview:self.textBackView];
    
    self.textView = [[UITextView alloc] init];
    self.textView.frame = CGRectMake(0, 0, self.textBackView.frame.size.width, 75);
    self.textView.layer.masksToBounds = true;
    self.textView.delegate = self;
    self.textView.backgroundColor = [UIColor colorWithRed:250/255.0 green:250/255.0 blue:250/255.0 alpha:1.0];
    [self.textBackView addSubview:self.textView];
    UILabel *countLab = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetHeight(self.textBackView.frame) - 12, CGRectGetWidth(self.textView.frame) - 4, 12)];
    countLab.textAlignment = NSTextAlignmentRight;
    countLab.font = [UIFont systemFontOfSize:11];
    countLab.textColor = QM_Color(100, 100, 100);
    countLab.text = @"120字";
    countLab.tag = 212;
    [self.textBackView addSubview:countLab];
    self.textBackView.backgroundColor = self.textView.backgroundColor;
    
    self.sendButton = [[UIButton alloc] initWithFrame:CGRectMake(self.backView.frame.size.width/2-85, CGRectGetMaxY(self.textBackView.frame)+25, 80, 30)];
    [self.sendButton setTitle:NSLocalizedString(@"button.submit.review", nil) forState:UIControlStateNormal];
    self.sendButton.titleLabel.font = [UIFont systemFontOfSize:15];
    self.sendButton.backgroundColor = [UIColor colorWithRed:243/255.0 green:147/255.0 blue:0/255.0 alpha:1.0];
    [self.sendButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.sendButton addTarget:self action:@selector(sendAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.backView addSubview:self.sendButton];
    
    self.cancelButton = [[UIButton alloc] initWithFrame:CGRectMake(self.backView.frame.size.width/2+5, CGRectGetMaxY(self.textBackView.frame)+25, 50, 30)];
    [self.cancelButton setTitle:NSLocalizedString(@"button.cancel", nil) forState:UIControlStateNormal];
    self.cancelButton.titleLabel.font = [UIFont systemFontOfSize:15];
    self.cancelButton.backgroundColor = [UIColor colorWithRed:243/255.0 green:147/255.0 blue:0/255.0 alpha:1.0];
    [self.cancelButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.cancelButton addTarget:self action:@selector(cancelAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.backView addSubview:self.cancelButton];
    
//    self.backView.frame = CGRectMake(30, 65, kScreenWidth - 60, CGRectGetMaxY(self.cancelButton.frame) + 25);
    self.backView.contentSize = CGSizeMake(self.backView.frame.size.width, CGRectGetMaxY(self.cancelButton.frame) + 25);
    [self addSubview:self.coverView];
}

- (void)buttonAction:(UIButton *)button {
    
    [self.textView resignFirstResponder];
    
    if (button == self.selectedButton) {

    }else{
        self.selectedButton.selected = NO;
        button.selected = YES;
        self.selectedButton = button;
        [self.radioView removeFromSuperview];
        [self createReason:button.tag - 100];
    }
    
    self.currentEvaluate = self.evaluation.evaluats[button.tag - 100];
    self.optionValue = self.currentEvaluate.value;
    self.optionName = self.currentEvaluate.name;
}

- (void)createReason:(NSInteger)number {
    __weak typeof(self) weakSelf = self;
    self.optionValue = @"";
    NSMutableArray * array = [[NSMutableArray alloc] init];
    for (int i = 0; i < self.evaluation.evaluats.count; i++) {
        [array addObject:self.evaluation.evaluats[i].name];
    }
    
    self.radioView = [[RadioContentView alloc] initWithFrame:CGRectZero];

    [self.radioView loadData:self.evaluation.evaluats[number].reason];
    CGRect frm = self.radioView.frame;
    frm.origin.x = 25;
    frm.origin.y = self.optionHeight + 20;
    self.radioView.frame = frm;
    
    self.radioView.selectRadio = ^(NSArray * arr) {
        __strong typeof(weakSelf)sSelf = weakSelf;
        sSelf.radioValue = arr;
        [sSelf.textView resignFirstResponder];
    };
    
    [self.backView addSubview:self.radioView];
    if (self.radioView.frame.size.height == 0) {
        CGRect supFrame = self.textBackView.frame;
        supFrame.origin.y = CGRectGetMaxY(self.radioView.frame) + 5;
        self.textBackView.frame = supFrame;
    }else {
        CGRect supFrame = self.textBackView.frame;
        supFrame.origin.y = CGRectGetMaxY(self.radioView.frame) + 10;

        self.textBackView.frame = supFrame;
    }
    self.sendButton.frame = CGRectMake(self.backView.frame.size.width/2-85, CGRectGetMaxY(self.textBackView.frame)+25, 80, 30);
    self.cancelButton.frame = CGRectMake(self.backView.frame.size.width/2+5, CGRectGetMaxY(self.textBackView.frame)+25, 50, 30);
//    self.backView.frame = CGRectMake(30, 65, kScreenWidth - 60, CGRectGetMaxY(self.cancelButton.frame) + 25);
    self.backView.contentSize = CGSizeMake(self.backView.frame.size.width,  CGRectGetMaxY(self.cancelButton.frame) + 25);
}

- (void)sendAction:(UIButton *)button {
    
    if (self.optionName.length > 0) {
        if (self.currentEvaluate.labelRequired.boolValue && self.radioValue.count == 0) {
            [QMAlert showMessage:NSLocalizedString(@"title.evaluation_label", nil)];
            return;
        }
        
        if (self.currentEvaluate.proposalRequired.boolValue && self.textView.text.length == 0) {
            [QMAlert showMessage:NSLocalizedString(@"title.evaluation_reason", nil)];
            return;
        }
        self.sendSelect(self.optionName, self.optionValue, self.radioValue, self.textView.text);
    }else{
        [QMAlert showMessage:NSLocalizedString(@"title.evaluation_select", nil)];
    }
}

- (void)cancelAction:(UIButton *)button {
    self.cancelSelect();
}

- (void)tapAction {
    [self.textView resignFirstResponder];
    [UIView animateWithDuration:0.3 animations:^{
        self.backView.contentSize = CGSizeMake(self.backView.frame.size.width, CGRectGetMaxY(self.cancelButton.frame) + 25);

    }];
}

- (BOOL)textViewShouldBeginEditing:(UITextView *)textView {
    [UIView animateWithDuration:0.3 animations:^{
        self.backView.contentSize = CGSizeMake(self.backView.frame.size.width, CGRectGetMaxY(self.cancelButton.frame) + 25);
    }];
    return true;
}

- (void)textViewDidEndEditing:(UITextView *)textView {
    [self tapAction];
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    if (textView.text.length >= 120 && text.length > 0) {
        return NO;
    }

    return YES;
}

- (void)textViewDidChange:(UITextView *)textView {
    NSString *str = textView.text;
    if (str.length > 120) {
        str = [str substringToIndex:120];
    }
    textView.text = str;
    UILabel *countLab = (UILabel *)[self.textBackView viewWithTag:212];
    if (countLab) {
        countLab.text = [NSString stringWithFormat:@"%ld字",(long)(120 - str.length)];
    }
}

@end
