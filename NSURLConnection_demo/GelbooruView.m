//
//  GelbooruView.m
//  NSURLConnection_demo
//
//  Created by Wujiao on 2017/3/15.
//  Copyright © 2017年 Wujiao. All rights reserved.
//

#import "GelbooruView.h"
#import "GDataXMLNode.h"
#import "AppDelegate.h"

@implementation GelbooruView


// 1.接收到服务器的响应
- (void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask didReceiveResponse:(NSURLResponse *)response completionHandler:(void (^)(NSURLSessionResponseDisposition))completionHandler {
    // 允许处理服务器的响应，才会继续接收服务器返回的数据
    completionHandler(NSURLSessionResponseAllow);
    NSLog(@"Gelbooru 收到响应");
}

// 2.接收到服务器的数据（可能调用多次）
- (void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask didReceiveData:(NSData *)data {
    // 处理每次接收的数据
    NSLog(@"Gelbooru 接受数据");
    if(!__data){
        __data = [NSMutableData new];
    }
    [__data appendData:data];
}

// 3.请求成功或者失败（如果失败，error有值）
- (void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task didCompleteWithError:(NSError *)error {
    // 请求完成,成功或者失败的处理
    NSLog(@"Gelbooru 请求完成");
    NSString *result = [[NSString alloc] initWithData:__data  encoding:NSUTF8StringEncoding];
    GDataXMLDocument *xmlDoc = [[GDataXMLDocument alloc]initWithXMLString:result options:0 error:nil];
    GDataXMLElement * xmlEle = [xmlDoc rootElement];
    NSArray * array = [xmlEle children];
    
    NSLog(@"Count : %ld",[array count]);
    NSMutableArray * resArray = [NSMutableArray new];
    for(int i=0;i<[array count];i++){
        GDataXMLElement * ele = [array objectAtIndex:i];
        NSMutableDictionary * tmpDict = [NSMutableDictionary new];
        [tmpDict setValue:[[ele attributeForName:@"tags"]stringValue] forKey:@"tags"];
        [tmpDict setValue:[[ele attributeForName:@"preview_height"]stringValue] forKey:@"actual_preview_height"];
        [tmpDict setValue:[[ele attributeForName:@"preview_width"]stringValue] forKey:@"actual_preview_width"];
        [tmpDict setValue:[[ele attributeForName:@"file_url"]stringValue] forKey:@"file_url"];
        if([[AppDelegate getImageLevel]isEqualToString:@"Low"]){
            [tmpDict setValue:[[ele attributeForName:@"preview_url"]stringValue] forKey:@"preview_url"];
        }else{
            [tmpDict setValue:[[ele attributeForName:@"sample_url"]stringValue] forKey:@"preview_url"];
        }
        [resArray addObject:tmpDict];
    }
    
//    NSError * jsonError;
//    NSDictionary * dict = [NSJSONSerialization JSONObjectWithData:__data options:NSJSONReadingMutableContainers error:&jsonError];
    //    NSLog(@"%@,%@",jsonError,dict);
    //    [self.viewControllerDelegate initTableViewWithDictUseDelegate:(NSMutableArray *)dict];
    //    NSLog(@"Send delegate");
    //    dispatch_async(dispatch_get_main_queue(), ^{
    //        [((ViewController *)self.viewController) initTableViewWithDict:dict];
    //    });
    [[NSNotificationCenter defaultCenter] postNotificationName:self.notificationId object:nil userInfo:resArray];
    
}

@end
