//
//  PnrServerTool.h
//  PoporNetRecord
//
//  Created by apple on 2018/12/18.
//

#import <Foundation/Foundation.h>
#import <GCDWebServer/GCDWebServer.h>
#import "PnrPortEntity.h"

NS_ASSUME_NONNULL_BEGIN

@interface PnrServerTool : NSObject

+ (instancetype)share;

@property (nonatomic, weak  ) PnrPortEntity * portEntity;
#pragma mark - server
@property (nonatomic, strong) NSArray * titleArray;
@property (nonatomic, strong) NSArray * jsonArray;

@property (nonatomic, strong, nullable) GCDWebServer * webServerList;
@property (nonatomic, strong, nullable) GCDWebServer * webServerAll;
@property (nonatomic, strong, nullable) GCDWebServer * webServerHead;
@property (nonatomic, strong, nullable) GCDWebServer * webServerRequest;
@property (nonatomic, strong, nullable) GCDWebServer * webServerResponse;

- (void)startListServer:(NSString *)body;

- (void)startServerTitle:(NSArray *)titleArray json:(NSArray *)jsonArray;

- (void)stopServer;

@end

NS_ASSUME_NONNULL_END
