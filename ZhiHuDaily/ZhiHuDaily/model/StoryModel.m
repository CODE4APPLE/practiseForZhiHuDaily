//
//  StoryModel.m
//  ZhiHuDaily
//
//  Created by yilos on 15/8/21.
//  Copyright (c) 2015年 yilos. All rights reserved.
//

#import "StoryModel.h"

@implementation StoryModel

+ (NSDictionary *)objectClassInArray {
    
    return @{@"stories" : @"NewsModel",
             @"top_stories" : @"AdModel"
             };
}

@end
