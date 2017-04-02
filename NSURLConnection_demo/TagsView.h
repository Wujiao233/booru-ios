//
//  TagsView.h
//  NSURLConnection_demo
//
//  Created by Wujiao on 2017/3/7.
//  Copyright © 2017年 Wujiao. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TagsView : NSObject

@property NSString * notificationId;
    
@end

@interface TagsView() <NSURLSessionDelegate> {
    NSMutableData* __data;
}
@end
