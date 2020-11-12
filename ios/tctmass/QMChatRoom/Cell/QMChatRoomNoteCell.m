//
//  QMChatRoomNoteCell.m
//  IMSDK-OC
//
//  Created by lishuijiao on 2018/3/23.
//  Copyright © 2018年 HCF. All rights reserved.
//

#import "QMChatRoomNoteCell.h"

@implementation QMChatRoomNoteCell {
    
    UILabel *_detailLabel;

}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self createUI];
    }
    return self;
}

- (void)createUI {
    _detailLabel = [[UILabel alloc] init];
    _detailLabel.frame = CGRectMake(10, 15, kScreenWidth - 20, 30);
    _detailLabel.textAlignment = NSTextAlignmentCenter;
    _detailLabel.textColor = [UIColor grayColor];
    _detailLabel.font = [UIFont systemFontOfSize:14];
    [self.contentView addSubview:_detailLabel];
}

- (void)setData:(CustomMessage *)message avater:(NSString *)avater {
    self.message = message;
        [super setData:message avater:avater];
    
    if ([message.fromType isEqualToString:@"1"]) {
        _detailLabel.text = message.message;
        self.iconImage.hidden = YES;
        self.timeLabel.hidden = YES;
    }
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
