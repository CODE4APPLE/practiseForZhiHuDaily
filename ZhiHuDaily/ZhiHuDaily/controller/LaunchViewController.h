//
//  LaunchViewController.h
//  ZhiHuDaily
//
//  Created by yilos on 15/8/20.
//  Copyright (c) 2015年 yilos. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LaunchViewController : UIViewController

+ (instancetype)addTransitionToViewController:(id)viewController
                         modalTransitionStyle:(UIModalTransitionStyle)theStyle
                                withImageName:(NSString *)imageName
                                    taskBlock:(void (^)(void))block;

+ (instancetype)addTransitionToViewController:(id)viewController
                         modalTransitionStyle:(UIModalTransitionStyle)theStyle
                                withImageData:(UIImage *)imageData
                                    taskBlock:(void (^)(void))block;
@end
