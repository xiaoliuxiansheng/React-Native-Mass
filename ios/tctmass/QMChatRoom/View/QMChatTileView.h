//
//  QMChatTileView.h
//  IMSDK-OC
//
//  Created by HCF on 16/8/10.
//  Copyright © 2016年 HCF. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface QMChatTileView : UIView

@property (nonatomic, strong)UIActivityIndicatorView *activityIndicatorView;

@property (nonatomic, strong)UILabel *nameLabel;

@property (nonatomic, strong)UILabel *stateInfoLabel;

@property (nonatomic, assign)CGSize intrinsicContentSize;

@end
