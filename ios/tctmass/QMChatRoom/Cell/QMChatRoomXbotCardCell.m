//
//  QMChatRoomXbotCardCell.m
//  IMSDK-OC
//
//  Created by lishuijiao on 2019/12/23.
//  Copyright © 2019 HCF. All rights reserved.
//

#import "QMChatRoomXbotCardCell.h"
#import "QMChatRoomXbotCardView.h"

@implementation QMChatRoomXbotCardCell {
    NSString *_messageId;

    UILabel *_titleLabel;
    UILabel *_shopName;
    UILabel *_shopAction;
    UITableView *_tableView;
    QMChatRoomXbotCardView *_cardView;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle: style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self createUI];
    }
    return self;
}

- (void)createUI {
    _cardView = [[QMChatRoomXbotCardView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.iconImage.frame)+5,  CGRectGetMaxY(self.timeLabel.frame)+10, kScreenWidth - CGRectGetMaxX(self.iconImage.frame) - 5 - 30, 300)];
    [self addSubview:_cardView];
}

- (void)setData:(CustomMessage *)message avater:(NSString *)avater {
    _messageId = message._id;
    self.message = message;
    [super setData:message avater:avater];

    NSData *jsonData = [message.cardMessage_New dataUsingEncoding:NSUTF8StringEncoding];
    NSError *err;
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:&err];
    if(err) {
        NSLog(@"json解析失败：%@",err);
        return;
    }else {
        
        CGFloat cellHeight = 0.0;
        CGFloat cellWidth = kScreenWidth - CGRectGetMaxX(self.iconImage.frame) - 5 - 30;

        if (message.cardType == QMMessageCardTypeNone) {
            NSArray *cardList = dic[@"data"][@"list"];
            int shopNumber = 0;
            int listNumber = 0;
            for (NSDictionary *dic in cardList) {
                if ([dic[@"item_type"] isEqualToString:@"0"]) {
                    listNumber += 1;
                }else if ([dic[@"item_type"] isEqualToString:@"1"]) {
                    shopNumber += 1;
                }
            }
            cellHeight = 88*listNumber + 72*shopNumber + 85;
        } else if (message.cardType == QMMessageCardTypeSeleced) {
            cellHeight = 81;
        } else {
            cellHeight = 44;
        }
        
        
        _cardView.frame = CGRectMake(CGRectGetMaxX(self.iconImage.frame)+5, CGRectGetMaxY(self.timeLabel.frame)+10, cellWidth, cellHeight);
        _cardView.messageId = _messageId;
        _cardView.type = message.cardType;
        [_cardView setCardDic:dic];
        self.chatBackgroudImage.frame = CGRectMake(CGRectGetMaxX(self.iconImage.frame)+5, CGRectGetMaxY(self.timeLabel.frame)+10, cellWidth, cellHeight);
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
