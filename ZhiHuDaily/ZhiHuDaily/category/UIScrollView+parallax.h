
#import <UIKit/UIKit.h>

@class ParallaxView;

@interface UIScrollView (parallax)

- (void)addParallaxWithImage:(UIImage *)image addHeight:(CGFloat)height;
- (void)addParallaxWithView:(UIView*)view andHeight:(CGFloat)height;

@property (nonatomic,strong) ParallaxView *parallaxView;
@property (nonatomic,assign) BOOL showsParallax;

@end

@protocol parallaxViewDelegate <NSObject>

@optional
- (void)parallaxView:(ParallaxView *)view willChangeFrame:(CGRect)frame;
- (void)parallaxView:(ParallaxView *)view didChangeFrame:(CGRect)frame;

@end

typedef NS_ENUM(NSUInteger, APParallaxTrackingState) {
    APParallaxTrackingActive = 0,
    APParallaxTrackingInactive
};

@interface ParallaxView : UIView
@property (nonatomic,assign) APParallaxTrackingState state;
@property (nonatomic,assign) id<parallaxViewDelegate>delegate;
@property (nonatomic,strong) UIImageView *imageView;
@property (nonatomic,strong) UIView *currentSubView;
@property (nonatomic,strong) UIView *customView;

@end

