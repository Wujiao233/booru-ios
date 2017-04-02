//
//  YandeNetwork.m
//  NSURLConnection_demo
//
//  Created by Wujiao on 2017/3/15.
//  Copyright © 2017年 Wujiao. All rights reserved.
//

#import "YandeNetwork.h"
#import "AppDelegate.h"
#import "YandeView.h"

@implementation YandeNetwork

+(void)getPostFromServerWithTag:(NSString *)tags Page:(int)page WithNotificationId:(NSString *)code{
    int limit = [[AppDelegate getLimit]intValue];
    [self getPostFromServerWithTag:tags Page:page WithNotificationId:code Limit:limit];
}

+(void)getPostFromServerWithTag:(NSString *)tags Page:(int)page WithNotificationId:(NSString *)code Limit:(int)limit{
    tags = [tags stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    NSString * param = [NSString stringWithFormat:@"tags=%@&page=%d&limit=%d",tags,page,limit];
    
    NSURL * url = [NSURL URLWithString:[NSString stringWithFormat:@"http://yande.re/post.json?%@",param]];
    
    YandeView * indexView = [YandeView new];
    indexView.notificationId = code;
    
    NSURLSession * session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration] delegate:indexView delegateQueue:[NSOperationQueue new]];
    
    NSURLSessionDataTask * task = [session dataTaskWithRequest:[NSURLRequest requestWithURL:url]];
    
    [task resume];
}

@end
