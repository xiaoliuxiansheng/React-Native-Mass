//
//  radioContentView.m
//  IMSDK-OC
//
//  Created by lishuijiao on 2019/1/10.
//  Copyright © 2019年 HCF. All rights reserved.
//

#import "RadioContentView.h"
#import "QMAlert.h"

@interface RadioContentView() {
    CGFloat minWidth;
    CGFloat maxWidth;
    CGFloat buttonHeight;
    CGFloat buttonMargin;
    CGFloat titleMargin;
    int startTag;
    NSArray *_reason;
    CGFloat buttonFrameHeight;
}

@property (nonatomic, strong) UIButton *selectedButton;

@property (nonatomic, strong) NSMutableArray *selectedArray;

@end

@implementation RadioContentView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        minWidth = [QMAlert calcLabelHeight:@"宽度" font:[UIFont systemFontOfSize:14]] + 2 * 10;
        maxWidth = kScreenWidth - 110;
        buttonHeight = 24;
        buttonMargin = 12;
        titleMargin = 10;
        startTag = 700;
        buttonFrameHeight = 0;
    }
    return self;
}

- (void)loadData:(NSArray *)reason {
    _reason = reason;
    
    self.selectedArray = [[NSMutableArray alloc] init];
    
    CGFloat originX = 0;
    CGFloat originY = 0;
    CGFloat height = 0;
    
    for (UIView *subView in self.subviews) {
        [subView removeFromSuperview];
    }
    
    for (int i = 0; i < reason.count; i++) {
        UIButton *button = [[UIButton alloc] init];
        button.layer.borderColor = [UIColor colorWithRed:179/255.0 green:179/255.0 blue:179/255.0 alpha:1.0].CGColor;
        button.layer.borderWidth = 0.5;
        button.layer.cornerRadius = 2;
        button.layer.masksToBounds = true;
        button.tag = startTag + i;
        button.titleLabel.font = [UIFont systemFontOfSize:14];
        [button setTitle:reason[i] forState:UIControlStateNormal];
        [button setTitleColor: [UIColor colorWithRed:102/255.0 green:102/255.0 blue:102/255.0 alpha:1.0] forState:UIControlStateNormal];
        [button setTitleColor:[UIColor colorWithRed:243/255.0 green:147/255.0 blue:0/255.0 alpha:1.0] forState:UIControlStateSelected];
        [button addTarget:self action:@selector(selectAction:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:button];

        button.titleLabel.lineBreakMode = 0;
        CGSize size = [QMAlert calculateText:reason[i] font:[UIFont systemFontOfSize:14] maxWidth:kScreenWidth - 120 maxHeight:100];
        buttonHeight = size.height > 24 ? size.height : 24;

        button.frame = CGRectMake(originX, originY, kScreenWidth - 120, buttonHeight);
        originY += buttonHeight + buttonMargin;
        
        height = CGRectGetMaxY(button.frame);
    }
    CGRect frm = self.frame;
    frm.size.width = maxWidth;
    frm.size.height = height;
    self.frame = frm;
}

- (void)selectAction:(UIButton *)button {
    if (button.selected) {
        button.selected = NO;
        button.layer.borderColor = [UIColor colorWithRed:179/255.0 green:179/255.0 blue:179/255.0 alpha:1.0].CGColor;
        if ([self.selectedArray containsObject:button.titleLabel.text]) {
            [self.selectedArray removeObject:button.titleLabel.text];
        }
    }else{
        button.selected = YES;
        button.layer.borderColor = [UIColor colorWithRed:243/255.0 green:147/255.0 blue:0/255.0 alpha:1.0].CGColor;
        
        if (![self.selectedArray containsObject:button.titleLabel.text]) {
            [self.selectedArray addObject:button.titleLabel.text];
        }
    }
        
    self.selectRadio(self.selectedArray);
}

@end
