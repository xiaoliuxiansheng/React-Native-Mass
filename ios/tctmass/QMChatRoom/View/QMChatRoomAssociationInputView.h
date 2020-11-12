//
//  QMChatRoomAssociationInputView.h
//  IMSDK-OC
//
//  Created by lishuijiao on 2019/5/27.
//  Copyright © 2019年 HCF. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface QMChatRoomAssociationInputView : UIView <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, copy) void(^questionsSelect)(NSString *question);

- (void)showData:(NSArray *)array;

@end

@interface QMChatRoomAssociationInputCell : UITableViewCell

@property (nonatomic, strong) UILabel *questionLabel;

@end
