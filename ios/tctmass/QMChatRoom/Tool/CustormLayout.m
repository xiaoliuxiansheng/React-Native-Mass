//
//  CustormLayout.m
//  CustormCollectionView
//
//  Created by shutong on 2019/4/9.
//  Copyright © 2019 shutong. All rights reserved.
//

#import "CustormLayout.h"

@interface CustormLayout ()
/**
 所有的布局
 */
@property (nonatomic, strong) NSMutableArray * attributArray;
/**
 列
 */
@property (nonatomic, assign) NSInteger line;
/**
 行
 */
@property (nonatomic, assign) NSInteger row;

/**
 列间隔
 */
@property (nonatomic, assign) CGFloat itemSpacing;
/**
 行间隔
 */
@property (nonatomic, assign) CGFloat lineSapcing;
/**
 计算页面
 */
@property (nonatomic, assign) NSInteger pageNumber;

@end

@implementation CustormLayout

/**
 首先我们要知道自定义layout需要做哪些操作，和使用哪些api
 自定义这玩意吧 在我看来就是按照自己想要的布局来设置点，不然直接用系统的就好了哦
 当然了系统该有的东西我们还是要有的
 
 //每次布局都会调用
 - (void)prepareLayout;
 //布局完成后设置contentSize
 - (CGSize)collectionViewContentSize;
 //返回每个item的属性
 - (UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath;
 //返回所有item属性
 - (NSArray *)layoutAttributesForElementsInRect:(CGRect)rect
 
 */

- (void)prepareLayout
{
    [super prepareLayout];
    //做什么都要有个初始化设置的
    [self.attributArray removeAllObjects];
    CGFloat itemWidth = self.itemSize.width;//item的宽
    CGFloat itemHeight = self.itemSize.height;//item的高
    CGFloat width = self.collectionView.frame.size.width;//collectionView的宽
    CGFloat height = self.collectionView.frame.size.height;//collectionView的高
    
    CGFloat contentWidth = width - self.sectionInset.left - self.sectionInset.right;//内容实际占有的宽
    CGFloat contentHeight = height - self.sectionInset.top - self.sectionInset.bottom;//内容实际占有的高
    
    //因为系统的item最小间隔就是通过item的大小和实际大小来计算的，所以这里处理一下item的间隔问题
    if (contentWidth >= 2 * itemWidth + self.minimumInteritemSpacing) {//如果collectionView大于等于两列
        //    在知道有n列的情况下算式是：(itemwidth + 间隔) * n - 间隔 = contentWidht 可以得出 n = contentWidth + 间隔 / (itemwidth + 间隔)
        NSInteger m = (contentWidth + self.minimumInteritemSpacing) / (self.minimumInteritemSpacing + itemWidth);
        _line = m; //这个算出来的是多少列
        
        //    这里我们要计算出还有多少尺寸被预留出来
        double offset = ((contentWidth + self.minimumInteritemSpacing) - _line * (itemWidth + self.minimumInteritemSpacing)) / _line;
        self.itemSpacing = self.minimumInteritemSpacing + offset;
    } else {
        self.itemSpacing = 0.f;
        if (self.isVertical) {
            _line = 1;
        }
    }
    
    if (contentHeight >= 2 * itemHeight + self.minimumLineSpacing) {//如果collectionView大于等于两列
        //    在知道有n列的情况下算式是：(itemwidth + 间隔) * n - 间隔 = contentWidht 可以得出 n = contentWidth + 间隔 / (itemwidth + 间隔)
        NSInteger m = (contentHeight + self.minimumLineSpacing) / (self.minimumLineSpacing + itemHeight);
        _row = m; //这个算出来的是多少列
        
        //    这里我们要计算出还有多少尺寸被预留出来
        double offset = ((contentHeight + self.minimumLineSpacing) - _row * (itemHeight + self.minimumLineSpacing)) / _row;
        self.lineSapcing = self.minimumLineSpacing + offset;
    } else {
        self.lineSapcing = 0.f;
        if (self.isVertical) {
            _row = 4;
        }
    }
    
    //总元素个数
    int itemNumber = 0;
    itemNumber = itemNumber + (int)[self.collectionView numberOfItemsInSection:0]; //这里只做了一组元素的内容，如果是多组目前还没想好怎么计算位置
    //计算有多少页面 (self.row * self.line)这个是一页的item个数
//    self.pageNumber = (itemNumber - 1) / ((self.row * self.line) + 1);
//    if (self.isVertical) {
//        self.pageNumber = itemNumber/4 > 0 ? itemNumber/4 : 1;
//    }else {
        if (self.row * self.line == 0) {
            self.pageNumber = 1;
        }else {
            self.pageNumber = (itemNumber - 1) / (self.row * self.line) + 1;
        }        
//    }
//    self.pageNumber = (itemNumber - 1) / (self.row * self.line) + 1;
    
    //    计算所有布局
    /*
     这里创建布局属性的时候之所以不在layoutAttributesForElementsInRect方法中创建，而在prepareLayout方法中去创建，是因为，如果你是继承自CollectionViewLayout，每次滑动屏幕的时候，layoutAttributesForElementsInRect都会调用，它的调用是动一下调用一次，默认是N频繁（如果你是继承自流水布局CollectionViewFlowLayout不是这种情况，这里默认有些控制你不能频繁调用它，除非重写shouldInvalidateLayoutForBoundsChange：方法才会频繁调用，这里是有区别的）
   
     */
    NSMutableArray *tmpAttributes = [NSMutableArray new];
    for (int j = 0; j < self.collectionView.numberOfSections; j ++)
    { //获取所有的组
        NSInteger count = [self.collectionView numberOfItemsInSection:j];
        for (NSInteger i = 0; i < count; i++) { //获取每组的item
            NSIndexPath *indexPath = [NSIndexPath indexPathForItem:i inSection:j];
            [tmpAttributes addObject:[self layoutAttributesForItemAtIndexPath:indexPath]];
        }
    }
    self.attributArray = tmpAttributes;
    
}

/**
 所有item的布局

 @param rect rect description
 @return return value description
 */
- (NSArray *)layoutAttributesForElementsInRect:(CGRect)rect{
    
    
    return self.attributArray;
}
- (BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)newBounds
{
    return NO;
}
//返回每个item的属性
- (UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewLayoutAttributes *attribute = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];
    
    CGRect frame;
    frame.size = self.itemSize; //尺寸大小
    //一个页面有多少元素
    NSInteger number = self.line * self.row;
    
    NSInteger p = 0; //页码
    NSInteger m = 0; //第几行
    NSInteger n = 0; //第几列
    if (indexPath.item >= number && number != 0) { //如果不是当前页面
        p = indexPath.item / number; //计算页码
        m = (indexPath.item % number) / self.line;
    } else {
        m = indexPath.item / self.line;
    }
    if (!self.isVertical) {
        n = indexPath.item % self.line;
    }
    frame.origin = CGPointMake(n * (self.itemSize.width + self.itemSpacing) + self.sectionInset.left + (indexPath.section + p) * self.collectionView.frame.size.width, m * self.itemSize.height + m * self.lineSapcing + self.sectionInset.top);
    attribute.frame = frame;
    return attribute;
}

//布局完成后设置contentSize
- (CGSize)collectionViewContentSize
{
    return CGSizeMake(self.collectionView.bounds.size.width * self.pageNumber, self.collectionView.bounds.size.height);
}
#pragma mark ************* lazy load *************
- (NSMutableArray *)attributArray
{
    if (!_attributArray) {
        _attributArray = [NSMutableArray arrayWithCapacity:0];
    }
    return _attributArray;
}

@end
