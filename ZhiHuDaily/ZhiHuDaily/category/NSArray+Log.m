//
//  NSArray+Log.m
//  ZLHttpHelper
//
//  Created by apple on 15/7/25.
//  Copyright (c) 2015年 com.iOSDevBird. All rights reserved.
//

#import "NSArray+Log.h"

@implementation NSArray (Log)

- (NSString *)descriptionWithLocale:(id)locale
{
    NSMutableString *str =[NSMutableString string];
    [str appendString:@"[\n"];
    [self enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        [str appendFormat:@"\t%@,\n",obj];
    }];
    [str appendString:@"\t]"];
    // 取出最后一个逗号
    NSRange range = [str rangeOfString:@"," options:NSBackwardsSearch];
    if (range.location != NSNotFound) {
        [str deleteCharactersInRange:range];
    }
    return str;
}


@end
