//
//  QMRecordIndicatorView.h
//  IMSDK-OC
//
//  Created by HCF on 16/7/31.
//  Copyright © 2016年 HCF. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum {
    QMIndicatorStatusShort = 1,
    QMIndicatorStatusLong,
    QMIndicatorStatusNormal,
    QMIndicatorStatusCancel
}QMIndicatorStatus;

@interface QMRecordIndicatorView : UIView

@property (nonatomic, assign) int count;

@property (nonatomic, assign) BOOL isCount;

-(void)updateImageWithPower: (float)power;

- (void)changeViewStatus:(QMIndicatorStatus)status;

@end
