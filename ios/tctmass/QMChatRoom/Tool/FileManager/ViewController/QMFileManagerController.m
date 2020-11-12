//
//  QMFileManagerController.m
//  IMSDK-OC
//
//  Created by HCF on 16/8/10.
//  Copyright © 2016年 HCF. All rights reserved.
//

#import "QMFileManagerController.h"
#import "QMItemCollectionCell.h"

#import "QMPickedPhotoViewController.h"
#import "QMPickedVideoViewController.h"
#import "QMPickedDocViewController.h"
#import "QMPickedAudioViewController.h"
#import "QMPickedOtherViewController.h"



/**
 
 */
@interface QMFileManagerController ()<UICollectionViewDelegate, UICollectionViewDataSource> {
    UICollectionView *_collectionView;
    NSArray *_items;
}

@end

@implementation QMFileManagerController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    _items = @[NSLocalizedString(@"button.chat_file", nil), NSLocalizedString(@"button.chat_img", nil), NSLocalizedString(@"button.chat_music", nil), NSLocalizedString(@"button.chat_video", nil), NSLocalizedString(@"button.chat_other", nil)];
    
    [self createUI];
}

- (void)dealloc {
    
}

- (void)createUI {
    UICollectionViewFlowLayout * layout = [[UICollectionViewFlowLayout alloc] init];
    layout.itemSize = CGSizeMake((kScreenWidth-6)/3, (kScreenWidth-6)/3);
    layout.scrollDirection = UICollectionViewScrollDirectionVertical;
    layout.sectionInset = UIEdgeInsetsMake(0, 1, 0, 1);
    layout.minimumLineSpacing = 2.0;
    layout.minimumInteritemSpacing = 1.0;
    layout.headerReferenceSize = CGSizeMake(0, 0);
    
    _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight-64) collectionViewLayout:layout];
    _collectionView.backgroundColor = [UIColor whiteColor];
    _collectionView.delegate = self;
    _collectionView.dataSource = self;
    [self.view addSubview:_collectionView];
    
    [_collectionView registerClass:[QMItemCollectionCell self] forCellWithReuseIdentifier:NSStringFromClass(QMItemCollectionCell.self)];
    
}

- (void)collectionView:(UICollectionView *)collectionView willDisplayCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath {
    NSString * name = _items[indexPath.item];
    if ([cell isKindOfClass:[QMItemCollectionCell class]]) {
        QMItemCollectionCell * displayCell = (QMItemCollectionCell *)cell;
        [displayCell configureWithName:name];
    }
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return _items.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    QMItemCollectionCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass(QMItemCollectionCell.self) forIndexPath:indexPath];
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {    
    switch (indexPath.item) {
        case 0: {
            QMPickedDocViewController *viewController = [[QMPickedDocViewController alloc] init];
            [self.navigationController pushViewController:viewController animated:YES];
        }
            break;
        case 1: {
            QMPickedPhotoViewController *viewController = [[QMPickedPhotoViewController alloc] init];
            [self.navigationController pushViewController:viewController animated:YES];
            break;
        }
        case 2: {
            QMPickedAudioViewController *viewController = [[QMPickedAudioViewController  alloc] init];
            [self.navigationController pushViewController:viewController animated:YES];
            break;
        }
        case 3: {
            QMPickedVideoViewController *viewController = [[QMPickedVideoViewController alloc] init];
            [self.navigationController pushViewController:viewController animated:YES];
            break;
        }
        case 4: {
            QMPickedOtherViewController *viewController = [[QMPickedOtherViewController alloc] init];
            [self.navigationController pushViewController:viewController animated:YES];
            break;
        }
        default:
            break;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

@end

