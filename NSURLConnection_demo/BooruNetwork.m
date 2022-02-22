//
//  BooruNetwork.m
//  NSURLConnection_demo
//
//  Created by Wujiao on 2017/3/23.
//  Copyright © 2017年 Wujiao. All rights reserved.
//

#import "BooruNetwork.h"
#import "AppDelegate.h"
#import "TagsView.h"
#import "SiteMethodMapper.h"
#import "BooruView.h"

@implementation BooruNetwork

+(void)getPostFromServerWithTag:(NSString *)tags Page:(int)page WithNotificationId:(NSString *)code{
    int limit = [[AppDelegate getLimit]intValue];
    [self getPostFromServerWithTag:tags Page:page WithNotificationId:code Limit:limit];
}

+(void)getPostFromServerWithTag:(NSString *)tags Page:(int)page WithNotificationId:(NSString *)code Limit:(int)limit{
    tags = [tags stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    NSURL * url = [NSURL URLWithString: [[SiteMethodMapper getSiteMethodMapper] getRequestUrlWithKey:[AppDelegate getSite] Tags:tags Page:page Limit:limit]];
    
    NSLog(@"%@",url);
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    NSLog(@"%@",[request allHTTPHeaderFields]);
    request.HTTPMethod = @"GET";
    BooruView * indexView = [BooruView new];
    indexView.notificationId = code;
    NSURLSession * session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration] delegate:indexView delegateQueue:[NSOperationQueue new]];
    NSURLSessionDataTask * task = [session dataTaskWithRequest:request];
    
    [task resume];
}

+(void)getTagInfoFromServerWithKey:(NSString *)key AndLimit:(int)limit Code:(NSString*)code{
    NSURL * url = [NSURL URLWithString:@"http://konachan.zju.link/FindTag.php"];
    TagsView * tagsView = [TagsView new];
    tagsView.notificationId =code;
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    request.HTTPMethod = @"POST";
    NSString * param = [NSString stringWithFormat:@"key=%@&limit=%d",key,limit];
    request.HTTPBody = [param dataUsingEncoding:NSUTF8StringEncoding];
    
    NSURLSession * session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration] delegate:tagsView delegateQueue:[NSOperationQueue new]];
    NSURLSessionDataTask * task = [session dataTaskWithRequest:request];
    
    [task resume];
}

@end
