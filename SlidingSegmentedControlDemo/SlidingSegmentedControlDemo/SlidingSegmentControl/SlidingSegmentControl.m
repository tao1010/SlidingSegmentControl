//
//  SlidingSegmentControl.m
//  JingXianPayDemo
//
//  Created by dengtao on 2017/5/16.
//  Copyright © 2017年 JingXian. All rights reserved.
//

#import "SlidingSegmentControl.h"

#define kTitleFont [UIFont systemFontOfSize:16]

//Model
@implementation SlidingSegmentControlItem

@end

//CustomCollectionViewCell
@interface CustomCollectionViewCell : UICollectionViewCell

@property (nonatomic, strong)   UILabel *titleLabel;
@property (nonatomic, copy)     NSString *menuID;

@end

//CustomCollectionViewCell
@implementation CustomCollectionViewCell


- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.font = kTitleFont;
        _titleLabel.textColor = [UIColor blackColor];
        [self.contentView addSubview:_titleLabel];
//        [self addSubview:_titleLabel];
    }
    return self;
}

@end

//self - SlidingSegmentControl

@interface SlidingSegmentControl()

@property (nonatomic, strong) NSMutableArray *separators;   // collectionView种的分割线
@property (nonatomic, strong) UIView *indexView;
@property (nonatomic, strong) UICollectionViewFlowLayout *flowLayout;

@end


@implementation SlidingSegmentControl

+ (instancetype)slidingSegmentControlWithFrame:(CGRect)frame {
    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    layout.sectionInset = UIEdgeInsetsZero;
    layout.minimumInteritemSpacing = 0;
    layout.minimumLineSpacing = 0;
    
    SlidingSegmentControl *control = [[SlidingSegmentControl alloc] initWithFrame:frame collectionViewLayout:layout];
    if (control) {
        control.flowLayout = layout;
        [control initialization];
    }
    return control;
}

+ (instancetype)slidingSegmentControllWithFrame:(CGRect)frame colloectionFlowLayout:(UICollectionViewFlowLayout *)layout {
    if (!layout) {
        layout = [[UICollectionViewFlowLayout alloc] init];
    }
    SlidingSegmentControl *control = [[SlidingSegmentControl alloc] initWithFrame:frame collectionViewLayout:layout];
    if (control) {
        control.flowLayout = layout;
        [control initialization];
    }
    return control;
}

- (void)initialization {
    self.delegate = self;
    self.dataSource = self;
    self.separators = [NSMutableArray array];
    self.backgroundColor = [UIColor whiteColor];
    
    self.showsHorizontalScrollIndicator = NO;
    self.showsVerticalScrollIndicator = NO;
    self.pagingEnabled = YES;
    
    self.tintColor = [UIColor blackColor];
    self.itemNumberForOnePage = 4;
    
    [self registerClass:[CustomCollectionViewCell class] forCellWithReuseIdentifier:@"CustomCollectionViewCell"];
    
    self.layer.borderColor = [[UIColor colorWithWhite:0.872 alpha:1.000] CGColor];
    self.layer.borderWidth = 1;
    
    CGSize cellSize = _flowLayout.itemSize;
    /**
     *  被选中的位置下标视图
     */
    _indexView = [[UIView alloc] init];
    _indexView.bounds = CGRectMake(0, 0, self.flowLayout.itemSize.width * 0.4, 3);//self.flowLayout.itemSize.width * 0.6
    _indexView.backgroundColor = _tintColor;
    _indexView.center = CGPointMake(-cellSize.width / 2.0, cellSize.height - _indexView.frame.size.height / 2.0);
    [self addSubview:_indexView];
}

- (void)updateTheItemSizeInLayout {
    
    self.flowLayout.itemSize = CGSizeMake((CGFloat)(self.frame.size.width / _itemNumberForOnePage), self.frame.size.height);
    self.indexView.bounds = CGRectMakeBound(self.flowLayout.itemSize.width * 0.4, 3);
    
    [self moveIndexViewToIndexPath:_selectedIndexPath];
}

- (void)setTintColor:(UIColor *)tintColor {
    if (_tintColor != tintColor) {
        _tintColor = tintColor;
        _indexView.backgroundColor = _tintColor;
    }
}

- (void)setItemNumberForOnePage:(NSInteger)itemNumberForOnePage {
    if (_itemNumberForOnePage != itemNumberForOnePage) {
        _itemNumberForOnePage = itemNumberForOnePage;
        [self updateTheItemSizeInLayout];
    }
}

- (void)setFrame:(CGRect)frame {
    [super setFrame:frame];
    [self updateTheItemSizeInLayout];
}

- (void)setBounds:(CGRect)bounds {
    [super setBounds:bounds];
    [self updateTheItemSizeInLayout];
}

- (void)setItems:(NSArray *)items {
    if (_items != items) {
        _items = items;
        [self reloadData];
        self.selectedIndexPath = [NSIndexPath indexPathForRow:0 inSection:0];
        [self moveIndexViewToIndexPath:self.selectedIndexPath];
    }
}

- (void)setSelectedIndexPath:(NSIndexPath *)selectedIndexPath {
    if (_selectedIndexPath != selectedIndexPath) {
        _selectedIndexPath = selectedIndexPath;
    }
}

/**
 *  通过传递即将选中的index，调整collection的偏移量，默认有动画
 */
- (void)checkCollectionContentOffsetWithSelectedIndex:(NSInteger)index animated:(BOOL)animated {
    CGFloat duration = animated ? 0.0 : 0;
    
    CGFloat offsetX = self.frame.size.width * (NSInteger)(index / _itemNumberForOnePage);
    if (offsetX + self.frame.size.width > self.contentSize.width) {
        offsetX = self.contentSize.width - self.frame.size.width;
    }
    __weak typeof (self) weakSelf = self;
    [UIView animateWithDuration:duration animations:^{
        weakSelf.contentOffset = CGPointMake(offsetX, weakSelf.contentOffset.y);
    }];
}

/**
 *  移动顶部菜单的选中下标视图的位置
 */
- (void)moveIndexViewToIndexPath:(NSIndexPath *)indexPath {
    
    NSInteger index = indexPath.row;
    if ([_items count] == 0 || indexPath == nil) {
        index = -1;
        _indexView.alpha = 0;
    } else {
        _indexView.alpha = 1;
    }
    
    CGSize cellSize = _flowLayout.itemSize;
    
    NSInteger x = cellSize.width * (index + 0.5); // 0.5、1.5、2.5
    NSInteger y = cellSize.height - _indexView.frame.size.height / 2.0;
    
    BOOL isShowTextLength = YES;
    if (isShowTextLength) {
        
        SlidingSegmentControlItem *item = [_items objectAtIndex:indexPath.row];
        if (item.title) {
            
            CustomCollectionViewCell *cell = (CustomCollectionViewCell *)[self cellForItemAtIndexPath:indexPath];
            
            CGRect rect = [item.title boundingRectWithSize:CGSizeMake(999999.0f, cell.frame.size.height) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : kTitleFont} context:nil];
            
//            CGSize size = [item.title sizeWithFont:kTitleFont
//                                 constrainedToSize:CGSizeMake(999999.0f, cell.frame.size.height)
//                                     lineBreakMode:NSLineBreakByWordWrapping];
            
            _indexView.frame = CGRectMake(_indexView.frame.origin.x, _indexView.frame.origin.y, rect.size.width, _indexView.frame.size.height);
            
        }
    }
    
    [UIView animateWithDuration:0.2 animations:^{
        _indexView.center = CGPointMake(x, y);
    }];
}

/**
 *  此方法种实现了对分割线显示的管理。
 */
- (void)checkCollectionSeparatorWithItemsCount:(NSInteger)count {
    if (count == 0) {
        _indexView.alpha = 0;
        return;
    }
    
    [UIView animateWithDuration:0.3 animations:^{
        _indexView.alpha = 1;
    }];
    
    
    CGSize cellSize = _flowLayout.itemSize;
    /**
     *  当实际分割线数量比应有分割线数量少时，新增分割线
     */
    while ([_separators count] < count - 1) { // 分割数量 = cell count - 1;
        UIImageView *line = [[UIImageView alloc] init];
        line.image = _separatorImage;
        line.bounds = CGRectMakeBound(2, cellSize.height * 0.8);
        line.center = CGPointMake(cellSize.width * ([_separators count] + 1) - line.frame.size.width / 2.0, cellSize.height / 2.0);
        [self addSubview:line];
        [_separators addObject:line];
    }
    
    /**
     *  当实际分割线数量比应有分割线数量多时，移除分割线
     */
    while ([_separators count] >= count) {
        [[_separators lastObject] removeFromSuperview];
        [_separators removeLastObject];
    }
}

- (void)selectTheCollectionCellWithIndexPath:(NSIndexPath *)indexPath {
    
    self.selectedIndexPath = indexPath;
    [self moveIndexViewToIndexPath:indexPath];
    [self reloadData];
    
    if (indexPath) {
        // 当有数据时才调用代理
        if ([_controlDelegate respondsToSelector:@selector(slidingSegmentedControl:didSelectedItemAtIndex:)]) {
            [_controlDelegate slidingSegmentedControl:self didSelectedItemAtIndex:indexPath.row];
        }
    }
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    [self checkCollectionSeparatorWithItemsCount:[_items count]];
    if (!_items.count) {
        [self checkCollectionContentOffsetWithSelectedIndex:-1 animated:YES];
        [self selectTheCollectionCellWithIndexPath:nil];
    }
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    return [_items count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    SlidingSegmentControlItem *item = _items[indexPath.row];
    CustomCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"CustomCollectionViewCell" forIndexPath:indexPath];
    cell.backgroundColor = [UIColor clearColor];
    cell.titleLabel.numberOfLines = 0;
    cell.titleLabel.text = item.title;
//    cell.titleLabel.backgroundColor = kGCColorMainPurple;
    cell.titleLabel.font = [UIFont systemFontOfSize:15];
    cell.titleLabel.textColor = _selectedIndexPath.row == indexPath.row ? _tintColor : [UIColor blackColor];
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    [self selectTheCollectionCellWithIndexPath:indexPath];
}

CGRect CGRectMakeBound( CGFloat w, CGFloat h )
{
    CGRect rect;
    rect.origin = CGPointZero;
    rect.size.width = w;
    rect.size.height = h;
    return rect;
}

- (CGFloat)width {
    return self.frame.size.width;
}

//- (void)setWidth:(CGFloat)width {
//    self.frame = CGRectMake(self.x, self.y, width, self.height);
//}


@end


@implementation SlidingSegmentControl (ControlOperation)
 
 - (void)selectNextItem {
     
     if ([_items count] == 0) {
         return;
     }
     
     NSInteger nextIndex = _selectedIndexPath.row + 1;
     if (nextIndex >= [_items count]) {
         // 超出数组最大界限，显示首个菜单
         [self selectItemAtIndex:0 scrollAnimated:NO];
     } else {
         [self selectItemAtIndex:nextIndex scrollAnimated:YES];
     }
 }
 
 - (void)selectLastItem {
     /**
     *  如果为空或者无选中ID
     */
    if ([_items count] <= 0) {
        return;
    }

    NSInteger lastIndex = _selectedIndexPath.row - 1;
    if (lastIndex  < 0) {
        // 超出数组最小范围，显示最后一个菜单
        [self selectItemAtIndex:[_items count] - 1 scrollAnimated:NO];
    } else {
        
        [self selectItemAtIndex:lastIndex scrollAnimated:YES];
    }
}

- (void)selectItemAtIndex:(NSInteger)index scrollAnimated:(BOOL)animated {
    if (index < 0 || index >= [_items count]) {
        return;
    }
    
    [self checkCollectionContentOffsetWithSelectedIndex:index animated:animated];
    [self selectTheCollectionCellWithIndexPath:[NSIndexPath indexPathForRow:index inSection:0]];
}

@end

