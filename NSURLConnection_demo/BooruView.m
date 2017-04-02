//
//  BooruView.m
//  NSURLConnection_demo
//
//  Created by Wujiao on 2017/3/23.
//  Copyright © 2017年 Wujiao. All rights reserved.
//

#import "BooruView.h"
#import "SiteMethodMapper.h"
#import "AppDelegate.h"

@implementation BooruView

- (void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask didReceiveResponse:(NSURLResponse *)response completionHandler:(void (^)(NSURLSessionResponseDisposition))completionHandler {
    completionHandler(NSURLSessionResponseAllow);
    NSLog(@"收到响应");
}

- (void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask didReceiveData:(NSData *)data {
    // 处理每次接收的数据
    NSLog(@"接受数据");
    if(!__data){
        __data = [NSMutableData new];
    }
    [__data appendData:data];
}

- (void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task didCompleteWithError:(NSError *)error {
    // 请求完成,成功或者失败的处理
    NSLog(@"请求完成");
    NSLog(@"%@",error);
    NSDictionary * result =[[SiteMethodMapper getSiteMethodMapper]getResultProcessMethod:[AppDelegate getSite] AndData:__data];
    [[NSNotificationCenter defaultCenter] postNotificationName:self.notificationId object:nil userInfo:result];
}


@end
