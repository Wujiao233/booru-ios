//
//  AppDelegate.h
//  NSURLConnection_demo
//
//  Created by Wujiao on 2017/3/4.
//  Copyright © 2017年 Wujiao. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "DownloadManagerViewModel.h"

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
+(NSInteger)getLineNumber;
+(void)setLineNumber:(NSInteger)i;
+(NSString *)getSizeType;
+(void)setSizeType:(NSString *)str;


+(NSInteger)getHeightLimit;
+(void)setHeightLimit:(NSInteger)i;
+(NSInteger)getWidthLimit;
+(void)setWidthLimit:(NSInteger)i;

+(void)addHistory:(NSString *)tag;

+(DownloadManagerViewModel *)getDownloadVM;

@end

