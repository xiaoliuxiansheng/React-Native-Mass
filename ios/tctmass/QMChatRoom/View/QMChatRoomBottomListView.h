//
//  QMChatRoomBottomListView.h
//  IMSDK-OC
//
//  Created by lishuijiao on 2019/9/20.
//  Copyright © 2019 HCF. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface QMChatRoomBottomListView : UIView <UICollectionViewDelegate, UICollectionViewDataSource>

@property (nonatomic, copy) void(^tapSendText)(NSString *);

@property (nonatomic, strong) NSArray *dataArr;

- (void)showData:(NSArray *)array;

@end


@interface QMChatRoomBottomListCell: UICollectionViewCell

@property (nonatomic, copy) void(^tapBottomText)(NSString *);

@property (nonatomic, copy) NSDictionary *dic;

@property (nonatomic, strong) UIButton *button;

- (void)showLabelText:(NSDictionary *)dic;

@end

NS_ASSUME_NONNULL_END
