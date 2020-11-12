//
//  QMMoreCardView.m
//  IMSDK-OC
//
//  Created by zcz on 2019/12/24.
//  Copyright © 2019 HCF. All rights reserved.
//

#import "QMMoreCardView.h"
#import "Masonry.h"
#import <QMLineSDK/QMLineSDK.h>
@interface QMMoreCardView () <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UITableView *moreTabView;
@property (nonatomic, strong) UIView *bgView;
@property (nonatomic, strong) NSArray *dataArr;
@end





@implementation QMMoreCardView

+ (instancetype)allocWithZone:(struct _NSZone *)zone {
    
    return [QMMoreCardView defualtView];
}

+ (instancetype)defualtView {
    
    static QMMoreCardView *_shareMoreCardView = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _shareMoreCardView = [[super allocWithZone:NULL] initWithFrame:UIScreen.mainScreen.bounds];
        _shareMoreCardView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.4];
        [_shareMoreCardView setSubViews];
    });

    return _shareMoreCardView;
}

- (void)setSubViews {
    CGRect frm = CGRectMake(0, kScreenAllHeight, self.frame.size.width, kScreenAllHeight - 220*kScale6);
    _bgView = [[UIView alloc] initWithFrame:frm];
    [self addSubview:_bgView];
    
    UIView *header = [[UIView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(_bgView.frame), 48)];
    header.backgroundColor = [UIColor colorWithRed:247/255.0 green:247/255.0 blue:247/255.0 alpha:1.0];
    [_bgView addSubview:header];
    UILabel *lab = [[UILabel alloc] initWithFrame:CGRectMake(17, 13, 200, 21)];
    lab.textColor = [UIColor colorWithRed:135/255.0 green:135/255.0 blue:135/255.0 alpha:1.0];
    lab.font = [UIFont fontWithName:PingFangSC_Reg size:15];
    lab.text = @"请选择您想要查询的订单";
    [header addSubview:lab];
    
    UIButton *closeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [closeBtn setImage:[UIImage imageNamed:@"close_btn"] forState:UIControlStateNormal];
    closeBtn.frame = CGRectMake(CGRectGetWidth(header.frame) - 14 -17, (header.frame.size.height - 14)/2.0, 14, 14);
    [closeBtn addTarget:self action:@selector(closeAction) forControlEvents:UIControlEventTouchUpInside];
    [header addSubview:closeBtn];
    
    frm.origin.y = header.frame.size.height;
    frm.size.height -= header.frame.size.height;
    self.moreTabView = [[UITableView alloc] initWithFrame:frm style:UITableViewStylePlain];
    self.moreTabView.tableFooterView = [UIView new];
    self.moreTabView.backgroundColor = [UIColor whiteColor];
    self.moreTabView.estimatedRowHeight = 100;
    self.moreTabView.rowHeight = UITableViewAutomaticDimension;
    self.moreTabView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.moreTabView.dataSource = self;
    self.moreTabView.delegate = self;
    self.moreTabView.contentInset = UIEdgeInsetsMake(0, 0, 8, 0);
    [_bgView addSubview:self.moreTabView];
 
    
}

- (void)setItemDict:(NSDictionary *)itemDict {
    _itemDict = itemDict;
    [self getData:itemDict];
}

- (void)getData:(NSDictionary *)dict {
    [QMConnect sdkGetCommonDataWithParams:dict completion:^(id data) {
        NSLog(@"data = %@",data);
        if ([data[@"Succeed"] boolValue] == 1) {
            NSString *json  = data[@"msgTask"];
            if (json && json.length > 0) {
                NSData *jsonData = [json dataUsingEncoding:NSUTF8StringEncoding];
                NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingAllowFragments error:nil];
                NSLog(@"dict = %@",dict);
                NSArray *arr = dict[@"data"][@"list"];
                if (arr.count > 0) {
                    self.dataArr = arr;
                    [self.moreTabView reloadData];
                }
            }
        }
    } failure:^(NSError *error) {
        
    }];
}

- (void)show {
    dispatch_async(dispatch_get_main_queue(), ^{
        [UIApplication.sharedApplication.keyWindow addSubview:self];
        CGRect frm = self.bgView.frame;
        frm.origin.y = 220*kScale6;
        [UIView animateWithDuration:0.25 animations:^{
            self.bgView.frame = frm;
        } completion:^(BOOL finished) {
            [self.moreTabView reloadData];
        }];
    });

}
- (void)closeAction {
    CGRect frm = self.bgView.frame;
    frm.origin.y = kScreenAllHeight;
    [UIView animateWithDuration:0.25 animations:^{
        self.bgView.frame = frm;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  
    NSDictionary *dict = self.dataArr[indexPath.row];
    QMCardInfoModel *model = [[QMCardInfoModel alloc] initWithDictionary:dict error:nil];
    if ([model.item_type isEqualToString:@"1"]) {
        
        QMMoreCardHeaderCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell_headerCell"];
        if (!cell) {
            cell = [[QMMoreCardHeaderCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell_headerCell"];
        }
        
        if (indexPath.row == 0 && indexPath.section == 0) {
            [cell.topLine mas_updateConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(cell.contentView);
            }];
 
        } else {
            [cell.topLine mas_updateConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(cell.contentView).offset(8);
            }];
        }
        
        [cell setCellData:model];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;

        return cell;
    } else {
        QMMoreCardCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell_id"];

        if (!cell) {
            cell = [[QMMoreCardCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell_id"];
        }
        [cell setCellData:model];
        return cell;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.selectItem) {
        NSDictionary *dict = self.dataArr[indexPath.row];
        self.selectItem(dict);
    }
    
    dispatch_after(DISPATCH_TIME_NOW+0.25, dispatch_get_main_queue(), ^{
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
        [self closeAction];
    });
}





/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end


@interface QMMoreCardHeaderCell ()

@property(nonatomic, strong) UIImageView *iconImage;
@property(nonatomic, strong) UILabel *titleLabel;
@property(nonatomic, strong) UILabel *statusLabel;
@property(nonatomic, strong) UIView *bottomLine;

@end

@implementation QMMoreCardHeaderCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        self.iconImage = [[UIImageView alloc] init];
        [self.contentView addSubview:self.iconImage];
        
        self.titleLabel = [[UILabel alloc] init];
        self.titleLabel.textColor = [UIColor blackColor];
        self.titleLabel.font = [UIFont fontWithName:PingFangSC_Reg size:16];
        [self.contentView addSubview:self.titleLabel];
        
        self.statusLabel = [[UILabel alloc] init];
        self.statusLabel.textColor = QMHEXRGB(0XFF6B6B);
        self.statusLabel.font =[UIFont fontWithName:PingFangSC_Reg size:14];
        self.statusLabel.textAlignment = NSTextAlignmentRight;
        [self.contentView addSubview:self.statusLabel];
        
        self.topLine = [[UIView alloc] init];
        self.topLine.backgroundColor = QMHEXRGB(0xEBEBEB);
        [self.contentView addSubview:self.topLine];
        
        self.bottomLine = [UIView new];
        self.bottomLine.backgroundColor = self.topLine.backgroundColor;
        [self.contentView addSubview:self.bottomLine];
        
        [self.topLine mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(self.contentView);
            make.height.mas_equalTo(1);
            make.top.equalTo(self.contentView).offset(8);
        }];
        
        [self.bottomLine mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.contentView);
            make.height.mas_equalTo(1);
            make.bottom.equalTo(self.contentView).offset(-8);
            make.left.equalTo(self.contentView).offset(16);
        }];
        
        [self.iconImage mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(16);
            make.top.equalTo(self.topLine.mas_bottom).offset(20);
            make.width.height.mas_equalTo(24);
            make.bottom.equalTo(self.bottomLine).offset(-12);
        }];
        
        [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentView).offset(48);
            make.top.equalTo(self.topLine.mas_bottom).offset(21);
            make.right.greaterThanOrEqualTo(self.contentView).offset(-100*kScale6);
            make.height.mas_equalTo(22);
        }];
        
        [self.statusLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.contentView).offset(-20);
            make.width.mas_equalTo(124*kScale6).priority(999);
            make.height.mas_equalTo(20);
            make.top.equalTo(self.topLine.mas_bottom).offset(20);
            make.left.equalTo(self.titleLabel.mas_right).offset(16);
        }];
        
        
    }
    return self;
}

- (void)setCellData:(QMCardInfoModel *)model {
    if (model.img.length > 0) {
        NSURL *url = [NSURL URLWithString:[model.img stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]]];
        [self.iconImage sd_setImageWithURL:url];
        self.iconImage.hidden = NO;
        [self.titleLabel mas_updateConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentView).offset(48);
        }];
    } else {
        self.iconImage.hidden = YES;
        [self.titleLabel mas_updateConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentView).offset(16);
        }];
    }
    
    self.titleLabel.text = model.title ? : @"";
    self.statusLabel.text = model.status ? : @"";
    
}


@end

@interface QMMoreCardCell ()

@property(nonatomic, strong) UIImageView *iconImage;
@property(nonatomic, strong) UILabel *titleLabel;
@property(nonatomic, strong) UILabel *priceLabel;
@property(nonatomic, strong) UILabel *descLabel1;
@property(nonatomic, strong) UILabel *descLabel2;
@property(nonatomic, strong) UILabel *countLabel;
@property(nonatomic, strong) UILabel *statusLabel;


@end



@implementation QMMoreCardCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
 
        [self setupSubViews];
    }
    
    return self;
}

- (void)setupSubViews {
    self.iconImage = [[UIImageView alloc] init];
    [self.contentView addSubview:self.iconImage];
    self.iconImage.backgroundColor = QMHEXSRGB(@"#EBEBEB");
    self.titleLabel = [[UILabel alloc] init];
    self.titleLabel.textColor = [UIColor blackColor];
    self.titleLabel.font = [UIFont fontWithName:PingFangSC_Reg size:15];
    [self.contentView addSubview:self.titleLabel];
    
    self.priceLabel = [[UILabel alloc] init];
    self.priceLabel.textColor = QMHEXRGB(0x262626);
    self.priceLabel.font = [UIFont fontWithName:PingFangSC_Reg size:15];
    self.priceLabel.adjustsFontSizeToFitWidth = YES;
    self.priceLabel.textAlignment = NSTextAlignmentRight;
    [self.contentView addSubview:self.priceLabel];
    
    self.descLabel1 = [UILabel new];
    self.descLabel1.textColor = QMHEXRGB(0x666666);
    self.descLabel1.font = [UIFont fontWithName:PingFangSC_Reg size:15];
    [self.contentView addSubview:self.descLabel1];
    
    self.descLabel2 = [UILabel new];
    self.descLabel2.textColor = QMHEXRGB(0x999999);
    self.descLabel2.font = [UIFont fontWithName:PingFangSC_Reg size:14];
    [self.contentView addSubview:self.descLabel2];
    
    
    self.countLabel = [UILabel new];
    self.countLabel.textColor = QMHEXRGB(0x666666);
    self.countLabel.font = [UIFont fontWithName:PingFangSC_Reg size:15];
    self.countLabel.textAlignment = NSTextAlignmentRight;
    [self.contentView addSubview:self.countLabel];
    
    self.statusLabel = [UILabel new];
    self.statusLabel.textColor = QMHEXRGB(0xFF6B6B);
    self.statusLabel.font = [UIFont fontWithName:PingFangSC_Reg size:14];
    self.statusLabel.textAlignment = NSTextAlignmentRight;
    [self.contentView addSubview:self.statusLabel];
    
    [self.iconImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(16);
        make.top.mas_equalTo(8);
        make.width.height.mas_equalTo(72);
        make.bottom.equalTo(self.contentView).offset(-8);
    }];
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(96);
        make.top.equalTo(self.contentView).offset(12);
        make.right.equalTo(self.contentView).offset(-84*kScale6);
        make.height.mas_equalTo(18);
    }];
    
    [self.priceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.contentView).offset(-16);
        make.top.equalTo(self.contentView).offset(12);
        make.width.mas_equalTo(60*kScale6);
        make.height.mas_equalTo(18);
    }];
    
    [self.descLabel1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.titleLabel);
        make.right.equalTo(self.contentView).offset(-72*kScale6);
        make.height.mas_equalTo(18);
        make.top.equalTo(self.contentView).offset(34);
    }];
    
    [self.countLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.contentView).offset(-16);
        make.top.equalTo(self.contentView).offset(34);
        make.width.mas_equalTo(40*kScale6);
        make.height.mas_equalTo(18);
    }];
    
    
    [self.descLabel2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.titleLabel);
        make.right.equalTo(self.contentView).offset(-89*kScale6);
        make.height.mas_equalTo(16);
        make.bottom.equalTo(self.contentView).offset(-12);
        
    }];
    
    [self.statusLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.contentView).offset(-16);
        make.width.mas_equalTo(64*kScale6);
        make.height.mas_equalTo(16);
        make.bottom.equalTo(self.contentView).offset(-12);
    }];
    
    
}

- (void)setCellData:(QMCardInfoModel *)model {
    if (model.img.length > 0) {
        NSURL *url = [NSURL URLWithString:[model.img stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]]];
        [self.iconImage sd_setImageWithURL:url];
        self.iconImage.hidden = NO;
        [self.titleLabel mas_updateConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentView).offset(96);
        }];
    } else {
        self.iconImage.hidden = YES;
        [self.titleLabel mas_updateConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentView).offset(16);
        }];
    }
    
    self.titleLabel.text = model.title ?: @"";
    self.descLabel1.text = model.sub_title ?: @"";
    self.descLabel2.text = model.other_title_one.length > 0 ? model.other_title_one : model.other_title_two.length > 0 ? model.other_title_two : model.other_title_three.length > 0 ? model.other_title_three : @"";
    self.countLabel.text = model.attr_one.content ?: @"";
    if (model.attr_one.color.length > 0) {
        self.countLabel.textColor = QMHEXSRGB(model.attr_one.color);
    } else {
        self.countLabel.textColor = QMHEXRGB(0x666666);
    }
    self.priceLabel.text = model.price ?: @"";
    self.statusLabel.text = model.attr_two.content ?: @"";
    if (model.attr_two.color.length > 0) {
        self.statusLabel.textColor = QMHEXSRGB(model.attr_two.color);
    } else {
        self.statusLabel.textColor = QMHEXRGB(0XFF6B6B);
    }
}


@end
