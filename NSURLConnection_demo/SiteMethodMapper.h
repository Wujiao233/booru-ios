//
//  SiteMethodMapper.h
//  NSURLConnection_demo
//
//  Created by Wujiao on 2017/3/23.
//  Copyright © 2017年 Wujiao. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SiteMethodMapper : NSObject

+(SiteMethodMapper *)getSiteMethodMapper;
-(NSString *)getRequestUrlWithKey:(NSString *) key Tags:(NSString *) tags Page:(int)page Limit:(int) limit;
-(NSDictionary *)getResultProcessMethod:(NSString *) key AndData:(NSMutableData *) data;
-(NSArray *)getSiteMapKeys;

@end

@interface SiteMethodMapper(){
    NSMutableDictionary * siteUrlMap;
    NSMutableDictionary * siteMethodMap;
}

-(id)initWithNothing;
-(void)addSiteMap;

@end
