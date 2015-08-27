//
//  NewsModel.h
//  ZhiHuDaily
//
//  Created by apple on 15/8/19.
//  Copyright (c) 2015年 yilos. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MJExtension.h"

@interface NewsModel : NSObject

@property (nonatomic,copy) NSString *prefix;
@property (nonatomic,copy) NSString *newsId;
@property (nonatomic,strong) NSArray *images;
@property (nonatomic,copy) NSString *title;
@property (nonatomic) int multipic;
@property (nonatomic) int type;

@end
