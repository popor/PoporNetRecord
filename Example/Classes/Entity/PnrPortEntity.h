//
//  PnrWebPortEntity.h
//  PoporNetRecord
//
//  Created by apple on 2018/12/18.
//

#import <Foundation/Foundation.h>
#import <GCDWebServer/GCDWebServer.h>

NS_ASSUME_NONNULL_BEGIN

static int PnrPortGet  = 8080;

@interface PnrPortEntity : NSObject

@property (nonatomic        ) int portGetInt;
+ (instancetype)share;

#pragma mark - plist
+ (void)savePort_get:(int)port;
+ (int)getPort_get;

@end

NS_ASSUME_NONNULL_END
