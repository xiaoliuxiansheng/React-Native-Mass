//
//  SJVoiceTransform.m
//  AudioDemo
//
//  Created by 张赛赛 on 15/8/24.
//  Copyright (c) 2015年 张赛赛. All rights reserved.
//

#import "SJVoiceTransform.h"
#import "lame.h"
@interface SJVoiceTransform()

//@property (strong , nonatomic)NSString * path;//存放音频沙河路径
@end

@implementation SJVoiceTransform

+(NSString *)stransformToMp3ByUrlWithUrl:(NSString *)docPath
{
    NSString *pathUrl = [NSString stringWithFormat:@"%@",docPath];//存储录音pcm格式音频地址
    NSString * mp3Url = pathUrl;
    NSString *mp3FilePath = [docPath stringByAppendingString:@".mp3"];//存放Mp3地址
    if (!mp3Url || !mp3FilePath) {
        return 0;
    }
    @try {
        int read, write;
        FILE *pcm = fopen([mp3Url cStringUsingEncoding:1], "rb"); //source 被转换的音频文件位置
        //音频不能为空
        if (!pcm) {
            return nil;
        }
        fseek(pcm, 4*1024, SEEK_CUR); //skip file header
        FILE *mp3 = fopen([mp3FilePath cStringUsingEncoding:1], "wb"); //output 输出生成的Mp3文件位置
        const int PCM_SIZE = 8192;
        const int MP3_SIZE = 8192;
        short int pcm_buffer[PCM_SIZE*2];
        unsigned char mp3_buffer[MP3_SIZE];
        lame_t lame = lame_init();
        lame_set_num_channels(lame,1);
        lame_set_in_samplerate(lame, 8000.0); //11025.0
        //lame_set_VBR(lame, vbr_default);
        lame_set_brate(lame, 8);
        lame_set_mode(lame, 3);
        lame_set_quality(lame, 2);//
        lame_init_params(lame);
        do {
            read = fread(pcm_buffer, 2*sizeof(short int), PCM_SIZE, pcm);
            if (read == 0)
                write = lame_encode_flush(lame, mp3_buffer, MP3_SIZE);
            else
                write = lame_encode_buffer_interleaved(lame, pcm_buffer, read, mp3_buffer, MP3_SIZE);
            fwrite(mp3_buffer, write, 1, mp3);
        } while (read != 0);
        lame_close(lame);
        fclose(mp3);
        fclose(pcm);
    }
    @catch (NSException *exception) {
        NSLog(@"%@",[exception description]);
    }
    @finally {
        NSLog(@"MP3生成成功: %@",mp3FilePath);
    }
    return mp3FilePath;

}


@end
