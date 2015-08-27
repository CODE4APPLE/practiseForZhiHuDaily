//
//  CustomNavBar.m
//  ZhiHuDaily
//
//  Created by yilos on 15/8/25.
//  Copyright (c) 2015年 yilos. All rights reserved.
//

#import "CustomNavBar.h"

@interface CustomNavBar ()

@end

@implementation CustomNavBar {
    
    UILabel *titleLabel;
}

- (instancetype) initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(60, 30, self.bounds.size.width-120, 30)];
        titleLabel.textAlignment = NSTextAlignmentCenter;
        titleLabel.textColor = [UIColor whiteColor];
        titleLabel.font = [UIFont boldSystemFontOfSize:16];
        [self addSubview:titleLabel];
    }
    return self;
}

- (void) setTitle:(NSString *)title {
    titleLabel.text = title;
}

- (void) lefeToggle {
    
    
}

@end
