//
//  QMItemCollectionCell.m
//  IMSDK-OC
//
//  Created by HCF on 16/8/10.
//  Copyright © 2016年 HCF. All rights reserved.
//

#import "QMItemCollectionCell.h"

@implementation QMItemCollectionCell

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self createUI];
    }
    return self;
}

- (void)createUI {
    self.contentView.backgroundColor = [UIColor whiteColor];
    
    self.iconImageView = [[UIImageView alloc] init];
    self.iconImageView.frame = CGRectMake(20, 20, self.bounds.size.width-40, self.bounds.size.height-60);
    [self.contentView addSubview:self.iconImageView];
    
    self.nameLabel = [[UILabel alloc] init];
    self.nameLabel.frame = CGRectMake(0, self.bounds.size.height-20, self.bounds.size.width, 20);
    self.nameLabel.font = [UIFont systemFontOfSize:14];
    self.nameLabel.textAlignment = NSTextAlignmentCenter;
    [self.contentView addSubview:self.nameLabel];
}

- (void)configureWithName: (NSString *)name {
    self.iconImageView.image = [UIImage imageNamed:@"custom_file_folder"];
    self.nameLabel.text = name;
}



@end
