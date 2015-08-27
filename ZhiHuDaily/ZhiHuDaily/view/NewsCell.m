//
//  NewsCell.m
//  ZhiHuDaily
//
//  Created by apple on 15/8/19.
//  Copyright (c) 2015年 yilos. All rights reserved.
//

#import "NewsCell.h"
#import "Masonry.h"
#import "UIImageView+WebCache.h"

@implementation NewsCell {
    UILabel *titleLabel;
    UIImageView *imageView;
}

- (instancetype) initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        //247
        titleLabel = [UILabel new];
        titleLabel.font = [UIFont systemFontOfSize:14];
        titleLabel.textColor = [UIColor blackColor];
        titleLabel.numberOfLines = 0;
        [self.contentView addSubview:titleLabel];
        
        imageView = [UIImageView new];
        imageView.contentMode = UIViewContentModeScaleAspectFill;
        imageView.clipsToBounds = YES;
        [self.contentView addSubview:imageView];
        
        [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(15);
            make.left.mas_equalTo(15);
            make.right.equalTo(imageView.mas_left).offset(-15);
            make.bottom.mas_equalTo(-15);
        }];
        
        [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(15);
            make.right.mas_equalTo(-15);
            make.size.mas_equalTo(CGSizeMake(67.5, 54));
        }];
    }
    return self;
}


- (void) setModel:(NewsModel *)model {
    if (model==nil) {
        return;
    }
    titleLabel.text = model.title;
    [imageView sd_setImageWithURL:[NSURL URLWithString:[model.images lastObject]]];
}






@end
