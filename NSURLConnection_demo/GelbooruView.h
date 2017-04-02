//
//  GelbooruView.h
//  NSURLConnection_demo
//
//  Created by Wujiao on 2017/3/15.
//  Copyright © 2017年 Wujiao. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GelbooruView : NSObject

@property NSString * notificationId;
@end

@interface GelbooruView() <NSURLSessionDelegate> {
    NSMutableData* __data;
}
@end
