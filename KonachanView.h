//
//  IndexView.h
//  NSURLConnection_demo
//
//  Created by Wujiao on 2017/3/4.
//  Copyright © 2017年 Wujiao. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface KonachanView : NSObject{
}
@property NSString * notificationId;

@end

@interface KonachanView() <NSURLSessionDelegate> {
    NSMutableData* __data;
}
@end
