//
//  BGCollectionViewCell.m
//  NSURLConnection_demo
//
//  Created by Wujiao on 2017/3/6.
//  Copyright © 2017年 Wujiao. All rights reserved.
//

#import "BGCollectionViewCell.h"
#import "UIImageView+WebCache.h"

@implementation BGCollectionViewCell
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self != nil) {
        [self initSubviews];
    }
    
    return self;
}

- (void)setUrlStr:(NSString *)urlStr{
    _urlStr = urlStr;
    [self setNeedsLayout];
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    [self initSubviews];
}

- (void)initSubviews
{
    self.picImgView = [[UIImageView alloc] initWithFrame:self.bounds];
    self.picImgView.contentMode = UIViewContentModeScaleAspectFill;
    self.picImgView.image = [UIImage imageNamed:@"example.png"];
    self.clipsToBounds = YES;
    [self.contentView addSubview:self.picImgView];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    self.picImgView.frame = self.bounds;
    NSURL *url = [NSURL URLWithString:self.urlStr];
    [self.picImgView sd_setImageWithURL:url placeholderImage:nil completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
    }];
    
}
@end
