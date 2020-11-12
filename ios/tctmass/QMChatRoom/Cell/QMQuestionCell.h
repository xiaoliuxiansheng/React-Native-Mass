//
//  QMQuestionCell.h
//  IMSDK-OC
//
//  Created by zcz on 2020/1/2.
//  Copyright © 2020 HCF. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface QMQuestionCell : UITableViewCell

@property(nonatomic, copy) void(^cellSelect)(void);
- (void)setCellData:(NSString *)title;
@end

NS_ASSUME_NONNULL_END
