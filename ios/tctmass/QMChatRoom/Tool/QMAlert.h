//
//  QMAlert.h
//  IMSDK-OC
//
//  Created by haochongfeng on 2017/5/17.
//  Copyright © 2017年 HCF. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface QMAlert : NSObject

+ (UIWindow *)mainWindow;

+ (void)showMessage:(NSString *)message;

+ (CGFloat)calculateRowHeight:(NSString *)string fontSize:(NSInteger)fontSize;

+ (CGFloat)calculateRowHeight:(NSString *)string fontSize:(NSInteger)fontSize Width:(CGFloat)width;

+ (CGFloat)calcLabelHeight: (NSString *)text font: (UIFont *)font;

+ (CGSize)calculateText:(NSString *)text font:(UIFont *)font maxWidth:(CGFloat)maxWidth maxHeight:(CGFloat)maxHeight;

+ (void)showMessageAtCenter:(NSString *)message;

+ (UIColor *)colorWithHexString: (NSString *)color;

@end
