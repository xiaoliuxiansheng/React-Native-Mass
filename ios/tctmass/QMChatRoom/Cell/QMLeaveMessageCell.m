//
//  QMLeaveMessageCell.m
//  IMSDK-OC
//
//  Created by haochongfeng on 2017/11/27.
//  Copyright © 2017年 HCF. All rights reserved.
//

#import "QMLeaveMessageCell.h"

@interface QMLeaveMessageCell ()

@end

@implementation QMLeaveMessageCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = [UIColor colorWithRed:244/255.0 green:244/255.0 blue:246/255.0 alpha:1];
        [self setUI];
    }
    return self;
}

- (void)setUI {
    self.backView = [[UIView alloc] init];
    self.backView.frame = CGRectMake(10, 0, kScreenWidth - 20, 44);
    self.backView.backgroundColor = [UIColor whiteColor];
    [self.contentView addSubview:self.backView];
    
    self.textField = [[UITextField alloc] init];
    self.textField.frame = CGRectMake(5, 7, kScreenWidth - 30, 30);
    self.textField.backgroundColor = [UIColor clearColor];
    self.textField.textAlignment = NSTextAlignmentLeft;
    self.textField.font = [UIFont systemFontOfSize:16];
    self.textField.placeholder = @"";
    [self.backView addSubview:self.textField];
    
    [self.textField addTarget:self action:@selector(change:) forControlEvents:UIControlEventEditingChanged];
}

- (void)setData: (NSDictionary *)information defaultValue: (NSString *)value {
    self.textField.text = @"";
    if (information[@"name"]) {
        self.textField.placeholder = information[@"name"];
    }
    
    if (value) {
        self.textField.text = value;
    }
}

- (void)change: (UITextField *)textF {
    self.backInformation(textF.text);
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
