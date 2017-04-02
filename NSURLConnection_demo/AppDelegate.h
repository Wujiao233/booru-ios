//
//  AppDelegate.h
//  NSURLConnection_demo
//
//  Created by Wujiao on 2017/3/4.
//  Copyright © 2017年 Wujiao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>{
    
}

@property (strong, nonatomic) UIWindow *window;

+(NSString *)getTags;
+(NSString *)getOriTags;
+(void)setTags:(NSString *)str;
+(NSString *)getSite;
+(void)setSite:(NSString *)str;
+(NSString *)getImageLevel;
+(void)setImageLevel:(NSString *)str;
+(NSString *)getLimit;
+(void)setLimit:(NSString *)str;

+(NSString *)getRating;
+(void)setRating:(NSString *)str;
+(NSString *)getCensore;
+(void)setCensore:(NSString *)str;

+(void)addHistory:(NSString *)tag;

@end

