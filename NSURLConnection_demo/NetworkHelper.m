//
//  NetworkHelper.m
//  NSURLConnection_demo
//
//  Created by Wujiao on 2017/4/3.
//  Copyright © 2017年 Wujiao. All rights reserved.
//

#import "NetworkHelper.h"
#import "SiteMethodMapper.h"
#import "AppDelegate.h"

static NetworkHelper * ownNetworkHelper;

@implementation NetworkHelper

// Git Commit Auther Test

+(instancetype)getHelper{
    if(ownNetworkHelper == nil){
        ownNetworkHelper = [NetworkHelper new];
    }
    return ownNetworkHelper;
}

-(void)getRemotoResponseUrlUsingGET:(NSString *)url Block:(CompleteBlock)block{
    [self getRemotoResponseUrl:url Method:@"GET" Block:block];
}

-(void)getRemotoResponseUrl:(NSString *)url Method:(NSString*)method Block:(CompleteBlock)block{
    [self getRemotoResponseUrl:url Method:method Body:nil Block:block];
}

-(void)getRemotoResponseUrl:(NSString *)url Method:(NSString*)method Body:(NSString *)body Block:(CompleteBlock)block{
    self.completeBlock = block;
    NSURL * nsUrl = [NSURL URLWithString:url];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:nsUrl];
    request.HTTPMethod = method;
    if([method isEqualToString:@"POST"] && body != nil){
        request.HTTPBody = [body dataUsingEncoding:NSUTF8StringEncoding];
    }
    NSURLSession * session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration] delegate:self delegateQueue:[NSOperationQueue new]];
    NSURLSessionDataTask * task = [session dataTaskWithRequest:request];
    
    [task resume];
}

- (void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask didReceiveResponse:(NSURLResponse *)response completionHandler:(void (^)(NSURLSessionResponseDisposition))completionHandler {
    completionHandler(NSURLSessionResponseAllow);
    NSLog(@"收到响应");
}

- (void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask didReceiveData:(NSData *)data {
    NSLog(@"接受数据");
    if(!__data){
        __data = [NSMutableData new];
    }
    [__data appendData:data];
}

- (void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task didCompleteWithError:(NSError *)error {
    // 请求完成,成功或者失败的处理
    NSLog(@"请求完成");
    if(self.completeBlock != nil)self.completeBlock(__data);
    // NSDictionary * result =[[SiteMethodMapper getSiteMethodMapper]getResultProcessMethod:[AppDelegate getSite] AndData:__data];
    // [[NSNotificationCenter defaultCenter] postNotificationName:self.notificationId object:nil userInfo:result];
}

@end

