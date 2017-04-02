//
//  KonachanNetwork.m
//  NSURLConnection_demo
//
//  Created by Wujiao on 2017/3/4.
//  Copyright © 2017年 Wujiao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "KonachanNetwork.h"
#import "KonachanView.h"
#import "TagsView.h"
#import "AppDelegate.h"


@implementation KonachanNetwork

+(void)getPostFromServerWithTag:(NSString *)tags Page:(int)page WithNotificationId:(NSString *)code{
    int limit = [[AppDelegate getLimit]intValue];
    [self getPostFromServerWithTag:tags Page:page WithNotificationId:code Limit:limit];
}

+(void)getPostFromServerWithTag:(NSString *)tags Page:(int)page WithNotificationId:(NSString *)code Limit:(int)limit{
    tags = [tags stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    NSString * param = [NSString stringWithFormat:@"tags=%@&page=%d&limit=%d",tags,page,limit];
    
    NSURL * url = [NSURL URLWithString:[NSString stringWithFormat:@"http://konachan.com/post.json?%@",param]];
    
    KonachanView * indexView = [KonachanView new];
    indexView.notificationId = code;
    
    NSURLSession * session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration] delegate:indexView delegateQueue:[NSOperationQueue new]];
    
    NSURLSessionDataTask * task = [session dataTaskWithRequest:[NSURLRequest requestWithURL:url]];
    
    [task resume];
}

+(void)getTagInfoFromServerWithKey:(NSString *)key AndLimit:(int)limit Code:(NSString*)code{
//    key = [key stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    NSURL * url = [NSURL URLWithString:@"http://konachan.zju.link/FindTag.php"];
    
    TagsView * tagsView = [TagsView new];
    tagsView.notificationId =code;
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    request.HTTPMethod = @"POST";
    NSString * param = [NSString stringWithFormat:@"key=%@&limit=%d",key,limit];
//    NSLog(param);
    request.HTTPBody = [param dataUsingEncoding:NSUTF8StringEncoding];
    
    NSURLSession * session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration] delegate:tagsView delegateQueue:[NSOperationQueue new]];
    
    NSURLSessionDataTask * task = [session dataTaskWithRequest:request];
    
    [task resume];
}


@end

