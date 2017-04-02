//
//  TableFootViewController.m
//  NSURLConnection_demo
//
//  Created by Wujiao on 2017/3/4.
//  Copyright © 2017年 Wujiao. All rights reserved.
//

#import "TableFootViewController.h"

@implementation TableFootViewController

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (id) initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if(self){
        UILabel * label = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
        label.text = @"加载中.....";
        label.textAlignment = NSTextAlignmentCenter;
        [self addSubview:label];
    }
    return self;
}

@end
