//
//  QMFlowView.h
//  IMSDK-OC
//
//  Created by lishuijiao on 2019/9/2.
//  Copyright © 2019 HCF. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface QMFlowView : UIView

@property (nonatomic, copy)void(^selectAction)(NSDictionary *);

@property (nonatomic, copy) void(^tapFlowNumberAction)(NSString *);

@property (nonatomic, copy) NSString *flowList;

@property (nonatomic, copy) NSString *flowTip;

@property (nonatomic, copy) NSString *flowType;

@property (nonatomic, assign) BOOL isVertical;

@property (nonatomic, copy) NSString *robotFlowTip;

- (void)setDate;

@end

NS_ASSUME_NONNULL_END
