//
//  QMProfileManager.m
//  IMSDK-OC
//
//  Created by HCF on 16/8/11.
//  Copyright © 2016年 HCF. All rights reserved.
//

#import "QMProfileManager.h"
#import "QMFileModel.h"
#import "QMFileManager.h"

@implementation QMProfileManager

static NSString *DocFolder   = @"%@/Doc";
static NSString *ImageFolder = @"%@/Image";
static NSString *AudioFolder = @"%@/Audio";
static NSString *VideoFolder = @"%@/Video";
static NSString *OtherFolder = @"%@/Other";
static NSString *SendVideoFolder = @"%@/SendVideo";

static NSString *profileList = @"profiles.plist";
static NSString *lastLogin   = @"lastlogin.plist";

static NSString *KEY_LASTLOGIN_NAME     = @"LASTLOGIN_NAME";
static NSString *KEY_LASTLOGIN_PASSWORD = @"LASTLOGIN_PASSWORD";

static QMProfileManager * instance = nil;
+ (instancetype)sharedInstance {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[self alloc] init];
    });
    return instance;
}

+ (instancetype)allocWithZone:(struct _NSZone *)zone {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [super allocWithZone:zone];
    });
    return instance;
}

- (BOOL)loadProfile: (NSString *)name password: (NSString *)password {
    if (![QMFileManager fileIsExsited:profileList]) {
        [QMFileManager writeDictionary:[NSDictionary new] toFile:profileList];
        [QMFileManager writeDictionary:[NSDictionary new] toFile:lastLogin];
    }
    
    NSMutableDictionary *profiles = [QMFileManager readDictionary:profileList];
    if ([profiles objectForKey:name]==nil) {
        [QMFileManager createFolder:name];
        
        [QMFileManager createFolder:[NSString stringWithFormat:DocFolder, name]];
        [QMFileManager createFolder:[NSString stringWithFormat:AudioFolder, name]];
        [QMFileManager createFolder:[NSString stringWithFormat:ImageFolder, name]];
        [QMFileManager createFolder:[NSString stringWithFormat:VideoFolder, name]];
        [QMFileManager createFolder:[NSString stringWithFormat:OtherFolder, name]];
        [QMFileManager createFolder:[NSString stringWithFormat:SendVideoFolder, name]];
    }
    
    NSDictionary *lastDict = @{
                               KEY_LASTLOGIN_NAME       :name,
                               KEY_LASTLOGIN_PASSWORD   :password
                               };
    [QMFileManager writeDictionary:lastDict toFile:lastLogin];
    return YES;
}

- (NSArray *)getFilesAttributes: (enum QMFileCategory)type {
    NSMutableArray *fileModels = [[NSMutableArray alloc] init];
    NSMutableDictionary *profiles = [QMFileManager readDictionary:lastLogin];
    if ([profiles objectForKey:KEY_LASTLOGIN_NAME] == nil) {
        return fileModels;
    }
    
    NSString *folder = @"";
    switch (type) {
        case DOCX:
            folder = [NSString stringWithFormat:DocFolder, [profiles objectForKey:KEY_LASTLOGIN_NAME]];
            break;
        case IMAGE:
            folder = [NSString stringWithFormat:ImageFolder, [profiles objectForKey:KEY_LASTLOGIN_NAME]];
            break;
        case AUDIO:
            folder = [NSString stringWithFormat:AudioFolder, [profiles objectForKey:KEY_LASTLOGIN_NAME]];
            break;
        case VIDEO:
            folder = [NSString stringWithFormat:VideoFolder, [profiles objectForKey:KEY_LASTLOGIN_NAME]];
            break;
        case OTHER:
            folder = [NSString stringWithFormat:OtherFolder, [profiles objectForKey:KEY_LASTLOGIN_NAME]];
            break;
        default:
            break;
    }
    
    NSArray *fileNames = [QMFileManager getFileNames:folder];
    
    NSLog(@"%@", fileNames);
    
    for (NSString * fileName in fileNames) {
        
        NSLog(@"%@", fileName);
        
        NSLog(@"%@", [NSString stringWithFormat:@"%@/%@", folder, fileName]);
        
        NSDictionary *fileInfo = [QMFileManager getFileAttributes:[NSString stringWithFormat:@"%@/%@", folder, fileName]];
        
        QMFileModel *model = [[QMFileModel alloc] init];
        model.fileName = fileName;
        
        NSDateFormatter * formatter = [[NSDateFormatter alloc] init];
        formatter.dateFormat = @"MM-dd HH:mm";
        model.fileDate = [formatter stringFromDate:[fileInfo objectForKey:NSFileCreationDate]];
        if ([[fileInfo objectForKey:NSFileSize] floatValue] > 1024) {
            model.fileSize = [NSString stringWithFormat:@"%.f KB", [[fileInfo objectForKey:NSFileSize] floatValue]/1024];
        }else {
            model.fileSize = [NSString stringWithFormat:@"%.f MB", [[fileInfo objectForKey:NSFileSize] floatValue]/1024/1024];
        }
        
//        model.fileSize = [[fileInfo objectForKey:NSFileSize] description];
        model.filePath = [NSString stringWithFormat:@"%@/%@", folder, fileName];
        
        [fileModels addObject:model];
    }
    return fileModels;
}

- (NSString *)getFilePath: (NSString *)fileName {
    
    NSMutableDictionary *profiles = [QMFileManager readDictionary:lastLogin];
    if ([profiles objectForKey:KEY_LASTLOGIN_NAME] == nil) {
        return @"";
    }
    
    NSString *folder = [NSString stringWithFormat:[self checkFileExtension:fileName], [profiles objectForKey:KEY_LASTLOGIN_NAME]];
    
    NSLog(@"%@", [NSString stringWithFormat:@"%@/%@", folder, fileName]);
    return [NSString stringWithFormat:@"%@/%@", folder, fileName];
}

- (NSString *)checkFileExtension: (NSString *)name {
    NSMutableDictionary *profiles = [QMFileManager readDictionary:lastLogin];
    if ([profiles objectForKey:KEY_LASTLOGIN_NAME] == nil) {
        return name;
    }
    
    NSString *tempString = @"";
    NSString *exten = name.pathExtension.lowercaseString;
    
    if ([exten isEqualToString:@"doc"]||[exten isEqualToString:@"docx"]||[exten isEqualToString:@"ppt"]||[exten isEqualToString:@"pptx"]||[exten isEqualToString:@"xls"]||[exten isEqualToString:@"xlsx"]||[exten isEqualToString:@"xml"]||[exten isEqualToString:@"wps"]||[exten isEqualToString:@"txt"]||[exten isEqualToString:@"html"]||[exten isEqualToString:@"htm"]||[exten isEqualToString:@"pps"]||[exten isEqualToString:@"text"]) {
        tempString = [NSString stringWithFormat:DocFolder, [profiles objectForKey:KEY_LASTLOGIN_NAME]];
    }else if ([exten isEqualToString:@"png"]||[exten isEqualToString:@"gif"]||[exten isEqualToString:@"jpg"]||[exten isEqualToString:@"jpeg"]||[exten isEqualToString:@"bmp"]) {
        tempString = [NSString stringWithFormat:ImageFolder, [profiles objectForKey:KEY_LASTLOGIN_NAME]];
    }else if ([exten isEqualToString:@"mp3"]||[exten isEqualToString:@"wav"]||[exten isEqualToString:@"m4a"]||[exten isEqualToString:@"wma"]||[exten isEqualToString:@"caf"]) {
        tempString = [NSString stringWithFormat:AudioFolder, [profiles objectForKey:KEY_LASTLOGIN_NAME]];
    }else if ([exten isEqualToString:@"avi"]||[exten isEqualToString:@"mov"]||[exten isEqualToString:@"mp4"]||[exten isEqualToString:@"mkv"]||[exten isEqualToString:@"rmvb"]||[exten isEqualToString:@"wmv"]) {
        tempString = [NSString stringWithFormat:VideoFolder, [profiles objectForKey:KEY_LASTLOGIN_NAME]];
    }else {
        tempString = [NSString stringWithFormat:OtherFolder, [profiles objectForKey:KEY_LASTLOGIN_NAME]];
    }
    
    return [NSString stringWithFormat:@"%@/%@", tempString, name];
}

@end
