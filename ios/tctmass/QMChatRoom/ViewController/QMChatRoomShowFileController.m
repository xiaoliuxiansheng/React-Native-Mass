//
//  QMChatRoomShowFileController.m
//  IMSDK-OC
//
//  Created by HCF on 16/8/15.
//  Copyright © 2016年 HCF. All rights reserved.
//

#import "QMChatRoomShowFileController.h"
#import <WebKit/WebKit.h>
@interface QMChatRoomShowFileController ()

@end

@implementation QMChatRoomShowFileController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.view.backgroundColor = [UIColor whiteColor];
    
    UIButton * button = [UIButton buttonWithType:UIButtonTypeSystem];
        
    button.frame = CGRectMake(10, kStatusBarHeight + 5, 60, 30);
    [button setTitle:NSLocalizedString(@"button.back", nil) forState:UIControlStateNormal];
    [button addTarget:self action:@selector(backAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
    
    
    CGRect webFrame = CGRectMake(0, kStatusBarAndNavHeight, kScreenWidth, kScreenHeight - kStatusBarAndNavHeight);
    
    WKWebViewConfiguration *config = [[WKWebViewConfiguration alloc] init];
    WKWebView *webView = [[WKWebView alloc] initWithFrame:webFrame configuration:config];
//    UIWebView * webView = [[UIWebView alloc] init];
//    webView.frame = CGRectMake(0, 44 + kStatusBarHeight, kScreenWidth, kScreenHeight-44-kStatusBarHeight);
//    webView.scalesPageToFit = YES;
//    webView.backgroundColor = [UIColor whiteColor];
    
    [self.view addSubview:webView];
    
    NSString * filePath = [NSString stringWithFormat:@"%@/%@/%@",NSHomeDirectory(),@"Documents",self.filePath];
    // 中文路径要encode
    if ([filePath hasPrefix:@"http"]) {
        NSString * fileUrl = [filePath stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
        NSURL *url = [NSURL URLWithString:fileUrl];
        [webView loadRequest:[NSURLRequest requestWithURL:url]];
    } else {
        NSURL *url = [NSURL fileURLWithPath:filePath];
        [webView loadFileURL:url allowingReadAccessToURL:url];
    }

//    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:fileUrl]];
//    [webView loadRequest:request];
}

- (void)backAction {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
