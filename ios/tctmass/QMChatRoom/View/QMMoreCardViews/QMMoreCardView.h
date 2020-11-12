//
//  QMMoreCardView.h
//  IMSDK-OC
//
//  Created by zcz on 2019/12/24.
//  Copyright © 2019 HCF. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "QMCardInfoModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface QMMoreCardView : UIView

@property (nonatomic, copy) void(^selectItem)(NSDictionary *dict);

@property (nonatomic, strong) NSDictionary *itemDict;

+ (instancetype)defualtView;
- (void)show;
- (void)closeAction;
@end

@interface QMMoreCardHeaderCell : UITableViewCell
@property(nonatomic, strong) UIView *topLine;

- (void)setCellData:(QMCardInfoModel *)model;
@end

@interface QMMoreCardCell : UITableViewCell
- (void)setCellData:(QMCardInfoModel *)model;

@end

NS_ASSUME_NONNULL_END
