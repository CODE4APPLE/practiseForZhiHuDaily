//
//  RefreshControl.h
//  ZhiHuDaily
//
//  Created by yilos on 15/8/25.
//  Copyright (c) 2015年 yilos. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

static CGFloat enableInsetTop = 65.0;
static CGFloat enableInsetBottom = 65.0;

typedef enum : NSUInteger {
    RefreshingDirectionNone,
    RefreshingDirectionPullDown,
    RefreshingDirectionPullUp,
} RefreshingDirection;

@interface RefreshControl : NSObject

@property (nonatomic,strong) UIScrollView *scrollView;


@end
