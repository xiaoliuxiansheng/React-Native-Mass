//
//  QMChatRoomAssociationInputView.m
//  IMSDK-OC
//
//  Created by lishuijiao on 2019/5/27.
//  Copyright © 2019年 HCF. All rights reserved.
//

#import "QMChatRoomAssociationInputView.h"

@implementation QMChatRoomAssociationInputView {
    NSArray *_questions;
    
    UITableView *_tableView;
    
    UILabel *_lineLabel;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        [self createView];
    }
    return  self;
}

- (void)createView {
    _tableView = [[UITableView alloc] init];
    _tableView.frame = self.bounds;
    _tableView.backgroundColor = [UIColor colorWithRed:240/255.0 green:240/255.0 blue:240/255.0 alpha:1];
    _tableView.scrollEnabled = NO;
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [self addSubview:_tableView];
    
    _lineLabel = [[UILabel alloc] init];
    _lineLabel.frame = CGRectMake(0, 0, kScreenWidth, 1);
    _lineLabel.backgroundColor = [UIColor colorWithRed:204/255.0 green:204/255.0 blue:204/255.0 alpha:1];
    [self addSubview:_lineLabel];
}

- (void)showData:(NSArray *)array {
    _questions = array;
    _tableView.frame = CGRectMake(0, 0, kScreenWidth, array.count*50);
    [_tableView reloadData];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _questions.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSString *identifier = @"associationInputCell";
    QMChatRoomAssociationInputCell * cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[QMChatRoomAssociationInputCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    cell.questionLabel.text = _questions[indexPath.row];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 50;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:true];
    NSString *question = _questions[indexPath.row];
    self.questionsSelect(question);
}

@end


@implementation QMChatRoomAssociationInputCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self createUI];
    }
    return self;
}

- (void)createUI {
    self.questionLabel = [[UILabel alloc] init];
    self.questionLabel.frame = CGRectMake(15, 15, kScreenWidth - 30, 20);
    self.questionLabel.text = @"";
    self.questionLabel.font = [UIFont systemFontOfSize:15];
    self.questionLabel.textColor = [UIColor colorWithRed:102/255.0 green:102/255.0 blue:102/255.0 alpha:1];
    [self.contentView addSubview:self.questionLabel];
}

@end
