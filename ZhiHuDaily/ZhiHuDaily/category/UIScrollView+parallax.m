
#import "UIScrollView+parallax.h"
#import <QuartzCore/QuartzCore.h>

@interface ParallaxView ()

@property (nonatomic,weak) UIScrollView *scrollView;
@property (nonatomic) CGFloat parallaxHeight;
@property (nonatomic) CGFloat originalTopInset;
@property(nonatomic, assign) BOOL isObserving;

@end

@implementation ParallaxView

- (instancetype) initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    if (self) {
        [self setBackgroundColor:[UIColor redColor]];
        
        // default styling values
        [self setAutoresizingMask:UIViewAutoresizingFlexibleHeight];
        [self setState:APParallaxTrackingActive];
        
        self.imageView = [[UIImageView alloc] init];
        [self.imageView setContentMode:UIViewContentModeScaleAspectFill];
        [self.imageView setClipsToBounds:YES];
        [self addSubview:self.imageView];
        
        [self.imageView setTranslatesAutoresizingMaskIntoConstraints:NO];
        [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[imageView]|" options:0 metrics:nil views:@{@"imageView" : self.imageView}]];
        [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[imageView]|" options:0 metrics:nil views:@{@"imageView" : self.imageView}]];
    }
    return self;
}

- (void)willMoveToSuperview:(UIView *)newSuperview {
    if (self.superview && newSuperview == nil) {
        UIScrollView *scrollView = (UIScrollView *)self.superview;
        if (scrollView.showsParallax) {
            if (self.isObserving) {
                [scrollView removeObserver:self forKeyPath:@"contentOffset"];
                [scrollView removeObserver:self forKeyPath:@"frame"];
                self.isObserving = NO;
            }
        }
    }
}

- (void)addSubview:(UIView *)view {
    [super addSubview:view];
    self.currentSubView = view;
}

- (void)setCustomView:(UIView *)customView
{
    if (_customView) {
        [_customView removeFromSuperview];
    }
    
    _customView = customView;
    
    [self addSubview:customView];
    [customView setTranslatesAutoresizingMaskIntoConstraints:NO];
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[customView]|" options:0 metrics:nil views:@{@"customView" : customView}]];
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[customView]|" options:0 metrics:nil views:@{@"customView" : customView}]];
}

#pragma mark - Observing

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    if([keyPath isEqualToString:@"contentOffset"]) {
        [self scrollViewDidScroll:[[change valueForKey:NSKeyValueChangeNewKey] CGPointValue]];
    }
    else if([keyPath isEqualToString:@"frame"]) {
        [self layoutIfNeeded];
    }
}

- (void)scrollViewDidScroll:(CGPoint)contentOffset {
    // We do not want to track when the parallax view is hidden
    if (contentOffset.y > 0) {
        [self setState:APParallaxTrackingInactive];
    } else {
        [self setState:APParallaxTrackingActive];
    }
    
    if(self.state == APParallaxTrackingActive) {
        CGFloat yOffset = contentOffset.y*-1;
        if ([self.delegate respondsToSelector:@selector(parallaxView:willChangeFrame:)]) {
            [self.delegate parallaxView:self willChangeFrame:self.frame];
        }
        
        [self setFrame:CGRectMake(0, contentOffset.y, CGRectGetWidth(self.frame), yOffset)];
        
        if ([self.delegate respondsToSelector:@selector(parallaxView:didChangeFrame:)]) {
            [self.delegate parallaxView:self didChangeFrame:self.frame];
        }
    }
}


@end

#import <objc/runtime.h>

static char UIScrollViewParallaxView;

@implementation UIScrollView (parallax)

- (void)addParallaxWithImage:(UIImage *)image addHeight:(CGFloat)height {
    if(self.parallaxView) {
        if(self.parallaxView.currentSubView) {
            [self.parallaxView.currentSubView removeFromSuperview];
        }
        [self.parallaxView.imageView setImage:image];
    }
    else
    {
        ParallaxView *parallaxView = [[ParallaxView alloc] initWithFrame:CGRectMake(0, 0, self.bounds.size.width*2, height)];
        [parallaxView setClipsToBounds:YES];
        [parallaxView.imageView setImage:image];
        
        parallaxView.scrollView = self;
        parallaxView.parallaxHeight = height;
        [self addSubview:parallaxView];
        
        parallaxView.originalTopInset = self.contentInset.top;
        
        UIEdgeInsets newInset = self.contentInset;
        newInset.top = height;
        self.contentInset = newInset;
        
        self.parallaxView = parallaxView;
        self.showsParallax = YES;
    }
}

- (void)addParallaxWithView:(UIView *)view andHeight:(CGFloat)height {
    if(self.parallaxView) {
        [self.parallaxView.currentSubView removeFromSuperview];
        [view setAutoresizingMask:UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight];
        [self.parallaxView setCustomView:view];
    }
    else
    {
        ParallaxView *parallaxView = [[ParallaxView alloc] initWithFrame:CGRectMake(0, 0, self.bounds.size.width, height)];
        [parallaxView setClipsToBounds:YES];
        
        [parallaxView setCustomView:view];
        
        parallaxView.scrollView = self;
        parallaxView.parallaxHeight = height;
        [self addSubview:parallaxView];
        
        parallaxView.originalTopInset = self.contentInset.top;
        
        UIEdgeInsets newInset = self.contentInset;
        newInset.top = height;
        self.contentInset = newInset;
        
        self.parallaxView = parallaxView;
        self.showsParallax = YES;
    }
}

- (void)setParallaxView:(ParallaxView *)parallaxView {
    objc_setAssociatedObject(self, &UIScrollViewParallaxView,
                             parallaxView,
                             OBJC_ASSOCIATION_ASSIGN);
}

- (ParallaxView *)parallaxView {
    return objc_getAssociatedObject(self, &UIScrollViewParallaxView);
}

- (void)setShowsParallax:(BOOL)showsParallax {
    self.parallaxView.hidden = !showsParallax;
    
    if(!showsParallax) {
        if (self.parallaxView.isObserving) {
            [self removeObserver:self.parallaxView forKeyPath:@"contentOffset"];
            [self removeObserver:self.parallaxView forKeyPath:@"frame"];
            self.parallaxView.isObserving = NO;
        }
    }
    else {
        if (!self.parallaxView.isObserving) {
            [self addObserver:self.parallaxView forKeyPath:@"contentOffset" options:NSKeyValueObservingOptionNew context:nil];
            [self addObserver:self.parallaxView forKeyPath:@"frame" options:NSKeyValueObservingOptionNew context:nil];
            self.parallaxView.isObserving = YES;
        }
    }
}

- (BOOL)showsParallax {
    return !self.parallaxView.hidden;
}

@end
