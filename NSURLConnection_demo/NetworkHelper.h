//
//  NetworkHelper.h
//  NSURLConnection_demo
//
//  Created by Wujiao on 2017/4/3.
//  Copyright © 2017年 Wujiao. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^CompleteBlock)(NSMutableData * data);

@interface NetworkHelper : NSObject

+(instancetype)getHelper;

-(void)getRemotoResponseUrl:(NSString *)url Method:(NSString*)method Block:(CompleteBlock)block;

-(void)getRemotoResponseUrl:(NSString *)url Method:(NSString*)method Body:(NSString *)body Block:(CompleteBlock)block;

@property NSString * notificationId;
@property CompleteBlock completeBlock;

@end

@interface NetworkHelper() <NSURLSessionDelegate> {
    NSMutableData* __data;
}
@end
