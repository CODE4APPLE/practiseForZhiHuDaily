//
//  VerticalSwipeScrollView.m
//  ZhiHuDaily
//
//  Created by yilos on 15/8/31.
//  Copyright (c) 2015年 yilos. All rights reserved.
//

#import "VerticalSwipeScrollView.h"

@interface VerticalSwipeScrollView (PrivateMethod)

- (void) showCurrentPage;

@end

@implementation VerticalSwipeScrollView {
    BOOL _headerLoaded;
    BOOL _footerLoaded;
}

- (instancetype) initWithFrame:(CGRect)frame
                    headerView:(UIView*)headerView
                    footerView:(UIView*)footerView
                    startingAt:(NSUInteger)pageIndex
                      delegate:(id<VerticalSwipeScrollViewDelegate,UIScrollViewDelegate>)verticalSwipeDelegate {
    self = [super initWithFrame:frame];
    if (self) {
        self.alwaysBounceVertical = YES;
        self.delegate = verticalSwipeDelegate;
        self.currentPageIndex = pageIndex;
        self.headerView = headerView;
        self.footerView = footerView;
        self.contentSize = self.frame.size;
    }
    return self;
}

- (void) setDelegate:(id<VerticalSwipeScrollViewDelegate,UIScrollViewDelegate>)delegate {
    if (delegate != (id<VerticalSwipeScrollViewDelegate,UIScrollViewDelegate>)self) {
        _externalDelegate = delegate;
    }
    [super setDelegate:self];
}

- (void) setHeaderView:(UIView *)headerView {
    _headerView = headerView;
    
    _headerView.frame = CGRectMake(0, -CGRectGetHeight(headerView.frame), CGRectGetWidth(headerView.frame), CGRectGetHeight(headerView.frame));
    [self addSubview:_headerView];
    if (_currentPageIndex <= 0) {
        _headerView.hidden = YES;
    }
}

- (void) setFooterView:(UIView *)footerView {
    _footerView = footerView;
    
    _footerView.frame = CGRectMake(0, -CGRectGetHeight(footerView.frame), CGRectGetWidth(footerView.frame), CGRectGetHeight(footerView.frame));
    [self addSubview:_footerView];
    if (_currentPageIndex <= 0) {
        _footerView.hidden = YES;
    }
}

- (void) setCurrentPageIndex:(NSUInteger)currentPageIndex {
    _currentPageIndex = currentPageIndex;
    
    _headerView.hidden = currentPageIndex <= 0;
    _footerView.hidden = (currentPageIndex == [_externalDelegate pageCount] -1);
    
    [self showCurrentPage];
}

- (void) showCurrentPage {
    [_currentPageView removeFromSuperview];
    self.currentPageView = [_externalDelegate viewForScrollView:self atPage:_currentPageIndex];
    [self addSubview:_currentPageView];
}

- (void) scrollViewDidScroll:(UIScrollView *)scrollView {
    
    if ([_externalDelegate respondsToSelector:@selector(scrollViewDidScroll:)]) {
        [_externalDelegate scrollViewDidScroll:scrollView];
    }
    
    if (!scrollView.dragging) return;
    
    if (scrollView.contentOffset.y < 0) {
        
        if (_headerView.hidden) return;
        
        if (scrollView.contentOffset.y < -CGRectGetHeight(_headerView.frame)) {
            
            if (_headerLoaded) return;

            if ([_externalDelegate respondsToSelector:@selector(headerLoadedInScrollView:)]) {
                _headerLoaded = YES;
            }
            
        }else {
            
            if (!_headerLoaded) return;
            
            if ([_externalDelegate respondsToSelector:@selector(headerUnloadInScrollView:)]) {
                _headerLoaded = NO;
            }
        }
        
    }else {
        
        if (_footerView.hidden) return;
        
        if (scrollView.contentOffset.y > CGRectGetHeight(_footerView.frame)) {
            
            if (_footerLoaded) return;
            
            if ([_externalDelegate respondsToSelector:@selector(footerLoadedInScrollView:)]) {
                _footerLoaded = YES;
            }
            
        }else {
            if (!_footerLoaded) return;
            
            if ([_externalDelegate respondsToSelector:@selector(footerUnloadInScrollView:)]) {
                _footerLoaded = NO;
            }
        }
    }
}

- (void) scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    
    if ([_externalDelegate respondsToSelector:@selector(scrollViewDidEndDragging:willDecelerate:)]) {
        [_externalDelegate scrollViewDidEndDragging:scrollView willDecelerate:decelerate];
    }
    
    if (_headerLoaded) {
        
        UIView *previousPage = [_externalDelegate viewForScrollView:self atPage:_currentPageIndex - 1];
        previousPage.frame = CGRectMake(0, -(CGRectGetHeight(previousPage.frame) + self.contentOffset.y), CGRectGetWidth(self.frame), CGRectGetHeight(self.frame));
        [self addSubview:previousPage];
        
        [UIView beginAnimations:nil context:(__bridge void *)(previousPage)];
        [UIView setAnimationDuration:0.2];
        [UIView setAnimationDelegate:self];
        [UIView setAnimationDidStopSelector:@selector(pageAnimationDidStop:finished:context:)];
        previousPage.frame = self.frame;
        _currentPageView.frame = CGRectMake(0, self.frame.size.height + _headerView.frame.size.height, self.frame.size.width, self.frame.size.height);
        _headerView.frame = CGRectMake(0, self.frame.size.height, _headerView.frame.size.width, _headerView.frame.size.height);
        [UIView commitAnimations];
        
        _currentPageIndex--;
        
    }
    else if (_footerLoaded) {
        
        UIView* nextPage = [_externalDelegate viewForScrollView:self atPage:_currentPageIndex+1];

        nextPage.frame = CGRectMake(0, nextPage.frame.size.height + self.contentOffset.y, self.frame.size.width, self.frame.size.height);
        [self addSubview:nextPage];
        
        [UIView beginAnimations:nil context:(__bridge void *)(nextPage)];
        [UIView setAnimationDuration:0.2];
        [UIView setAnimationDelegate:self];
        [UIView setAnimationDidStopSelector:@selector(pageAnimationDidStop:finished:context:)];
    
        nextPage.frame = self.frame;
    
        _currentPageView.frame = CGRectMake(0, -(self.frame.size.height + _headerView.frame.size.height), self.frame.size.width, self.frame.size.height);
        _footerView.frame = CGRectMake(0, -_footerView.frame.size.height, _footerView.frame.size.width, _footerView.frame.size.height);
        [UIView commitAnimations];
        
        _currentPageIndex++;
    }
}

- (void)pageAnimationDidStop:(NSString *)animationID finished:(NSNumber *)finished context:(void *)context {
    
    [_currentPageView removeFromSuperview];
    
    UIView *newPage = (__bridge UIView *)context;
    self.currentPageView = newPage;
    
    if (_footerLoaded && [_externalDelegate respondsToSelector:@selector(footerUnloadInScrollView:)]) {
        [_externalDelegate performSelector:@selector(footerUnloadInScrollView:)];
        _footerLoaded = NO;
    }
    
    if (_headerLoaded && [_externalDelegate respondsToSelector:@selector(headerUnloadInScrollView:)]) {
        [_externalDelegate performSelector:@selector(headerUnloadInScrollView:)];
        _headerLoaded = NO;
    }
    
    _headerView.frame = CGRectMake(0, -CGRectGetHeight(_headerView.frame), CGRectGetWidth(_headerView.frame), CGRectGetHeight(_headerView.frame));
    _footerView.frame = CGRectMake(0, CGRectGetHeight(self.frame), CGRectGetWidth(_footerView.frame), CGRectGetHeight(_footerView.frame));
    
    _headerView.hidden = _currentPageIndex <= 0;
    _footerView.hidden = (_currentPageIndex == [_externalDelegate pageCount] - 1);
}

#pragma mark (由于我们设置了UIScrollViewDelegate,所以我们实现原来的代理方法)

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    if ([_externalDelegate respondsToSelector:@selector(scrollViewWillBeginDragging:)])
        [_externalDelegate scrollViewWillBeginDragging:scrollView];
}

- (void)scrollViewWillBeginDecelerating:(UIScrollView *)scrollView
{
    if ([_externalDelegate respondsToSelector:@selector(scrollViewWillBeginDecelerating:)])
        [_externalDelegate scrollViewWillBeginDecelerating:scrollView];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    if ([_externalDelegate respondsToSelector:@selector(scrollViewDidEndDecelerating:)])
        [_externalDelegate scrollViewDidEndDecelerating:scrollView];
}

- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView
{
    if ([_externalDelegate respondsToSelector:@selector(scrollViewDidEndScrollingAnimation:)])
        [_externalDelegate scrollViewDidEndScrollingAnimation:scrollView];
}

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    if ([_externalDelegate respondsToSelector:@selector(viewForZoomingInScrollView:)])
        return [_externalDelegate viewForZoomingInScrollView:scrollView];
    else
        return nil;
}

- (void)scrollViewDidEndZooming:(UIScrollView *)scrollView withView:(UIView *)view atScale:(CGFloat)scale
{
    if ([_externalDelegate respondsToSelector:@selector(scrollViewDidEndZooming:withView:atScale:)])
        [_externalDelegate scrollViewDidEndZooming:scrollView withView:view atScale:scale];
}

- (BOOL)scrollViewShouldScrollToTop:(UIScrollView *)scrollView
{
    if ([_externalDelegate respondsToSelector:@selector(scrollViewShouldScrollToTop:)])
        return [_externalDelegate scrollViewShouldScrollToTop:scrollView];
    else
        return YES;
}

- (void)scrollViewDidScrollToTop:(UIScrollView *)scrollView
{
    if ([_externalDelegate respondsToSelector:@selector(scrollViewDidScrollToTop:)])
        [_externalDelegate scrollViewDidScrollToTop:scrollView];
}

@end
