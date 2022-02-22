//
//  DownloadManagerViewModel.m
//  NSURLConnection_demo
//
//  Created by Wujiao on 2017/7/21.
//  Copyright © 2017年 Wujiao. All rights reserved.
//

#import "DownloadManagerViewModel.h"
#import "DownloadBlockViewModel.h"
#import "AppDelegate.h"
#import "HSDownloadManager.h"

@implementation DownloadManagerViewModel

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.downloadingList = [NSArray new];
    }
    return self;
}

-(void)addThingTo{
    NSMutableArray * mArr = [NSMutableArray arrayWithArray:self.downloadingList];
    DownloadBlockViewModel * vm = [[DownloadBlockViewModel alloc]init];
    vm.fileName = @"2333";
    vm.process = @(0.542);
    [mArr addObject:vm];
    self.downloadingList = [NSArray arrayWithArray:mArr];
}

-(void)addVmToListWithVm:(DownloadBlockViewModel *)vm{
    NSMutableArray *mArr = [NSMutableArray arrayWithArray:self.downloadingList];
    [mArr addObject:vm];
    self.downloadingList = [NSArray arrayWithArray:mArr];
}

- (void)download:(NSString *)url{
    DownloadBlockViewModel *vm = [DownloadBlockViewModel new];
    vm.fileName = url;
    vm.process = @(0);
    [vm startWithUrl:url];
    [self addVmToListWithVm:vm];
}

- (void)download:(NSString *)url withSize:(NSNumber *)size{
    DownloadBlockViewModel *vm = [DownloadBlockViewModel new];
    vm.fileName = url;
    vm.process = @(0);
    [vm startWithUrl:url andSize:size];
    [self addVmToListWithVm:vm];
}

-(void)deleteFileWithIndexPath:(NSIndexPath *)indexPath{
    NSMutableArray *mArr = [NSMutableArray arrayWithArray:self.downloadingList];
    DownloadBlockViewModel * vm = mArr[indexPath.row];
    [[HSDownloadManager sharedInstance]deleteFile:vm.fileName];
    [mArr removeObject:vm];
    self.downloadingList = [NSArray arrayWithArray:mArr];
}

-(void)restartFileDownloadWithIndexPath:(NSIndexPath *)indexPath{
    NSMutableArray *mArr = [NSMutableArray arrayWithArray:self.downloadingList];
    DownloadBlockViewModel * vm = mArr[indexPath.row];
    NSString *url = vm.fileName;
    NSNumber *size = vm.ext;
    [[HSDownloadManager sharedInstance]deleteFile:vm.fileName];
    [mArr removeObject:vm];
    self.downloadingList = [NSArray arrayWithArray:mArr];
    [self download:url withSize:size];
}

@end
