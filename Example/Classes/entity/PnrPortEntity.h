//
//  PnrWebPortEntity.h
//  PoporNetRecord
//
//  Created by apple on 2018/12/18.
//

#import <Foundation/Foundation.h>
#import <GCDWebServer/GCDWebServer.h>

NS_ASSUME_NONNULL_BEGIN

static int PoporNetRecordPort = 8080;

@interface PnrPortEntity : NSObject

@property (nonatomic        ) int portInt;

+ (instancetype)share;

#pragma mark - plist
+ (void)savePort:(NSString *)allPort;
+ (NSString *)getPort;

@end

NS_ASSUME_NONNULL_END
