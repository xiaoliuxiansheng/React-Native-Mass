//
//  QMQuestionSubController.m
//  IMSDK-OC
//
//  Created by zcz on 2020/1/2.
//  Copyright © 2020 HCF. All rights reserved.
//

#import "QMQuestionSubController.h"
#import <QMLineSDK/QMLineSDK.h>
#import "QMActivityView.h"
#import "QMQuestionCell.h"
#import "QMAlert.h"
#import "MJRefresh.h"
@interface QMQuestionSubController ()<UITableViewDataSource>
@property (nonatomic, strong) UITableView *rootView;
@property (nonatomic, strong) NSMutableArray *dataArr;
@property (nonatomic, assign) NSInteger currentCount;

@end

@implementation QMQuestionSubController

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
    self.rootView.estimatedRowHeight = 200;
    self.rootView.rowHeight = UITableViewAutomaticDimension;
    self.rootView.dataSource = self;
    //        self.rootView.delegate = self;
    __weak typeof(self)wSelf = self;
    self.currentCount = 1;
    self.rootView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        [wSelf getSubCommonQuestion];
    }];

    self.rootView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:self.rootView];
    self.dataArr = [NSMutableArray array];
    [self getSubCommonQuestion];
}


- (void)getSubCommonQuestion {
    
    NSString *cid = self.groupModel._id;
    [QMActivityView startAnimating];
    
    NSDictionary *parameters = @{
                                 @"Action"       : @"sdkPullQAMsg",
                                 @"qaType"       : @"queryItemListInf",
                                 @"cid"           : cid,
                                 @"page"          : @(self.currentCount),
//                                 @"limit"         : @"30"
                                 @"limit"        : [NSNumber numberWithInt:30]
                                 };
    
    [QMConnect sdkGetCommonDataWithParams:parameters completion:^(NSDictionary *data) {
        
        if ([data[@"Succeed"] boolValue] == YES) {
            NSArray *dataArr = data[@"list"];
            if (dataArr.count > 0) {
                [self.dataArr addObjectsFromArray:dataArr];
                [self.rootView.mj_footer endRefreshing];
                self.currentCount++;
                [self.rootView reloadData];
            } else {
                
                [self.rootView.mj_footer endRefreshingWithNoMoreData];
            }
        }else {
            [self.rootView.mj_footer endRefreshing];
        }

        [QMActivityView stopAnimating];
    } failure:^(NSError *error) {
        [QMActivityView stopAnimating];
        [self.rootView.mj_footer endRefreshing];
    }];
    
//    [QMConnect sdkGetSubCommonQuestionWithcid:cid completion:^(NSArray *subArr) {
//        NSLog(@"subArr = %@",subArr);
//        if (subArr.count > 0) {
//            dispatch_async(dispatch_get_main_queue(), ^{
//                self.dataArr = subArr;
//                [self.rootView reloadData];
//            });
//        }
//        [QMActivityView stopAnimating];
//    } failure:^(NSString *error) {
//        [QMActivityView stopAnimating];
//    }];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
        QMQuestionCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell_id"];
        if (!cell) {
            cell = [[QMQuestionCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell_id"];
        }
        
        
        NSDictionary *dict = self.dataArr[indexPath.row];
        QMQuestionModel *model = [[QMQuestionModel alloc] initWithDictionary:dict error:nil];


        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        [cell setCellData:model.title];
        __weak typeof(self)wSelf = self;
        cell.cellSelect = ^{
            __strong typeof(wSelf)sSelf = wSelf;
            [sSelf senderMsg:model];
        };
        return cell;
}

- (void)senderMsg:(QMQuestionModel *)model {
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setValue:@"sdkPullQAMsg" forKey:@"Action"];
    [dict setValue:@"getKmDetailInf" forKey:@"qaType"];
    [dict setValue:@"text" forKey:@"contentType"];
    [dict setValue:model._id forKey:@"qaItemInfoId"];
    [dict setValue:model.title forKey:@"content"];

    [QMConnect sdkGetCommonDataWithParams:dict completion:^(NSDictionary *data) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if (self.backQuestion) {
                self.backQuestion(model);
            }
            NSInteger count = self.navigationController.viewControllers.count;
            if (count >= 3) {
                [self.navigationController popToViewController:self.navigationController.viewControllers[count - 3] animated:YES];
            } else {
                [self.navigationController popViewControllerAnimated:YES];
            }
        });
    } failure:^(NSError *error) {
        [QMAlert showMessage:NSLocalizedString(@"title.chat_question_fail", nil)];
    }];
}

@end
