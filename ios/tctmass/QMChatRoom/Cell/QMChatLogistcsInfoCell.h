//
//  QMChatLogistcsInfoCell.h
//  IMSDK-OC
//
//  Created by zcz on 2019/12/25.
//  Copyright © 2019 HCF. All rights reserved.
//

#import "QMChatRoomBaseCell.h"
#import "QMLogistcsInfoModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface QMChatLogistcsInfoCell : QMChatRoomBaseCell
@property(nonatomic, strong) QMLogistcsInfoModel *dataModel;

@property(nonatomic, copy) void(^showMore)(void);
+ (CGFloat)getCellHeigt:(QMLogistcsInfoModel *)model;
@end

@interface QMLogistcsInfoSubCell : UITableViewCell

@property(nonatomic, strong) UIView *verticalTopLine;
@property(nonatomic, strong) UIView *verticalBottomLine;

@property(nonatomic, copy) void(^showMore)(void);


- (void)setCireBlue;
- (void)setCireGreen;

+ (CGFloat)getCellHeight:(NSString *)title;
- (void)setCellData:(QMLogistcsInfo *)model;
@end

NS_ASSUME_NONNULL_END
