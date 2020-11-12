//
//  QMQuestionController.m
//  IMSDK-OC
//
//  Created by zcz on 2019/12/31.
//  Copyright © 2019 HCF. All rights reserved.
//

#import "QMQuestionController.h"
#import <QMLineSDK/QMLineSDK.h>
#import "Masonry.h"
#import "QMQuestionCell.h"
#import "QMActivityView.h"
#import "QMAlert.h"
#import "QMQuestionSubController.h"
@interface QMQuestionController () <UITableViewDataSource, UITableViewDelegate>
@property (nonatomic, strong) UITableView *rootView;
@property (nonatomic, strong) NSArray *dataArr;
@property (nonatomic, strong) NSMutableDictionary *dataDict;

/// 当前选择的位置
@property (nonatomic, assign) NSUInteger selectSection;

@end

@implementation QMQuestionController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = NSLocalizedString(@"button.chat_question", nil);
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    CGRect frm = self.view.bounds;
    frm.size.height = kScreenHeight - kStatusBarAndNavHeight;
    self.rootView = [[UITableView alloc] initWithFrame:frm style:UITableViewStylePlain];
    self.rootView.tableFooterView = [UIView new];
//    self.rootView.sectionHeaderHeight = 56;
//    self.rootView.estimatedRowHeight = 200;
    self.rootView.rowHeight = 56;
    self.rootView.dataSource = self;
    self.rootView.delegate = self;
//    self.rootView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:self.rootView];
    [self getExampleQuestionData];
    self.selectSection = 3000;
    self.dataDict = [NSMutableDictionary dictionary];
    
}

//- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
//    return self.dataArr.count;
//}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
//    if (section == self.selectSection) {
//        NSDictionary *dict = self.dataArr[section];
//        NSString *cid = dict[@"_id"];
//        NSArray *arr = self.dataDict[cid];
//        return arr.count;
//    }
//    return 0;
    return self.dataArr.count;
}



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell_id"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell_id"];
    }
    
    
    NSDictionary *dict = self.dataArr[indexPath.row];
    QMQuestionModel *model = [[QMQuestionModel alloc] initWithDictionary:dict error:nil];

    cell.textLabel.text = model.name;
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
//    NSString *cid = dict[@"_id"];
//    NSArray *arr = self.dataDict[cid];
//    NSDictionary *subDict = arr[indexPath.row];
//    QMQuestionModel *model = [[QMQuestionModel alloc] initWithDictionary:subDict error:nil];
//    NSString *title = subDict[@"name"] ? : @"";
//    cell.selectionStyle = UITableViewCellSelectionStyleNone;
//    [cell setCellData:title];
//    __weak typeof(self)wSelf = self;
//    cell.cellSelect = ^{
//        __strong typeof(wSelf)sSelf = wSelf;
//        [sSelf senderMsg:model];
//    };
    return cell;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.15 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
    });
    NSDictionary *dict = self.dataArr[indexPath.row];
    QMQuestionModel *model = [[QMQuestionModel alloc] initWithDictionary:dict error:nil];

    QMQuestionSubController *vc = [QMQuestionSubController new];
    vc.backQuestion = self.backQuestion;
    vc.groupModel = model;
    [self.navigationController pushViewController:vc animated:YES];
}

/*
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UITableViewHeaderFooterView *footer = [tableView dequeueReusableHeaderFooterViewWithIdentifier:@"cell_header"];
    if (!footer) {
        footer = [[UITableViewHeaderFooterView alloc] initWithReuseIdentifier:@"cell_header"];
        footer.frame = CGRectMake(0, 0, CGRectGetWidth(tableView.frame), 56);
        UIControl *control = [[UIControl alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(tableView.frame), 56)];
        control.tag = 200;
        UIView *bgView = [UIView new];
        bgView.backgroundColor = [UIColor whiteColor];
        footer.backgroundView = bgView;
        footer.userInteractionEnabled = YES;
        [footer.contentView addSubview:control];
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [btn setImage:[UIImage imageNamed:@"iconfont_downFanhui"] forState:UIControlStateSelected];
        [btn setImage:[UIImage imageNamed:@"iconfont_leftFanhui"] forState:UIControlStateNormal];
        btn.tag = 120;
        [control addSubview:btn];
        [btn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(control).offset(16);
            make.top.equalTo(control).offset(20);
            make.width.height.mas_equalTo(16);
        }];
        
        UILabel *titleLab = [UILabel new];
        titleLab.tag = 121;
        titleLab.font = [UIFont fontWithName:PingFangSC_Reg size:17];
        titleLab.textColor = [UIColor blackColor];
        [control addSubview:titleLab];
        [titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(control).offset(40);
            make.top.equalTo(control).offset(17);
            make.height.mas_equalTo(24);
            make.width.mas_equalTo(283*kScale6);
        }];
        
        UIView *line = [UIView new];
        line.backgroundColor = QM_Color(237, 237, 237);
        [control addSubview:line];
        [line mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(control);
            make.height.mas_equalTo(1);
            make.bottom.equalTo(control);
        }];
        
        [control addTarget:self action:@selector(openMoreQuestion:) forControlEvents:UIControlEventTouchUpInside];

    }
    NSDictionary *dict = self.dataArr[section];
    NSString *title = dict[@"name"] ? : @"";
    UILabel *titleLab = [footer viewWithTag:121];
    titleLab.text = title;
    UIControl *control = (UIControl *)[footer.contentView viewWithTag:200];

    UIButton *btn = (UIButton *)[control viewWithTag:120];
    if (self.selectSection == section) {
        control.selected = YES;
    } else {
        control.selected = NO;
    }
    
    btn.selected = control.selected;
    footer.contentView.tag = section;
    return footer;
}
 */

- (void)openMoreQuestion:(UIControl *)sender {
    UIButton *btn = (UIButton *)[sender viewWithTag:120];
    sender.selected = !sender.selected;
    btn.selected = sender.selected;
    NSInteger curTag = sender.superview.tag;
    if (curTag != self.selectSection) {
        UITableViewHeaderFooterView *lastHeader = [self.rootView headerViewForSection:self.selectSection];
        if (lastHeader) {
            UIControl *lastControl = (UIControl *)[lastHeader.contentView viewWithTag:200];
            lastControl.selected = NO;
            UIButton *lastbtn = (UIButton *)[lastControl viewWithTag:120];
            lastbtn.selected = lastControl.selected;
        }
    }
    
    if (sender.selected == YES) {
        self.selectSection = curTag;
        
        NSDictionary *dict = self.dataArr[curTag];
        NSString *cid = dict[@"_id"];
        NSArray *subArr = self.dataDict[cid];
        NSIndexPath *index = [NSIndexPath indexPathForRow:0 inSection:curTag];
        
        if (subArr.count == 0) {
            [self getSubCommonQuestion:cid andIndexPath:index];
        } else {
            [self rootViewReloadDataAndScrollToIndexPath:index];
        }
    } else {
        self.selectSection = 3000;
        [self.rootView reloadData];
    }
    
}

- (void)rootViewReloadDataAndScrollToIndexPath:(NSIndexPath *)index {
    [self.rootView reloadData];
    [self.rootView scrollToRowAtIndexPath:index atScrollPosition:UITableViewScrollPositionTop animated:YES];
}


- (void)senderMsg:(QMQuestionModel *)model {
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setValue:@"sdkPullQAMsg" forKey:@"Action"];
    [dict setValue:@"getKmDetailInf" forKey:@"qaType"];
    [dict setValue:@"text" forKey:@"contentType"];
    [dict setValue:model._id forKey:@"qaItemInfoId"];
    [dict setValue:model.name forKey:@"content"];

    [QMConnect sdkGetCommonDataWithParams:dict completion:^(NSDictionary *data) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if (self.backQuestion) {
                self.backQuestion(model);
            }
            [self.navigationController popViewControllerAnimated:YES];
        });
    } failure:^(NSError *error) {
        [QMAlert showMessage:NSLocalizedString(@"title.chat_question_fail", nil)];
    }];
}


- (void)getExampleQuestionData {
    [QMConnect sdkGetCommonQuestion:^(NSArray *dataArr) {
        NSLog(@"dataArr = %@",dataArr);
        self.dataArr = [dataArr copy];
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.rootView reloadData];
        });
    } failure:^(NSString *error) {
        
    }];
}

- (void)getSubCommonQuestion:(NSString *)cid andIndexPath:(NSIndexPath *)index {
    
    [QMActivityView startAnimating];
    [QMConnect sdkGetSubCommonQuestionWithcid:cid completion:^(NSArray *subArr) {
        NSLog(@"subArr = %@",subArr);
        if (subArr.count > 0) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.dataDict setObject:subArr forKey:cid];
                [self.rootView reloadData];
                [self.rootView scrollToRowAtIndexPath:index atScrollPosition:UITableViewScrollPositionTop animated:YES];

            });
        }
        [QMActivityView stopAnimating];
    } failure:^(NSString *error) {
        [QMActivityView stopAnimating];
    }];
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
