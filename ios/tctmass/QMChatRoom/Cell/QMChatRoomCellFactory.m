//
//  QMChatRoomCellFactory.m
//  IMSDK-OC
//
//  Created by HCF on 16/3/11.
//  Copyright © 2016年 HCF. All rights reserved.
//

#import "QMChatRoomCellFactory.h"
#import "QMChatRoomBaseCell.h"
#import "QMChatRoomTextCell.h"
#import "QMChatRoomImageCell.h"
#import "QMChatRoomVoiceCell.h"

@implementation QMChatRoomCellFactory

+ (QMChatRoomBaseCell *)createCellWithClassName:(NSString *)className
                                      cellModel:(CustomMessage *)cellModel
                                      indexPath:(NSIndexPath *)indexPath {
    QMChatRoomBaseCell * cell = nil;
    
    Class cellClass = NSClassFromString(className);
    
    cell = [[cellClass alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:className];
    
    if (cell == nil) {
        cell = [[QMChatRoomBaseCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"QMChatRoomBaseCell"];
    }
    
    return cell;
}

@end
