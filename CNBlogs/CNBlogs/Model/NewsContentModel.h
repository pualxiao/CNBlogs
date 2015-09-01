//
//  NewsContentModel.h
//  CNBlogs
//
//  Created by 李远超 on 15/8/26.
//  Copyright (c) 2015年 liyc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NewsContentModel : NSObject

@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *sourceName;
@property (nonatomic, copy) NSDate *submitDate;
@property (nonatomic, copy) NSString *content;
@property (nonatomic, copy) NSString *imageUrl;
@property (nonatomic, copy) NSNumber *prevNews;
@property (nonatomic, copy) NSNumber *nextNews;
@property (nonatomic, copy) NSNumber *comments;

// 非协议字段
@property (nonatomic, copy) NSString *html;

@end
