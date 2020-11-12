//
//  TCFaceView.m
//  QimoQM
//
//  Created by TuChuan on 15/5/13.
//  Copyright (c) 2015年 七陌科技. All rights reserved.
//

#import "TCFaceView.h"

#define NumPerLine 7
#define Lines    3
#define FaceSize  34
/*
 ** 两边边缘间隔
 */
#define EdgeDistance 20
/*
 ** 上下边缘间隔
 */
#define EdgeInterVal 5

@implementation TCFaceView

- (id)initWithFrame:(CGRect)frame forIndexPath:(int)index
{
    self = [super initWithFrame:frame];
    if (self) {
        // 水平间隔
        CGFloat horizontalInterval = (CGRectGetWidth(self.bounds)-NumPerLine*FaceSize -2*EdgeDistance)/(NumPerLine-1);
        // 上下垂直间隔
        CGFloat verticalInterval = (CGRectGetHeight(self.bounds)-2*EdgeInterVal -Lines*FaceSize)/(Lines-1);
        
        NSString *bundlePath = [[NSBundle mainBundle]pathForResource:@"QMEmoticon" ofType:@"bundle"];
        
        for (int i = 0; i<Lines; i++)
        {
            for (int x = 0;x<NumPerLine;x++)
            {
                UIButton *expressionButton =[UIButton buttonWithType:UIButtonTypeCustom];
                [self addSubview:expressionButton];
                [expressionButton setFrame:CGRectMake(x*FaceSize+EdgeDistance+x*horizontalInterval,
                                                      i*FaceSize +i*verticalInterval+EdgeInterVal,
                                                      FaceSize,
                                                      FaceSize)];
                if (i*7+x+1 ==21) {
                    [expressionButton setBackgroundImage:[UIImage imageWithContentsOfFile: [NSString stringWithFormat:@"%@/emoji_delete", bundlePath]]
                                                forState:UIControlStateNormal];
                    expressionButton.tag = 101;
                }else{
                    NSString *imageStr = [NSString stringWithFormat:@"emoji_%d",(index*20+i*7+x+1)];
                    NSString *imagePath = [NSString stringWithFormat:@"%@/%@", bundlePath, imageStr];
                    
                    [expressionButton setBackgroundImage:[UIImage imageWithContentsOfFile:imagePath] forState:UIControlStateNormal];
                    expressionButton.tag = 20*index+i*7+x+1;
                }
                [expressionButton addTarget:self
                                     action:@selector(faceClick:)
                           forControlEvents:UIControlEventTouchUpInside];
            }
        }
    }
    return self;
}

- (void)faceClick:(UIButton *)button{
    NSString *faceName;
    BOOL isDelete;
    if (button.tag ==101){
        faceName = nil;
        isDelete = YES;
    }else{
        NSString *expressstring = [NSString stringWithFormat:@"emoji_%ld.png",(long)button.tag];
        NSString *plistStr = [[NSBundle mainBundle]pathForResource:@"expressionImage" ofType:@"plist"];
        NSDictionary *plistDic = [[NSDictionary  alloc]initWithContentsOfFile:plistStr];
        for (int j = 0; j<[[plistDic allKeys]count]; j++)
        {
            if ([[plistDic objectForKey:[[plistDic allKeys]objectAtIndex:j]]
                 isEqualToString:[NSString stringWithFormat:@"%@",expressstring]])
            {
                faceName = [[plistDic allKeys]objectAtIndex:j];
            }
        }
        isDelete = NO;
    }
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(didSelecteFace:andIsSelecteDelete:)]) {
        [self.delegate didSelecteFace:faceName andIsSelecteDelete:isDelete];
    }
}




@end
