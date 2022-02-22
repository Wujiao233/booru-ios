//
//  DownloadBlockViewModel.h
//  NSURLConnection_demo
//
//  Created by Wujiao on 2017/7/21.
//  Copyright © 2017年 Wujiao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DownloadBlockViewModel : UITableViewCell

@property(nonatomic,strong)NSString *fileName;
@property(nonatomic,strong)NSNumber *process;
@property(nonatomic,strong)NSNumber *rec,*ext;
@property(nonatomic,strong)NSNumber *isComplete;
-(void)startWithUrl:(NSString *)url;
-(void)startWithUrl:(NSString *)url andSize:(NSNumber *)size;
@end
