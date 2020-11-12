//
//  QMTextAttachment.h
//  IMSDK-OC
//
//  Created by haochongfeng on 2017/5/18.
//  Copyright © 2017年 HCF. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface QMTextAttachment : NSTextAttachment

@property(strong, nonatomic) NSString *emojiCode;

@property(assign, nonatomic) CGSize emojiSize;

@end
