//
//  StoryModel.h
//  ZhiHuDaily
//
//  Created by yilos on 15/8/21.
//  Copyright (c) 2015年 yilos. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MJExtension.h"

@interface StoryModel : NSObject

@property (nonatomic,copy) NSString *date;

@property (nonatomic,strong) NSArray *stories;

@property (nonatomic,strong) NSArray *top_stories;

@end
