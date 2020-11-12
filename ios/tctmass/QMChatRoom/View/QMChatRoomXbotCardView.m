//
//  QMChatRoomXbotCardView.m
//  IMSDK-OC
//
//  Created by lishuijiao on 2019/12/24.
//  Copyright © 2019 HCF. All rights reserved.
//

#import "QMChatRoomXbotCardView.h"
#import "QMAlert.h"
#import <QMLineSDK/QMLineSDK.h>
#import "QMMoreCardView.h"
#import "JSONModel.h"
@implementation QMChatRoomXbotCardView {
    UILabel *_title;
    UIButton *_moreButton;
    UITableView *_tableView;
    NSArray *_dataSource;
    UIView *_boomView;
    UIView *_lineView1;
    UIView *_lineView2;
    NSDictionary *_msgDic;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self createUI];
    }
    return  self;
}

- (void)createUI {
    _title = [[UILabel alloc] init];
    _title.frame = CGRectMake(12, 12, CGRectGetWidth(self.frame), 21);
    _title.font = [UIFont systemFontOfSize:15];
    _title.textColor = [QMAlert colorWithHexString:@"#333333"];
    [self addSubview:_title];
    
    _lineView1 = [[UIView alloc] init];
    _lineView1.backgroundColor = [QMAlert colorWithHexString:@"#E6E6E6"];
    [self addSubview:_lineView1];
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 45, CGRectGetWidth(self.frame), 88*4 + 56) style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [_tableView registerClass:[QMChatRoomXbotCardShopCell class] forCellReuseIdentifier:@"xbotCardShopCell"];
    [_tableView registerClass:[QMChatRoomXbotCardListCell class] forCellReuseIdentifier:@"xbotCardListCell"];
    [self addSubview:_tableView];
    
    _lineView2 = [[UIView alloc] init];
    _lineView2.backgroundColor = [QMAlert colorWithHexString:@"#E6E6E6"];
    [self addSubview:_lineView2];

    _boomView = [[UIView alloc] init];
    _boomView.frame = CGRectMake(0, CGRectGetHeight(self.frame) - 40, CGRectGetWidth(self.frame), 40);
    [self addSubview:_boomView];
    
    _moreButton = [[UIButton alloc] initWithFrame:CGRectMake(12, 10, 70, 20)];
    _moreButton.titleLabel.font = [UIFont systemFontOfSize:14];
    [_moreButton setTitle:@"查看更多" forState:UIControlStateNormal];
    [_moreButton setTitleColor:[QMAlert colorWithHexString:@"#0D8BFF"] forState:UIControlStateNormal];
    [_moreButton addTarget:self action:@selector(moreAction:) forControlEvents:UIControlEventTouchUpInside];
    [_boomView addSubview:_moreButton];
}

- (void)setCardDic:(NSDictionary *)dic {
    _msgDic = dic;
    _title.frame = CGRectMake(22, 12, CGRectGetWidth(self.frame) - 44, 21);
    NSString *cardTitle = dic[@"data"][@"message"];
    _title.text = cardTitle.length > 0 ? cardTitle : @"";
    NSArray *cardList = dic[@"data"][@"list"];
    if (cardList.count > 0 && self.type == QMMessageCardTypeNone) {
        _boomView.hidden = NO;

        int shopNumber = 0;
        int listNumber = 0;
        
        for (NSDictionary *dic in cardList) {
            if ([dic[@"item_type"] isEqualToString:@"0"]) {
                listNumber += 1;
            }else if ([dic[@"item_type"] isEqualToString:@"1"]) {
                shopNumber += 1;
            }
        }
        
        _tableView.frame = CGRectMake(0, 45, CGRectGetWidth(self.frame), 88*listNumber + 72*shopNumber);
        _boomView.frame = CGRectMake(0, CGRectGetMaxY(_tableView.frame), CGRectGetWidth(self.frame), 40);

        _dataSource = cardList;
        [_tableView reloadData];
    } else {
        _tableView.frame = CGRectMake(0, 45, CGRectGetWidth(self.frame), 0);
        _boomView.hidden = YES;
        
        if (self.type == QMMessageCardTypeSeleced) {
            _boomView.frame = CGRectMake(0, CGRectGetHeight(self.frame) - 40, CGRectGetWidth(self.frame), 40);
            _boomView.hidden = NO;
            [_moreButton setTitle:@"重新选择" forState:UIControlStateNormal];
        }
    }
}

- (void)moreAction: (UIButton *)button {
    QMMoreCardView *moreView = [QMMoreCardView defualtView];
    [QMConnect changeAllCardMessageHidden];
    [QMConnect changeCardMessageType:QMMessageCardTypeSeleced messageId:self.messageId];

    NSDictionary *dict = @{@"current":_msgDic[@"current"],@"item":@{@"page":@"all",@"target":@"self"}};
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dict options:NSJSONWritingFragmentsAllowed error:nil];
    NSString *cardMessage = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    NSString * newStr = [cardMessage stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    NSCharacterSet *customAllowSet = [NSCharacterSet characterSetWithCharactersInString:@"=\"#%/<>?@\\^`{|}&+"].invertedSet;
    NSString *newString = [newStr stringByAddingPercentEncodingWithAllowedCharacters:customAllowSet];

    moreView.itemDict = @{@"msgTask": newString, @"Action": @"sdkGetXbotMsgTaskInfo", @"Message": @"查看更多商品信息"};
    [moreView show];
    
    __weak typeof(self)wSelf = self;
    moreView.selectItem = ^(NSDictionary * _Nonnull dict) {
        __strong typeof(wSelf)sSelf = wSelf;
        NSString *current = sSelf->_msgDic[@"current"];
        NSDictionary *params = dict[@"params"];
        NSMutableDictionary *itemDic = [NSMutableDictionary dictionary];
        [itemDic setValue:@"next" forKey:@"target"];
        [itemDic setValue:params forKey:@"params"];
        
        NSMutableDictionary *msg_task = [NSMutableDictionary dictionary];
        [msg_task setValue:current forKey:@"current"];
        [msg_task setValue:itemDic forKey:@"item"];
        
        NSDictionary *cardDic = @{@"msg_task": msg_task,
                                  @"shopList": dict
        };
        
        [wSelf selectItem:cardDic];
        
    };
    
//    [[NSNotificationCenter defaultCenter] postNotificationName:@"RefeashCardMessageView" object:nil];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (self.type == QMMessageCardTypeNone) {
        return _dataSource.count;
    } else if (self.type == QMMessageCardTypeSeleced) {
        return 0;
    } else {
        return 0;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *type = _dataSource[indexPath.row][@"item_type"];
    if ([type isEqual:@"1"]) {
        NSString *identifier = @"xbotCardShopCell";
        QMChatRoomXbotCardShopCell * cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        if (!cell) {
            cell = [[QMChatRoomXbotCardShopCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        }
        [cell setShopDataDic:_dataSource[indexPath.row] cellWidth:CGRectGetWidth(_tableView.frame)];
        return cell;
    }else if ([type isEqual:@"0"]) {
        NSString *identifier = @"xbotCardListCell";
        QMChatRoomXbotCardListCell * cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        if (!cell) {
            cell = [[QMChatRoomXbotCardListCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        }
        [cell setDataListDic:_dataSource[indexPath.row] cellWidth:CGRectGetWidth(_tableView.frame)];
        return cell;
    }
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *type = _dataSource[indexPath.row][@"item_type"];
    if ([type isEqual:@"1"]) {
        return 56+16;
    }else if ([type isEqual:@"0"]) {
        return 88;
    }else {
        return 0;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *type = _dataSource[indexPath.row][@"item_type"];
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
    if ([type isEqual:@"1"]) {
        
    } else if ([type isEqual:@"0"]) {
        [QMConnect changeCardMessageType:QMMessageCardTypeSeleced messageId:self.messageId];

        NSString *current = _msgDic[@"current"];
        NSDictionary *params = _dataSource[indexPath.row][@"params"];
        NSMutableDictionary *itemDic = [NSMutableDictionary dictionary];
        if (current.length > 0 && params.count > 0) {
            [itemDic setValue:@"next" forKey:@"target"];
            [itemDic setValue:params forKey:@"params"];
            
            [dic setValue:current forKey:@"current"];
            [dic setValue:itemDic forKey:@"item"];
            
            NSDictionary *cardDic = @{@"msg_task": dic,
                                      @"shopList": _dataSource[indexPath.row],
                                    };

            [self selectItem:cardDic];
        }
        
    } else {

    }

}

- (void)selectItem:(NSDictionary *)dict {
    [QMConnect sendMsgCardInfo:dict successBlock:^{
        NSLog(@"发送商品信息成功");
    } failBlock:^{
        NSLog(@"发送失败");
    }];
}

@end

@implementation QMChatRoomXbotCardShopCell {
    UIImageView *_shopImageView;
    UILabel *_shopName;
    UILabel *_shopstatus;
    UIView *_lineView;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self createUI];
    }
    return self;
}

- (void)createUI {
    _shopImageView = [[UIImageView alloc] initWithFrame:CGRectMake(12, 20, 24, 24)];
    [self addSubview:_shopImageView];
    
    _shopName = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_shopImageView.frame) + 8, 21, CGRectGetWidth(self.frame) - CGRectGetMaxX(_shopImageView.frame) - 8 - 80, 22)];
    _shopName.font = [UIFont systemFontOfSize:15];
    _shopName.textColor = [QMAlert colorWithHexString:@"#000000"];
    _shopName.textAlignment = NSTextAlignmentLeft;
    [self addSubview:_shopName];
    
    _shopstatus = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetWidth(self.frame) - 80, 25, 68, 16)];
    _shopstatus.font = [UIFont systemFontOfSize:14];
    _shopstatus.textColor = [QMAlert colorWithHexString:@"#FF6B6B"];
    _shopstatus.textAlignment = NSTextAlignmentRight;
    [self addSubview:_shopstatus];
    
    _lineView = [[UIView alloc] initWithFrame:CGRectMake(12, CGRectGetMaxY(_shopImageView.frame) + 12, CGRectGetWidth(self.frame) - 24, 1)];
    _lineView.backgroundColor = [QMAlert colorWithHexString:@"#E6E6E6"];
    [self addSubview:_lineView];

}

- (void)setShopDataDic:(NSDictionary *)dic cellWidth:(CGFloat)cellWidth {
    [_shopImageView sd_setImageWithURL:[NSURL URLWithString:dic[@"img"]] placeholderImage:[UIImage imageNamed:@"qm_default_user"]];
    _shopName.text = dic[@"title"];
    NSString *statusStr = dic[@"status"];
    if (statusStr.length > 0) {
        _shopstatus.text = statusStr;
    }else {
        _shopstatus.text = @"";
    }
    _shopstatus.frame = CGRectMake(cellWidth - 80, 25, 68, 16);
    _lineView.frame = CGRectMake(12, CGRectGetMaxY(_shopImageView.frame) + 12, cellWidth - 24, 1);

}

#pragma mark - 绘制Cell分割线
- (void)drawRect:(CGRect)rect {
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [UIColor clearColor].CGColor);
    CGContextFillRect(context, rect);
    //上分割线，
    CGContextSetStrokeColorWithColor(context, [QMAlert colorWithHexString:@"#EBEBEB"].CGColor);
    CGContextStrokeRect(context, CGRectMake(0, 0, rect.size.width, 1));
    //下分割线
//    CGContextSetStrokeColorWithColor(context, [QMAlert colorWithHexString:@"#EBEBEB"].CGColor);
//    CGContextStrokeRect(context, CGRectMake(0, rect.size.height, rect.size.width, 1));
}

@end

@implementation QMChatRoomXbotCardListCell {
    UIImageView *_listImageView;
    UILabel *_title;
    UILabel *_sub_title;
    UILabel *_price;
    UILabel *_attr_one;
    UILabel *_attr_two;
    UILabel *_other_title_one;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self createUI];
    }
    return self;
}

- (void)createUI {

    _listImageView = [[UIImageView alloc] initWithFrame:CGRectMake(12, 0, 72, 72)];
    [self addSubview:_listImageView];
    
    _title = [[UILabel alloc] initWithFrame:CGRectMake(92, 4, 126, 18)];
    _title.font = [UIFont systemFontOfSize:14];
    _title.textColor = [QMAlert colorWithHexString:@"#333333"];
    _title.textAlignment = NSTextAlignmentLeft;
    [self addSubview:_title];
    
    _price = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetWidth(self.frame) - 62, 4, 50, 18)];
    _price.font = [UIFont systemFontOfSize:14];
    _price.textColor = [QMAlert colorWithHexString:@"#333333"];
    _price.textAlignment = NSTextAlignmentRight;
    [self addSubview:_price];

    _sub_title = [[UILabel alloc] initWithFrame:CGRectMake(92, CGRectGetMaxY(_title.frame) + 5, 144, 18)];
    _sub_title.font = [UIFont systemFontOfSize:12];
    _sub_title.textColor = [QMAlert colorWithHexString:@"#666666"];
    _sub_title.textAlignment = NSTextAlignmentLeft;
    [self addSubview:_sub_title];

    _attr_one = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetWidth(self.frame) - 44, CGRectGetMaxY(_title.frame) + 5, 32, 18)];
    _attr_one.font = [UIFont systemFontOfSize:12];
    _attr_one.textColor = [QMAlert colorWithHexString:@"#666666"];
    _attr_one.textAlignment = NSTextAlignmentRight;
    [self addSubview:_attr_one];

    _other_title_one = [[UILabel alloc] initWithFrame:CGRectMake(92, CGRectGetMaxY(_sub_title.frame) + 10, 120, 16)];
    _other_title_one.font = [UIFont systemFontOfSize:12];
    _other_title_one.textColor = [QMAlert colorWithHexString:@"#999999"];
    _other_title_one.textAlignment = NSTextAlignmentLeft;
    [self addSubview:_other_title_one];
    
    _attr_two = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetWidth(self.frame) - 68, CGRectGetMaxY(_sub_title.frame) + 10, 56, 16)];
    _attr_two.font = [UIFont systemFontOfSize:12];
    _attr_two.textColor = [QMAlert colorWithHexString:@"#FF667A"];
    _attr_two.textAlignment = NSTextAlignmentRight;
    [self addSubview:_attr_two];

}

- (void)setDataListDic:(NSDictionary *)dic cellWidth:(CGFloat)cellWidth {
    [_listImageView sd_setImageWithURL:[NSURL URLWithString:dic[@"img"]] placeholderImage:[UIImage imageNamed:@"qm_default_user"]];
    _title.text = dic[@"title"];
    _price.text = dic[@"price"];
    _attr_two.text = dic[@"attr_two"][@"content"];
    NSString *subTitleStr = dic[@"sub_title"];
    NSString *attrOneStr = dic[@"attr_one"][@"content"];
    NSString *otherTitleStr = dic[@"other_title_one"];
    
    _sub_title.text = subTitleStr.length > 0 ? subTitleStr : @"";
    _attr_one.text = attrOneStr.length > 0 ? attrOneStr : @"";
    _other_title_one.text = otherTitleStr.length > 0 ? otherTitleStr : @"";
    

    _price.frame = CGRectMake(cellWidth - 62, 4, 50, 18);
    _sub_title.frame = CGRectMake(92, CGRectGetMaxY(_title.frame) + 5, 144, 18);
    _attr_one.frame = CGRectMake(cellWidth - 44, CGRectGetMaxY(_title.frame) + 5, 32, 18);
    _other_title_one.frame = CGRectMake(92, CGRectGetMaxY(_sub_title.frame) + 10, 120, 16);
    _attr_two.frame = CGRectMake(cellWidth - 68, CGRectGetMaxY(_sub_title.frame) + 10, 56, 16);

}

@end
