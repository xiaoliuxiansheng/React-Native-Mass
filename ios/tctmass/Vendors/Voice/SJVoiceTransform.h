//
//  SJVoiceTransform.h
//  AudioDemo
//
//  Created by 张赛赛 on 15/8/24.
//  Copyright (c) 2015年 张赛赛. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SJVoiceTransform : NSObject

/**
 *  根据路径将pcm文件转化为MP3
 *
 *  @param docPath docment路径
 */
+(NSString *)stransformToMp3ByUrlWithUrl:(NSString *)docPath;

@end
