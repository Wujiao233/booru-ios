//
//  SiteMethodMapper.m
//  NSURLConnection_demo
//
//  Created by Wujiao on 2017/3/23.
//  Copyright © 2017年 Wujiao. All rights reserved.
//

#import "SiteMethodMapper.h"
#import "GDataXMLNode.h"
#import "AppDelegate.h"

typedef NSString * (^UrlMapper)(NSString *,int,int);
typedef NSDictionary * (^ResultProcessMethod)(NSMutableData *);

static SiteMethodMapper * siteMethodMapper;

@implementation SiteMethodMapper

+(SiteMethodMapper *)getSiteMethodMapper{
    if(siteMethodMapper){
        return siteMethodMapper;
    }
    siteMethodMapper = [[SiteMethodMapper alloc]initWithNothing];
    return siteMethodMapper;
}

-(id)initWithNothing{
    self = [super init];
    if(self){
        siteMethodMap = [NSMutableDictionary new];
        siteUrlMap = [NSMutableDictionary new];
        [self addSiteMap];
    }
    return self;
}

-(NSString *)getRequestUrlWithKey:(NSString *) key Tags:(NSString *) tags Page:(int)page Limit:(int) limit{
    return ((UrlMapper)siteUrlMap[key])(tags,page,limit);
}

-(NSDictionary *)getResultProcessMethod:(NSString *) key AndData:(NSMutableData *) data{
    return ((ResultProcessMethod)siteMethodMap[key])(data);
}

-(NSArray *)getSiteMapKeys{
    return [siteUrlMap allKeys];
}

-(void)addSiteMap{
    [siteUrlMap setObject:(NSString *)^(NSString * tags,int page,int limit){
        NSString * param = [NSString stringWithFormat:@"tags=%@&page=%d&limit=%d",tags,page,limit];
        NSString * result = [NSString stringWithFormat:@"http://konachan.com/post.json?%@",param];
        return result;
    } forKey:@"Konachan"];
    
    [siteMethodMap setObject:(NSDictionary *)^(NSMutableData * data){
        NSError * jsonError;
        NSDictionary * dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&jsonError];
        return dict;
    } forKey:@"Konachan"];
    
    [siteUrlMap setObject:(NSString *)^(NSString * tags,int page,int limit){
        tags = [tags stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
        tags = [tags stringByReplacingOccurrencesOfString:@"%2520" withString:@"%20"];
        NSString * param = [NSString stringWithFormat:@"page=dapi&s=post&q=index&tags=%@&pid=%d&limit=%d",tags,page-1,limit];
        NSString * result = [NSString stringWithFormat:@"http://gelbooru.com/index.php?%@",param];
        return result;
    } forKey:@"Gelbooru"];
    
    [siteMethodMap setObject:(NSDictionary *)^(NSMutableData * data){
        NSString *result = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        GDataXMLDocument *xmlDoc = [[GDataXMLDocument alloc]initWithXMLString:result options:0 error:nil];
        GDataXMLElement * xmlEle = [xmlDoc rootElement];
        NSArray * array = [xmlEle children];
        NSLog(@"Count : %ld",[array count]);
        NSMutableArray * resArray = [NSMutableArray new];
        for(int i=0;i<[array count];i++){
            GDataXMLElement * ele = [array objectAtIndex:i];
            NSMutableDictionary * tmpDict = [NSMutableDictionary new];
            [tmpDict setValue:[[ele attributeForName:@"tags"]stringValue] forKey:@"tags"];
            [tmpDict setValue:[[ele attributeForName:@"preview_height"]stringValue] forKey:@"actual_preview_height"];
            [tmpDict setValue:[[ele attributeForName:@"preview_width"]stringValue] forKey:@"actual_preview_width"];
            [tmpDict setValue:[[ele attributeForName:@"file_url"]stringValue] forKey:@"file_url"];
            if([[AppDelegate getImageLevel]isEqualToString:@"Low"]){
                [tmpDict setValue:[[ele attributeForName:@"preview_url"]stringValue] forKey:@"preview_url"];
            }else{
                [tmpDict setValue:[[ele attributeForName:@"sample_url"]stringValue] forKey:@"preview_url"];
            }
            [resArray addObject:tmpDict];
        }
        return (NSDictionary *)resArray;
    } forKey:@"Gelbooru"];
    
    [siteUrlMap setObject:(NSString *)^(NSString * tags,int page,int limit){
        tags = [tags stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
        tags = [tags stringByReplacingOccurrencesOfString:@"%2520" withString:@"%20"];
        NSString * param = [NSString stringWithFormat:@"tags=%@&page=%d&limit=%d",tags,page,limit];
        NSString * result = [NSString stringWithFormat:@"http://yande.re/post.json?%@",param];
        return result;
    } forKey:@"Yande"];
    
    [siteMethodMap setObject:(NSDictionary *)^(NSMutableData * data){
        NSError * jsonError;
        NSDictionary * dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&jsonError];
        NSMutableArray * tmpArray = (NSMutableArray *)dict;
        for(int i=0;i<[tmpArray count];i++){
            tmpArray[i][@"preview_url"] = [tmpArray[i][@"preview_url"] stringByReplacingOccurrencesOfString:@"https:" withString:@""];
            tmpArray[i][@"file_url"] = [tmpArray[i][@"file_url"] stringByReplacingOccurrencesOfString:@"https:" withString:@""];
        }
        return tmpArray;
    } forKey:@"Yande"];
    
    [siteUrlMap setObject:(NSString *)^(NSString * tags,int page,int limit){
        tags = [tags stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
        tags = [tags stringByReplacingOccurrencesOfString:@"%2520" withString:@"%20"];
        NSString * param = [NSString stringWithFormat:@"tags=%@&page=%d&limit=%d",tags,page,limit];
        NSString * result = [NSString stringWithFormat:@"http://danbooru.donmai.us/posts.json?%@",param];
        return result;
    } forKey:@"Danbooru"];
    
    [siteMethodMap setObject:(NSDictionary *)^(NSMutableData * data){
        NSError * jsonError;
        NSDictionary * dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&jsonError];
        NSMutableArray * tmpArray = (NSMutableArray *)dict;
        for(int i=0;i<[tmpArray count];i++){
            tmpArray[i][@"actual_preview_height"] = tmpArray[i][@"image_height"];
            tmpArray[i][@"actual_preview_width"] = tmpArray[i][@"image_width"];
            if([[AppDelegate getImageLevel]isEqualToString:@"Low"]){
                tmpArray[i][@"preview_url"] = [NSString stringWithFormat:@"//danbooru.donmai.us%@",tmpArray[i][@"preview_file_url"]];
            }else{
                tmpArray[i][@"preview_url"] = [NSString stringWithFormat:@"//danbooru.donmai.us%@",tmpArray[i][@"large_file_url"]];
            }
            tmpArray[i][@"file_url"] = [NSString stringWithFormat:@"//danbooru.donmai.us%@",tmpArray[i][@"file_url"]];
            tmpArray[i][@"tags"] = tmpArray[i][@"tag_string"];
        }
        return tmpArray;
    } forKey:@"Danbooru"];
    
    [siteUrlMap setObject:(NSString *)^(NSString * tags,int page,int limit){
        tags = [tags stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
        tags = [[[tags stringByReplacingOccurrencesOfString:@"%2520" withString:@"+"] stringByReplacingOccurrencesOfString:@"%20" withString:@"+"] stringByReplacingOccurrencesOfString:@"++" withString:@"+"];
        NSArray * tmpArray = [tags componentsSeparatedByString:@"+"];
        NSMutableArray * newTags = [NSMutableArray new];
        for(int i=[tmpArray count]-1;i>=0;i--){
            if(![tmpArray[i]  isEqual: @""]){
                [newTags addObject:tmpArray[i]];
            }
            if([newTags count]>=2)break;
        }
        if([newTags count] >= 2){
            tags = [NSString stringWithFormat:@"%@+%@",newTags[0],newTags[1] ];
        }
        NSString * param = [NSString stringWithFormat:@"tags=%@&page=%d&limit=%d",tags,page,limit];
        NSString * result = [NSString stringWithFormat:@"http://konachan.zju.link/behoimi.php?%@",param];
        return result;
    } forKey:@"3DBooru"];
    
    [siteMethodMap setObject:(NSDictionary *)^(NSMutableData * data){
        NSError * jsonError;
        NSLog(@"%@",[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding]);
        NSDictionary * dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&jsonError];
        NSMutableArray * tmpArray = (NSMutableArray *)dict;
        for(int i=0;i<[tmpArray count];i++){
            tmpArray[i][@"actual_preview_height"] = tmpArray[i][@"sample_height"];
            tmpArray[i][@"actual_preview_width"] = tmpArray[i][@"sample_width"];
            if([[AppDelegate getImageLevel]isEqualToString:@"Low"]){
                tmpArray[i][@"preview_url"] = [NSString stringWithFormat:@"//konachan.zju.link/behoimi_image.php?url=%@",tmpArray[i][@"preview_url"]];
            }else{
                tmpArray[i][@"preview_url"] = [NSString stringWithFormat:@"//konachan.zju.link/behoimi_image.php?url=%@",tmpArray[i][@"sample_url"]];
            }
            tmpArray[i][@"file_url"] = [NSString stringWithFormat:@"//konachan.zju.link/behoimi_image.php?url=%@",tmpArray[i][@"file_url"]];
        }
        return dict;
    } forKey:@"3DBooru"];
    
    [siteUrlMap setObject:(NSString *)^(NSString * tags,int page,int limit){
        NSString * param = [NSString stringWithFormat:@"tags=%@&page=%d&limit=%d",tags,page,limit];
        NSString * result = [NSString stringWithFormat:@"https://lolibooru.moe/post/index.json?%@",param];
        return result;
    } forKey:@"LoliBooru"];
    
    [siteMethodMap setObject:(NSDictionary *)^(NSMutableData * data){
        NSError * jsonError;
        NSDictionary * dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&jsonError];
        NSMutableArray * tmpArray = (NSMutableArray *)dict;
        for(int i=0;i<[tmpArray count];i++){
            tmpArray[i][@"preview_url"] = [tmpArray[i][@"preview_url"] stringByReplacingOccurrencesOfString:@"https:" withString:@""];
            tmpArray[i][@"file_url"] = [tmpArray[i][@"file_url"] stringByReplacingOccurrencesOfString:@"https:" withString:@""];
            tmpArray[i][@"file_url"] = [tmpArray[i][@"file_url"] stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
        }
        return tmpArray;
    } forKey:@"LoliBooru"];
    
    [siteUrlMap setObject:(NSString *)^(NSString * tags,int page,int limit){
        tags = [tags stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
        tags = [tags stringByReplacingOccurrencesOfString:@"%2520" withString:@"%20"];
        NSString * param = [NSString stringWithFormat:@"page=dapi&s=post&q=index&tags=%@&pid=%d&limit=%d",tags,page-1,limit];
        NSString * result = [NSString stringWithFormat:@"http://xbooru.com/index.php?%@",param];
        return result;
    } forKey:@"XBooru"];
    
    [siteMethodMap setObject:(NSDictionary *)^(NSMutableData * data){
        NSString *result = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        GDataXMLDocument *xmlDoc = [[GDataXMLDocument alloc]initWithXMLString:result options:0 error:nil];
        GDataXMLElement * xmlEle = [xmlDoc rootElement];
        NSArray * array = [xmlEle children];
        NSLog(@"Count : %ld",[array count]);
        NSMutableArray * resArray = [NSMutableArray new];
        for(int i=0;i<[array count];i++){
            GDataXMLElement * ele = [array objectAtIndex:i];
            NSMutableDictionary * tmpDict = [NSMutableDictionary new];
            [tmpDict setValue:[[ele attributeForName:@"tags"]stringValue] forKey:@"tags"];
            [tmpDict setValue:[[ele attributeForName:@"preview_height"]stringValue] forKey:@"actual_preview_height"];
            [tmpDict setValue:[[ele attributeForName:@"preview_width"]stringValue] forKey:@"actual_preview_width"];
            [tmpDict setValue:[[[ele attributeForName:@"file_url"] stringValue]stringByReplacingOccurrencesOfString:@"http:" withString:@""]  forKey:@"file_url"];
            if([[AppDelegate getImageLevel]isEqualToString:@"Low"]){
                [tmpDict setValue:[[[ele attributeForName:@"preview_url"]stringValue] stringByReplacingOccurrencesOfString:@"http:" withString:@""] forKey:@"preview_url"];
            }else{
                [tmpDict setValue:[[[ele attributeForName:@"sample_url"]stringValue]stringByReplacingOccurrencesOfString:@"http:" withString:@""] forKey:@"preview_url"];
            }
            [resArray addObject:tmpDict];
        }
        return (NSDictionary *)resArray;
    } forKey:@"XBooru"];
    
    [siteUrlMap setObject:(NSString *)^(NSString * tags,int page,int limit){
        tags = [tags stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
        tags = [tags stringByReplacingOccurrencesOfString:@"%2520" withString:@"%20"];
        NSString * param = [NSString stringWithFormat:@"page=dapi&s=post&q=index&tags=%@&pid=%d&limit=%d",tags,page-1,limit];
        NSString * result = [NSString stringWithFormat:@"http://rule34.xxx/index.php?%@",param];
        return result;
    } forKey:@"Rule34"];
    
    [siteMethodMap setObject:(NSDictionary *)^(NSMutableData * data){
        NSString *result = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        GDataXMLDocument *xmlDoc = [[GDataXMLDocument alloc]initWithXMLString:result options:0 error:nil];
        GDataXMLElement * xmlEle = [xmlDoc rootElement];
        NSArray * array = [xmlEle children];
        NSLog(@"Count : %ld",[array count]);
        NSMutableArray * resArray = [NSMutableArray new];
        for(int i=0;i<[array count];i++){
            GDataXMLElement * ele = [array objectAtIndex:i];
            NSMutableDictionary * tmpDict = [NSMutableDictionary new];
            [tmpDict setValue:[[ele attributeForName:@"tags"]stringValue] forKey:@"tags"];
            [tmpDict setValue:[[ele attributeForName:@"preview_height"]stringValue] forKey:@"actual_preview_height"];
            [tmpDict setValue:[[ele attributeForName:@"preview_width"]stringValue] forKey:@"actual_preview_width"];
            [tmpDict setValue:[[ele attributeForName:@"file_url"]stringValue] forKey:@"file_url"];
            if([[AppDelegate getImageLevel]isEqualToString:@"Low"]){
                [tmpDict setValue:[[ele attributeForName:@"preview_url"]stringValue] forKey:@"preview_url"];
            }else{
                [tmpDict setValue:[[ele attributeForName:@"sample_url"]stringValue] forKey:@"preview_url"];
            }
            [resArray addObject:tmpDict];
        }
        return (NSDictionary *)resArray;
    } forKey:@"Rule34"];
}

@end
