//
//  YandeView.m
//  NSURLConnection_demo
//
//  Created by Wujiao on 2017/3/15.
//  Copyright © 2017年 Wujiao. All rights reserved.
//

#import "YandeView.h"

@implementation YandeView

// 1.接收到服务器的响应
- (void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask didReceiveResponse:(NSURLResponse *)response completionHandler:(void (^)(NSURLSessionResponseDisposition))completionHandler {
    // 允许处理服务器的响应，才会继续接收服务器返回的数据
    completionHandler(NSURLSessionResponseAllow);
    NSLog(@"Yande 收到响应");
}

// 2.接收到服务器的数据（可能调用多次）
- (void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask didReceiveData:(NSData *)data {
    // 处理每次接收的数据
    NSLog(@"Yande 接受数据");
    if(!__data){
        __data = [NSMutableData new];
    }
    [__data appendData:data];
}

// 3.请求成功或者失败（如果失败，error有值）
- (void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task didCompleteWithError:(NSError *)error {
    // 请求完成,成功或者失败的处理
    NSLog(@"Yande 请求完成");
    NSLog(@"%@",error);
    NSError * jsonError;
    NSDictionary * dict = [NSJSONSerialization JSONObjectWithData:__data options:NSJSONReadingMutableContainers error:&jsonError];
    NSMutableArray * tmpArray = (NSMutableArray *)dict;
    for(int i=0;i<[tmpArray count];i++){
        tmpArray[i][@"preview_url"] = [tmpArray[i][@"preview_url"] stringByReplacingOccurrencesOfString:@"https:" withString:@""];
        tmpArray[i][@"file_url"] = [tmpArray[i][@"file_url"] stringByReplacingOccurrencesOfString:@"https:" withString:@""];
    }
    
    //    NSLog(@"%@,%@",jsonError,dict);
    //    [self.viewControllerDelegate initTableViewWithDictUseDelegate:(NSMutableArray *)dict];
    //    NSLog(@"Send delegate");
    //    dispatch_async(dispatch_get_main_queue(), ^{
    //        [((ViewController *)self.viewController) initTableViewWithDict:dict];
    //    });
    [[NSNotificationCenter defaultCenter] postNotificationName:self.notificationId object:nil userInfo:tmpArray];
    
}

@end
