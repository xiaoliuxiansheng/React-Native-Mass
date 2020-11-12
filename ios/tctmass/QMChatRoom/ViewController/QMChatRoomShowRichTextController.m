//
//  QMChatRoomShowRichTextController.m
//  IMSDK-OC
//
//  Created by lishuijiao on 2018/3/8.
//  Copyright © 2018年 HCF. All rights reserved.
//

#import "QMChatRoomShowRichTextController.h"
#import <WebKit/WebKit.h>
@interface QMChatRoomShowRichTextController () <UIScrollViewDelegate>{
//    UIWebView *_webView;
    WKWebView *_webView;
    UIView *_topView;
    
    UIButton *_backButton;
}

@end

@implementation QMChatRoomShowRichTextController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self createUI];
    [self createWebView];
}

- (void)createUI {
    _topView = [[UIView alloc] init];
    _topView.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, kStatusBarAndNavHeight);
    [self.view addSubview:_topView];
    
    _backButton = [[UIButton alloc] init];
    _backButton.frame = CGRectMake([UIScreen mainScreen].bounds.size.width - 60, kStatusBarHeight + 5, 40, 35);
    [_backButton setTitle:NSLocalizedString(@"button.back", nil) forState:UIControlStateNormal];
    [_backButton setTitleColor:[UIColor colorWithRed:13/255.0 green:139/255.0 blue:249/255.0 alpha:1] forState:UIControlStateNormal];
    [_backButton addTarget:self action:@selector(backAction:) forControlEvents:UIControlEventTouchUpInside];
    [_topView addSubview:_backButton];
}

- (void)createWebView {
    _webView = [[WKWebView alloc] initWithFrame:CGRectMake(0, kStatusBarAndNavHeight, kScreenWidth, [UIScreen mainScreen].bounds.size.height - kStatusBarAndNavHeight) configuration:[[WKWebViewConfiguration alloc] init]];
    if ([self.urlStr hasPrefix:@"http"]) {
        self.urlStr = [self.urlStr stringByRemovingPercentEncoding];
        NSString * url = [self.urlStr stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
        NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:url]];
        [_webView loadRequest:request];
    } else {
        NSURL *url = [NSURL fileURLWithPath:self.urlStr];
        [_webView loadFileURL:url allowingReadAccessToURL:url];
    }

    [self.view addSubview:_webView];
}

- (void)backAction:(UIButton *)button {
    [self dismissViewControllerAnimated:true completion:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
