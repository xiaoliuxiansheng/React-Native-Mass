//
//  TCFaceView.h
//  QimoQM
//
//  Created by TuChuan on 15/5/13.
//  Copyright (c) 2015年 七陌科技. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol TCFaceViewDelegate <NSObject>
@optional

/*
 * 点击表情代理
 * @param faceName 表情对应的名称
 * @param del      是否点击删除
 *
 */
- (void)didSelecteFace:(NSString *)faceName andIsSelecteDelete:(BOOL)del;

@end

@interface TCFaceView : UIView

@property (nonatomic,weak) id<TCFaceViewDelegate>delegate;

/*
 * 初始化表情页面
 * @param frame     大小
 * @param indexPath 创建第几个
 *
 */
- (id)initWithFrame:(CGRect)frame forIndexPath:(int)index;


@end
