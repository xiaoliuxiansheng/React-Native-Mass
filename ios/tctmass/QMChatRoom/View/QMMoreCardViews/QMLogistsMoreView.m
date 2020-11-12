//
//  QMLogistsMoreView.m
//  IMSDK-OC
//
//  Created by zcz on 2019/12/25.
//  Copyright © 2019 HCF. All rights reserved.
//

#import "QMLogistsMoreView.h"
#import "QMChatLogistcsInfoCell.h"
@interface QMLogistsMoreView () <UITableViewDataSource, UITableViewDelegate>
@property (nonatomic, strong) UITableView *moreTabView;
@property (nonatomic, strong) UIView *bgView;
@property (nonatomic, strong) QMLogistcsInfoModel *model;
@property (nonatomic, strong) UILabel *msgLab;
@end

@implementation QMLogistsMoreView


+ (instancetype)allocWithZone:(struct _NSZone *)zone {
    
    return [QMLogistsMoreView defualtView];
}

+ (instancetype)defualtView {
    
    static QMLogistsMoreView *_shareLogistsMoreView = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _shareLogistsMoreView = [[super allocWithZone:NULL] initWithFrame:UIScreen.mainScreen.bounds];
        _shareLogistsMoreView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.4];
        [_shareLogistsMoreView setSubViews];
    });

    return _shareLogistsMoreView;
}

- (void)setSubViews {
    CGRect frm = CGRectMake(0, kScreenAllHeight, self.frame.size.width, kScreenAllHeight - 220*kScale6);
    _bgView = [[UIView alloc] initWithFrame:frm];
    _bgView.backgroundColor = [UIColor whiteColor];
    [self addSubview:_bgView];
    
    UIView *header = [[UIView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(_bgView.frame), 48)];
    header.backgroundColor = [UIColor colorWithRed:247/255.0 green:247/255.0 blue:247/255.0 alpha:1.0];
    [_bgView addSubview:header];
    UILabel *lab = [[UILabel alloc] initWithFrame:CGRectMake(17, 13, 200, 21)];
    lab.textColor = [UIColor colorWithRed:135/255.0 green:135/255.0 blue:135/255.0 alpha:1.0];
    lab.font = [UIFont fontWithName:PingFangSC_Reg size:15];
    lab.text = @"物流信息";
    [header addSubview:lab];
    
    UIButton *closeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [closeBtn setImage:[UIImage imageNamed:@"close_btn"] forState:UIControlStateNormal];
    closeBtn.frame = CGRectMake(CGRectGetWidth(header.frame) - 14 -17, (header.frame.size.height - 14)/2.0, 14, 14);
    [closeBtn addTarget:self action:@selector(closeAction) forControlEvents:UIControlEventTouchUpInside];
    [header addSubview:closeBtn];
    
    UIView *line0 = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(header.frame), CGRectGetWidth(_bgView.frame), 1)];
    line0.backgroundColor = QMHEXRGB(0xEBEBEB);
    [_bgView addSubview:line0];
    
    self.msgLab = [[UILabel alloc] initWithFrame:CGRectMake(18, CGRectGetMaxY(header.frame) + 11, CGRectGetWidth(_bgView.frame) - 36, 20)];
    self.msgLab.textColor = [UIColor blackColor];
    self.msgLab.font = [UIFont fontWithName:PingFangSC_Reg size:14];
    self.msgLab.text = @"";
    [header addSubview:self.msgLab];
    
    UIView *line1 = [[UIView alloc] initWithFrame:CGRectMake(16, CGRectGetMaxY(self.msgLab.frame) + 10, CGRectGetWidth(_bgView.frame) - 16, 1)];
    line1.backgroundColor = QMHEXRGB(0xEBEBEB);
    [_bgView addSubview:line1];
    
    frm.origin.y = CGRectGetMaxY(line1.frame);
    frm.size.height -= CGRectGetMaxY(line1.frame);
    self.moreTabView = [[UITableView alloc] initWithFrame:frm style:UITableViewStylePlain];
    self.moreTabView.tableFooterView = [UIView new];
    self.moreTabView.backgroundColor = [UIColor whiteColor];
    self.moreTabView.estimatedRowHeight = 100;
    self.moreTabView.rowHeight = UITableViewAutomaticDimension;
    self.moreTabView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.moreTabView.dataSource = self;
    self.moreTabView.delegate = self;
    self.moreTabView.contentInset = UIEdgeInsetsMake(8, 0, 8, 0);
    [_bgView addSubview:self.moreTabView];
    
}



- (void)show:(QMLogistcsInfoModel *)model {
    
    self.model = model;
    self.msgLab.text = [NSString stringWithFormat:@"%@  %@",model.list_title, self.model.list_num?:@""];
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
    return self.model.list.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    //    QMCardInfoModel *model = self.dataArr[indexPath.row];
    
    
    QMLogistcsInfoSubCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell_id"];
    
    if (!cell) {
        cell = [[QMLogistcsInfoSubCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell_id"];
    }
    
    NSDictionary *dict = self.model.list[indexPath.row];
    QMLogistcsInfo *model = [[QMLogistcsInfo alloc] initWithDictionary:dict error:nil];
    
    [cell setCellData:model];
    if (indexPath.row == 0) {
        cell.verticalTopLine.hidden = YES;
        [cell setCireBlue];
    } else {
        cell.verticalTopLine.hidden = NO;
    }
    
    if (indexPath.row == self.model.list.count - 1) {
        cell.verticalBottomLine.hidden = YES;
        [cell setCireGreen];
    } else {
        cell.verticalBottomLine.hidden = NO;
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    dispatch_after(DISPATCH_TIME_NOW+0.25, dispatch_get_main_queue(), ^{
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
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
