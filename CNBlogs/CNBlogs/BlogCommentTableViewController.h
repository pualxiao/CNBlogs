//
//  BlogCommentTableViewController.h
//  CNBlogs
//
//  Created by 李远超 on 15/9/2.
//  Copyright (c) 2015年 liyc. All rights reserved.
//

#import "UIPageTableViewController.h"

@class BlogModel;

@interface BlogCommentTableViewController : UIPageTableViewController

@property (nonatomic, strong) BlogModel *blogModel;

@end
