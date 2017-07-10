//
//  SlidingSegmentControl.h
//  JingXianPayDemo
//
//  Created by dengtao on 2017/5/16.
//  Copyright © 2017年 JingXian. All rights reserved.
//

#import <UIKit/UIKit.h>

//Model
@interface SlidingSegmentControlItem : NSObject

@property (nonatomic, copy) NSString *title;
@property (nonatomic, strong) id managedObject;

@end

//Delegate
@class SlidingSegmentControl;

@protocol SlidingSegmentControlDelegate <NSObject>

@optional

- (void)slidingSegmentedControl:(SlidingSegmentControl *)control didSelectedItemAtIndex:(NSInteger)index;

@end


@interface SlidingSegmentControl : UICollectionView<UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout>

@property (nonatomic, assign) id<SlidingSegmentControlDelegate>controlDelegate;
@property (nonatomic, strong) NSArray *items;
@property (nonatomic, strong) UIColor *tintColor;             //默认为[UIColor blackColor]
@property (nonatomic, strong) UIImage *separatorImage;
@property (nonatomic, assign) NSInteger itemNumberForOnePage; //每页的条目数量,默认为 4

@property (nonatomic, strong, readonly) NSIndexPath *selectedIndexPath; //当前选中的indexPath  (nonatomic, strong, readonly)

/**
 *  务必使用此方法实例化对象
 */
+ (instancetype)slidingSegmentControlWithFrame:(CGRect)frame;
+ (instancetype)slidingSegmentControllWithFrame:(CGRect)frame colloectionFlowLayout:(UICollectionViewFlowLayout *)layout;


@end

/**
 *  对分段控制器进行相关操作
 */
@interface SlidingSegmentControl (ControlOperation)

- (void)selectLastItem; // 选中上一个条目
- (void)selectNextItem; // 选中下一个条目
- (void)selectItemAtIndex:(NSInteger)index scrollAnimated:(BOOL)animated; // 选中下标为index的条目，超出正确范围将不做任何处理

@end
