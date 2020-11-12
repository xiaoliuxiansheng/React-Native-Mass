//
//  QMFileModel.h
//  IMSDK-OC
//
//  Created by HCF on 16/8/11.
//  Copyright © 2016年 HCF. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface QMFileModel : NSObject

@property (nonatomic, copy)NSString *fileName;
@property (nonatomic, copy)NSString *fileDate;
@property (nonatomic, copy)NSString *fileSize;
@property (nonatomic, copy)NSString *filePath;

@end
