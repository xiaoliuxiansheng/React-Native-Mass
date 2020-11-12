//
//  QMProfileManager.h
//  IMSDK-OC
//
//  Created by HCF on 16/8/11.
//  Copyright © 2016年 HCF. All rights reserved.
//

#import <Foundation/Foundation.h>

enum QMFileCategory {
    DOCX,
    IMAGE,
    AUDIO,
    VIDEO,
    OTHER
};

enum QMFileType {
    DOC,
    MP3
};

@class QMFileModel;

@interface QMProfileManager : NSObject

+ (QMProfileManager *)sharedInstance;

- (BOOL)loadProfile: (NSString *)name password: (NSString *)password;

- (NSArray *)getFilesAttributes: (enum QMFileCategory)type;

- (NSString *)getFilePath: (NSString *)fileName;

- (NSString *)checkFileExtension: (NSString *)name;

@end
