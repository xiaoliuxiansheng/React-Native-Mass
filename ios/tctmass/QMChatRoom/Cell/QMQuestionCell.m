//
//  QMQuestionCell.m
//  IMSDK-OC
//
//  Created by zcz on 2020/1/2.
//  Copyright © 2020 HCF. All rights reserved.
//

#import "QMQuestionCell.h"
#import "Masonry.h"
#import "MJRefresh.h"
@interface QMQuestionCell ()
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIButton *senderBtn;
@end

@implementation QMQuestionCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
    
        [self setupSubviews];
    }
    
    return self;
}

- (void)setupSubviews {
    self.titleLabel = [UILabel new];
    self.titleLabel.font = [UIFont fontWithName:PingFangSC_Reg size:16];
    self.titleLabel.numberOfLines = 0;
    self.titleLabel.textColor = [UIColor blackColor];
    [self.contentView addSubview:self.titleLabel];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(20);
        make.right.equalTo(self.contentView).offset(-52);
        make.top.equalTo(self.contentView).offset(20);
        make.bottom.equalTo(self.contentView.mas_bottom).offset(-20);
    }];
    
    self.senderBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.senderBtn setImage:[UIImage imageNamed:@"senderBtn"] forState:UIControlStateNormal];
    [self.senderBtn addTarget:self action:@selector(selectedAction) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:self.senderBtn];
    [self.senderBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.contentView).offset(-16);
        make.width.height.mas_equalTo(20);
        make.centerY.equalTo(self.contentView);
    }];
    
    UIView *line = [UIView new];
    line.backgroundColor = QM_Color(237, 237, 237);
    [self.contentView addSubview:line];
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(20);
        make.right.equalTo(self.contentView);
        make.height.mas_equalTo(1);
        make.bottom.equalTo(self.contentView);
    }];
    
}

- (void)setCellData:(NSString *)title {
    self.titleLabel.text = title ? title : @"";
}

- (void)selectedAction {
    if (self.cellSelect) {
        self.cellSelect();
    }
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
