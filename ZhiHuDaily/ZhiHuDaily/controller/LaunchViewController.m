//
//  LaunchViewController.m
//  ZhiHuDaily
//
//  Created by yilos on 15/8/20.
//  Copyright (c) 2015年 yilos. All rights reserved.
//

#import "LaunchViewController.h"
#import "Contanst.h"

@implementation LaunchViewController {
    UIImage *launchImage;
    UILabel *rightCopyLabel;
    UIViewController *toViewController;
    UIImageView *fromImageView;
    UIImageView *toImageView;
    UIImageView *maskImageView;
    UIImageView *logoImageView;
}

+ (instancetype)addTransitionToViewController:(id)viewController
                         modalTransitionStyle:(UIModalTransitionStyle)theStyle
                                withImageName:(NSString *)imageName
                                    taskBlock:(void (^)(void))block {
    return [[self alloc] initWithViewController:viewController
                           modalTransitionStyle:theStyle
                                      imageName:imageName
                                      taskBlock:block];
}

+ (instancetype)addTransitionToViewController:(id)viewController
                         modalTransitionStyle:(UIModalTransitionStyle)theStyle
                                withImageData:(UIImage *)imageData
                                    taskBlock:(void (^)(void))block {
    return [[self alloc] initWithViewController:viewController
                           modalTransitionStyle:theStyle
                                      imageData:imageData
                                      taskBlock:block];
}

- (instancetype)initWithViewController:(id)viewController
                  modalTransitionStyle:(UIModalTransitionStyle)theStyle
                             imageData:(UIImage *)imageData
                             taskBlock:(void (^)(void))block {
    self = [super init];
    if (self) {
        [viewController setModalTransitionStyle:theStyle];
        launchImage = imageData;
        toViewController = viewController;
        block();
    }
    return self;
}

- (instancetype)initWithViewController:(id)viewController
                  modalTransitionStyle:(UIModalTransitionStyle)theStyle
                             imageName:(NSString *)imageName
                             taskBlock:(void (^)(void))block {
    self = [super init];
    if (self) {
        [viewController setModalTransitionStyle:theStyle];
        launchImage = [UIImage imageNamed:imageName];
        toViewController = viewController;
        block();
    }
    return self;
}

- (BOOL)prefersStatusBarHidden
{
    return STATUS_BAR_HIDDEN;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    fromImageView = [[UIImageView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    toImageView = [[UIImageView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    
    if ([self respondsToSelector:@selector(setNeedsStatusBarAppearanceUpdate)]) {
        [self prefersStatusBarHidden];
        [self performSelector:@selector(setNeedsStatusBarAppearanceUpdate)];
    }
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    fromImageView.image = [UIImage imageNamed:@"Splash_lauch"];
    [self.view addSubview:fromImageView];
    toImageView.image = launchImage;
    [self.view insertSubview:toImageView belowSubview:fromImageView];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:TRANSITION_DURATION];
    [fromImageView setAlpha:0.0f];
    [UIView commitAnimations];
    
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:ANIMATION_DURATION];
    CGAffineTransform transform = CGAffineTransformMakeScale(XSCALE, YSCALE);
    toImageView.transform = transform;
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDidStopSelector:@selector(presentNextViewController)];
    [UIView commitAnimations];
}


- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    toViewController = nil;
    launchImage = nil;
}

- (void)presentNextViewController {
    dispatch_async(dispatch_get_main_queue(), ^{
        [self dismissViewControllerAnimated:NO completion:NULL];
    });
}

@end
