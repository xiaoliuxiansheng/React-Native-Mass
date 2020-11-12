//
//  QMChatRoomInvestigateCell.m
//  IMSDK-OC
//
//  Created by HCF on 16/3/11.
//  Copyright © 2016年 HCF. All rights reserved.
//

#import "QMChatRoomInvestigateCell.h"
#import <QMLineSDK/QMLineSDK.h>

@implementation QMChatRoomInvestigateCell
{
    UIView *_backgrounView;
    
    UILabel *_warnLabel;
    
    NSArray *_investigateArray;
    
    UILabel *_investigateLabel;
    
    UILabel *_investigateValue;
    
    UIButton *_submitButton;
    
    UIButton *_valueButtonOne;
    UIButton *_valueButtonTwo;
    UIButton *_valueButtonThree;
    UIButton *_valueButtonFour;
    UIButton *_valueButtonFive;
    
    NSString *_messageId;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self createUI];
    }
    return self;
}

- (void)createUI {    
    _backgrounView = [[UIView alloc] init];
    _backgrounView.frame = CGRectMake(30, 5, kScreenWidth-60, 140);
    _backgrounView.backgroundColor = [UIColor whiteColor];
    _backgrounView.layer.borderColor = [[UIColor lightGrayColor] CGColor];
    _backgrounView.layer.borderWidth = 0.5;
    [self.contentView addSubview:_backgrounView];
    
    _warnLabel = [[UILabel alloc] init];
    _warnLabel.frame = CGRectMake(10, 5, kScreenWidth-80, 60);
    _warnLabel.numberOfLines = 0;
    _warnLabel.font = [UIFont systemFontOfSize:15];
    _warnLabel.text = @"[邀评]系统提示：“为了提高服务质量，请您在咨询结束后，点击五角星对客服的服务进行评价，谢谢！”";
    [_backgrounView addSubview:_warnLabel];
    
    _investigateLabel = [[UILabel alloc] init];
    _investigateLabel.frame = CGRectMake(10, 100, 180, 30);
    [_backgrounView addSubview:_investigateLabel];
    
    _investigateValue = [[UILabel alloc] init];
    
    _valueButtonOne = [UIButton buttonWithType:UIButtonTypeCustom];
    _valueButtonOne.frame = CGRectMake(0, 60, 40, 40);
    _valueButtonOne.tag = 1;
    _valueButtonOne.selected = YES;
    [_valueButtonOne setBackgroundImage:[UIImage imageNamed:@"contactflag_star_nor"] forState:UIControlStateNormal];
    [_valueButtonOne setBackgroundImage:[UIImage imageNamed:@"contactflag_star_select"] forState:UIControlStateSelected];
    [_valueButtonOne addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
    
    _valueButtonTwo = [UIButton buttonWithType:UIButtonTypeCustom];
    _valueButtonTwo.frame = CGRectMake(40, 60, 40, 40);
    _valueButtonTwo.tag = 2;
    _valueButtonTwo.selected = YES;
    [_valueButtonTwo setBackgroundImage:[UIImage imageNamed:@"contactflag_star_nor"] forState:UIControlStateNormal];
    [_valueButtonTwo setBackgroundImage:[UIImage imageNamed:@"contactflag_star_select"] forState:UIControlStateSelected];
    [_valueButtonTwo addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
    
    _valueButtonThree = [UIButton buttonWithType:UIButtonTypeCustom];
    _valueButtonThree.frame = CGRectMake(80, 60, 40, 40);
    _valueButtonThree.tag = 3;
    _valueButtonThree.selected = YES;
    [_valueButtonThree setBackgroundImage:[UIImage imageNamed:@"contactflag_star_nor"] forState:UIControlStateNormal];
    [_valueButtonThree setBackgroundImage:[UIImage imageNamed:@"contactflag_star_select"] forState:UIControlStateSelected];
    [_valueButtonThree addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
    
    _valueButtonFour = [UIButton buttonWithType:UIButtonTypeCustom];
    _valueButtonFour.frame = CGRectMake(120, 60, 40, 40);
    _valueButtonFour.tag = 4;
    [_valueButtonFour setBackgroundImage:[UIImage imageNamed:@"contactflag_star_nor"] forState:UIControlStateNormal];
    [_valueButtonFour setBackgroundImage:[UIImage imageNamed:@"contactflag_star_select"] forState:UIControlStateSelected];
    [_valueButtonFour addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
    
    _valueButtonFive = [UIButton buttonWithType:UIButtonTypeCustom];
    _valueButtonFive.frame = CGRectMake(160, 60, 40, 40);
    _valueButtonFive.tag = 5;
    [_valueButtonFive setBackgroundImage:[UIImage imageNamed:@"contactflag_star_nor"] forState:UIControlStateNormal];
    [_valueButtonFive setBackgroundImage:[UIImage imageNamed:@"contactflag_star_select"] forState:UIControlStateSelected];
    [_valueButtonFive addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];

    if ([_investigateArray count] == 0) {
        [_backgrounView addSubview:_valueButtonOne];
    }else if ([_investigateArray count] == 1) {
        [_backgrounView addSubview:_valueButtonOne];
        [_backgrounView addSubview:_valueButtonTwo];
    }else if ([_investigateArray count] == 2) {
        [_backgrounView addSubview:_valueButtonOne];
        [_backgrounView addSubview:_valueButtonTwo];
        [_backgrounView addSubview:_valueButtonThree];
    }else if ([_investigateArray count] == 3) {
        [_backgrounView addSubview:_valueButtonOne];
        [_backgrounView addSubview:_valueButtonTwo];
        [_backgrounView addSubview:_valueButtonThree];
        [_backgrounView addSubview:_valueButtonFour];
    }else {
        [_backgrounView addSubview:_valueButtonOne];
        [_backgrounView addSubview:_valueButtonTwo];
        [_backgrounView addSubview:_valueButtonThree];
        [_backgrounView addSubview:_valueButtonFour];
        [_backgrounView addSubview:_valueButtonFive];
    }
    
    NSDictionary * dict = [_investigateArray objectAtIndex:[_investigateArray count]-3];
    _investigateLabel.text = [dict objectForKey:@"name"];
    _investigateValue.text = [dict objectForKey:@"value"];
    
    
    _submitButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _submitButton.frame = CGRectMake(_backgrounView.frame.size.width-80, _backgrounView.frame.size.height-40, 70, 30);
    _submitButton.backgroundColor = [UIColor redColor];
    [_submitButton setTitle:@"提交" forState:UIControlStateNormal];
    [_submitButton addTarget:self action:@selector(submitAction:) forControlEvents:UIControlEventTouchUpInside];
    [_backgrounView addSubview:_submitButton];
}

- (void)buttonAction: (UIButton *)sender {
    NSDictionary * dict = [_investigateArray objectAtIndex:[_investigateArray count]-(sender.tag-1)-1];
    _investigateLabel.text = [dict objectForKey:@"name"];
    _investigateValue.text = [dict objectForKey:@"value"];
    
    if (sender.tag == 1) {
        _valueButtonOne.selected = YES;
        _valueButtonTwo.selected = NO;
        _valueButtonThree.selected = NO;
        _valueButtonFour.selected = NO;
        _valueButtonFive.selected = NO;
    }else if (sender.tag == 2) {
        _valueButtonOne.selected = YES;
        _valueButtonTwo.selected = YES;
        _valueButtonThree.selected = NO;
        _valueButtonFour.selected = NO;
        _valueButtonFive.selected = NO;
    }else if (sender.tag == 3) {
        _valueButtonOne.selected = YES;
        _valueButtonTwo.selected = YES;
        _valueButtonThree.selected = YES;
        _valueButtonFour.selected = NO;
        _valueButtonFive.selected = NO;
    }else if (sender.tag == 4) {
        _valueButtonOne.selected = YES;
        _valueButtonTwo.selected = YES;
        _valueButtonThree.selected = YES;
        _valueButtonFour.selected = YES;
        _valueButtonFive.selected = NO;
    }else {
        _valueButtonOne.selected = YES;
        _valueButtonTwo.selected = YES;
        _valueButtonThree.selected = YES;
        _valueButtonFour.selected = YES;
        _valueButtonFive.selected = YES;
    }
}

- (void)setData:(CustomMessage *)message {
    _messageId = message._id;
}

- (void)submitAction: (UIButton *)sender {
    [QMConnect sdkSubmitInvestigate:_investigateLabel.text value:_investigateValue.text successBlock:^{
        NSLog(@"评价成功");
    } failBlock:^{
        NSLog(@"评价失败");
    }];
    // 提交评价成功，收到评价状态反馈，不用reload tableView
    [QMConnect removeDataFromDataBase:_messageId];
    [[NSNotificationCenter defaultCenter] postNotificationName:CHATMSG_RELOAD object:nil];
}

@end
