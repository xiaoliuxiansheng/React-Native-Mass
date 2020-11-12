//
//  QMVideoTableCell.h
//  IMSDK-OC
//
//  Created by HCF on 16/8/11.
//  Copyright © 2016年 HCF. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Photos/Photos.h>

@interface QMVideoTableCell : UITableViewCell

@property (nonatomic, strong)PHAsset *imageAsset;
@property (nonatomic, strong)PHImageManager *imageManager;

@property (nonatomic, strong)UIImageView *pickedItemImageView;

@end
