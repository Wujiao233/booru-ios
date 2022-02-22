//
//  ReactiveView.h
//  NSURLConnection_demo
//
//  Created by Wujiao on 2017/7/21.
//  Copyright © 2017年 Wujiao. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol ReactiveView <NSObject>

- (void)bindViewModel:(id)viewModel;

@end
