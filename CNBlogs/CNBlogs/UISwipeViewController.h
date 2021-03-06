//
//  UISwipeViewController.h
//  CNBlogs
//
//  Created by 李远超 on 15/8/31.
//  Copyright (c) 2015年 liyc. All rights reserved.
//

#import "UIBaseViewController.h"

@interface UISwipeViewController : UIBaseViewController

@property (nonatomic, strong) UISegmentedControl *segmentedControl;
@property (nonatomic, strong) UICollectionView *collectionView;

@property (nonatomic, strong) NSArray *titleArray;
@property (nonatomic, strong) NSArray *viewControllerArray;

@end
