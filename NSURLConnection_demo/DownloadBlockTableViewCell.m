//
//  DownloadBlockTableViewCell.m
//  NSURLConnection_demo
//
//  Created by Wujiao on 2017/7/21.
//  Copyright © 2017年 Wujiao. All rights reserved.
//

#import "DownloadBlockTableViewCell.h"
#import "DownloadBlockViewModel.h"
#import "ReactiveCocoa/ReactiveCocoa.h"
#import "ReactiveCocoa/RACEXTScope.h"

@interface DownloadBlockTableViewCell()
@property (weak, nonatomic) IBOutlet UILabel *fileNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *processLabel;
@property (weak, nonatomic) IBOutlet UIProgressView *processView;
@property (weak, nonatomic) IBOutlet UILabel *sizeLabel;



@end

@implementation DownloadBlockTableViewCell

- (void)bindViewModel:(id)viewModel{
    DownloadBlockViewModel *vm = (DownloadBlockViewModel *)viewModel;
    self.processLabel.textColor = [UIColor blackColor];
    self.fileNameLabel.text = vm.fileName;
    self.sizeLabel.text =  [NSString stringWithFormat:@"已下载：%@",vm.rec];
    self.processView.progress = [vm.process floatValue];
    
    @weakify(self)
    [RACObserve(vm,fileName)subscribeNext:^(id x) {
        @strongify(self)
        NSArray * arr = [(NSString *)x componentsSeparatedByString:@"/"];
        self.fileNameLabel.text = arr.lastObject;
        
    }];
    [RACObserve(vm,process)subscribeNext:^(id x) {
        @strongify(self)
        self.processView.progress = [x floatValue];
    }];
    
    [RACObserve(vm, rec) subscribeNext:^(id x) {
        @strongify(self)
        if(self.processLabel.textColor == [UIColor blackColor]){
            self.sizeLabel.text = [NSString stringWithFormat:@"Size：%@",vm.rec];
        }
        self.processView.progress = [x floatValue];
    }];
    [RACObserve(vm,isComplete) subscribeNext:^(id x) {
        @strongify(self)
            if([vm.isComplete integerValue ]== 1){
                [self performSelectorOnMainThread:@selector(changeLabelColorWith:) withObject:@{@"color":[UIColor greenColor],@"msg":@"已完成"} waitUntilDone:NO];
            }else if([vm.isComplete integerValue ] == 2){
                [self performSelectorOnMainThread:@selector(changeLabelColorWith:) withObject:@{@"color":[UIColor redColor],@"msg":@"失败"} waitUntilDone:NO];
            }else{
                [self performSelectorOnMainThread:@selector(changeLabelColorWith:) withObject:@{@"color":[UIColor blackColor],@"msg":@"下载中"} waitUntilDone:NO];
            }
        
        
    } ];
}

-(void)changeLabelColorWith:(NSDictionary *)info{
    self.processLabel.textColor = info[@"color"];
    self.processLabel.text = info[@"msg"];
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
