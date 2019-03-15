//
//  PnrWebBody.h
//  PoporNetRecord
//
//  Created by apple on 2019/3/15.
//  Copyright © 2019 wangkq. All rights reserved.
//

#import <Foundation/Foundation.h>

@class PnrEntity;

static NSString * ErrorUrl    = @"<html> <head><title>错误</title></head> <body><p> URL异常 </p> </body></html>";
static NSString * ErrorEntity = @"<html> <head><title>错误</title></head> <body><p> 无法找到对应请求 </p> </body></html>";
static NSString * ErrorUnknow = @"<html> <head><title>错误</title></head> <body><p> 未知bug </p> </body></html>";
static NSString * ErrorEmpty  = @"<html> <head><title>错误</title></head> <body><p> 无 </p> </body></html>";

NS_ASSUME_NONNULL_BEGIN

@interface PnrWebBody : NSObject

+ (NSString *)jsonReadForm:(NSString *)form key:(NSString *)key name:(NSString *)keyName content:(NSString *)content;

+ (NSString *)rootBody;
+ (NSString *)listH5:(NSString *)body;

+ (void)deatilEntity:(PnrEntity *)pnrEntity index:(NSInteger)index extra:(NSDictionary *)extraDic finish:(void (^ __nullable)(NSString * detail, NSString * resubmit))finish;

+ (NSString *)resubmitH5:(NSString *)body;

@end

NS_ASSUME_NONNULL_END
