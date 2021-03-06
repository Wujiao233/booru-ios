//
//  KonachanNetwork.h
//  NSURLConnection_demo
//
//  Created by Wujiao on 2017/3/4.
//  Copyright © 2017年 Wujiao. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface KonachanNetwork :NSObject

+(void)getPostFromServerWithTag:(NSString *)tags Page:(int)page WithNotificationId:(NSString*)code;
+(void)getPostFromServerWithTag:(NSString *)tags Page:(int)page WithNotificationId:(NSString*)code Limit:(int)limit;
+(void)getTagInfoFromServerWithKey:(NSString *)key AndLimit:(int)limit Code:(NSString*)code;

@end
