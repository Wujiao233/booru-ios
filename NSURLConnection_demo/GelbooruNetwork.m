//
//  GelbooruNetwork.m
//  NSURLConnection_demo
//
//  Created by Wujiao on 2017/3/15.
//  Copyright © 2017年 Wujiao. All rights reserved.
//

#import "GelbooruNetwork.h"
#import "GelbooruView.h"
#import "AppDelegate.h"

@implementation GelbooruNetwork

+(void)getPostFromServerWithTag:(NSString *)tags Page:(int)page WithNotificationId:(NSString *)code{
    int limit = [[AppDelegate getLimit]intValue];
    [self getPostFromServerWithTag:tags Page:page WithNotificationId:code Limit:limit];
}

+(void)getPostFromServerWithTag:(NSString *)tags Page:(int)page WithNotificationId:(NSString *)code Limit:(int)limit{
    tags = [tags stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    NSString * param = [NSString stringWithFormat:@"page=dapi&s=post&q=index&tags=%@&pid=%d&limit=%d",tags,page,limit];
    NSURL * url = [NSURL URLWithString:[NSString stringWithFormat:@"http://gelbooru.com/index.php?%@",param]];
//    NSLog(@"%@",param);
    GelbooruView * indexView = [GelbooruView new];
    indexView.notificationId = code;
    
    NSURLSession * session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration] delegate:indexView delegateQueue:[NSOperationQueue new]];
    
    NSURLSessionDataTask * task = [session dataTaskWithRequest:[NSURLRequest requestWithURL:url]];
    
    [task resume];
}

@end
