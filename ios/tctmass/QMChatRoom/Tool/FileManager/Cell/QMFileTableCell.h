//
//  QMFileTableCell.h
//  IMSDK-OC
//
//  Created by HCF on 16/8/11.
//  Copyright © 2016年 HCF. All rights reserved.
//

#import <UIKit/UIKit.h>

@class QMFileModel;
@interface QMFileTableCell : UITableViewCell

@property (nonatomic, strong)UIImageView *pickedItemImageView;

- (void)configureWithModel: (QMFileModel *)model;

@end
