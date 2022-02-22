//
//  DownloadManagerViewModel.h
//  NSURLConnection_demo
//
//  Created by Wujiao on 2017/7/21.
//  Copyright © 2017年 Wujiao. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DownloadManagerViewModel : NSObject

@property(nonatomic,strong)NSArray *downloadingList;

-(void)addThingTo;
-(void)download:(NSString *)url;
-(void)download:(NSString *)url withSize:(NSNumber *)size;
-(void)deleteFileWithIndexPath:(NSIndexPath *)indexPath;
-(void)restartFileDownloadWithIndexPath:(NSIndexPath *)indexPath;
@end
