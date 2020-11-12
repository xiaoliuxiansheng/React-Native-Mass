//
//  QMChatRoomShowImageController.h
//  IMSDK-OC
//
//  Created by haochongfeng on 2017/5/17.
//  Copyright © 2017年 HCF. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface QMChatRoomShowImageController : UIViewController

@property (nonatomic ,copy)NSString * picName;

@property (nonatomic ,copy)NSString * picType;

@property (nonatomic ,strong)UIImage *image;

@property (nonatomic ,strong)UIImageView * bigImageView;

@end
