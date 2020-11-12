//
//  QMFileManager.h
//  IMSDK-OC
//
//  Created by HCF on 16/8/11.
//  Copyright © 2016年 HCF. All rights reserved.
//

#import <Foundation/Foundation.h>

#define kDOCUMENTS NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0]

@interface QMFileManager : NSObject

+ (BOOL)createFolder: (NSString *)folderPath;

+ (NSArray *)getFileNames: (NSString *)folderPath;

+ (BOOL)fileIsExsited: (NSString *)filePath;

+ (NSDictionary *)getFileAttributes: (NSString *)filePath;

+ (NSString *)writeDictionary: (NSDictionary *)dict toFile: (NSString *)filePath;

+ (NSMutableDictionary *)readDictionary: (NSString *)filePath;

@end
