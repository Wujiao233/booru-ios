//
//  YandeView.h
//  NSURLConnection_demo
//
//  Created by Wujiao on 2017/3/15.
//  Copyright © 2017年 Wujiao. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YandeView : NSObject

@property NSString * notificationId;
@end

@interface YandeView() <NSURLSessionDelegate> {
    NSMutableData* __data;
}
@end
