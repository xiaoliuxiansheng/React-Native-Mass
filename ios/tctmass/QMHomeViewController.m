//
//  QMHomeViewController.m
//  IMSDK-OC
//
//  Created by haochongfeng on 2017/8/7.
//  Copyright © 2017年 HCF. All rights reserved.
//

#import "QMHomeViewController.h"
#import "QMChatRoomViewController.h"
#import <QMLineSDK/QMLineSDK.h>

#import "QMChatRoomGuestBookViewController.h"
#import "QMAlert.h"
#import "QMManager.h"
#import "QMWeiXinDateManager.h"

@interface QMHomeViewController () <QMKRegisterDelegate>

@property (nonatomic, strong) UIImageView *imageView;

@property (nonatomic, strong) UILabel *headLabel;

@property (nonatomic, strong) UILabel *detailLabel;

@property (nonatomic, strong) UIButton *button;

@property (nonatomic, strong) UIActivityIndicatorView *indicatorView;

@property (nonatomic, assign) BOOL isPushed;

@property (nonatomic, assign) BOOL isConnecting;

@property (nonatomic, copy) NSDictionary * dictionary;

@end

@implementation QMHomeViewController

- (instancetype)init {
    self = [super init];
    if (self) {
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(registerSuccess:) name:CUSTOM_LOGIN_SUCCEED object:nil];
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(registerFailure:) name:CUSTOM_LOGIN_ERROR_USER object:nil];
    }
    return self;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:CUSTOM_LOGIN_SUCCEED object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:CUSTOM_LOGIN_ERROR_USER object:nil];
}

- (void)registerSuccess {
    NSLog(@"代理成功");
}

- (void)registerSuccess:(NSNotification *)sender {
    NSLog(@"注册成功");

    if ([QMManager defaultManager].selectedPush) {
        [self showChatRoomViewController:@"" processType:@"" entranceId:@""]; //
    }else{

       //  页面跳转控制
        if (self.isPushed) {
            return;
        }

        [QMConnect sdkGetWebchatScheduleConfig:^(NSDictionary * _Nonnull scheduleDic) {
            dispatch_async(dispatch_get_main_queue(), ^{
                self.dictionary = scheduleDic;
                if ([self.dictionary[@"scheduleEnable"] intValue] == 1) {
                    NSLog(@"日程管理");
                    [self starSchedule];
                }else{
                    NSLog(@"技能组");
                    [self getPeers];
                }
            });
        } failBlock:^{
            [self getPeers];
        }];
    }

    [QMManager defaultManager].selectedPush = NO;

}

- (void)registerFailure:(NSNotification *)sender {
    NSLog(@"注册失败::%@", sender.object);
    QMLineError *err = sender.object;
    if (err.errorDesc.length > 0) {
        [QMAlert showMessageAtCenter:err.errorDesc];
    }
    self.isConnecting = NO;
    [self.indicatorView stopAnimating];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.isConnecting = NO;
    self.isPushed = NO;
    [self layoutView];

}

- (void)viewWillAppear:(BOOL)animated {
    self.navigationController.navigationBarHidden = YES;
    self.isPushed = NO;
}

- (void)viewWillDisappear:(BOOL)animated {
    self.navigationController.navigationBarHidden = NO;
    self.isPushed = YES;
}

- (void)layoutView {
  // 注销
      self.logoutButton = [UIButton buttonWithType:UIButtonTypeSystem];
      self.logoutButton.frame = CGRectMake(0, 0, 50, 30);
      self.logoutButton.titleLabel.font = [UIFont systemFontOfSize:16];
      [self.logoutButton setTitle:NSLocalizedString(@"button.logout", nil) forState:UIControlStateNormal];
      [self.logoutButton setTitleColor:[UIColor colorWithRed:13/255.0 green:139/255.0 blue:249/255.0 alpha:1] forState:UIControlStateNormal];
      [self.logoutButton addTarget:self action:@selector(logoutAction) forControlEvents:UIControlEventTouchUpInside];
      self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:self.logoutButton];

    self.imageView = [[UIImageView alloc] init];
    self.imageView.frame = CGRectMake(([UIScreen mainScreen].bounds.size.width - 236 * kIphone6sScaleWidth)/2, 55 * kIphone6sScaleWidth, 236 * kIphone6sScaleWidth, 250 * kIphone6sScaleWidth);
    self.imageView.image = [UIImage imageNamed:@"logo"];
    [self.view addSubview:self.imageView];

    self.headLabel = [[UILabel alloc] init];
    self.headLabel.frame = CGRectMake(0, CGRectGetMaxY(self.imageView.frame) + 35 * kIphone6sScaleWidth, [UIScreen mainScreen].bounds.size.width, 25 * kIphone6sScaleWidth);
    self.headLabel.textAlignment = NSTextAlignmentCenter;
    self.headLabel.text = NSLocalizedString(@"title.good_7moor", nil);
    self.headLabel.textColor = [UIColor blackColor];
    self.headLabel.font = [UIFont systemFontOfSize:25 * kIphone6sScaleWidth];
    [self.view addSubview:self.headLabel];

    self.detailLabel = [[UILabel alloc] init];
    self.detailLabel.frame = CGRectMake(0, CGRectGetMaxY(self.headLabel.frame) + 15 * kIphone6sScaleWidth, [UIScreen mainScreen].bounds.size.width, 65 * kIphone6sScaleWidth);
    self.detailLabel.textAlignment = NSTextAlignmentCenter;
    self.detailLabel.attributedText = [self setSpace:4 kern:[NSNumber numberWithInt:1] font:[UIFont systemFontOfSize:15 * kIphone6sScaleWidth] text:NSLocalizedString(@"title.introduction", nil)];
    self.detailLabel.textColor = [UIColor grayColor];
    self.detailLabel.numberOfLines = 0;
    self.detailLabel.font = [UIFont systemFontOfSize:15 * kIphone6sScaleWidth];
    [self.view addSubview:self.detailLabel];

    self.button = [UIButton buttonWithType:UIButtonTypeCustom];
    self.button.frame = CGRectMake(([UIScreen mainScreen].bounds.size.width - 150 * kIphone6sScaleWidth)/2, [UIScreen mainScreen].bounds.size.height - 105 * kIphone6sScaleWidth, 150 * kIphone6sScaleWidth, 40 * kIphone6sScaleWidth);
    [self.button setBackgroundImage:[UIImage imageNamed:@"button"] forState:UIControlStateNormal];
    [self.button setTitle:NSLocalizedString(@"title.contact_im", nil) forState:UIControlStateNormal];
    [self.button setTitleColor:[UIColor colorWithRed:0/255.0 green:183/255.0 blue:255/255.0 alpha:1] forState:UIControlStateNormal];
    [self.button addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.button];

    // 建议使用网络指示器
    self.indicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    self.indicatorView.layer.cornerRadius = 5;
    self.indicatorView.layer.masksToBounds = YES;
    self.indicatorView.frame = CGRectMake((kScreenWidth-100)/2, (kScreenHeight-100)/2-64, 100, 100);
    self.indicatorView.backgroundColor = [UIColor blackColor];
    self.indicatorView.color = [UIColor whiteColor];
    self.indicatorView.alpha = 0.7;
    [self.view addSubview:self.indicatorView];

}

// 注销事件
- (void)logoutAction {
        NSLog(@"不应该显示满意度评价弹框");
        [self popVC];
}
- (void)popVC {
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)buttonAction:(UIButton *)sender {
    [self.indicatorView startAnimating];

    // 按钮连点控制
    if (self.isConnecting) {
        return;
    }
    self.isConnecting = YES;

    /**
     accessId:  接入客服系统的密钥， 登录web客服系统（渠道设置->移动APP客服里获取）
     userName:  用户名， 区分用户， 用户名可直接在后台会话列表显示
     userId:    用户ID， 区分用户（只能使用  数字 字母(包括大小写) 下划线 短横线）
     以上3个都是必填项
     */

    [QMConnect registerSDKWithAppKey:@"7a6926e0-181a-11eb-b15d-054468910f6c" userName:@"IOS用户" userId:@"1234"];
}

#pragma mark - 技能组选择
- (void)getPeers {
    [QMConnect sdkGetPeers:^(NSArray * _Nonnull peerArray) {
        dispatch_async(dispatch_get_main_queue(), ^{
            NSArray *peers = peerArray;
            self.isConnecting = NO;
            [_indicatorView stopAnimating];
            if (peers.count == 1 && peers.count != 0) {
                [self showChatRoomViewController:[peers.firstObject objectForKey:@"id"] processType:@"" entranceId:@""];
            }else {
                [self showPeersWithAlert:peers messageStr:NSLocalizedString(@"title.type", nil)];
            }
        });
    } failureBlock:^{
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.indicatorView stopAnimating];
            self.isConnecting = NO;
        });
    }];
}

#pragma mark - 日程管理
- (void)starSchedule {
    self.isConnecting = NO;
    [_indicatorView stopAnimating];
    if ([self.dictionary[@"scheduleId"] isEqual: @""] || [self.dictionary[@"processId"] isEqual: @""] || [self.dictionary objectForKey:@"entranceNode"] == nil || [self.dictionary objectForKey:@"leavemsgNodes"] == nil) {
        [QMAlert showMessage:NSLocalizedString(@"title.sorryconfigurationiswrong", nil)];
    }else{
        NSDictionary *entranceNode = self.dictionary[@"entranceNode"];
        NSArray *entrances = entranceNode[@"entrances"];
        if (entrances.count == 1 && entrances.count != 0) {
            [self showChatRoomViewController:[entrances.firstObject objectForKey:@"processTo"] processType:[entrances.firstObject objectForKey:@"processType"] entranceId:[entrances.firstObject objectForKey:@"_id"]];
        }else{
            [self showPeersWithAlert:entrances messageStr:NSLocalizedString(@"title.schedule_type", nil)];
        }
    }
}

- (void)showPeersWithAlert: (NSArray *)peers messageStr: (NSString *)message {


    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:NSLocalizedString(@"title.type", nil) preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"button.cancel", nil) style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        self.isConnecting = NO;
    }];
    [alertController addAction:cancelAction];
    for (NSDictionary *index in peers) {
        UIAlertAction *surelAction = [UIAlertAction actionWithTitle:[index objectForKey:@"name"] style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            if ([self.dictionary[@"scheduleEnable"] integerValue] == 1) {
                [self showChatRoomViewController:[index objectForKey:@"processTo"] processType:[index objectForKey:@"processType"] entranceId:[index objectForKey:@"_id"]];
            }else{
                [self showChatRoomViewController:[index objectForKey:@"id"] processType:@"" entranceId:@""];
            }
        }];
        [alertController addAction:surelAction];
    }
    [self presentViewController:alertController animated:YES completion:nil];
}

#pragma mark - 跳转聊天界面
- (void)showChatRoomViewController:(NSString *)peerId processType:(NSString *)processType entranceId:(NSString *)entranceId {
    QMChatRoomViewController *chatRoomViewController = [[QMChatRoomViewController alloc] init];
    chatRoomViewController.peerId = peerId;
    chatRoomViewController.isPush = NO;
    chatRoomViewController.avaterStr = @"";
    if ([self.dictionary[@"scheduleEnable"] intValue] == 1) {
        chatRoomViewController.isOpenSchedule = true;
        chatRoomViewController.scheduleId = self.dictionary[@"scheduleId"];
        chatRoomViewController.processId = self.dictionary[@"processId"];
        chatRoomViewController.currentNodeId = peerId;
        chatRoomViewController.processType = processType;
        chatRoomViewController.entranceId = entranceId;
    }else{
        chatRoomViewController.isOpenSchedule = false;
    }
    [self.navigationController pushViewController:chatRoomViewController animated:YES];
}

- (NSMutableAttributedString *)setSpace:(CGFloat)line kern:(NSNumber *)kern font:(UIFont *)font text:(NSString *)text {
    NSMutableParagraphStyle * paraStyle = [NSMutableParagraphStyle new];
    paraStyle.lineBreakMode = NSLineBreakByCharWrapping;
    paraStyle.alignment = NSTextAlignmentCenter;
    paraStyle.lineSpacing = line;
    paraStyle.hyphenationFactor = 1.0;
    paraStyle.firstLineHeadIndent = 0.0;
    paraStyle.paragraphSpacingBefore = 0.0;
    paraStyle.headIndent = 0;
    paraStyle.tailIndent = 0;
    NSDictionary *attributes = @{
                                 NSFontAttributeName: font,
                                 NSParagraphStyleAttributeName: paraStyle,
                                 NSKernAttributeName: kern
                                 };
    NSMutableAttributedString *attributeStr = [[NSMutableAttributedString alloc] initWithString:text attributes:attributes];
    return attributeStr;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
