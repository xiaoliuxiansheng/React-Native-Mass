//
//  QMChatRoomGuestBookViewController.m
//  IMSDK-OC
//
//  Created by HCF on 16/3/10.
//  Copyright © 2016年 HCF. All rights reserved.
//

#import "QMChatRoomGuestBookViewController.h"
#import <QMLineSDK/QMLineSDK.h>
#import "QMLeaveMessageCell.h"
#import "QMAlert.h"

/**
 留言板
 */
@interface QMChatRoomGuestBookViewController ()<UITextViewDelegate, UITableViewDelegate, UITableViewDataSource> {
    UITableView *_tableView;
    BOOL isSucceed;
}

@end

@implementation QMChatRoomGuestBookViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = NSLocalizedString(@"title.messageBoard", nil);
    self.view.backgroundColor = [UIColor colorWithRed:244/255.0 green:244/255.0 blue:246/255.0 alpha:1];
    [self.navigationController.navigationBar setTranslucent:NO];
    
    self.view.userInteractionEnabled = true;
    UITapGestureRecognizer * tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction)];
    [self.view addGestureRecognizer:tapGesture];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardFrameChange:) name:UIKeyboardWillChangeFrameNotification object:nil];
    
    if (!self.isScheduleLeave) {
        NSString *title = [QMConnect leaveMessageTitle];
        self.headerTitle = [title isEqualToString:@""] ? NSLocalizedString(@"title.messageHeader", nil) : title;
        self.leaveMsg = [QMConnect leaveMessagePlaceholder];
        self.contactFields = [QMConnect leaveMessageContactInformation];
    }
    if ([self.leaveMsg isEqualToString:@""]) {
        self.leaveMsg = NSLocalizedString(@"title.pleaseLeave", nil);
    }
    _condition = [NSMutableDictionary dictionary];
    
    [self createUI];

    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [backBtn setTitle:@"返回" forState:UIControlStateNormal];
    [backBtn setTitleColor:QM_Color(13, 139, 249) forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(backToRootVC) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *buttonItem = [[UIBarButtonItem alloc] initWithCustomView:backBtn];
    self.navigationItem.leftBarButtonItem = buttonItem;
}

- (void)backToRootVC {
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (void)createUI {
    CGFloat height = [self calcLabelHeight:self.headerTitle ?: NSLocalizedString(@"title.messageHeader", nil) font:[UIFont systemFontOfSize:17] width:kScreenWidth - 20];
    CGFloat labelHeight = height > 25 ? height : 25;
    
    self.headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 185+labelHeight)];
    self.headerView.backgroundColor = [UIColor colorWithRed:244/255.0 green:244/255.0 blue:246/255.0 alpha:1];
    
    self.henaderLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, kScreenWidth, labelHeight)];
    self.henaderLabel.text = self.headerTitle ?: NSLocalizedString(@"title.messageHeader", nil);
    self.henaderLabel.font = [UIFont systemFontOfSize:17];
    self.henaderLabel.textColor = [UIColor colorWithRed:102/255.0 green:102/255.0 blue:102/255.0 alpha:1];
    self.henaderLabel.numberOfLines = 0;
    [self.headerView addSubview:self.henaderLabel];
    
    self.textView = [[UITextView alloc] initWithFrame:CGRectMake(10, CGRectGetMaxY(self.henaderLabel.frame)+10, kScreenWidth-20, 165)];
    self.textView.font = [UIFont systemFontOfSize:16];
    self.textView.backgroundColor = [UIColor whiteColor];
    self.textView.layer.borderColor = [[UIColor colorWithRed:215/255.0 green:215/255.0 blue:215/255.0 alpha:1.0] CGColor];
    self.textView.layer.borderWidth = 0.6;
    self.textView.layer.masksToBounds = YES;
    self.textView.layer.cornerRadius = 2;
    self.textView.delegate = self;
    
    self.textLabel = [[UILabel alloc] initWithFrame:CGRectMake(5, 5, CGRectGetWidth(self.textView.frame),  [self calcLabelHeight:self.leaveMsg ?: NSLocalizedString(@"title.pleaseLeave", nil) font:[UIFont systemFontOfSize:15] width:CGRectGetWidth(self.textView.frame)])];
    self.textLabel.backgroundColor = [UIColor clearColor];
    self.textLabel.textColor = [UIColor lightGrayColor];
    self.textLabel.font = [UIFont systemFontOfSize:15];
    self.textLabel.numberOfLines = 0;
    self.textLabel.text = self.leaveMsg ?: NSLocalizedString(@"title.pleaseLeave", nil);
    [self.textView addSubview:self.textLabel];
    [self.headerView addSubview:self.textView];
    
    UIView *bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 100)];
    bottomView.backgroundColor = [UIColor colorWithRed:239/255.0 green:239/255.0 blue:244/255.0 alpha:1.0];
    
    self.submitBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    self.submitBtn.frame = CGRectMake(20, 30, kScreenWidth-40, 44);
    [self.submitBtn setTitle:NSLocalizedString(@"title.leaving", nil) forState:UIControlStateNormal];
    self.submitBtn.backgroundColor = [UIColor colorWithRed:13/255.0 green:139/255.0 blue:249/255.0 alpha:1];
    [self.submitBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.submitBtn.titleLabel.font = [UIFont systemFontOfSize:18];
    [self.submitBtn addTarget:self action:@selector(submitAction:) forControlEvents:UIControlEventTouchUpInside];
    [bottomView addSubview:self.submitBtn];

    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight-64) style:UITableViewStyleGrouped];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [self.view addSubview:_tableView];
    
    _tableView.tableHeaderView = self.headerView;
    _tableView.tableFooterView = bottomView;
}

- (void)tapAction {
    [self.textView resignFirstResponder];
}

- (void)textViewDidBeginEditing:(UITextView *)textView {
    self.textLabel.text = @"";
}

- (void)textViewDidEndEditing:(UITextView *)textView {
    if ([textView.text isEqualToString:@""]) {
        self.textLabel.text = self.leaveMsg ?: NSLocalizedString(@"title.pleaseLeave", nil);
    }
}

- (void)submitAction: (UIButton *)sender {
    if (isSucceed) {
        [QMAlert showMessage:NSLocalizedString(@"title.isBeginLeave", nil)];
    }
    isSucceed = YES;
    if (![[self.textView.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] isEqualToString:@""] && [self verifyRequired]) {
        [QMConnect sdkSubmitLeaveMessageWithInformation:self.peerId information:_condition leavemsgFields:self.contactFields message:self.textView.text successBlock:^{
            dispatch_async(dispatch_get_main_queue(), ^{
                [self showAlertViewControllerWithTitle:NSLocalizedString(@"title.messageSuccess", nil)];
                isSucceed = NO;
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [self.navigationController popToRootViewControllerAnimated:YES];
                });
            });
        } failBlock:^{
            dispatch_async(dispatch_get_main_queue(), ^{
                [self showAlertViewControllerWithTitle:NSLocalizedString(@"title.messageFailure", nil)];
                isSucceed = NO;
            });
        }];
    }else {
        [self showAlertViewControllerWithTitle:NSLocalizedString(@"title.messageContent", nil)];
    }
}

- (BOOL)verifyRequired {
    for (NSDictionary *field in self.contactFields) {
        BOOL required = [[field objectForKey:@"required"] boolValue];
        NSString *_id = [NSString stringWithFormat:@"%@", [field objectForKey:@"_id"]];
        if (required == YES) {
            BOOL tempRequired = YES;
            if (!_condition[_id]) {
                tempRequired = NO;
            }
            
            for (NSString *key in _condition.allKeys) {
                if ([key isEqualToString:_id]) {
                    if ([[_condition[key] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] isEqualToString:@""]) {
                        tempRequired = NO;
                    }
                }
            }
            
            if (!tempRequired) {
                NSString *alertTitle = [NSString stringWithFormat:@"%@%@", field[@"name"], NSLocalizedString(@"title.requireItem", nil)];
                [self showAlertViewControllerWithTitle:alertTitle];
                return NO;
            }
        }
    }
    return YES;
}

- (CGFloat)calcLabelHeight: (NSString *)text font: (UIFont *)font width: (CGFloat)width {
    NSDictionary *attribute = @{NSFontAttributeName: font};
    CGRect labelRect = [text boundingRectWithSize:CGSizeMake(width, CGRectGetHeight(self.textView.frame)) options:NSStringDrawingUsesLineFragmentOrigin attributes:attribute context:nil];
    return labelRect.size.height;
}

- (void)showAlertViewControllerWithTitle: (NSString *)title {
    [self.view endEditing:YES];
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"" message:title preferredStyle:UIAlertControllerStyleAlert];
    [self presentViewController:alertController animated:YES completion:nil];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [alertController dismissViewControllerAnimated:YES completion:nil];
    });
}

#pragma mark - UITableViewDelegate UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.contactFields.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 10;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    return [[UIView alloc] init];
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.1;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    return [[UIView alloc] init];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 44;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *identifier = @"leaveMsgCell";
    QMLeaveMessageCell * cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[QMLeaveMessageCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    [cell setData:self.contactFields[indexPath.section] defaultValue:self.condition[self.contactFields[indexPath.section][@"_id"]]];
    __weak QMChatRoomGuestBookViewController *strongSelf = self;
    cell.backInformation = ^(NSString *information) {
        if ([information isEqualToString:@""]) {
            [strongSelf.condition removeObjectForKey:strongSelf.contactFields[indexPath.section][@"_id"]];
        }else {
            [strongSelf.condition setValue:information forKey:strongSelf.contactFields[indexPath.section][@"_id"]];
        }
    };
    return cell;
}

#pragma mark - Push Notification
// 键盘通知
- (void)keyboardFrameChange: (NSNotification *)notification {
    NSDictionary * userInfo =  notification.userInfo;
    NSValue * value = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGRect newFrame = [value CGRectValue];
    if (newFrame.origin.y == [UIScreen mainScreen].bounds.size.height) {
        [UIView animateWithDuration:0.3 animations:^{
            _tableView.frame = CGRectMake(0, 0, kScreenWidth, kScreenHeight-64);
        }];
    }else {
        [UIView animateWithDuration:0.3 animations:^{
            _tableView.frame = CGRectMake(0, 0, kScreenWidth, [UIScreen mainScreen].bounds.size.height-64-newFrame.size.height);
        }];
    }
}

- (void)dealloc {
    NSLog(@"留言板dealloc");
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
@end
