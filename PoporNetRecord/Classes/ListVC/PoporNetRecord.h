//
//  NetMonitorTool.h
//  PoporNetRecord
//
//  Created by apple on 2018/5/16.
//  Copyright © 2018年 popor. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PoporNetRecordConfig.h"

typedef void(^PoporNetRecordBlockPVoid) (void);

@interface PoporNetRecord : NSObject

@property (nonatomic, weak  ) PoporNetRecordConfig * config;

@property (nonatomic, weak  ) UIWindow * window;
@property (nonatomic, strong) UIButton * ballBT;

@property (nonatomic        ) BOOL freshListWebLock; // 锁,防止频繁刷新
@property (nonatomic        ) NSInteger freshListWebLockTime; // 阻塞时间间隔
@property (nonatomic        ) NSInteger freshListWebLockMax; // 锁次数,防止一直无法解锁
@property (nonatomic        ) NSInteger freshListWebLockNum; // 当前阻塞数字

@property (nonatomic        ) CGFloat sBallHideWidth;
@property (nonatomic        ) CGFloat sBallWidth;
@property (nonatomic, strong) NSMutableArray * infoArray;

@property (nonatomic, weak  ) UINavigationController * nc;
@property (nonatomic, copy  ) PoporNetRecordBlockPVoid openBlock;
@property (nonatomic, copy  ) PoporNetRecordBlockPVoid closeBlock;

// 是否开启监测
@property (nonatomic, getter=isRecord) BOOL record;

// 自定义ballBT可见度, 假如为YES,那么ballBT第一次显示会设置为hidden=YES.
@property (nonatomic, getter=isCustomBallBtVisible) BOOL customBallBtVisible;

+ (instancetype)share;

/**
 headValue:     NSDictionary | NSString
 requestValue:  NSDictionary | NSString
 responseValue: NSDictionary | NSString
 */
+ (void)addUrl:(NSString *)urlString method:(NSString *)method head:(id)headValue request:(id)requestValue response:(id)responseValue;

// 增加title
+ (void)addUrl:(NSString *)urlString title:(NSString *)title method:(NSString *)method head:(id)headValue request:(id)requestValue response:(id)responseValue;

// 弹出请求列表 UINavigationController
- (void)showPnrListVCNC;

// 获取VC,可以设置在自定义 UINavigationController 中
- (UIViewController *)getPnrListVC;

// 把ballBT提到最高层.
+ (void)bringFrontBallBT;

@end
