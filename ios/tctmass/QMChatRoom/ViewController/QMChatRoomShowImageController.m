//
//  QMChatRoomShowImageController.m
//  IMSDK-OC
//
//  Created by haochongfeng on 2017/5/17.
//  Copyright © 2017年 HCF. All rights reserved.
//

#import "QMChatRoomShowImageController.h"

@interface QMChatRoomShowImageController () <UIAlertViewDelegate,UINavigationControllerDelegate>

@end

@implementation QMChatRoomShowImageController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor blackColor];
    
    self.bigImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height)];
    self.bigImageView.contentMode = UIViewContentModeScaleAspectFit;
    if ([self.picType isEqualToString:@"0"]) {
        NSString * filePath = [NSString stringWithFormat:@"%@/%@/%@",NSHomeDirectory(),@"Documents",self.picName];
        self.bigImageView.image = [UIImage imageWithContentsOfFile:filePath];
    }else {
        [self.bigImageView sd_setImageWithURL:[NSURL URLWithString:self.picName] placeholderImage:self.image];
    }
    UITapGestureRecognizer * gestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction)];
    UILongPressGestureRecognizer * pressGestureRecognizer = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressAction:)];
    [self.bigImageView addGestureRecognizer:pressGestureRecognizer];
    self.bigImageView.userInteractionEnabled = YES;
    [self.bigImageView addGestureRecognizer:gestureRecognizer];
    [self.view addSubview:self.bigImageView];
}

//长按保存图片
- (void)longPressAction:(UILongPressGestureRecognizer *)pressGestureRecognizer {
    if (pressGestureRecognizer.state == UIGestureRecognizerStateBegan) {
        UIAlertView * alertView = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"title.prompt", nil) message:NSLocalizedString(@"title.savePicture", nil) delegate:self cancelButtonTitle:NSLocalizedString(@"button.cancel", nil) otherButtonTitles:NSLocalizedString(@"button.sure", nil), nil];
        [alertView show];
    }
}

//保存图片代理方法
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 1) {
        if ([self.picType isEqualToString:@"0"]) {
            NSString * filePath = [NSString stringWithFormat:@"%@/%@/%@/%@",NSHomeDirectory(),@"Documents",@"SaveFile",self.picName];
            UIImageWriteToSavedPhotosAlbum([UIImage imageWithContentsOfFile:filePath], nil, nil, nil);
        }else {
            NSURL * url = [NSURL URLWithString:self.picName];
            NSURLRequest * request = [NSURLRequest requestWithURL:url];
            NSOperationQueue * queue = [[NSOperationQueue alloc] init];
            [NSURLConnection sendAsynchronousRequest:request queue:queue completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
                UIImageWriteToSavedPhotosAlbum([UIImage imageWithData:data], nil, nil, nil);
            }];
        }
    }
}

//返回
- (void)tapAction {
    [self dismissViewControllerAnimated:true completion:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
