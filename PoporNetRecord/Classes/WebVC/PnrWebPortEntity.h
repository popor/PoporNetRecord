//
//  PnrWebPortEntity.h
//  GCDWebServer
//
//  Created by apple on 2018/12/18.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

static int PoporNetRecordAllPort      = 8080;
static int PoporNetRecordHeadPort     = 8081;
static int PoporNetRecordRequestPort  = 8082;
static int PoporNetRecordResponsePort = 8083;

@interface PnrWebPortEntity : NSObject

@property (nonatomic        ) int allPortInt;
@property (nonatomic        ) int headPortInt;
@property (nonatomic        ) int requestPortInt;
@property (nonatomic        ) int responsePortInt;

+ (void)saveAllPort:(NSString *)allPort;
+ (NSString *)getAllPort;

+ (void)saveHeadPort:(NSString *)headPort;
+ (NSString *)getHeadPort;

+ (void)saveRequestPort:(NSString *)requestPort;
+ (NSString *)getRequestPort;

+ (void)saveResponsePort:(NSString *)responsePort;
+ (NSString *)getResponsePort;

@end

NS_ASSUME_NONNULL_END
