//
//  QMChatRoomNewCardCell.m
//  IMSDK-OC
//
//  Created by lishuijiao on 2019/12/19.
//  Copyright © 2019 HCF. All rights reserved.
//

#import "QMChatRoomNewCardCell.h"
#import "QMChatRoomShowRichTextController.h"
#import "QMAlert.h"

@implementation QMChatRoomNewCardCell {
    NSDictionary *_cardDic;
    
    NSString *_messageId;
    
    UIView *_newCardView;
    
    UILabel *_titleLabel;
    
    UILabel *_descriptionLabel;
        
    UIImageView *_imageView;
    
    UILabel *_attrOne;
    
    UILabel *_attrTwo;
    
    UILabel *_price;

    UILabel *_otherOne;
    
    UILabel *_otherTwo;

    UILabel *_otherThree;

}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self createUI];
    }
    return self;
}

- (void)createUI {
    _newCardView = [[UIView alloc] init];
    _newCardView.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width - 120, 110);
    _newCardView.clipsToBounds = YES;
    [self.contentView addSubview:_newCardView];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction:)];
    [_newCardView addGestureRecognizer:tap];
    
    _titleLabel = [[UILabel alloc] init];
    _titleLabel.frame = CGRectMake(10, 15, [UIScreen mainScreen].bounds.size.width - 180, 30);
    _titleLabel.font = [UIFont systemFontOfSize:14.0f];
    _titleLabel.numberOfLines = 2;
    [_newCardView addSubview:_titleLabel];
    
    _descriptionLabel = [[UILabel alloc] init];
    _descriptionLabel.frame = CGRectMake(10, _titleLabel.frame.size.height + 15, [UIScreen mainScreen].bounds.size.width - 250, 50);
    _descriptionLabel.numberOfLines = 0;
    _descriptionLabel.font = [UIFont systemFontOfSize:12.0f];
    _descriptionLabel.textColor = [UIColor colorWithRed:89/255.0 green:89/255.0 blue:89/255.0 alpha:1];
    [_newCardView addSubview:_descriptionLabel];
        
    _imageView = [[UIImageView alloc] init];
    _imageView.frame = CGRectMake( 10, 10, 80, 80);
    [_newCardView addSubview:_imageView];
    
    _attrOne = [[UILabel alloc] init];
    _attrOne.font = [UIFont systemFontOfSize:12.0f];
    _attrOne.textColor = [UIColor colorWithRed:102/255.0 green:102/255.0 blue:102/255.0 alpha:1];
    [_newCardView addSubview:_attrOne];

    _attrTwo = [[UILabel alloc] init];
    _attrTwo.font = [UIFont systemFontOfSize:12.0f];
    _attrTwo.textColor = [UIColor colorWithRed:102/255.0 green:102/255.0 blue:102/255.0 alpha:1];
    [_newCardView addSubview:_attrTwo];

    _price = [[UILabel alloc] init];
    _price.font = [UIFont systemFontOfSize:12.0f];
    _price.textColor = [UIColor colorWithRed:102/255.0 green:102/255.0 blue:102/255.0 alpha:1];
    [_newCardView addSubview:_price];

    _otherOne = [[UILabel alloc] init];
    _otherOne.font = [UIFont systemFontOfSize:12.0f];
    _otherOne.textColor = [UIColor colorWithRed:102/255.0 green:102/255.0 blue:102/255.0 alpha:1];
    [_newCardView addSubview:_otherOne];

    _otherTwo = [[UILabel alloc] init];
    _otherTwo.font = [UIFont systemFontOfSize:12.0f];
    _otherTwo.textColor = [UIColor colorWithRed:102/255.0 green:102/255.0 blue:102/255.0 alpha:1];
    [_newCardView addSubview:_otherTwo];

    _otherThree = [[UILabel alloc] init];
    _otherThree.font = [UIFont systemFontOfSize:12.0f];
    _otherThree.textColor = [UIColor colorWithRed:102/255.0 green:102/255.0 blue:102/255.0 alpha:1];
    [_newCardView addSubview:_otherThree];

}

- (void)setData:(CustomMessage *)message avater:(NSString *)avater {
    self.message = message;
    _messageId = message._id;
    [super setData:message avater:avater];
    

    NSData *jsonData = [message.cardMessage_New dataUsingEncoding:NSUTF8StringEncoding];
    NSError *err;
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:&err];
    if(err) {
        NSLog(@"json解析失败：%@",err);
        return;
    }

    _cardDic = dic;
    
    _imageView.hidden = NO;
    _imageView.frame = CGRectMake(10, 10, 80, 80);
    [_imageView sd_setImageWithURL:[NSURL URLWithString:dic[@"img"]] placeholderImage:[UIImage imageNamed:@"qm_default_user"]];

    NSString *otherTitleOne = dic[@"other_title_one"];
    NSString *otherTitleTwo = dic[@"other_title_two"];
    NSString *otherTitleThree = dic[@"other_title_three"];
    
    if (otherTitleOne.length > 0) {
        _otherOne.text = otherTitleOne;
        _otherOne.frame = CGRectMake(10, CGRectGetMaxY(_imageView.frame) + 10, CGRectGetMaxX(_newCardView.frame) - 20, 15);
    }else {
        _otherOne.frame = CGRectMake(10, CGRectGetMaxY(_imageView.frame) + 10, CGRectGetMaxX(_newCardView.frame) - 20, 0);
    }
    if (otherTitleTwo.length > 0) {
        _otherTwo.text = otherTitleTwo;
        _otherTwo.frame = CGRectMake(10, CGRectGetMaxY(_otherOne.frame) + 5, CGRectGetMaxX(_newCardView.frame) - 20, 15);
    }else {
        _otherTwo.frame = CGRectMake(10, CGRectGetMaxY(_otherOne.frame), CGRectGetMaxX(_newCardView.frame) - 20, 0);
    }
    if (otherTitleThree.length > 0) {
        _otherThree.text = otherTitleThree;
        _otherThree.frame = CGRectMake(10, CGRectGetMaxY(_otherTwo.frame) + 5, CGRectGetMaxX(_newCardView.frame) - 20, 15);
    }else {
        _otherThree.frame = CGRectMake(10, CGRectGetMaxY(_otherTwo.frame), CGRectGetMaxX(_newCardView.frame) - 20, 0);
    }

    if ([message.fromType isEqualToString:@"1"]) {
        NSString *price = dic[@"price"];
        NSString *attrOne = dic[@"attr_one"][@"content"];
        NSString *attrTwo = dic[@"attr_two"][@"content"];

        BOOL isTwoLine = NO;
        BOOL isThreeLine = NO;
        
        _titleLabel.text = dic[@"title"];
        CGFloat strHeight = [QMAlert calculateRowHeight:dic[@"title"] fontSize:14.0 Width:kScreenWidth - 225];
        
        if (price.length > 0 || attrTwo.length > 0) {
            isThreeLine = YES;
            _titleLabel.numberOfLines = 1;
            _titleLabel.frame = CGRectMake(100, 15, [UIScreen mainScreen].bounds.size.width - 225, 20);
        }else {
            _titleLabel.numberOfLines = 2;
            _titleLabel.frame = CGRectMake(100, 15, [UIScreen mainScreen].bounds.size.width - 225, strHeight > 35 ? 35 : strHeight);
        }
        
        if (attrOne.length > 0) {
            isTwoLine = YES;
            _attrOne.text = attrOne;
            _attrOne.frame = CGRectMake([UIScreen mainScreen].bounds.size.width - 145, CGRectGetMaxY(_titleLabel.frame) + 5, 25, 15);
        }else {
            _attrOne.text = @"";
        }
        
        NSString *sub_Title = dic[@"sub_title"];
        if (sub_Title.length > 0) {
            _descriptionLabel.text = sub_Title;
        }else {
            _descriptionLabel.text = @"";
        }
        CGFloat subStrHeight = [QMAlert calculateRowHeight:sub_Title fontSize:12.0 Width:kScreenWidth - 245];
        if (isThreeLine && isTwoLine) {
            _descriptionLabel.numberOfLines = 1;
            _descriptionLabel.frame = CGRectMake(100, CGRectGetMaxY(_titleLabel.frame) + 5, [UIScreen mainScreen].bounds.size.width - 245, 15);
        }else if (isTwoLine && !isThreeLine) {
            _descriptionLabel.numberOfLines = 2;
            _descriptionLabel.frame = CGRectMake(100, CGRectGetMaxY(_titleLabel.frame) + 5, [UIScreen mainScreen].bounds.size.width - 245, subStrHeight > 30 ? 30 : subStrHeight);
        }else if (!isTwoLine && isThreeLine) {
            _descriptionLabel.numberOfLines = 1;
            _descriptionLabel.frame = CGRectMake(100, CGRectGetMaxY(_titleLabel.frame) + 5, [UIScreen mainScreen].bounds.size.width - 225, 15);
        }else {
            subStrHeight = [QMAlert calculateRowHeight:sub_Title fontSize:12.0 Width:kScreenWidth - 225];
            _descriptionLabel.numberOfLines = 2;
            _descriptionLabel.frame = CGRectMake(100, CGRectGetMaxY(_titleLabel.frame) + 5, [UIScreen mainScreen].bounds.size.width - 225, subStrHeight > 30 ? 30 : subStrHeight);
        }
        
        if (price.length > 0) {
            _price.text = price;
            _price.frame = CGRectMake(100, CGRectGetMaxY(_descriptionLabel.frame) + 10, 72, 15);
        }else {
            _price.text = @"";
            _price.frame = CGRectMake(100, CGRectGetMaxY(_descriptionLabel.frame), 72, 0);
        }

        if (attrTwo.length > 0) {
            _attrTwo.text = attrTwo;
            _attrTwo.frame = CGRectMake([UIScreen mainScreen].bounds.size.width - 160, CGRectGetMaxY(_descriptionLabel.frame) + 10, 40, 15);
        }else {
            _attrTwo.text = @"";
            _attrTwo.frame = CGRectMake([UIScreen mainScreen].bounds.size.width - 160, CGRectGetMaxY(_descriptionLabel.frame), 40, 0);
        }

        _newCardView.frame = CGRectMake(CGRectGetMaxX(self.iconImage.frame)+5, CGRectGetMaxY(self.timeLabel.frame)+5, [UIScreen mainScreen].bounds.size.width - 120, CGRectGetMaxY(_otherThree.frame) > 100 ? CGRectGetMaxY(_otherThree.frame) + 10 : 100);
        self.chatBackgroudImage.frame = CGRectMake(CGRectGetMaxX(self.iconImage.frame)+5, CGRectGetMaxY(self.timeLabel.frame)+5, [UIScreen mainScreen].bounds.size.width - 120, CGRectGetMaxY(_otherThree.frame) > 100 ? CGRectGetMaxY(_otherThree.frame) + 10 : 100);
    }else {
        _titleLabel.text = dic[@"title"];
        NSString *sub_Title = dic[@"sub_title"];
        NSString *price = dic[@"price"];
        NSString *attrOne = dic[@"attr_one"][@"content"];
        NSString *attrTwo = dic[@"attr_two"][@"content"];
        NSString *itemType = dic[@"item_type"];
        if (itemType.length > 0) {
//            CGFloat strHeight = [QMAlert calculateRowHeight:dic[@"title"] fontSize:14.0 Width:kScreenWidth - 225 - 60];
            _titleLabel.numberOfLines = 1;
            _titleLabel.frame = CGRectMake(100, 10, [UIScreen mainScreen].bounds.size.width - 225 - 60, 18);
            
            if (price.length > 0) {
                _price.text = price;
                _price.textAlignment = NSTextAlignmentRight;
                _price.frame = CGRectMake(CGRectGetMaxX(_titleLabel.frame), 10, 60, 18);
            }else {
                _price.text = @"";
            }
            
            if (sub_Title.length > 0) {
                _descriptionLabel.text = sub_Title;
//                CGFloat subStrHeight = [QMAlert calculateRowHeight:sub_Title fontSize:12.0 Width:kScreenWidth - 225 - 40];
                _descriptionLabel.frame = CGRectMake(100, CGRectGetMaxY(_titleLabel.frame) + 5, [UIScreen mainScreen].bounds.size.width - 225 - 40, 18);
            }else {
                _descriptionLabel.text = @"";
                _descriptionLabel.frame = CGRectMake(100, CGRectGetMaxY(_titleLabel.frame) + 5, [UIScreen mainScreen].bounds.size.width - 225 - 40, 18);
            }
            
            if (attrOne.length > 0) {
                _attrOne.text = attrOne;
                _attrOne.textAlignment = NSTextAlignmentRight;
                _attrOne.frame = CGRectMake(CGRectGetMaxX(_descriptionLabel.frame), CGRectGetMaxY(_titleLabel.frame) + 5, 40, 18);
                NSString *color = dic[@"attr_one"][@"color"];
                if (color.length > 0) {
                    _attrOne.textColor = QMHEXSRGB(color);
                }
            }else {
                _attrOne.text = @"";
            }
            
            NSString *otherTitleOne = dic[@"other_title_one"];
            if (otherTitleOne.length > 0) {
                _otherOne.text = otherTitleOne;
                _otherOne.frame = CGRectMake(100, CGRectGetMaxY(_descriptionLabel.frame) + 5, [UIScreen mainScreen].bounds.size.width - 225 - 50, 16);
            }else {
                _otherOne.frame = CGRectMake(100, CGRectGetMaxY(_imageView.frame) + 10, [UIScreen mainScreen].bounds.size.width - 225 - 50, 16);
            }
            
            if (attrTwo.length > 0) {
                _attrTwo.text = attrTwo;
                _attrTwo.textAlignment = NSTextAlignmentRight;
                _attrTwo.frame = CGRectMake(CGRectGetMaxX(_otherOne.frame), CGRectGetMaxY(_descriptionLabel.frame) + 5, 50, 16);
                NSString *color = dic[@"attr_two"][@"color"];
                if (color.length > 0) {
                    _attrTwo.textColor = QMHEXSRGB(color);
                }
            }else {
                _attrTwo.text = @"";
            }

            _newCardView.frame = CGRectMake(60, CGRectGetMaxY(self.timeLabel.frame)+5, [UIScreen mainScreen].bounds.size.width - 120, 100);
            self.chatBackgroudImage.frame = CGRectMake(60, CGRectGetMaxY(self.timeLabel.frame)+5, [UIScreen mainScreen].bounds.size.width - 120, 100);
            UIImage *image = [UIImage imageNamed:@"SenderCardNodeBkg"];
            self.chatBackgroudImage.image = image;
            self.chatBackgroudImage.image = [self.chatBackgroudImage.image stretchableImageWithLeftCapWidth:20 topCapHeight:20];
        }else {
        
        CGFloat strHeight = [QMAlert calculateRowHeight:dic[@"title"] fontSize:14.0 Width:kScreenWidth - 225];
        _titleLabel.frame = CGRectMake(100, 10, [UIScreen mainScreen].bounds.size.width - 225, strHeight > 35 ? 35 : strHeight);
        if (sub_Title.length > 0) {
            _descriptionLabel.text = sub_Title;
            CGFloat subStrHeight = [QMAlert calculateRowHeight:sub_Title fontSize:12.0 Width:kScreenWidth - 225];
            _descriptionLabel.frame = CGRectMake(100, CGRectGetMaxY(_titleLabel.frame) + 5, [UIScreen mainScreen].bounds.size.width - 225, subStrHeight > 30 ? 30 : subStrHeight);
        }else {
            _descriptionLabel.text = @"";
            _descriptionLabel.frame = CGRectMake(100, CGRectGetMaxY(_titleLabel.frame) + 5, [UIScreen mainScreen].bounds.size.width - 225, 15);
        }

        _newCardView.frame = CGRectMake(60, CGRectGetMaxY(self.timeLabel.frame)+5, [UIScreen mainScreen].bounds.size.width - 120, CGRectGetMaxY(_otherThree.frame) > 100 ? CGRectGetMaxY(_otherThree.frame) + 10 : 100);
        self.chatBackgroudImage.frame = CGRectMake(60, CGRectGetMaxY(self.timeLabel.frame)+5, [UIScreen mainScreen].bounds.size.width - 120, CGRectGetMaxY(_otherThree.frame) > 100 ? CGRectGetMaxY(_otherThree.frame) + 10 : 100);
        UIImage *image = [UIImage imageNamed:@"SenderCardNodeBkg"];
        self.chatBackgroudImage.image = image;
        self.chatBackgroudImage.image = [self.chatBackgroudImage.image stretchableImageWithLeftCapWidth:20 topCapHeight:20];
        }
    }
}

- (void)tapAction:(UITapGestureRecognizer *)gestureRecognizer {
    QMChatRoomShowRichTextController * showWebVC = [[QMChatRoomShowRichTextController alloc] init];
    NSString *urlStr = _cardDic[@"target"];
    if (urlStr.length > 0) {
        showWebVC.urlStr = urlStr;
    }else {
        return;
    }
    showWebVC.modalPresentationStyle = UIModalPresentationFullScreen;
    [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:showWebVC animated:true completion:nil];
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
