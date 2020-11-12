//
//  QMChatRoomRichTextCell.m
//  IMSDK-OC
//
//  Created by lishuijiao on 2018/3/8.
//  Copyright © 2018年 HCF. All rights reserved.
//

#import "QMChatRoomRichTextCell.h"
#import "QMChatRoomShowRichTextController.h"
#import "QMAlert.h"

/**
 富文本消息
 */
@interface QMChatRoomRichTextCell() <MLEmojiLabelDelegate>

@end

@implementation QMChatRoomRichTextCell
{
    NSString *_messageId;
    
    UIView *_richView;
    
    UILabel *_titleLabel;
    
    UILabel *_descriptionLabel;
    
    UILabel *_price;
    
    UIImageView *_imageView;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self createUI];
    }
    return self;
}

- (void)createUI {
    _richView = [[UIView alloc] init];
    _richView.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width - 160, 110);
    _richView.clipsToBounds = YES;
    [self.contentView addSubview:_richView];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction:)];
    [_richView addGestureRecognizer:tap];
    
    _titleLabel = [[UILabel alloc] init];
    _titleLabel.frame = CGRectMake(10, 10, [UIScreen mainScreen].bounds.size.width - 180, 30);
    _titleLabel.font = [UIFont systemFontOfSize:15.0f];
    _titleLabel.numberOfLines = 2;
    [_richView addSubview:_titleLabel];
    
    _descriptionLabel = [[UILabel alloc] init];
    _descriptionLabel.frame = CGRectMake(10, _titleLabel.frame.size.height + 15, [UIScreen mainScreen].bounds.size.width - 250, 50);
    _descriptionLabel.numberOfLines = 0;
    _descriptionLabel.font = [UIFont systemFontOfSize:12.0f];
    _descriptionLabel.textColor = [UIColor colorWithRed:89/255.0 green:89/255.0 blue:89/255.0 alpha:1];
    [_richView addSubview:_descriptionLabel];
    
    _price = [[UILabel alloc] init];
    _price.font = [UIFont systemFontOfSize:12.0f];
    _price.textColor = [UIColor colorWithRed:255/255.0 green:107/255.0 blue:107/255.0 alpha:1];
    [_richView addSubview:_price];
    
    _imageView = [[UIImageView alloc] init];
    _imageView.frame = CGRectMake( _descriptionLabel.frame.size.width+20, _titleLabel.frame.size.height + 15, 60, 50);
    [_richView addSubview:_imageView];
}

- (void)setData:(CustomMessage *)message avater:(NSString *)avater {
    self.message = message;
    _messageId = message._id;
    [super setData:message avater:avater];
    
    if ([message.fromType isEqualToString:@"1"]) {
        
        _titleLabel.textColor = [UIColor blackColor];
        self.chatBackgroudImage.frame = CGRectMake(CGRectGetMaxX(self.iconImage.frame)+5, CGRectGetMaxY(self.timeLabel.frame)+10, [UIScreen mainScreen].bounds.size.width - 160, 110);
        _richView.frame = CGRectMake(CGRectGetMaxX(self.iconImage.frame)+5, CGRectGetMaxY(self.timeLabel.frame)+5, [UIScreen mainScreen].bounds.size.width - 160, 120);
        _titleLabel.text = message.richTextTitle;
        
        if (_titleLabel.text != nil) {
            CGFloat height = [self calculateRowHeight:_titleLabel.text fontSize:15];
            if (height > 20) {
                _titleLabel.frame = CGRectMake(10, 10, [UIScreen mainScreen].bounds.size.width - 180, 40);
                _imageView.frame = CGRectMake( [UIScreen mainScreen].bounds.size.width - 230, _titleLabel.frame.size.height + 15, 60, 50);
                _descriptionLabel.frame = CGRectMake(10, _titleLabel.frame.size.height + 15, [UIScreen mainScreen].bounds.size.width - 250, 50);
            }
            NSMutableAttributedString *content = [[NSMutableAttributedString alloc]initWithString:_titleLabel.text];
            NSRange range = NSMakeRange(0, content.length);
            [content addAttribute:NSUnderlineStyleAttributeName value:[NSNumber numberWithInteger:NSUnderlineStyleSingle] range:range];
            _titleLabel.attributedText = content;
        }
        _descriptionLabel.text = message.richTextDescription;
        
        if ([message.richTextPicUrl  isEqual: @""]) {
            _descriptionLabel.frame = CGRectMake(10, _titleLabel.frame.size.height + 15, [UIScreen mainScreen].bounds.size.width - 180, 50);
            _imageView.hidden = YES;
        }else{
            _descriptionLabel.frame = CGRectMake(10, _titleLabel.frame.size.height + 15, [UIScreen mainScreen].bounds.size.width - 250, 50);
            _imageView.hidden = NO;
            [_imageView sd_setImageWithURL:[NSURL URLWithString:message.richTextPicUrl] placeholderImage:[UIImage imageNamed:@""]];
        }
        [_descriptionLabel sizeToFit];
    }else{
        
        self.sendStatus.frame = CGRectMake(CGRectGetMinX(self.chatBackgroudImage.frame)-25, CGRectGetMinY(self.chatBackgroudImage.frame)+15, 20, 20);
        
        _richView.frame = CGRectMake(60, CGRectGetMaxY(self.timeLabel.frame)+5, [UIScreen mainScreen].bounds.size.width - 120, 80);
        
        self.chatBackgroudImage.frame = CGRectMake(60, CGRectGetMaxY(self.timeLabel.frame)+5, [UIScreen mainScreen].bounds.size.width - 120, 80);
        _titleLabel.text = message.cardHeader;
        if (message.cardSubhead != nil) {
            _descriptionLabel.text = message.cardSubhead;
        }
        if (message.cardPrice != nil) {
            _price.text = message.cardPrice;
        }
        
        if ([message.cardImage  isEqual: @""]) {
            _titleLabel.frame = CGRectMake(10, 10, [UIScreen mainScreen].bounds.size.width - 140, 25);
            _descriptionLabel.frame = CGRectMake(10, CGRectGetMaxY(_titleLabel.frame) + 5, [UIScreen mainScreen].bounds.size.width - 140, 15);
            _price.frame = CGRectMake(10, CGRectGetMaxY(_descriptionLabel.frame) + 5, [UIScreen mainScreen].bounds.size.width - 140, 15);
        }else{
            _imageView.frame = CGRectMake(10, 10, 60, 60);
            _titleLabel.frame = CGRectMake(80, 10, [UIScreen mainScreen].bounds.size.width - 200, 25);
            _descriptionLabel.frame = CGRectMake(80, CGRectGetMaxY(_titleLabel.frame) + 5, [UIScreen mainScreen].bounds.size.width - 220, 15);
            _price.frame = CGRectMake(80, CGRectGetMaxY(_descriptionLabel.frame) + 5, [UIScreen mainScreen].bounds.size.width - 220, 15);
            _imageView.hidden = NO;
            [_imageView sd_setImageWithURL:[NSURL URLWithString:message.cardImage] placeholderImage:[UIImage imageNamed:@""]];
        }
        UIImage *image = [UIImage imageNamed:@"SenderCardNodeBkg"];
        self.chatBackgroudImage.image = image;
        self.chatBackgroudImage.image = [self.chatBackgroudImage.image stretchableImageWithLeftCapWidth:20 topCapHeight:20];
    }
}

- (void)tapAction:(UITapGestureRecognizer *)gestureRecognizer {
    NSLog(@"点击富文本");
    QMChatRoomShowRichTextController * showWebVC = [[QMChatRoomShowRichTextController alloc] init];
    if ([self.message.fromType isEqualToString:@"1"]) {
        showWebVC.urlStr = self.message.richTextUrl;
    }else{
        showWebVC.urlStr = self.message.cardUrl;
    }
    showWebVC.modalPresentationStyle = UIModalPresentationFullScreen;
    [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:showWebVC animated:true completion:nil];
}

- (CGFloat)calculateRowHeight:(NSString *)string fontSize:(NSInteger)fontSize {
    NSDictionary *dic = @{NSFontAttributeName:[UIFont systemFontOfSize:fontSize]};//指定字号
    CGRect rect = [string boundingRectWithSize:CGSizeMake([UIScreen mainScreen].bounds.size.width - 180, 0)/*计算高度要先指定宽度*/ options:NSStringDrawingUsesLineFragmentOrigin |
                   NSStringDrawingUsesFontLeading attributes:dic context:nil];
    return rect.size.height;
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
