//
//  QMItemCollectionCell.h
//  IMSDK-OC
//
//  Created by HCF on 16/8/10.
//  Copyright © 2016年 HCF. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface QMItemCollectionCell : UICollectionViewCell

@property (nonatomic, strong)UIImageView *iconImageView;

@property (nonatomic, strong)UILabel *nameLabel;

- (void)configureWithName: (NSString *)name;

@end
