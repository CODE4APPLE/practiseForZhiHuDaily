//
//  VerticalSwipeScrollView.h
//  ZhiHuDaily
//
//  Created by yilos on 15/8/31.
//  Copyright (c) 2015年 yilos. All rights reserved.
//

#import <UIKit/UIKit.h>

@class VerticalSwipeScrollView;
@protocol  VerticalSwipeScrollViewDelegate<NSObject>

@optional
- (UIView *) viewForScrollView:(VerticalSwipeScrollView *)scrollView atPage:(NSUInteger)page;
- (NSUInteger) pageCount;

- (void) headerLoadedInScrollView:(VerticalSwipeScrollView *)scrollView;
- (void) headerUnloadInScrollView:(VerticalSwipeScrollView *)scrollView;
- (void) footerLoadedInScrollView:(VerticalSwipeScrollView *)scrollView;
- (void) footerUnloadInScrollView:(VerticalSwipeScrollView *)scrollView;

@end

@interface VerticalSwipeScrollView : UIScrollView <UIScrollViewDelegate>

@property (nonatomic, assign) id<VerticalSwipeScrollViewDelegate,UIScrollViewDelegate> externalDelegate;
@property (nonatomic, strong) UIView* headerView;
@property (nonatomic, strong) UIView* footerView;
@property (nonatomic) NSUInteger currentPageIndex;
@property (nonatomic, strong) UIView* currentPageView;

- (instancetype) initWithFrame:(CGRect)frame
                    headerView:(UIView*)headerView
                    footerView:(UIView*)footerView
                    startingAt:(NSUInteger)pageIndex
                      delegate:(id<VerticalSwipeScrollViewDelegate,UIScrollViewDelegate>)verticalSwipeDelegate;

@end
