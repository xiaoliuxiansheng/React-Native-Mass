//
//  QMPickedPhotoViewController.m
//  IMSDK-OC
//
//  Created by HCF on 16/8/11.
//  Copyright © 2016年 HCF. All rights reserved.
//

#import "QMPickedPhotoViewController.h"

#import "QMFileCollectionCell.h"
#import <Photos/Photos.h>
#import "QMFileTabbarView.h"
#import "QMChatRoomViewController.h"

@interface QMPickedPhotoViewController ()<UICollectionViewDelegate, UICollectionViewDataSource> {
    UICollectionView *_collectionView;
    PHFetchResult *_photoAssets;
    PHCachingImageManager *_cacheManager;
    
    QMFileTabbarView *_tabbarView;
    CGFloat _navHeight;
}

@property (nonatomic, strong) NSMutableSet *pickedImageSet;

@end

@implementation QMPickedPhotoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    CGRect StatusRect = [[UIApplication sharedApplication] statusBarFrame];
    CGRect NavRect = self.navigationController.navigationBar.frame;
    _navHeight = StatusRect.size.height + NavRect.size.height;

    _cacheManager = [[PHCachingImageManager alloc] init];
    self.pickedImageSet = [[NSMutableSet alloc] init];
    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.itemSize = CGSizeMake((kScreenWidth-6)/3, (kScreenWidth-6)/3);
    layout.scrollDirection = UICollectionViewScrollDirectionVertical;
    layout.sectionInset = UIEdgeInsetsMake(0, 1, 0, 1);
    layout.minimumLineSpacing = 2.0;
    layout.minimumInteritemSpacing = 1.0;
    layout.headerReferenceSize = CGSizeMake(0, 0);

    _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight-_navHeight-44) collectionViewLayout:layout];
    _collectionView.backgroundColor = [UIColor whiteColor];
    _collectionView.delegate = self;
    _collectionView.dataSource = self;
    [self.view addSubview:_collectionView];
    [_collectionView registerClass:[QMFileCollectionCell self] forCellWithReuseIdentifier:NSStringFromClass(QMFileCollectionCell.self)];

    _tabbarView = [[QMFileTabbarView alloc] init];
    _tabbarView.frame = CGRectMake(0, kScreenHeight-44-_navHeight, kScreenWidth, 44);
    [self.view addSubview:_tabbarView];
    
    __weak QMPickedPhotoViewController *strongSelf = self;
    _tabbarView.selectAction = ^{
        QMChatRoomViewController * tagViewController = nil;
        for (UIViewController *viewController in strongSelf.navigationController.viewControllers) {
            if ([viewController isKindOfClass:[QMChatRoomViewController class]]) {
                tagViewController = (QMChatRoomViewController *)viewController;
                [strongSelf.navigationController popToViewController:tagViewController animated:true];
                
                for (PHAsset *asset in strongSelf.pickedImageSet) {
                                            
     
//                        if (@available(iOS 13, *)) {
//                            [[PHImageManager defaultManager] requestImageDataAndOrientationForAsset:asset options:nil resultHandler:^(NSData * _Nullable imageData, NSString * _Nullable dataUTI, CGImagePropertyOrientation orientation, NSDictionary * _Nullable info) {
//
//                                NSString *photoPath = [[info objectForKey:@"PHImageFileURLKey"] absoluteString];
//                                NSArray *array = [photoPath componentsSeparatedByString:@"/"];
//                                NSString *name = array.lastObject;
//                                if (!name && name.length == 0) {
//                                    NSString *uuid = [[[NSUUID UUID] UUIDString] stringByReplacingOccurrencesOfString:@"-" withString:@""];
//                                    name = [NSString stringWithFormat:@"%@%@",uuid,dataUTI];
//                                }
//                                NSString *fileSize = [imageData length]<1024*1024 ? [NSString stringWithFormat:@"%d KB", (int)([imageData length]/1024.0)] : [NSString stringWithFormat:@"%d MB", (int)([imageData length]/1024.0/1024)];
//
//                                NSString * filePath = [NSString stringWithFormat:@"%@/%@", NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0], name];
//                                // 写入sendVideo文件夹
//                                [imageData writeToFile:filePath atomically:YES];
//
//                                [tagViewController sendFileMessageWithName:name AndSize:fileSize AndPath:name];
//                            }];
//                        } else {
                            // Fallback on earlier versions
                            
                            [[PHImageManager defaultManager] requestImageDataForAsset:asset options:nil resultHandler:^(NSData * _Nullable imageData, NSString * _Nullable dataUTI, UIImageOrientation orientation, NSDictionary * _Nullable info) {
                                NSString *photoPath = [[info objectForKey:@"PHImageFileURLKey"] absoluteString];
                                NSArray *array = [photoPath componentsSeparatedByString:@"/"];
                                
                                NSString *name = array.lastObject;
                                if (!name && name.length == 0) {
                                    NSString *uuid = [[[NSUUID UUID] UUIDString] stringByReplacingOccurrencesOfString:@"-" withString:@""];
                                    name = [NSString stringWithFormat:@"%@%@",uuid,dataUTI];
                                }
                                
                                NSString *fileSize = [imageData length]<1024*1024 ? [NSString stringWithFormat:@"%d KB", (int)([imageData length]/1024.0)] : [NSString stringWithFormat:@"%d MB", (int)([imageData length]/1024.0/1024)];
                                
                                NSString * filePath = [NSString stringWithFormat:@"%@/%@", NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0], name];
                                // 写入sendVideo文件夹
                                [imageData writeToFile:filePath atomically:YES];
                                
                                
                                [tagViewController sendFileMessageWithName:name AndSize:fileSize AndPath:name];
                            }];
//                        }
                }
            }
        }        
    };
    
    dispatch_async(dispatch_get_main_queue(), ^{
        PHFetchOptions *options = [[PHFetchOptions alloc] init];
        options.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"creationDate" ascending:YES]];
        
        _photoAssets = [PHAsset fetchAssetsWithMediaType:PHAssetMediaTypeImage options:options];
        [_collectionView reloadData];
    });
}

- (void)dealloc {
    
}

#pragma mark - CollectionViewDelegate CollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return _photoAssets ? _photoAssets.count : 0;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    QMFileCollectionCell * cell = (QMFileCollectionCell *)[collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass(QMFileCollectionCell.self) forIndexPath:indexPath];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView willDisplayCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath {
    
    if ([cell isKindOfClass:[QMFileCollectionCell class]]) {
        QMFileCollectionCell *displayCell = (QMFileCollectionCell *)cell;
        displayCell.imageManager = _cacheManager;
        if (_photoAssets) {
            PHAsset * asset = _photoAssets[indexPath.item];
            displayCell.imageAsset = asset;
            displayCell.pickedItemImageView.hidden = ![self.pickedImageSet containsObject:asset];
        }
    }
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if (_photoAssets) {
        PHAsset *asset = _photoAssets[indexPath.item];
        if ([self.pickedImageSet containsObject:asset]) {
            [self.pickedImageSet removeObject:asset];
        }else {
            if (self.pickedImageSet.count>0) {
                return;
            }
            [self.pickedImageSet addObject:asset];
        }
        
        QMFileCollectionCell * cell = (QMFileCollectionCell *)[collectionView cellForItemAtIndexPath:indexPath];
        cell.pickedItemImageView.hidden = ![self.pickedImageSet containsObject:asset];
    }
    
    if (self.pickedImageSet.count>0) {
        _tabbarView.doneButton.selected = YES;
    }else {
        _tabbarView.doneButton.selected = NO;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
