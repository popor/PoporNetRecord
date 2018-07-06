//
//  PoporNetRecordViewController.m
//  PoporNetRecord
//
//  Created by wangkq on 07/06/2018.
//  Copyright (c) 2018 wangkq. All rights reserved.
//

#import "PoporNetRecordViewController.h"

#import <PoporNetRecord/PoporNetRecord.h>

@interface PoporNetRecordViewController ()

@end

@implementation PoporNetRecordViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [PoporNetRecord addUrl:@"http://www.baidu.com/test0.5" method:@"POST" head:@{@"os":@"iOS"} request:@{@"name":@"popor"} response:@{@"success":@"true"}];
    });
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [PoporNetRecord addUrl:@"http://www.baidu.com/test1.5" method:@"POST" head:@{@"os":@"iOS"} request:@{@"name":@"popor"} response:@{@"success":@"true"}];
    });
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [PoporNetRecord addUrl:@"http://www.baidu.com/test3.5" method:@"POST" head:@{@"os":@"iOS"} request:@{@"name":@"popor"} response:@{@"success":@"true"}];
    });
    
}


@end
