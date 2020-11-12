//
//  QMPickedOtherViewController.m
//  IMSDK-OC
//
//  Created by HCF on 16/8/10.
//  Copyright © 2016年 HCF. All rights reserved.
//

#import "QMPickedOtherViewController.h"

#import "QMFileManager.h"
#import "QMFileTabbarView.h"
#import "QMProfileManager.h"
#import "QMFileTableCell.h"
#import "QMFileModel.h"
#import "QMChatRoomViewController.h"

@interface QMPickedOtherViewController ()<UITableViewDelegate, UITableViewDataSource> {
    UITableView *_tableView;
    QMFileTabbarView *_tabbarView;
    
    NSArray *_otherArray;
    CGFloat _navHeight;
}

@property (nonatomic, strong) NSMutableSet *pickedOtherSet;

@end

@implementation QMPickedOtherViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    CGRect StatusRect = [[UIApplication sharedApplication] statusBarFrame];
    CGRect NavRect = self.navigationController.navigationBar.frame;
    _navHeight = StatusRect.size.height + NavRect.size.height;

    self.view.backgroundColor = [UIColor whiteColor];
    
    self.pickedOtherSet = [[NSMutableSet alloc] initWithCapacity:10];
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight-_navHeight-44) style:UITableViewStylePlain];
    _tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    _tableView.backgroundColor = [UIColor whiteColor];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [self.view addSubview:_tableView];
    
    _tabbarView = [[QMFileTabbarView alloc] init];
    _tabbarView.frame = CGRectMake(0, kScreenHeight-44-_navHeight, kScreenWidth, 44);
    [self.view addSubview:_tabbarView];
    
    [_tableView registerClass:[QMFileTableCell class] forCellReuseIdentifier:NSStringFromClass(QMFileTableCell.self)];
    
    __weak QMPickedOtherViewController *strongSelf = self;
    _tabbarView.selectAction = ^{
        QMChatRoomViewController * tagViewController = nil;
        for (UIViewController *viewController in strongSelf.navigationController.viewControllers) {
            if ([viewController isKindOfClass:[QMChatRoomViewController class]]) {
                tagViewController = (QMChatRoomViewController *)viewController;
                [strongSelf.navigationController popToViewController:tagViewController animated:true];
                for (QMFileModel *model in strongSelf.pickedOtherSet) {
                    [tagViewController sendFileMessageWithName:model.fileName AndSize:model.fileSize AndPath:model.filePath];
                }
            }
        }
    };
    
    [self getData];
}

- (void)dealloc {
    
}

- (void)getData {
    QMProfileManager * manager = [QMProfileManager sharedInstance];
    _otherArray = [manager getFilesAttributes:OTHER];
    [_tableView reloadData];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 80;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _otherArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    QMFileTableCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass(QMFileTableCell.self) forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    QMFileModel *model = _otherArray[indexPath.row];
    if ([cell isKindOfClass:[QMFileTableCell class]]) {
        QMFileTableCell *displayCell = (QMFileTableCell *)cell;
        [displayCell configureWithModel:model];
        
        displayCell.pickedItemImageView.hidden = ![self.pickedOtherSet containsObject:model];
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    QMFileModel *model = _otherArray[indexPath.row];
    if ([self.pickedOtherSet containsObject:model]) {
        [self.pickedOtherSet removeObject:model];
    }else {
        if ([self.pickedOtherSet count]>0) {
            
        }else {
            [self.pickedOtherSet addObject:model];
        }
    }
    
    QMFileTableCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    cell.pickedItemImageView.hidden = ![self.pickedOtherSet containsObject:model];
    
    if ([self.pickedOtherSet count]>0) {
        _tabbarView.doneButton.selected = YES;
    }else {
        _tabbarView.doneButton.selected = NO;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
