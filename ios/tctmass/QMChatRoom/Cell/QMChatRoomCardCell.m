//
//  QMChatCardCell.m
//  IMSDK-OC
//
//  Created by lishuijiao on 2018/6/22.
//  Copyright © 2018年 HCF. All rights reserved.
//

#import "QMChatRoomCardCell.h"

@interface QMChatRoomCardCell()

@end


@implementation QMChatRoomCardCell
{
    NSString *_messageId;
    
    UIView *_cardView;
    
    UILabel *_headerLabel;
    
    UILabel *_subheadLabel;
    
    UILabel *_priceLabel;
    
    UIImageView *_imageView;
    
    UIButton *_sendButton;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self createUI];
    }
    return self;
}

- (void)createUI {
    self.iconImage.hidden = YES;

    _cardView = [[UIView alloc] init];
    _cardView.backgroundColor = [UIColor whiteColor];

    [self.contentView addSubview:_cardView];
    
    _imageView = [[UIImageView alloc] init];
    _imageView.frame = CGRectMake(10, 10, 60, 60);
    [_cardView addSubview:_imageView];
    
    _headerLabel = [[UILabel alloc] init];
    _headerLabel.frame = CGRectMake(80, 10, kScreenWidth - 90, 30);
    _headerLabel.font = [UIFont systemFontOfSize:15.0f];
    _headerLabel.textColor = [UIColor blackColor];
    _headerLabel.numberOfLines = 2;
    [_cardView addSubview:_headerLabel];
    
    _subheadLabel = [[UILabel alloc] init];
    _subheadLabel.font = [UIFont systemFontOfSize:12.0f];
    _subheadLabel.textColor = [UIColor colorWithRed:89/255.0 green:89/255.0 blue:89/255.0 alpha:1];
    [_cardView addSubview:_subheadLabel];
    
    _priceLabel = [[UILabel alloc] init];
    _priceLabel.textColor = [UIColor colorWithRed:255/255.0 green:107/255.0 blue:107/255.0 alpha:1];
    _priceLabel.font = [UIFont systemFontOfSize:14.0f];
    [_cardView addSubview:_priceLabel];
    
    _sendButton = [[UIButton alloc] init];
    [_sendButton setTitle:NSLocalizedString(@"button.send", nil) forState:UIControlStateNormal];
    [_sendButton setTitleColor:[UIColor colorWithRed:115/255.0 green:170/255.0 blue:234/255.0 alpha:1] forState:UIControlStateNormal];
    _sendButton.layer.borderWidth = 1;
    _sendButton.layer.borderColor = [[UIColor colorWithRed:115/255.0 green:170/255.0 blue:234/255.0 alpha:1] CGColor];
    _sendButton.layer.masksToBounds = YES;
    _sendButton.layer.cornerRadius = 25/2;
    _sendButton.titleLabel.font = [UIFont systemFontOfSize:15.0f];
    [_sendButton addTarget:self action:@selector(sendAction:) forControlEvents:UIControlEventTouchUpInside];
    [_cardView addSubview:_sendButton];
}

- (void)setData:(CustomMessage *)message avater:(NSString *)avater {
    self.message = message;
    _messageId = message._id;
    [super setData:message avater:avater];
    
    _cardView.frame = CGRectMake(0, CGRectGetMaxY(self.timeLabel.frame)+10, kScreenWidth, 150);
    
    if ([message.messageType isEqualToString:@"card"]) {

    [_imageView sd_setImageWithURL:[NSURL URLWithString:message.cardImage] placeholderImage:[UIImage imageNamed:@"qm_default_user"]];

    _headerLabel.text = message.cardHeader;
    
    CGFloat strHeight = [self calcLabelHeight:message.cardHeader font:[UIFont systemFontOfSize:15.0f] width:kScreenWidth - 90];
    _subheadLabel.text = message.cardSubhead;
    _priceLabel.text = message.cardPrice;

    _headerLabel.frame = CGRectMake(80, 10, kScreenWidth - 90, strHeight);
    _subheadLabel.frame = CGRectMake(80, CGRectGetMaxY(_headerLabel.frame)+5, kScreenWidth - 90, 20);
    _priceLabel.frame = CGRectMake(80, CGRectGetMaxY(_subheadLabel.frame)+10, kScreenWidth - 90, 20);
    _sendButton.frame = CGRectMake(kScreenWidth/2-40, CGRectGetMaxY(_priceLabel.frame)+10, 80, 25);
    }else if ([message.messageType isEqualToString:@"cardInfo_New"]) {
        NSData *jsonData = [message.cardInfo_New dataUsingEncoding:NSUTF8StringEncoding];
          NSError *err;
          NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:&err];
          if(err) {
              NSLog(@"json解析失败：%@",err);
              return;
          }
        NSDictionary *newCardInfoDic = dic;
        [_imageView sd_setImageWithURL:[NSURL URLWithString:newCardInfoDic[@"img"]] placeholderImage:[UIImage imageNamed:@"qm_default_user"]];
        _headerLabel.text = newCardInfoDic[@"title"];
        
        CGFloat strHeight = [self calcLabelHeight:newCardInfoDic[@"title"] font:[UIFont systemFontOfSize:15.0f] width:kScreenWidth - 90];
        _subheadLabel.text = newCardInfoDic[@"sub_title"];
        _priceLabel.text = newCardInfoDic[@"price"];
        _headerLabel.frame = CGRectMake(80, 10, kScreenWidth - 90, strHeight);
        _subheadLabel.frame = CGRectMake(80, CGRectGetMaxY(_headerLabel.frame)+5, kScreenWidth - 90, 20);
        _priceLabel.frame = CGRectMake(80, CGRectGetMaxY(_subheadLabel.frame)+10, kScreenWidth - 90, 20);
        _sendButton.frame = CGRectMake(kScreenWidth/2-40, CGRectGetMaxY(_priceLabel.frame)+10, 80, 25);
    }
}

- (void)sendAction: (UIButton *) button {
    if ([self.message.messageType isEqualToString:@"card"]) {
        NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
        [dic setObject:self.message.cardImage forKey:@"cardImage"];
        [dic setObject:self.message.cardHeader forKey:@"cardHeader"];
        [dic setObject:self.message.cardSubhead forKey:@"cardSubhead"];
        [dic setObject:self.message.cardPrice forKey:@"cardPrice"];
        [dic setObject:self.message.cardUrl forKey:@"cardUrl"];
        
        [QMConnect sendMsgCardInfo:dic successBlock:^{
            NSLog(@"发送商品信息成功");
        } failBlock:^{
            NSLog(@"发送失败");
        }];
    }else if ([self.message.messageType isEqualToString:@"cardInfo_New"]) {
        NSData *jsonData = [self.message.cardInfo_New dataUsingEncoding:NSUTF8StringEncoding];
          NSError *err;
          NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:&err];
          if(err) {
              NSLog(@"json解析失败：%@",err);
              return;
          }
        [QMConnect sendMsgCardInfo:dic successBlock:^{
            NSLog(@"发送商品信息成功");
        } failBlock:^{
            NSLog(@"发送失败");
        }];
    }
}

- (void)setCornerButton: (UIButton *) button {
    UIBezierPath * maskPath = [UIBezierPath bezierPathWithRoundedRect:button.bounds byRoundingCorners: UIRectCornerTopLeft | UIRectCornerBottomLeft | UIRectCornerTopRight | UIRectCornerBottomRight cornerRadii:CGSizeMake(20, 20)];
    CAShapeLayer * maskLayer = [[CAShapeLayer alloc] init];
    maskLayer.path = maskPath.CGPath;
    button.layer.mask = maskLayer;
}

- (CGFloat)calcLabelHeight: (NSString *)text font: (UIFont *)font width: (CGFloat)width {
    NSDictionary *attribute = @{NSFontAttributeName: font};
    CGRect labelRect = [text boundingRectWithSize:CGSizeMake(width, 40) options:NSStringDrawingUsesLineFragmentOrigin attributes:attribute context:nil];
    return labelRect.size.height;
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
