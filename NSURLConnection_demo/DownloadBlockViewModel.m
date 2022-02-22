//
//  DownloadBlockViewModel.m
//  NSURLConnection_demo
//
//  Created by Wujiao on 2017/7/21.
//  Copyright © 2017年 Wujiao. All rights reserved.
//

#import "DownloadBlockViewModel.h"
#import "HSDownloadManager.h"

@implementation DownloadBlockViewModel

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)startWithUrl:(NSString *)url{
    self.isComplete = @(0);
    [[HSDownloadManager sharedInstance] download:url progress:^(NSInteger receivedSize, NSInteger expectedSize, CGFloat progress) {
        dispatch_async(dispatch_get_main_queue(), ^{
            self.process = @(progress);
            self.rec = @(receivedSize);
            self.ext = @(expectedSize);
        });
    } state:^(DownloadState state) {
        if(state == DownloadStateCompleted){
            self.isComplete = @(1);
        }else if(state == DownloadStateFailed){
            self.isComplete = @(2);
        }
        
    }];
}

-(void)startWithUrl:(NSString *)url andSize:(NSNumber *)size{
    self.isComplete = @(0);
//    NSNumber *realSize = [NSNumber numberWithBool:size];
    self.ext = size;
    [[HSDownloadManager sharedInstance] download:url progress:^(NSInteger receivedSize, NSInteger expectedSize, CGFloat progress) {
        dispatch_async(dispatch_get_main_queue(), ^{
            
            self.rec = @(receivedSize);
            self.process = @(1.0 * receivedSize / [self.ext doubleValue]);
            if([self.process doubleValue] > 1){
                self.process = @(1);
            }
//            self.ext = @(expectedSize);
        });
    } state:^(DownloadState state) {
        if(state == DownloadStateCompleted){
            self.isComplete = @(1);
        }else if(state == DownloadStateFailed){
            self.isComplete = @(2);
        }
        
    }];
}

@end
