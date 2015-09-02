//
//  BlogViewController.m
//  CNBlogs
//
//  Created by 李远超 on 15/8/26.
//  Copyright (c) 2015年 liyc. All rights reserved.
//

#import "BlogViewController.h"
#import "ContentBarView.h"
#import "ProtocolUtil.h"
#import "BlogContentModel.h"
#import "BlogDAO.h"
#import "BlogModel.h"
#import <MJRefresh/MJRefresh.h>

@interface BlogViewController ()

@end

@implementation BlogViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = self.blogModel.title;

    __weak BlogViewController *weakSelf = self;
    self.contentWebView.scrollView.header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [weakSelf requestContentData];
    }];

    if (self.blogModel.contentModel) {
        [self loadWebView];
    } else {
        [self.contentWebView.scrollView.header beginRefreshing];
    }

    BlogDAO *dao = [[BlogDAO alloc] init];
    self.contentBarView.likeButton.selected = [dao findBlog:self.blogModel] != nil;
}

- (void)likeButtonAction:(UIButton *)sender {
    sender.selected = !sender.selected;
    BlogDAO *dao = [[BlogDAO alloc] init];
    if (sender.selected) {
        [dao insertBlog:self.blogModel];
    } else {
        [dao deleteBlog:self.blogModel];
    }
}

- (void)loadWebView {
    NSDictionary *dictionary = @{@"title": self.blogModel.title, @"authorName": self.blogModel.authorModel.name, @"publishedTime": [self.blogModel.publishDate stringWithFormate:yyMMddHHmm], @"content": self.blogModel.contentModel.content};

    NSString *html = [AppUtil htmlWithDictionary:dictionary usingTemplate:@"blog"];
    [self.contentWebView loadHTMLString:html baseURL:nil];
}

- (void)requestContentData {
    [ProtocolUtil getBlogContentWithID:self.blogModel.identifier success:^(id data, id identifier) {
        [self.contentWebView.scrollView.header endRefreshing];
        self.blogModel.contentModel = data;
        [self loadWebView];
    } failure:^(RKObjectRequestOperation *operation, NSError *error) {
        [self.contentWebView.scrollView.header endRefreshing];
    }];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
