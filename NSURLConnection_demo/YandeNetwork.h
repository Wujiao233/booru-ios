//
//  YandeNetwork.h
//  NSURLConnection_demo
//
//  Created by Wujiao on 2017/3/15.
//  Copyright © 2017年 Wujiao. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YandeNetwork : NSObject

+(void)getPostFromServerWithTag:(NSString *)tags Page:(int)page WithNotificationId:(NSString*)code;
+(void)getPostFromServerWithTag:(NSString *)tags Page:(int)page WithNotificationId:(NSString*)code Limit:(int)limit;

@end
