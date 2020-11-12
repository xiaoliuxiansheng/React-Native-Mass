//
//  QMTextModel.m
//  IMSDK-OC
//
//  Created by haochongfeng on 2018/1/23.
//  Copyright © 2018年 HCF. All rights reserved.
//

#import "QMTextModel.h"

@implementation QMTextModel

// 计算文本图片混合高度
+ (CGFloat)calcRobotHeight: (NSString *)htmlString {
    
    htmlString = [htmlString stringByReplacingOccurrencesOfString:@"<br>" withString:@"\n"];
    htmlString = [htmlString stringByReplacingOccurrencesOfString:@"</br>" withString:@"\n"];
    htmlString = [htmlString stringByReplacingOccurrencesOfString:@"</p>" withString:@"\n"];

    __block CGFloat height = 0;
    __block NSString *tempString = htmlString;
    
    NSRegularExpression *regularExpretion = [[NSRegularExpression alloc] initWithPattern:@"<[^>]*>" options:NSRegularExpressionCaseInsensitive error:nil];
    [regularExpretion enumerateMatchesInString:htmlString options:NSMatchingReportProgress range:NSMakeRange(0, [htmlString length]) usingBlock:^(NSTextCheckingResult * _Nullable result, NSMatchingFlags flags, BOOL * _Nonnull stop) {
        
        if (result.range.length != 0) {
            NSString *actionString = [NSString stringWithFormat:@"%@",[htmlString substringWithRange:result.range]];
            
            NSRange range = [tempString rangeOfString:actionString];
            
            // 判断知否包含图片资源
            NSArray *components = nil;
            if ([actionString rangeOfString:@"src=\""].location != NSNotFound) {
                components = [actionString componentsSeparatedByString:@"src=\""];
            }else if ([actionString rangeOfString:@"src="].location != NSNotFound) {
                components = [actionString componentsSeparatedByString:@"src="];
            }
            
            if (components.count >= 2) {
                
                // 文本高度计算
                height += [QMTextModel calcTextHeight:[tempString substringToIndex:range.location] width:160];
                
                // 图片高度固定
                height += 100;
                
                tempString = [tempString substringFromIndex:range.location+range.length];
            }else {
                tempString = [tempString stringByReplacingCharactersInRange:range withString:@""];
            }
        }
    }];
    
    // 文本高度计算
    height += [QMTextModel calcTextHeight:tempString width:160];
    
    return height;
}

// 计算文本高度
+ (CGFloat)calcTextHeight: (NSString *)text width:(CGFloat)width {
    MLEmojiLabel *tLabel = [MLEmojiLabel new];
    tLabel.numberOfLines = 0;
    tLabel.font = [UIFont systemFontOfSize:14.0f];
    tLabel.lineBreakMode = NSLineBreakByTruncatingTail;
    tLabel.disableEmoji = NO;
    tLabel.disableThreeCommon = NO;
    tLabel.isNeedAtAndPoundSign = YES;
    tLabel.customEmojiRegex = @"\\:[^\\:]+\\:";
    tLabel.customEmojiPlistName = @"expressionImage.plist";
    tLabel.customEmojiBundleName = @"QMEmoticon.bundle";
    tLabel.text = text;
    CGSize size = [tLabel preferredSizeWithMaxWidth: [UIScreen mainScreen].bounds.size.width - width];
    return size.height;
}

+ (CGFloat)calculateRowHeight:(NSString *)string fontSize:(NSInteger)fontSize width:(CGFloat)width {
    NSDictionary *dic = @{NSFontAttributeName:[UIFont systemFontOfSize:fontSize]};//指定字号
    CGRect rect = [string boundingRectWithSize:CGSizeMake([UIScreen mainScreen].bounds.size.width - width, 0)/*计算高度要先指定宽度*/ options:NSStringDrawingUsesLineFragmentOrigin |
                   NSStringDrawingUsesFontLeading attributes:dic context:nil];
    return rect.size.height;
}


+ (NSMutableArray *)dictionaryWithJsonString:(NSString *)jsonString {
    if (jsonString == nil) {
        return nil;
    }
    
    NSData *jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    NSError *err;
    
    NSMutableArray *arr = [NSJSONSerialization JSONObjectWithData:jsonData
                                                          options:NSJSONReadingMutableContainers
                                                            error:&err];
    if(err) {
        NSLog(@"json解析失败：%@",err);
        return nil;
    }
    return arr;
}

+ (CGFloat)calcxbotRobotHeight: (NSString *)htmlString textWidth:(CGFloat)textWidth {
    
    htmlString = [htmlString stringByReplacingOccurrencesOfString:@"<br>" withString:@"\n"];
    htmlString = [htmlString stringByReplacingOccurrencesOfString:@"</br>" withString:@"\n"];
    htmlString = [htmlString stringByReplacingOccurrencesOfString:@"</p>" withString:@"\n"];

    __block CGFloat height = 0;
    __block NSString *tempString = htmlString;
    
    NSRegularExpression *regularExpretion = [[NSRegularExpression alloc] initWithPattern:@"<[^>]*>" options:NSRegularExpressionCaseInsensitive error:nil];
    [regularExpretion enumerateMatchesInString:htmlString options:NSMatchingReportProgress range:NSMakeRange(0, [htmlString length]) usingBlock:^(NSTextCheckingResult * _Nullable result, NSMatchingFlags flags, BOOL * _Nonnull stop) {
        
        if (result.range.length != 0) {
            NSString *actionString = [NSString stringWithFormat:@"%@",[htmlString substringWithRange:result.range]];
            
            NSRange range = [tempString rangeOfString:actionString];
            
            // 判断知否包含图片资源
            NSArray *components = nil;
            if ([actionString rangeOfString:@"src=\""].location != NSNotFound) {
                components = [actionString componentsSeparatedByString:@"src=\""];
            }else if ([actionString rangeOfString:@"src="].location != NSNotFound) {
                components = [actionString componentsSeparatedByString:@"src="];
            }
            
            if (components.count >= 2) {
                
                // 文本高度计算
                height += [QMTextModel calcTextHeight:[tempString substringToIndex:range.location] width:textWidth];
                
                // 图片高度固定
                height += 100;
                
                tempString = [tempString substringFromIndex:range.location+range.length];
            }else {
                tempString = [tempString stringByReplacingCharactersInRange:range withString:@""];
            }
        }
    }];
    
    // 文本高度计算
    height += [QMTextModel calcTextHeight:tempString width:textWidth];
    
    return height;
}

@end
