//
//  ViewController.m
//  ZhiHuDaily
//
//  Created by yilos on 15/8/19.
//  Copyright (c) 2015年 yilos. All rights reserved.
//

#import "ViewController.h"
#import "HTTPHelper.h"
#import "NewsCell.h"
#import "NewsModel.h"
#import "StoryModel.h"
#import "NSDictionary+Log.h"
#import "NSArray+Log.h"
#import "MJRefresh.h"
#import "UINavigationBar+Awesome.h"
#import "UIScrollView+parallax.h"
#import "UIImageView+WebCache.h"

static CGFloat parallaxH = 200.0;

@interface ViewController ()<UITableViewDataSource,UITableViewDelegate,parallaxViewDelegate>

@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,strong) NSMutableArray *dataArray;
@property (nonatomic,assign) NSInteger  currentDate;
@property (nonatomic,strong) NSDateFormatter *formatter;
@property (nonatomic,strong) UIImageView *topImageView;
@property (nonatomic,strong) UIView *statusView;
@property (nonatomic,strong) UIScrollView *scrollView;

@end

@implementation ViewController {
    UIImageView *navBarHairLineImageView;
}

- (instancetype) init {
    self = [super init];
    if (self) {
        self.view.backgroundColor = [UIColor whiteColor];
    }
    return self;
}

- (void) loadData:(NSString *)urlstring {
    
    [HTTPHelper GETURL:urlstring completionHandler:^(NSDictionary *result, NSError *error) {

        if (!result || result.count == 0 || error) {
            NSLog(@"response error : %@",error);
            return;
        }
        
        StoryModel *model = [StoryModel objectWithKeyValues:result];
        self.currentDate = [model.date integerValue];
        [self.dataArray addObject:model];
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.tableView reloadData];
            [self.tableView.footer endRefreshing];
        });
    }];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    navBarHairLineImageView = [self findHairlineImageViewUnder:self.navigationController.navigationBar];
    [self.view addSubview:self.tableView];
    [self.view addSubview:self.statusView];
    [self.tableView addParallaxWithView:self.topImageView andHeight:parallaxH];
    self.dataArray = [NSMutableArray array];
    [self loadData:LATEST_NEWS_URL];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    navBarHairLineImageView.hidden = YES;
    self.title = @"今日热闻";
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self.topImageView sd_setImageWithURL:[NSURL URLWithString:@"http://pic4.zhimg.com/1e11ee519152830a6fff2ba670ed3b2b.jpg"]];
    [self.navigationController.navigationBar lt_setBackgroundColor:[UIColor clearColor]];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    navBarHairLineImageView.hidden = NO;
}

#pragma mark - 找出导航栏底部的分割线

- (UIImageView *)findHairlineImageViewUnder:(UIView *)view {
    if ([view isKindOfClass:UIImageView.class] && view.bounds.size.height <= 1.0) {
        return (UIImageView *)view;
    }
    for (UIView *subview in view.subviews) {
        UIImageView *imageView = [self findHairlineImageViewUnder:subview];
        if (imageView) {
            return imageView;
        }
    }
    return nil;
}

- (void)loadMoreNews {
    [self loadData:[NSString stringWithFormat:BEFORE_NEWS_URL,@(self.currentDate)]];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    UIColor * color = [UIColor colorWithRed:0/255.0 green:175/255.0 blue:240/255.0 alpha:1];
    CGFloat offsetY = scrollView.contentOffset.y;
    
    if (offsetY > 0) {
        CGFloat alpha = MIN(1.0, (1.0 - (64*2 - offsetY) / 64.0));
        [self.navigationController.navigationBar lt_setBackgroundColor:[color colorWithAlphaComponent:alpha]];
        if (alpha >= 1.0) {
            StoryModel *model = self.dataArray[0];
            self.tableView.contentInset = UIEdgeInsetsMake(20, 0, 44, 0);
            if (offsetY+20 >= [model.stories count] * 84) {
                self.statusView.hidden = NO;
                self.title = @"";
                [self.navigationController.navigationBar lt_setBackgroundColor:[color colorWithAlphaComponent:0]];
            }else {
                
            }
        }
        
    } else {
        
        self.statusView.hidden = YES;
        [self.navigationController.navigationBar lt_setBackgroundColor:[color colorWithAlphaComponent:0]];
        self.title = @"今日热闻";
        self.tableView.contentInset = UIEdgeInsetsMake(parallaxH+64, 0, 44, 0);
    }
}


#pragma mark - tableView dataSource & delegate

- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView {
    return [self.dataArray count];;
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    StoryModel *model = self.dataArray[section];
    return [model.stories count];
}

- (CGFloat) tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (0 == section) {
        return 0.0;
    }
    return 44.0;
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 84.0;
}

- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NewsCell *cell = [tableView dequeueReusableCellWithIdentifier:@"NewsID" forIndexPath:indexPath];
    StoryModel *model = self.dataArray[indexPath.section];
    cell.model = model.stories[indexPath.row];
    return cell;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {

    StoryModel *model = self.dataArray[section];
    return [self viewForHeaderInSection:model.date];
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (UIView *)viewForHeaderInSection:(NSString *)text {
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.tableView.frame), 44)];
    titleLabel.backgroundColor = RGB(0, 175, 240, 1);
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.font = [UIFont boldSystemFontOfSize:14];
    titleLabel.text = [self dateForHeaderInSection:text];
    return titleLabel;
}

- (NSString *)dateForHeaderInSection:(NSString *)date {
    self.formatter.dateFormat = @"yyyyMMdd";
    NSDate *today = [self.formatter dateFromString:date];
    self.formatter.dateFormat = @"MM月d日 cccc";
    return [self.formatter stringFromDate:today];
}

- (NSDateFormatter *)formatter {
    if (!_formatter) {
        _formatter = [[NSDateFormatter alloc] init];
        _formatter.locale = [NSLocale localeWithLocaleIdentifier:@"zh_CN"];
    }
    return _formatter;
}

- (UIImageView *)topImageView {
    
    if (!_topImageView) {
        _topImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.bounds),parallaxH)];
        _topImageView.contentMode = UIViewContentModeScaleAspectFill;
    }
    return _topImageView;
}

- (UIView *)statusView {
    if (!_statusView) {
        _statusView = [[UIView alloc] initWithFrame:CGRectMake(0, -20, CGRectGetWidth(self.view.bounds), 40)];
        _statusView.backgroundColor = RGB(0, 175, 240, 1);
    }
    return _statusView;
}

- (UIScrollView *)scrollView {
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.bounds),parallaxH)];
        _scrollView.pagingEnabled = YES;
    }
    return _scrollView;
}

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:self.view.bounds];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        _tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
        [_tableView registerClass:[NewsCell class] forCellReuseIdentifier:@"NewsID"];
        MJRefreshAutoNormalFooter *footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreNews)];
        footer.appearencePercentTriggerAutoRefresh = -40.0;
        _tableView.footer = footer;
    }
    return _tableView;
}


@end
