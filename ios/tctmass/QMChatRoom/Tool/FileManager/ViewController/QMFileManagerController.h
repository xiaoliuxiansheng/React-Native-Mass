//
//  QMFileManagerController.h
//  IMSDK-OC
//
//  Created by HCF on 16/8/10.
//  Copyright © 2016年 HCF. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^CallBackBlock)(NSString *name, NSString * size, NSString * path);

@interface QMFileManagerController : UIViewController

@property (nonatomic, strong)CallBackBlock callBackBlock;

@end
