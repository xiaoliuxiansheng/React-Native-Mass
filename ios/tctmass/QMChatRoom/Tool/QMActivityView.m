//
//  QMActivityView.m
//  IMSDK-OC
//
//  Created by zcz on 2020/1/2.
//  Copyright © 2020 HCF. All rights reserved.
//

#import "QMActivityView.h"

@implementation QMActivityView

+ (instancetype)allocWithZone:(struct _NSZone *)zone {
    return [QMActivityView shareQMactivityView];
}

+ (instancetype)shareQMactivityView {
    static QMActivityView *_qmActivityView = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _qmActivityView = [[super allocWithZone:NULL] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
        _qmActivityView.layer.cornerRadius = 5;
        _qmActivityView.layer.masksToBounds = YES;
        _qmActivityView.frame = CGRectMake((kScreenWidth-100)/2, (kScreenHeight-100)/2-64, 100, 100);
        _qmActivityView.backgroundColor = [UIColor blackColor];
        _qmActivityView.color = [UIColor whiteColor];
        _qmActivityView.alpha = 0.7;
    });
    
    return _qmActivityView;
}

- (id)copy {
    return [QMActivityView shareQMactivityView];
}

+ (void)startAnimating {
    dispatch_async(dispatch_get_main_queue(), ^{
        QMActivityView *activityView = [QMActivityView shareQMactivityView];
        [activityView removeFromSuperview];
        [[UIApplication sharedApplication].keyWindow addSubview:activityView];
        [activityView startAnimating];
    });
}

+ (void)stopAnimating {
    dispatch_async(dispatch_get_main_queue(), ^{
        QMActivityView *activityView = [QMActivityView shareQMactivityView];
        [activityView stopAnimating];
        [activityView removeFromSuperview];
    });
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
