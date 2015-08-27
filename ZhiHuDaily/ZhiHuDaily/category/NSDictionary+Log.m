//
//  NSDictionary+Log.m
//  ZLHttpHelper
//
//  Created by apple on 15/7/25.
//  Copyright (c) 2015年 com.iOSDevBird. All rights reserved.
//

#import "NSDictionary+Log.h"

@implementation NSDictionary (Log)

- (NSString *)descriptionWithLocale:(id)locale
{
    NSMutableString *str =[NSMutableString string];
    [str appendString:@"{\n"];
    [self enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
        // 拼接字符串
        [str appendFormat:@"\t%@",key];
        [str appendString:@" : "];
        [str appendFormat:@"%@,\n",obj];
    }];
    [str appendString:@"}"];
    // 取出最后一个逗号
    NSRange range = [str rangeOfString:@"," options:NSBackwardsSearch];
    if (range.location != NSNotFound) {
        [str deleteCharactersInRange:range];
    }
    return str;
}

@end
