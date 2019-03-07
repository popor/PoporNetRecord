//
//  PnrWebPortEntity.h
//  PoporNetRecord
//
//  Created by apple on 2018/12/18.
//

#import <Foundation/Foundation.h>
#import <GCDWebServer/GCDWebServer.h>

NS_ASSUME_NONNULL_BEGIN

static int PoporNetRecordAllPort      = 8080;
static int PoporNetRecordHeadPort     = 8081;
static int PoporNetRecordRequestPort  = 8082;
static int PoporNetRecordResponsePort = 8083;

@interface PnrPortEntity : NSObject

@property (nonatomic        ) int allPortInt;
@property (nonatomic        ) int headPortInt;
@property (nonatomic        ) int requestPortInt;
@property (nonatomic        ) int responsePortInt;

@property (nonatomic        ) BOOL jsonWindow; // json详情网页 是否在新窗口打开
@property (nonatomic        ) BOOL detailVCStartServer; // 是否在detailVC开启服务,默认为开

+ (instancetype)share;

#pragma mark - plist
+ (void)saveAllPort:(NSString *)allPort;
+ (NSString *)getAllPort;

+ (void)saveHeadPort:(NSString *)headPort;
+ (NSString *)getHeadPort;

+ (void)saveRequestPort:(NSString *)requestPort;
+ (NSString *)getRequestPort;

+ (void)saveResponsePort:(NSString *)responsePort;
+ (NSString *)getResponsePort;

+ (void)saveJsonWindow:(BOOL)jsonWindow;
+ (BOOL)getJsonWindow;

+ (void)saveDetailVCStartServer:(BOOL)detailVCStartServer;
+ (BOOL)getDetailVCStartServer;

@end

NS_ASSUME_NONNULL_END
