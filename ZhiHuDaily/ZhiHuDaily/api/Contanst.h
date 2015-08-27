//
//  Contanst.h
//  ZhiHuDaily
//
//  Created by yilos on 15/8/19.
//  Copyright (c) 2015年 yilos. All rights reserved.
//

#ifndef ZhiHuDaily_Contanst_h
#define ZhiHuDaily_Contanst_h


#define pixelWidth        CGRectGetWidth([UIScreen mainScreen].bounds)*2
#define pixelHeight       CGRectGetHeight([UIScreen mainScreen].bounds)*2
#define pixelSize         [NSString stringWithFormat:@"%.0f*%.0f",pixelWidth,pixelHeight]
#define RGB(r,g,b,a)	  [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:a]
#define TRANSITION_DURATION 1.68
#define ANIMATION_DURATION 4.0
#define XSCALE 1.15
#define YSCALE 1.15
#define STATUS_BAR_HIDDEN 1

#define SERVERHOST        @"http://news-at.zhihu.com"
#define LAUNCH_IMAGE_URL  [SERVERHOST stringByAppendingString:@"/api/4/start-image/%@"]
#define LATEST_NEWS_URL   [SERVERHOST stringByAppendingString:@"/api/4/news/latest?client=0"]
#define BEFORE_NEWS_URL   [SERVERHOST stringByAppendingString:@"/api/4/news/before/%@?client=0"]
#define DETAIL_STORY_URL  [SERVERHOST stringByAppendingString:@"api/4/story/%@"]
#define EXTRA_STORY_URL   [SERVERHOST stringByAppendingString:@"api/4/story-extra/%@"]
#define LONG_COMMENTS_URL [SERVERHOST stringByAppendingString:@"/api/4/story/%@/long-comments"]
#define VOTE_STORY_URL    [SERVERHOST stringByAppendingString:@"/api/4/vote/stories"]
#define ACTIVITY_URL      [SERVERHOST stringByAppendingString:@"/api/4/activity"]
#define THEMES_URL        [SERVERHOST stringByAppendingString:@"/api/4/themes"]

#endif
