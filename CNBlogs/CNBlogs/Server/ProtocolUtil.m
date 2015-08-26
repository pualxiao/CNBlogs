//
//  ProtocolUtil.m
//  CNBlogs
//
//  Created by 李远超 on 15/8/26.
//  Copyright (c) 2015年 liyc. All rights reserved.
//

#import "ProtocolUtil.h"
#import "BlogModel.h"
#import "BlogContentModel.h"

static NSString *protocolBaseUrl = @"http://wcf.open.cnblogs.com/";

@implementation ProtocolUtil

+ (NSIndexSet *)createStatusCodes {
    NSMutableIndexSet *indexSet = [[NSMutableIndexSet alloc] init];
    [indexSet addIndexes:RKStatusCodeIndexSetForClass(RKStatusCodeClassSuccessful)];
    [indexSet addIndexes:RKStatusCodeIndexSetForClass(RKStatusCodeClassClientError)];
    [indexSet addIndexes:RKStatusCodeIndexSetForClass(RKStatusCodeClassServerError)];
    return indexSet;
}

+ (void)getBlogListWithPageIndex:(NSNumber *)index pageCount:(NSNumber *)count success:(ProtocolSuccessBlock)success failure:(ProtocolFailureBlock)failure {
    [RKMIMETypeSerialization registerClass:[RKXMLReaderSerialization class] forMIMEType:@"application/atom+xml"];
    RKObjectMapping *responseMapping = [self blogModelMapping];
    RKResponseDescriptor *responseDescriptor = [RKResponseDescriptor responseDescriptorWithMapping:responseMapping method:RKRequestMethodGET pathPattern:nil keyPath:@"feed.entry" statusCodes:[self createStatusCodes]];

    NSString *path = [NSString stringWithFormat:@"%@blog/sitehome/paged/%@/%@", protocolBaseUrl, index, count];

    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:path]];
    RKObjectRequestOperation *operation = [[RKObjectRequestOperation alloc] initWithRequest:request responseDescriptors:@[responseDescriptor]];
    [operation setCompletionBlockWithSuccess:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
        if (success) {
            success(mappingResult.array, nil);
        }
    } failure:^(RKObjectRequestOperation *operation, NSError *error) {
        if (failure) {
            failure(operation, error);
        }
    }];
    [operation start];
}

+ (RKObjectMapping *)blogModelMapping {
    RKObjectMapping *blogMapping = [RKObjectMapping mappingForClass:[BlogModel class]];
    [blogMapping addAttributeMappingsFromDictionary:@{@"id.text": @"identifier", @"title.text": @"title", @"summary.text": @"summary", @"published.text": @"published", @"updated.text": @"updated", @"link.href": @"link", @"blogapp.text": @"blogapp", @"diggs.text": @"diggs", @"views.text": @"views", @"comments.text": @"comments"}];
    [blogMapping addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:@"author" toKeyPath:@"author" withMapping:[self authorModelMapping]]];
    return blogMapping;
}

+ (RKObjectMapping *)authorModelMapping {
    RKObjectMapping *authorMapping = [RKObjectMapping mappingForClass:[AuthorModel class]];
    [authorMapping addAttributeMappingsFromDictionary:@{@"name.text": @"name", @"uri.text": @"uri", @"avatar.text": @"avatar"}];
    return authorMapping;
}

+ (void)getBlogContentWithID:(NSNumber *)identifier success:(ProtocolSuccessBlock)success failure:(ProtocolFailureBlock)failure {
    [RKMIMETypeSerialization registerClass:[RKXMLReaderSerialization class] forMIMEType:@"application/xml"];
    RKObjectMapping *responseMapping = [RKObjectMapping mappingForClass:[BlogContentModel class]];
    [responseMapping addAttributeMappingsFromDictionary:@{@"string.text": @"content"}];
    RKResponseDescriptor *responseDescriptor = [RKResponseDescriptor responseDescriptorWithMapping:responseMapping method:RKRequestMethodGET pathPattern:nil keyPath:nil statusCodes:[self createStatusCodes]];

    NSString *path = [NSString stringWithFormat:@"%@blog/post/body/%@", protocolBaseUrl, identifier];

    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:path]];
    RKObjectRequestOperation *operation = [[RKObjectRequestOperation alloc] initWithRequest:request responseDescriptors:@[responseDescriptor]];
    [operation setCompletionBlockWithSuccess:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
        if (success) {
            success(mappingResult.firstObject, nil);
        }
    } failure:^(RKObjectRequestOperation *operation, NSError *error) {
        if (failure) {
            failure(operation, error);
        }
    }];
    [operation start];
}

@end