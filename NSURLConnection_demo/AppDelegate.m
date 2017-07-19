//
//  AppDelegate.m
//  NSURLConnection_demo
//
//  Created by Wujiao on 2017/3/4.
//  Copyright © 2017年 Wujiao. All rights reserved.
//

#import "AppDelegate.h"
#import "HistoryViewController.h"

static NSString * tags;
static NSString * site;
static NSString * imageLevel;
static NSString * limit;

static NSString * ratting;
static NSString * censore;

static NSInteger lineNumber;

@interface AppDelegate ()

@end

@implementation AppDelegate

+(void)addHistory:(NSString *)tag{
    if([tag isEqualToString:@" "])return;
    NSMutableArray * arr =[[NSMutableArray alloc]initWithArray:[[NSUserDefaults standardUserDefaults]valueForKey:@"History"]];
    if(![arr containsObject:tag]){
        [arr insertObject:tag atIndex:0];
    }
    NSArray * tmp = [[NSArray alloc]initWithArray:arr];
    [[NSUserDefaults standardUserDefaults]setObject:tmp forKey:@"History"];
    [[NSUserDefaults standardUserDefaults]synchronize];
    
}

+(NSString *)getSite{
    return site;
}
+(void)setSite:(NSString *)str{
    site = str;
}

+(NSString *)getTags{
    return [NSString stringWithFormat:@"%@ %@ %@",tags,ratting,censore];
}
+(NSString *)getOriTags{
    return tags;
}
+(void)setTags:(NSString *)str{
    tags = str;
    [self addHistory:str];
}

+(NSString *)getImageLevel{
    return imageLevel;
}
+(void)setImageLevel:(NSString *)str{
    imageLevel = str;
}

+(NSString *)getLimit{
    return limit;
}
+(void)setLimit:(NSString *)str{
    limit = str;
}

+(NSInteger)getLineNumber{
    return lineNumber;
}
+(void)setLineNumber:(NSInteger)i{
    lineNumber = i;
}

+(NSString *)getRating{
    return ratting;
}
+(void)setRating:(NSString *)str{
    ratting = str;
    [[NSUserDefaults standardUserDefaults]setObject:ratting forKey:@"ratting"];
    [[NSUserDefaults standardUserDefaults]synchronize];
}

+(NSString *)getCensore{
    return censore;
}
+(void)setCensore:(NSString *)str{
    censore = str;
    [[NSUserDefaults standardUserDefaults]setObject:censore forKey:@"censore"];
    [[NSUserDefaults standardUserDefaults]synchronize];
}



- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    site = [[NSUserDefaults standardUserDefaults]stringForKey:@"site"];
    if(!site){
        site = @"Konachan";
        [[NSUserDefaults standardUserDefaults]setObject:site forKey:@"site"];
        [[NSUserDefaults standardUserDefaults]synchronize];
    }
    
    imageLevel = [[NSUserDefaults standardUserDefaults]stringForKey:@"imageLevel"];
    if(!imageLevel){
        imageLevel = @"High";
        [[NSUserDefaults standardUserDefaults]setObject:imageLevel forKey:@"imageLevel"];
        [[NSUserDefaults standardUserDefaults]synchronize];
    }
    
    limit = [[NSUserDefaults standardUserDefaults]stringForKey:@"limit"];
    if(!limit){
        limit = @"20";
        [[NSUserDefaults standardUserDefaults]setObject:limit forKey:@"limit"];
        [[NSUserDefaults standardUserDefaults]synchronize];
    }
    
    ratting = [[NSUserDefaults standardUserDefaults]stringForKey:@"ratting"];
    if(!ratting){
        ratting = @"rating:safe";
        [[NSUserDefaults standardUserDefaults]setObject:ratting forKey:@"ratting"];
        [[NSUserDefaults standardUserDefaults]synchronize];
    }
    
    censore = [[NSUserDefaults standardUserDefaults]stringForKey:@"censore"];
    if(!censore){
        censore = @"";
        [[NSUserDefaults standardUserDefaults]setObject:censore forKey:@"censore"];
        [[NSUserDefaults standardUserDefaults]synchronize];
    }
    
    NSArray * history = [[NSUserDefaults standardUserDefaults]valueForKey:@"History"];
    if(!history){
        history = [NSArray new];
        [[NSUserDefaults standardUserDefaults]setObject:history forKey:@"History"];
        [[NSUserDefaults standardUserDefaults]synchronize];
    }
    
    return YES;
}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}



@end
