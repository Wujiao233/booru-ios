//
//  BooruView.h
//  NSURLConnection_demo
//
//  Created by Wujiao on 2017/3/23.
//  Copyright © 2017年 Wujiao. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BooruView : NSObject

@property NSString * notificationId;
@end

@interface BooruView() <NSURLSessionDelegate> {
    NSMutableData* __data;
}
@end
