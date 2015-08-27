//
//  HTTPHelper.m
//  ZhiHuDaily
//
//  Created by apple on 15/8/19.
//  Copyright (c) 2015年 yilos. All rights reserved.
//

#import "HTTPHelper.h"

@interface HTTPHelper ()<NSURLSessionDataDelegate>

@end

@implementation HTTPHelper

+ (void) GETURL:(NSString *)urlString
completionHandler:(void(^)(NSDictionary *,NSError *))block {
    
    NSURL *url = [NSURL URLWithString:[urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    //获得NSURLSession单例对象
    NSURLSession *session = [NSURLSession sharedSession];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    [request setHTTPMethod:@"GET"];
    [request setCachePolicy:NSURLRequestReloadIgnoringCacheData];
    [request setHTTPShouldHandleCookies:NO];
    [request setTimeoutInterval:20];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    
    //创建任务
    NSURLSessionDataTask *task = [session dataTaskWithRequest:request
                                            completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                                                
                                                NSError *parseError = nil;
                                                NSDictionary* json = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&parseError];
                                                if (parseError) {
                                                    block(nil,parseError);
                                                    return;
                                                }
                                                block(json,error);
                                            }];
    [task resume];
}

+ (void) POSTURL:(NSString *)urlString
      parameters:(NSData *)parameters
completionHandler:(void(^)(NSDictionary *,NSError *))block {
    
   
    NSURL *url = [NSURL URLWithString:[urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    //获得NSURLSession单例对象
    NSURLSession *session = [NSURLSession sharedSession];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    [request setHTTPMethod:@"POST"];
    [request setHTTPBody:parameters];
    [request setCachePolicy:NSURLRequestReloadIgnoringCacheData];
    [request setHTTPShouldHandleCookies:NO];
    [request setTimeoutInterval:20];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    
    NSURLSessionDataTask *task = [session dataTaskWithRequest:request
                                            completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                                                
                                                NSError *parseError = nil;
                                                NSDictionary* json = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&parseError];
                                                if (parseError) {
                                                    block(nil,parseError);
                                                    return;
                                                }
                                                block(json,error);
                                            }];
    [task resume];
}

+ (void) sendSyncRequest:(NSURL *)url
       completionHandler:(void(^)(NSDictionary *,NSError *))block {
    NSURLRequest *req = [NSURLRequest requestWithURL:url];
    NSError *connectionError = nil;
    NSURLResponse *response = nil;
    NSData *data = [NSURLConnection sendSynchronousRequest:req returningResponse:&response error:&connectionError];
    NSError *parseError = nil;
    NSDictionary* json = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&parseError];
    if (parseError) {
        block(nil,parseError);
        return;
    }
    block(json,connectionError);
}


@end
