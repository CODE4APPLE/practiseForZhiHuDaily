//
//  NewsModel.m
//  ZhiHuDaily
//
//  Created by apple on 15/8/19.
//  Copyright (c) 2015年 yilos. All rights reserved.
//

#import "NewsModel.h"

@implementation NewsModel

+ (NSDictionary *)replacedKeyFromPropertyName {
    return @{@"newsId":@"id",
             @"prefix":@"ga_prefix",
            };
}
@end
