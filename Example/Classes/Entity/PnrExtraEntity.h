//
//  PnrExtraEntity.h
//  PoporNetRecord_Example
//
//  Created by apple on 2019/11/16.
//  Copyright © 2019 wangkq. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(int, PnrExtraUrlPortEntityType) {
    PnrExtraUrlPortEntityType_title ,
    PnrExtraUrlPortEntityType_url ,
    PnrExtraUrlPortEntityType_port ,
    PnrExtraUrlPortEntityType_api ,
};


// 转发接口
@interface PnrExtraUrlPortEntity : NSObject

@property (nonatomic, copy  ) NSString * title;
@property (nonatomic, copy  ) NSString * url;
@property (nonatomic, copy  ) NSString * port;
@property (nonatomic, copy  ) NSString * api;

@end

@class PnrExtraEntity;
typedef void(^PnrExtraEntityBlock)(PnrExtraEntity * pnrExtraEntity);

@interface PnrExtraEntity : NSObject

@property (nonatomic        ) NSInteger selectNum;
@property (nonatomic        ) BOOL      forward; // 是否转发
@property (nonatomic, copy  ) NSString * selectUrlPort;

@property (nonatomic, strong) NSMutableArray<PnrExtraUrlPortEntity *> * urlPortArray;

//// 额外的的默认参数
@property (nonatomic        ) BOOL       defaultForward;// 默认是否转发
@property (nonatomic, copy  ) NSString * defaultTitle;
@property (nonatomic, copy  ) NSString * defaultUrl;
@property (nonatomic, copy  ) NSString * defaultPort;
@property (nonatomic, copy  ) NSString * defaultApi;

/**
 这个获取单例, 只需要执行一次, 可以在block中初始化一些默认参数:
 
 defaultForward;// 默认是否转发
 defaultTitle;
 defaultUrl;
 defaultPort;
 defaultApi;
 
 */
+ (instancetype)shareConfig:(PnrExtraEntityBlock)block; // 包含初始化单例和数据.

// 普通获取 单例
+ (instancetype)share; // 包含初始化单例, 0.2后, 假如发现没有初始化数据, 则自动初始化数据.

- (void)initData;

- (void)saveArray;

- (void)saveSelectNum:(NSInteger)selectNum;

- (void)saveForward;

- (void)updateSelectUrlPort;

@end

NS_ASSUME_NONNULL_END
