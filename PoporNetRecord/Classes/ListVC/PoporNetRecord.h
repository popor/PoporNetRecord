//
//  NetMonitorTool.h
//  linRunShengPi
//
//  Created by apple on 2018/5/16.
//  Copyright © 2018年 popor. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PoporNetRecordConfig.h"

@interface PoporNetRecord : NSObject

@property (nonatomic, weak  ) PoporNetRecordConfig * config;
+ (instancetype)share;

+ (void)addUrl:(NSString *)urlString method:(NSString *)method head:(NSDictionary *)headDic request:(NSDictionary *)requestDic response:(NSDictionary *)responseDic;

@end
