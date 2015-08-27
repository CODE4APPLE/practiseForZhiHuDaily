//
//  HTTPHelper.h
//  ZhiHuDaily
//
//  Created by apple on 15/8/19.
//  Copyright (c) 2015年 yilos. All rights reserved.
//


@import UIKit;
@import Foundation;
#import "Contanst.h"

@interface HTTPHelper : NSObject

+ (void) GETURL:(NSString *)urlString
completionHandler:(void(^)(NSDictionary *,NSError *))block;

+ (void) POSTURL:(NSString *)urlString
      parameters:(NSData *)parameters
completionHandler:(void(^)(NSDictionary *,NSError *))block;

+ (void) sendSyncRequest:(NSURL *)url
       completionHandler:(void(^)(NSDictionary *,NSError *))block;

@end
