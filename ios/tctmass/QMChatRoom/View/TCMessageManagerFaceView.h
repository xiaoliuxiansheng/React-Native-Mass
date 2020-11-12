//
//  TCMessageManagerFaceView.h
//  QimoQM
//
//  Created by TuChuan on 15/5/13.
//  Copyright (c) 2015年 七陌科技. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TCFaceView.h"

@protocol TCMessageManagerFaceViewDelegate <NSObject>

- (void)SendTheFaceStr:(NSString *)faceStr isDelete:(BOOL)dele;

@end

@interface TCMessageManagerFaceView : UIView<UIScrollViewDelegate,TCFaceViewDelegate>

@property (nonatomic,weak)id<TCMessageManagerFaceViewDelegate>delegate;

@property (nonatomic, strong)UIButton * sendButton;

@end
