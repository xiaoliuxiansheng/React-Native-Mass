//
//  QMLogistcsInfoCell.m
//  IMSDK-OC
//
//  Created by zcz on 2019/12/25.
//  Copyright © 2019 HCF. All rights reserved.
//

#import "QMChatLogistcsInfoCell.h"
#import "Masonry.h"
#import "QMRegexHandle.h"
@interface QMChatLogistcsInfoCell () <UITableViewDataSource, UITableViewDelegate>

@property(nonatomic, strong) UILabel *titleLabel;
@property(nonatomic, strong) UILabel *msgLabel;
@property(nonatomic, strong) UITableView *rootTableView;

@end

@implementation QMChatLogistcsInfoCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setupSubviews];
    }
    return self;
}

- (void)setupSubviews {
    self.titleLabel = [[UILabel alloc] init];
    self.titleLabel.font = [UIFont fontWithName:PingFangSC_Reg size:15];
    self.titleLabel.textColor = [UIColor blackColor];
    [self.chatBackgroudImage addSubview:self.titleLabel];
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.chatBackgroudImage).offset(20);
        make.top.equalTo(self.chatBackgroudImage).offset(12);
        make.right.equalTo(self.chatBackgroudImage).offset(-14);
        make.height.mas_equalTo(21);
    }];
    
    UIView *line0 = [UIView new];
    line0.backgroundColor = QMHEXRGB(0xEBEBEB);
    [self.chatBackgroudImage addSubview:line0];
    [line0 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.chatBackgroudImage);
        make.height.mas_equalTo(1);
        make.top.equalTo(self.chatBackgroudImage).offset(45);
    }];
    
    self.msgLabel = [[UILabel alloc] init];
    self.msgLabel.font = [UIFont fontWithName:PingFangSC_Reg size:14];
    self.msgLabel.textColor = [UIColor blackColor];
    self.msgLabel.adjustsFontSizeToFitWidth = YES;
    [self.chatBackgroudImage addSubview:self.msgLabel];
    [self.msgLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.titleLabel);
        make.height.mas_equalTo(20);
        make.top.equalTo(line0.mas_bottom).offset(10);
    }];
    
    UIView *line1 = [UIView new];
    line1.backgroundColor = QMHEXRGB(0xEBEBEB);
    [self.chatBackgroudImage addSubview:line1];
    [line1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.chatBackgroudImage);
        make.left.equalTo(self.msgLabel);
        make.height.mas_equalTo(1);
        make.top.equalTo(self.msgLabel.mas_bottom).offset(10);
    }];
    
    self.rootTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.chatBackgroudImage.frame), 50) style:UITableViewStylePlain];
    self.rootTableView.showsVerticalScrollIndicator = NO;
    self.rootTableView.contentInset = UIEdgeInsetsMake(9, 0, 0, 0);
    self.rootTableView.scrollEnabled = NO;
    self.rootTableView.estimatedRowHeight = 200;
    self.rootTableView.rowHeight = UITableViewAutomaticDimension;
    self.rootTableView.tableFooterView = [UIView new];
    self.rootTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.rootTableView.sectionFooterHeight = 41;
    self.rootTableView.dataSource = self;
    self.rootTableView.delegate = self;
    self.rootTableView.backgroundColor = [UIColor clearColor];
    [self.chatBackgroudImage addSubview:self.rootTableView];
    [self.rootTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.chatBackgroudImage).offset(6);
        
        make.right.bottom.equalTo(self.chatBackgroudImage);
        make.top.equalTo(line1);
//        make.height.mas_equalTo(233);
    }];
    
    [self.chatBackgroudImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.lessThanOrEqualTo(self.contentView).offset(52).priorityMedium();
        make.width.mas_equalTo(300*kScale6).priorityHigh();
        make.bottom.equalTo(self.contentView);
        make.height.mas_equalTo(320);
        make.top.equalTo(self.iconImage);
    }];

    
}

- (void)setData:(CustomMessage *)message avater:(NSString *)avater {
    [super setData:message avater:avater];
    
    if ([message.fromType isEqualToString:@"0"]) {
        //发送者
        self.chatBackgroudImage.image = [UIImage imageNamed:@"SenderCardNodeBkg"];
        [self.chatBackgroudImage mas_updateConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.contentView.mas_right).offset(-62).priorityHigh();
        }];
    } else {
        //接收方
        self.chatBackgroudImage.image = [UIImage imageNamed:@"ReceiverTextNodeBkg"];
        [self.chatBackgroudImage mas_updateConstraints:^(MASConstraintMaker *make) {
            make.right.lessThanOrEqualTo(self.contentView.mas_right).offset(-23);
            make.left.equalTo(self.contentView).offset(52).priorityHigh();
        }];
    }
    
    self.chatBackgroudImage.image = [self.chatBackgroudImage.image stretchableImageWithLeftCapWidth:20 topCapHeight:20];
        
    
    if (self.dataModel.list.count == 0 && self.dataModel.list_title.length == 0) {
        
        self.titleLabel.text = self.dataModel.empty_message;
        self.msgLabel.hidden = YES;
        CGFloat width = [self.titleLabel.text boundingRectWithSize:CGSizeMake(300*kScale6 - 34, 100) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName: self.titleLabel.font} context:nil].size.width;
        [self.chatBackgroudImage mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(41);
            make.width.mas_equalTo(width + 34).priorityHigh();
        }];
        self.rootTableView.hidden = YES;

    } else {
        self.msgLabel.hidden = NO;
        self.rootTableView.hidden = NO;

        CGFloat addHeight = 41;
        int i = 0;
        for (NSDictionary *dict in self.dataModel.list) {
            
            NSString *title = dict[@"title"] ?: @"";
            CGFloat f = [QMLogistcsInfoSubCell getCellHeight:title];
            addHeight += f;
            i ++;
            if (i == 3) {
                break;
            }
            
        }
        
        [self.chatBackgroudImage mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(addHeight + 87);
            make.width.mas_equalTo(300*kScale6).priorityHigh();
        }];
        
        self.titleLabel.text = self.dataModel.message;
        self.msgLabel.text = [NSString stringWithFormat:@"%@  运单号：%@",self.dataModel.list_title ?: @"", self.dataModel.list_num ?: @""];
        self.msgLabel.hidden = NO;
           self.rootTableView.hidden = NO;
    }
    
    
    
}

+ (CGFloat)getCellHeigt:(QMLogistcsInfoModel *)model {

    CGFloat addHeight = 87 + 41 + 9/*tableviewContentInset*/;
    int i = 0;
    for (NSDictionary *dict in model.list) {
        NSString *title = dict[@"title"] ?: @"";
        CGFloat f = [QMLogistcsInfoSubCell getCellHeight:title];
        addHeight += f;
        i++;
        if (i == 3) {
            break;
        }
    }
    
    if (i == 0 && model.list_title.length == 0) {
        addHeight = 40;
    }
    
    
    return addHeight;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataModel.list.count > 3 ? 3 : self.dataModel.list.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    QMLogistcsInfoSubCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell_id"];
    if (!cell) {
        cell = [[QMLogistcsInfoSubCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell_id"];
    }
    
    NSDictionary *dict = self.dataModel.list[indexPath.row];
    QMLogistcsInfo *model = [[QMLogistcsInfo alloc] initWithDictionary:dict error:nil];
    
    [cell setCellData:model];
    
    if (indexPath.row == 0 && indexPath.section == 0) {
        cell.verticalTopLine.hidden = YES;
        [cell setCireBlue];
    } else {
        cell.verticalTopLine.hidden = NO;
    }
    if (indexPath.row == self.dataModel.list.count - 1) {
        [cell setCireGreen];
        cell.verticalBottomLine.hidden = YES;
    } else {
        cell.verticalBottomLine.hidden = NO;
    }
    
    return cell;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    UITableViewHeaderFooterView *footer = [tableView dequeueReusableHeaderFooterViewWithIdentifier:@"footer"];
    if (footer == nil) {
        footer = [[UITableViewHeaderFooterView alloc] initWithReuseIdentifier:@"footer"];
        footer.frame = CGRectMake(0, 0, tableView.frame.size.width, 41);
        
        UIControl *backView = [UIControl new];
        backView.backgroundColor = [UIColor clearColor];
        footer.backgroundView = backView;
        
        if (self.dataModel.list.count == 0) {
            UILabel *noMsgLab = [UILabel new];
            noMsgLab.text = @"暂无物流信息";
            noMsgLab.textColor = [UIColor blackColor];
            noMsgLab.font = [UIFont fontWithName:PingFangSC_Reg size:14];
            [footer addSubview:noMsgLab];
            [noMsgLab mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerX.centerY.equalTo(footer);
            }];
        } else {
            
            UIView *line = [UIView new];
            line.backgroundColor = QMHEXRGB(0xEBEBEB);
            [footer addSubview:line];
            [line mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.right.top.equalTo(footer);
                make.height.mas_equalTo(1);
            }];
            
            UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
            btn.backgroundColor = [UIColor clearColor];
            btn.frame = CGRectMake(0, 1, footer.frame.size.width, footer.frame.size.height - 1);
            [footer addSubview:btn];
            [btn setImage:[UIImage imageNamed:@"set_cell_arrow"] forState:UIControlStateNormal];
            [btn addTarget:self action:@selector(tapAction:) forControlEvents:UIControlEventTouchUpInside];
            
            btn.imageEdgeInsets = UIEdgeInsetsMake(0, btn.frame.size.width - 32, 0, 18);
            UILabel *titleLab = [UILabel new];
            titleLab.text = @"查看完整物流信息";
            titleLab.textColor = QMHEXRGB(0x2684FF);
            titleLab.font = [UIFont fontWithName:PingFangSC_Reg size:14];
            [btn addSubview:titleLab];
            [titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(btn).offset(14);
                make.centerY.equalTo(btn);
                make.right.equalTo(btn).offset(130);
            }];
            
        }
        
    }
    
    return footer;
    
}

- (void)tapAction:(UIControl *)tap {
    NSLog(@"tappppppp");
    if (self.showMore) {
        self.showMore();
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 41;
}


@end














@interface QMLogistcsInfoSubCell ()
@property(nonatomic, strong) UIView *circularLine;
@property(nonatomic, strong) UILabel *titleLabel;
@property(nonatomic, strong) UILabel *timeLabel;
@end

@implementation QMLogistcsInfoSubCell

+ (CGFloat)getCellHeight:(NSString *)title {
    CGFloat height = 7.0 + 4 + 20 + 9;
    CGFloat h = [title boundingRectWithSize:CGSizeMake(255*kScale6, 300) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName: [UIFont fontWithName:PingFangSC_Reg size:14]} context:nil].size.height;
    height += h;
    return height;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setupSubviews];
    }
    
    return self;
}

- (void)setupSubviews {
    self.verticalTopLine = [UIView new];
    self.verticalTopLine.backgroundColor = QMHEXRGB(0xEBEBEB);
    [self.contentView addSubview:self.verticalTopLine];
    
    self.verticalBottomLine = [UIView new];
    self.verticalBottomLine.backgroundColor = self.verticalTopLine.backgroundColor;
    [self.contentView addSubview:self.verticalBottomLine];
    
    self.circularLine = [UIView new];
    self.circularLine.backgroundColor = self.verticalTopLine.backgroundColor;
    self.circularLine.layer.cornerRadius = 4;
    [self.contentView addSubview:self.circularLine];
    
    self.titleLabel = [UILabel new];
    self.titleLabel.font = [UIFont fontWithName:PingFangSC_Reg size:14];
    self.titleLabel.textColor = QMHEXRGB(0x333333);
    self.titleLabel.numberOfLines = 0;
    [self.contentView addSubview:self.titleLabel];
    
    self.timeLabel = [UILabel new];
    self.timeLabel.font = [UIFont fontWithName:PingFangSC_Reg size:14];
    self.timeLabel.textColor = QMHEXRGB(0x999999);
    [self.contentView addSubview:self.timeLabel];
    
    [self.verticalTopLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(16);
        make.top.equalTo(self.contentView);
        make.width.mas_equalTo(1);
        make.bottom.equalTo(self.titleLabel.mas_centerY);
    }];
    
    [self.verticalBottomLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(16);
        make.top.equalTo(self.titleLabel.mas_centerY);
        make.width.mas_equalTo(1);
        make.bottom.equalTo(self.contentView);
    }];
    
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(28);
        make.top.equalTo(self.contentView).offset(7);
        make.width.mas_equalTo(255.0*kScale6);
    }];
    
    [self.circularLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.verticalBottomLine);
        make.centerY.equalTo(self.titleLabel.mas_centerY);
        make.width.height.mas_equalTo(8);
    }];
    
    [self.timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.titleLabel);
        make.top.equalTo(self.titleLabel.mas_bottom).offset(4);
        make.bottom.equalTo(self.contentView).offset(-9);
    }];
    
    
}

- (void)setCellData:(QMLogistcsInfo *)model {
    NSString *title = model.title;
    self.circularLine.backgroundColor = QMHEXRGB(0xEBEBEB);
    NSArray *arr = [QMRegexHandle getMobileNumberLoc:title];
    NSMutableAttributedString *attr = [[NSMutableAttributedString alloc] initWithString:title];
    for (NSTextCheckingResult *result in arr) {
        NSRange rag = result.range;
        if (rag.location != NSNotFound) {
            [attr addAttributes:@{NSForegroundColorAttributeName: QMHEXRGB(0xFF6B6B)} range:rag];
        }
    }
    
    self.titleLabel.attributedText = attr;
    
    self.timeLabel.text = model.desc;

}

- (void)setCireBlue {
    self.circularLine.backgroundColor = QMHEXRGB(0x2684FF);
}

- (void)setCireGreen {
    self.circularLine.backgroundColor = QMHEXRGB(0x00C922);
}



@end
