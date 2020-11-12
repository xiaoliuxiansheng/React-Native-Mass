//
//  QMChatRoomMoreView.m
//  IMSDK-OC
//
//  Created by HCF on 16/3/10.
//  Copyright © 2016年 HCF. All rights reserved.
//

#import "QMChatRoomMoreView.h"

@implementation QMChatRoomMoreView


- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        [self createView];
    }
    return self;
}

- (void)createView {    
    // 获取相册图片
    self.takePicBtn = [[BottomTitleBtn alloc] initWithFrame:CGRectMake(([UIScreen mainScreen].bounds.size.width-60*4)/5, 15, 60, 81)];
    
    [self addSubview:self.takePicBtn];
    [self.takePicBtn setTitle:NSLocalizedString(@"button.chat_img", nil) forState:UIControlStateNormal];
    [self.takePicBtn setImage:[UIImage imageNamed:@"sharemore_ album"] forState:UIControlStateNormal];

    // 获取本地文件
    self.takeFileBtn = [BottomTitleBtn buttonWithType:UIButtonTypeCustom];
    self.takeFileBtn.frame = CGRectMake(([UIScreen mainScreen].bounds.size.width-60*4)/5*2+60, 15, 60, 81);
    
    [self.takeFileBtn setTitle:NSLocalizedString(@"button.chat_file", nil) forState:UIControlStateNormal];
    [self.takeFileBtn setImage:[UIImage imageNamed:@"sharemore_folder"] forState:UIControlStateNormal];
    [self addSubview:self.takeFileBtn];

    // 进行服务评价
    self.evaluateBtn = [BottomTitleBtn buttonWithType:UIButtonTypeCustom];
    self.evaluateBtn.frame = CGRectMake(([UIScreen mainScreen].bounds.size.width-60*4)/5*3+120, 15, 60, 81);
    
    [self.evaluateBtn setTitle:NSLocalizedString(@"button.chat_evaluate", nil) forState:UIControlStateNormal];
    [self.evaluateBtn setImage:[UIImage imageNamed:@"sharemore_evalue"] forState:UIControlStateNormal];
    [self addSubview:self.evaluateBtn];
    
    
    // 常见问题
    self.questionBtn = [BottomTitleBtn buttonWithType:UIButtonTypeCustom];
    self.questionBtn.frame = CGRectMake(([UIScreen mainScreen].bounds.size.width-60*4)/5*4+180, 15, 60, 81);
    self.questionBtn.titleLabel.lineBreakMode = NSLineBreakByTruncatingTail;
    [self.questionBtn setTitle:NSLocalizedString(@"button.chat_question", nil)
                      forState:UIControlStateNormal];
    [self.questionBtn setImage:[UIImage imageNamed:@"commonProblem"]
                      forState:UIControlStateNormal];
    [self addSubview:self.questionBtn];

    [self.evaluateBtn addObserver:self forKeyPath:@"hidden" options:NSKeyValueObservingOptionNew context:nil];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
    if ([keyPath isEqualToString:@"hidden"] && object == self.evaluateBtn) {
        NSLog(@"YES");
        BOOL isHidden = [change[NSKeyValueChangeNewKey] boolValue];
        if (isHidden) {
            self.questionBtn.frame = self.evaluateBtn.frame;
        } else {
            self.evaluateBtn.alpha = 0.0;
            [UIView animateWithDuration:0.25 animations:^{
                self.questionBtn.frame =  CGRectMake(([UIScreen mainScreen].bounds.size.width-60*4)/5*4+180, 15, 60, 81);
                self.evaluateBtn.alpha = 1.0;
            }];
        }
    }
}

@end

@interface BottomTitleBtn()

@end

@implementation BottomTitleBtn

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.titleLabel.font = [UIFont systemFontOfSize:12];
        self.titleLabel.textColor = [UIColor colorWithRed:153/255.0 green:153/255.0 blue:153/255.0 alpha:1.0];
        [self setTitleColor:[UIColor colorWithRed:153/255.0 green:153/255.0 blue:153/255.0 alpha:1.0] forState:UIControlStateNormal];
        self.titleLabel.textAlignment = NSTextAlignmentCenter;
        self.imageView.contentMode = UIViewContentModeScaleAspectFit;
    }
    return self;
}

- (CGRect)titleRectForContentRect:(CGRect)contentRect {
    CGFloat orgX = 0;
    CGFloat orgY = contentRect.size.height - [UIFont systemFontOfSize:12].lineHeight - 4;
    orgY = orgY > 0 ? orgY : 0;
    CGFloat w = contentRect.size.width;
    CGFloat h = [UIFont systemFontOfSize:12].lineHeight;

    return CGRectMake(orgX, orgY, w, h);
}

- (CGRect)imageRectForContentRect:(CGRect)contentRect {
//    [super imageRectForContentRect:contentRect];
    CGFloat orgX = 0;
    CGFloat orgY = 0;
    CGFloat w = contentRect.size.width;
    CGFloat h = contentRect.size.height - [UIFont systemFontOfSize:12].lineHeight - 4;
    h = h > 0 ? h : 0;
    if (w > h) {
        w = h;
    } else {
        h = w;
    }
    
    if (w < contentRect.size.width) {
        orgX = (contentRect.size.width - w)/2.0;
    }
    
    return CGRectMake(orgX, orgY, w, h);
}



@end
