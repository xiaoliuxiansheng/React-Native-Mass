//
//  QMChatRoomRobotFlowCell.m
//  IMSDK-OC
//
//  Created by lishuijiao on 2019/8/29.
//  Copyright © 2019 HCF. All rights reserved.
//

#import "QMChatRoomRobotFlowCell.h"
#import "QMFlowView.h"
#import "QMTextModel.h"
#import "QMAlert.h"

@implementation QMChatRoomRobotFlowCell {
    
    UILabel *_headerLabel;
    
    UIScrollView *_scrollView;
    
    UICollectionView *_collectionView;
    
    QMFlowView *flowView;
    
    NSString *_flowTip;
    
    BOOL flowStyle;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self createUI];
    }
    return self;
}

- (void)createUI {
    
    flowView = [[QMFlowView alloc] init];
    flowView.frame = CGRectMake(CGRectGetMaxX(self.iconImage.frame)+5, CGRectGetMaxY(self.timeLabel.frame)+10, kScreenWidth - 150, 300);
    [self.contentView addSubview:flowView];
    
}

- (void)setData:(CustomMessage *)message avater:(NSString *)avater {
    self.message = message;
    [super setData:message avater:avater];
    if ([message.fromType isEqualToString:@"0"]) {
        
    }else {
        NSString *robotFlowTip = message.robotFlowTip;
        _flowTip = message.robotFlowTip;
        message.robotFlowTip = [message.robotFlowTip stringByReplacingOccurrencesOfString:@"<p>" withString:@""];
        message.robotFlowTip = [message.robotFlowTip stringByReplacingOccurrencesOfString:@"</p>" withString:@""];
        message.robotFlowTip = [message.robotFlowTip stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        //html标签替换
//        CGFloat titleHeight = [QMTextModel calcRobotHeight: robotFlowTip];
        CGFloat titleHeight = [QMTextModel calcxbotRobotHeight:robotFlowTip textWidth:[UIScreen mainScreen].bounds.size.width - 240];
        NSRegularExpression *regularExpretion = [[NSRegularExpression alloc] initWithPattern:@"<[^>]*>" options:NSRegularExpressionCaseInsensitive error:nil];
        message.robotFlowTip = [regularExpretion stringByReplacingMatchesInString:message.robotFlowTip options:NSMatchingReportProgress range:NSMakeRange(0, message.robotFlowTip.length) withTemplate:@""];
        
        NSMutableArray * arr = [QMTextModel dictionaryWithJsonString:self.message.robotFlowList];
        CGFloat messageHeight = 0;
        
        if ([message.robotFlowsStyle isEqualToString:@"1"]) {
            if (arr.count < 4) {
                messageHeight = 25+titleHeight+30+arr.count*50;
            }else {
                messageHeight = 265 + titleHeight;
            }
        }else {
            if (arr.count < 7) {
                if (arr.count%2 == 0) {
                    messageHeight = 25+titleHeight+30+ceil(arr.count/2)*50;
                }else {
                    messageHeight = 25+titleHeight+30+ceil(arr.count/2+1)*50;
                }
            }else {
                messageHeight = 265 + titleHeight;
            }
        }
        
        self.chatBackgroudImage.frame = CGRectMake(CGRectGetMaxX(self.iconImage.frame)+5, CGRectGetMaxY(self.timeLabel.frame)+10, 260, messageHeight);

        flowView.frame = CGRectMake(CGRectGetMaxX(self.iconImage.frame)+5, CGRectGetMaxY(self.timeLabel.frame)+10, 260, messageHeight);
        flowView.flowList = self.message.robotFlowList;
        flowView.robotFlowTip = robotFlowTip;
        if (message.robotFlowsStyle == nil || [message.robotFlowsStyle isEqualToString:@"0"] || [message.robotFlowsStyle isEqualToString:@"null"]) {
            flowView.isVertical = NO;
        }else {
            flowView.isVertical = YES;
        }
        __weak typeof(self) weakSelf = self;
        flowView.selectAction = ^(NSDictionary * dic) {
            dispatch_async(dispatch_get_main_queue(), ^{
                weakSelf.tapSendMessage(dic[@"text"], @"");
            });
        };
        flowView.tapFlowNumberAction = ^(NSString * _Nonnull number) {
            dispatch_async(dispatch_get_main_queue(), ^{
                weakSelf.tapNumberAction(number);
            });
        };
        [flowView setDate];
        message.robotFlowTip = _flowTip;
    }
}


#pragma mark 文本处理
- (NSMutableArray *)showHtml: (NSString *)htmlString {

    htmlString = [htmlString stringByReplacingOccurrencesOfString:@"<br>" withString:@"\n"];
    htmlString = [htmlString stringByReplacingOccurrencesOfString:@"</br>" withString:@"\n"];
    htmlString = [htmlString stringByReplacingOccurrencesOfString:@"</p>" withString:@"\n"];
    // 拆分文本和图片
    __block NSString *tempString = htmlString;
    __block NSMutableArray *srcArr = [NSMutableArray array];
    
    NSRegularExpression *regularExpretion = [[NSRegularExpression alloc] initWithPattern:@"<[^>]*>" options:NSRegularExpressionCaseInsensitive error:nil];
    [regularExpretion enumerateMatchesInString:htmlString options:NSMatchingReportProgress range:NSMakeRange(0, [htmlString length]) usingBlock:^(NSTextCheckingResult * _Nullable result, NSMatchingFlags flags, BOOL * _Nonnull stop) {
        if (result.range.length != 0) {
            // 字符串
            NSString *actionString = [NSString stringWithFormat:@"%@",[htmlString substringWithRange:result.range]];
            
            // 新的range
            NSRange range = [tempString rangeOfString:actionString];
            
            NSArray *components = nil;
            if ([actionString rangeOfString:@"<img src=\""].location != NSNotFound) {
                components = [actionString componentsSeparatedByString:@"src=\""];
            }else if ([actionString rangeOfString:@"<img src="].location != NSNotFound) {
                components = [actionString componentsSeparatedByString:@"src="];
            }

            if (components.count >= 2) {
                // 文本内容
                QMTextModel *model1 = [[QMTextModel alloc] init];
                model1.type = @"text";
                model1.content = [tempString substringToIndex:range.location];
                [srcArr addObject:model1];
                
                // 图片内容
                QMTextModel *model2 = [[QMTextModel alloc] init];
                model2.type = @"image";
                model2.content = [tempString substringWithRange:range];;
                [srcArr addObject:model2];
                tempString = [tempString substringFromIndex:range.location+range.length];
            }
        }
    }];
    
    QMTextModel *model3 = [[QMTextModel alloc] init];
    model3.type = @"text";
    model3.content = tempString;
    [srcArr addObject:model3];
    return srcArr;
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
