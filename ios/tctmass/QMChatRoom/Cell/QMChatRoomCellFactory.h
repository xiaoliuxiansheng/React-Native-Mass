//
//  QMChatRoomCellFactory.h
//  IMSDK-OC
//
//  Created by HCF on 16/3/11.
//  Copyright © 2016年 HCF. All rights reserved.
//

@class QMChatRoomBaseCell;
#import <Foundation/Foundation.h>
#import <QMLineSDK/QMLineSDK.h>

@interface QMChatRoomCellFactory : NSObject

/**
    cell工厂方法
    
    @param cellClassName cell类名
    @param cellModel cell数据模型
    @param indexPath index索引
 
    return cell目标
 */

+ (QMChatRoomBaseCell *)createCellWithClassName: (NSString *)className
                                      cellModel: (CustomMessage *)cellModel
                                      indexPath: (NSIndexPath *)indexPath;

@end
