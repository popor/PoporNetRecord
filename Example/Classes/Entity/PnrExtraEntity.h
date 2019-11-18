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
};


// 转发接口
@interface PnrExtraUrlPortEntity : NSObject

@property (nonatomic, strong) NSString * title;
@property (nonatomic, strong) NSString * url;
@property (nonatomic, strong) NSString * port;

@end


@interface PnrExtraEntity : NSObject

@property (nonatomic        ) NSInteger selectNum;
@property (nonatomic, strong) NSString * selectUrlPort;

@property (nonatomic, strong) NSMutableArray<PnrExtraUrlPortEntity *> * urlPortArray;

+ (instancetype)share;

- (void)saveArray;

- (void)saveSelectNum:(NSInteger)selectNum;

@end

NS_ASSUME_NONNULL_END
