//
//  PoporNetRecord.h
//  PoporNetRecord
//
//  Created by apple on 2018/5/16.
//  Copyright © 2018年 popor. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PnrConfig.h"
#import "PnrView.h"

typedef void(^PoporNetRecordBlockPVoid) (void);

@interface PoporNetRecord : NSObject

@property (nonatomic, weak  ) PnrConfig * config;
@property (nonatomic, weak  ) PnrView   * view;

@property (nonatomic, strong) NSMutableArray * infoArray;

@property (nonatomic, weak  ) UINavigationController * nc;
@property (nonatomic, copy  ) PoporNetRecordBlockPVoid openBlock;
@property (nonatomic, copy  ) PoporNetRecordBlockPVoid closeBlock;

+ (instancetype)share;

/**
 headValue:     NSDictionary | NSString
 requestValue:  NSDictionary | NSString
 responseValue: NSDictionary | NSString
 */
+ (void)addUrl:(NSString *)urlString method:(NSString *)method head:(id)headValue request:(id)requestValue response:(id)responseValue;

// 增加title
+ (void)addUrl:(NSString *)urlString title:(NSString *)title method:(NSString *)method head:(id)headValue request:(id)requestValue response:(id)responseValue;

@end
