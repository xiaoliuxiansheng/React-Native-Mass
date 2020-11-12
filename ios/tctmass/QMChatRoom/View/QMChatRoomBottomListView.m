//
//  QMChatRoomBottomListView.m
//  IMSDK-OC
//
//  Created by lishuijiao on 2019/9/20.
//  Copyright © 2019 HCF. All rights reserved.
//

#import "QMChatRoomBottomListView.h"
#import "QMAlert.h"

@implementation QMChatRoomBottomListView {
    
    UICollectionView *_collectionView;
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
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    layout.minimumLineSpacing = 10;
    layout.minimumInteritemSpacing = 10;
    layout.sectionInset = UIEdgeInsetsMake(8, 10, 8, 10);
    _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 52) collectionViewLayout:layout];
    _collectionView.delegate = self;
    _collectionView.dataSource = self;
    _collectionView.showsVerticalScrollIndicator = NO;
    _collectionView.showsHorizontalScrollIndicator = NO;
    _collectionView.backgroundColor = [UIColor colorWithRed:240/255.0 green:240/255.0 blue:240/255.0 alpha:1];
    [_collectionView registerClass:[QMChatRoomBottomListCell class] forCellWithReuseIdentifier:NSStringFromClass([QMChatRoomBottomListCell class])];
    [self addSubview:_collectionView];
}

- (void)showData:(NSArray *)array {
    self.dataArr = array;
    [_collectionView reloadData];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.dataArr.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    QMChatRoomBottomListCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([QMChatRoomBottomListCell class]) forIndexPath:indexPath];
    [cell showLabelText:self.dataArr[indexPath.row]];
    __weak typeof(self) weakSelf = self;
    cell.tapBottomText = ^(NSString * text) {
        dispatch_async(dispatch_get_main_queue(), ^{
            weakSelf.tapSendText(text);
        });
    };
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    CGFloat width = [QMAlert calcLabelHeight:self.dataArr[indexPath.row][@"button"] font:[UIFont systemFontOfSize:16.0f]];
    return CGSizeMake(width + 24, 36);
}

@end

@implementation QMChatRoomBottomListCell

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self createUI];
    }
    return self;
}

- (void)createUI {
    self.button = [[UIButton alloc] init];
    self.button.frame = CGRectMake(0, 0, 100, 36);
    self.button.backgroundColor = [UIColor whiteColor];
    self.button.titleLabel.font = [UIFont systemFontOfSize:16.0f];
    [self.button setTitleColor:[UIColor colorWithRed:38/255.0 green:38/255.0 blue:38/255.0 alpha:1] forState:UIControlStateNormal];
    self.button.titleLabel.textAlignment = NSTextAlignmentCenter;
    self.button.layer.masksToBounds = YES;
    self.button.layer.cornerRadius = 18;
    [self.button addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:self.button];
}

- (void)showLabelText:(NSDictionary *)dic {
    self.dic = dic;
    CGFloat width = [QMAlert calcLabelHeight:dic[@"button"] font:[UIFont systemFontOfSize:16.0f]];
    [self.button setTitle:dic[@"button"] forState:UIControlStateNormal];
    self.button.frame = CGRectMake(0, 0, width + 24, 36);
}

- (void)buttonAction:(UIButton *)button {
    self.tapBottomText(self.dic[@"text"]);
}

@end
