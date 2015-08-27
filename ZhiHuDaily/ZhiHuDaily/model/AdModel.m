//
//  AdModel.m
//  ZhiHuDaily
//
//  Created by yilos on 15/8/21.
//  Copyright (c) 2015年 yilos. All rights reserved.
//

#import "AdModel.h"

@implementation AdModel
+ (NSDictionary *)replacedKeyFromPropertyName {
    return @{@"adid":@"id",
             @"prefix":@"ga_prefix",
             };
}
@end
