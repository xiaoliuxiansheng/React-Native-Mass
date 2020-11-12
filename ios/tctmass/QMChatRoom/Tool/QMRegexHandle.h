//
//  QMRegexHandle.h
//  IMSDK-OC
//
//  Created by zcz on 2019/12/25.
//  Copyright © 2019 HCF. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface QMRegexHandle : NSObject

+ (NSArray <NSTextCheckingResult *>*)getMobileNumberLoc:(NSString *)sourcStr;

@end

NS_ASSUME_NONNULL_END
