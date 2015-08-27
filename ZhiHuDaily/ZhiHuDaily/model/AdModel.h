//
//  AdModel.h
//  ZhiHuDaily
//
//  Created by yilos on 15/8/21.
//  Copyright (c) 2015年 yilos. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MJExtension.h"

@interface AdModel : NSObject
@property (nonatomic,copy) NSString *prefix;
@property (nonatomic,copy) NSString *adid;
@property (nonatomic,strong) NSArray *image;
@property (nonatomic,copy) NSString *title;
@property (nonatomic) int type;
@end
