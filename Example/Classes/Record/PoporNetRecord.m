//
//  PoporNetRecord.m
//  PoporNetRecord
//
//  Created by apple on 2018/5/16.
//  Copyright © 2018年 popor. All rights reserved.
//

#import "PoporNetRecord.h"
#import "PnrEntity.h"
#import "PnrWebServer.h"

#import "PnrListVC.h"
#import <PoporUI/UIView+pExtension.h>
#import <PoporFoundation/Fun+pPrefix.h>
#import <PoporFoundation/NSDate+pTool.h>
#import <JSONSyntaxHighlight/JSONSyntaxHighlight.h>

#define LL_SCREEN_WIDTH  [[UIScreen mainScreen] bounds].size.width
#define LL_SCREEN_HEIGHT [[UIScreen mainScreen] bounds].size.height

@interface PoporNetRecord () <UIGestureRecognizerDelegate>

@property (nonatomic, strong) NSMutableString * listWebH5;

@end

@implementation PoporNetRecord

+ (instancetype)share {
    static dispatch_once_t once;
    static PoporNetRecord * instance;
    dispatch_once(&once, ^{
        instance = [self new];
        instance.infoArray = [NSMutableArray new];
        instance.listWebH5 = [NSMutableString new];
        
        instance.config    = [PnrConfig share];
        instance.view      = [PnrView share];
        
        // 相关联的关联数组
        [PnrWebServer share].infoArray = instance.infoArray;
        instance.view.infoArray = instance.infoArray;
        
    });
    return instance;
}

+ (void)addUrl:(NSString *)urlString method:(PnrMethod)method head:(id _Nullable)headValue parameter:(id _Nullable)parameterValue response:(id _Nullable)responseValue
{
    [self addUrl:urlString title:@"--" method:method head:headValue parameter:parameterValue response:responseValue];
}

+ (void)addUrl:(NSString *)urlString title:(NSString *)title method:(PnrMethod)method head:(id _Nullable)headValue parameter:(id _Nullable)parameterValue response:(id _Nullable)responseValue
{
    PoporNetRecord * pnr = [PoporNetRecord share];
    if (pnr.config.isRecord) {
        PnrEntity * entity = [PnrEntity new];
        entity.title          = title;
        entity.url            = urlString;
        entity.method         = method;
        entity.headValue      = headValue;
        entity.parameterValue = parameterValue;
        entity.responseValue  = responseValue;
        entity.time           = [NSDate stringFromDate:[NSDate date] formatter:@"HH:mm:ss"];

        if (urlString.length>0) {
            NSURL * url = [NSURL URLWithString:urlString];
            if (url.baseURL) {
                entity.domain = [NSString stringWithFormat:@"%@://%@", url.scheme, url.host];
                
                if (entity.domain.length+1 < urlString.length) {
                    entity.path = [urlString substringFromIndex:entity.domain.length+1];
                    NSString * query = url.query;
                    if (query.length > 0) {
                        entity.path = [entity.path substringToIndex:entity.path.length-1-query.length];
                    }
                }
            }else{
                entity.domain = urlString;
                entity.path   = @"";
            }
        }
        if (pnr.infoArray.count == 0) {
            // 当执行了数组清空之后, h5代码清零一次.
            [pnr.listWebH5 setString:@""];
        }
        [pnr.infoArray addObject:entity];
        
        if (pnr.config.isShowListWeb) {
            [entity createListWebH5:pnr.infoArray.count - 1];
            [pnr.listWebH5 insertString:entity.listWebH5 atIndex:0];
            [[PnrWebServer share] startListServer:pnr.listWebH5];
        }else{
            [[PnrWebServer share] stopServer];
        }
        
        // 假如在打开界面的时候收到请求,那么刷新数据
        if (pnr.config.freshBlock) {
            pnr.config.freshBlock();
        }
        if (pnr.blockExtraRecord) {
            entity.deviceName = [[UIDevice currentDevice] name];
            pnr.blockExtraRecord(entity);
        }
    }
}

+ (void)setPnrBlockResubmit:(PnrBlockResubmit _Nullable)block extraDic:(NSDictionary * _Nullable)dic {
    [PnrWebServer share].resubmitBlock = block;
    [PnrWebServer share].resubmitExtraDic = dic;
}

// Log 部分

+ (void)addLog:(NSString *)log {
    [self addLog:log title:@"日志"];
}

+ (void)addLog:(NSString *)log title:(NSString *)title
{
    PoporNetRecord * pnr = [PoporNetRecord share];
    if (pnr.config.isRecord) {
        PnrEntity * entity = [PnrEntity new];
        entity.log   = log;
        entity.title = title;
        entity.url   = @"无链接";
        entity.time  = [NSDate stringFromDate:[NSDate date] formatter:@"HH:mm:ss"];
        
        if (pnr.infoArray.count == 0) {
            // 当执行了数组清空之后, h5代码清零一次.
            [pnr.listWebH5 setString:@""];
        }
        [pnr.infoArray addObject:entity];
        
        if (pnr.config.isShowListWeb) {
            [entity createListWebH5:pnr.infoArray.count - 1];
            [pnr.listWebH5 insertString:entity.listWebH5 atIndex:0];
            [[PnrWebServer share] startListServer:pnr.listWebH5];
        }else{
            [[PnrWebServer share] stopServer];
        }
        
        // 假如在打开界面的时候收到请求,那么刷新数据
        if (pnr.config.freshBlock) {
            pnr.config.freshBlock();
        }
        if (pnr.blockExtraRecord) {
            entity.deviceName = [[UIDevice currentDevice] name];
            pnr.blockExtraRecord(entity);
        }
    }
}

@end
