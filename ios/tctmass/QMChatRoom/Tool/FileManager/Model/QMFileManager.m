//
//  QMFileManager.m
//  IMSDK-OC
//
//  Created by HCF on 16/8/11.
//  Copyright © 2016年 HCF. All rights reserved.
//

#import "QMFileManager.h"

@interface QMFileManager ()

@property (nonatomic)NSFileManager *fileManager;

@end

@implementation QMFileManager


+ (BOOL)createFolder: (NSString *)folderPath {
    NSString * path = [NSString stringWithFormat:@"%@/%@", kDOCUMENTS, folderPath];
    
    if (![[NSFileManager defaultManager] fileExistsAtPath:path]) {
        NSError *error = nil;
        [[NSFileManager defaultManager] createDirectoryAtPath:path withIntermediateDirectories:YES attributes:nil error:&error];
        if (error) {
            return NO;
        }else {
            return YES;
        }
    }else {
        return NO;
    }
}

+ (NSArray *)getFileNames: (NSString *)folderPath {
    NSString * path = [NSString stringWithFormat:@"%@/%@", kDOCUMENTS, folderPath];
    return [[NSFileManager defaultManager] subpathsAtPath:path];
}

+ (BOOL)fileIsExsited: (NSString *)filePath {
    NSString *path = [NSString stringWithFormat:@"%@/%@", kDOCUMENTS, filePath];
    return [[NSFileManager defaultManager] fileExistsAtPath:path];
}

+ (NSDictionary *)getFileAttributes: (NSString *)filePath {
    NSString *path = [NSString stringWithFormat:@"%@/%@", kDOCUMENTS, filePath];
    if ([[NSFileManager defaultManager] fileExistsAtPath:path]) {
        NSError *error = nil;
        return [[NSFileManager defaultManager] attributesOfItemAtPath:path error:&error];
    }else {
        return nil;
    }
}

+ (NSString *)writeDictionary: (NSDictionary *)dict toFile: (NSString *)filePath {
    NSString *path = [NSString stringWithFormat:@"%@/%@", kDOCUMENTS, filePath];
    BOOL success = [dict writeToFile:path atomically:YES];
    if (success) {
        return path;
    }else {
        return nil;
    }
}

+ (NSMutableDictionary *)readDictionary: (NSString *)filePath {
    NSString *path = [NSString stringWithFormat:@"%@/%@", kDOCUMENTS, filePath];
    return [NSMutableDictionary dictionaryWithContentsOfFile:path];
}


@end
