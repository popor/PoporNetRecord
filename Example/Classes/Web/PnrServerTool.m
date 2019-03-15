//
//  PnrWebPortEntity.m
//  PoporNetRecord
//
//  Created by apple on 2018/12/18.
//

#import "PnrServerTool.h"

#import "PnrEntity.h"
#import "PnrPortEntity.h"
#import "PnrWebBody.h"

#import <PoporUI/IToastKeyboard.h>

#import <GCDWebServer/GCDWebServer.h>
#import <GCDWebServer/GCDWebServerDataResponse.h>
#import <GCDWebServer/GCDWebServerPrivate.h>

@interface PnrServerTool ()

@property (nonatomic        ) NSInteger lastIndex;

@property (nonatomic, strong) NSString * h5Root;
@property (nonatomic, strong) NSString * h5List;
@property (nonatomic, strong) NSString * h5Detail;
@property (nonatomic, strong) NSString * h5Resubmit;

@end

@implementation PnrServerTool

+ (instancetype)share {
    static dispatch_once_t once;
    static PnrServerTool * instance;
    dispatch_once(&once, ^{
        instance = [PnrServerTool new];
        instance.h5List = [NSMutableString new];
        instance.h5Root = [PnrWebBody rootBody];
        
        instance.lastIndex  = -1;
        [GCDWebServer setLogLevel:kGCDWebServerLoggingLevel_Error];
    });
    return instance;
}

- (id)init {
    if (self = [super init]) {
        self.portEntity = [PnrPortEntity share];
    }
    return self;
}

#pragma mark - list server
- (void)startListServer:(NSMutableString *)listBodyH5 {
    if (!listBodyH5) {
        return;
    }
    self.h5List = [PnrWebBody listH5:listBodyH5];
    __weak typeof(self) weakSelf = self;
    
    if (!self.webServer) {
        GCDWebServer * server = [GCDWebServer new];
        self.webServer = server;
        
        [self.webServer addDefaultHandlerForMethod:@"GET" requestClass:[GCDWebServerRequest class] asyncProcessBlock:^(__kindof GCDWebServerRequest * _Nonnull request, GCDWebServerCompletionBlock  _Nonnull completionBlock) {
            NSString * path = request.URL.path;
            //NSLog(@"get path :'%@'", path);
            if (path.length >= 1) {
                path = [path substringFromIndex:1];
                NSArray * pathArray = [path componentsSeparatedByString:@"/"];
                if (pathArray.count == 2) {
                    [weakSelf analysisGetIndex:[pathArray[0] integerValue] path:pathArray[1] request:request complete:completionBlock];
                }else if (pathArray.count == 1){
                    if ([path isEqualToString:@""]) {
                        completionBlock([GCDWebServerDataResponse responseWithHTML:weakSelf.h5Root]);
                    }else if ([path isEqualToString:PnrPathList]){
                        completionBlock([GCDWebServerDataResponse responseWithHTML:weakSelf.h5List]);
                    }else{
                        completionBlock([GCDWebServerDataResponse responseWithHTML:ErrorUrl]);
                    }
                }
            }
            else {
                completionBlock([GCDWebServerDataResponse responseWithHTML:ErrorUrl]);
            }
        }];
        
        [self.webServer addDefaultHandlerForMethod:@"POST" requestClass:[GCDWebServerURLEncodedFormRequest class] asyncProcessBlock:^(__kindof GCDWebServerRequest * _Nonnull request, GCDWebServerCompletionBlock  _Nonnull completionBlock) {
            NSString * path = request.URL.path;
            //NSLog(@"post path :'%@'", path);
            if (path.length>=1) {
                path = [path substringFromIndex:1];
                NSArray * pathArray = [path componentsSeparatedByString:@"/"];
                if (pathArray.count == 1) {
                    [weakSelf analysisPost1Path:path request:request complete:completionBlock];
                }
                else if (pathArray.count == 2) {
                    [weakSelf analysisPost2Index:[pathArray[0] integerValue] path:pathArray[1] request:request complete:completionBlock];
                }else{
                    completionBlock([GCDWebServerDataResponse responseWithHTML:ErrorUrl]);
                }
            }
            else{
                completionBlock([GCDWebServerDataResponse responseWithHTML:ErrorUrl]);
            }
        }];
        
        PnrPortEntity * port = [PnrPortEntity share];
        [server startWithPort:port.portGetInt bonjourName:nil];
    }
}

// 分析 get 请求
- (void)analysisGetIndex:(NSInteger)index path:(NSString *)path request:(GCDWebServerRequest * _Nonnull)request complete:(GCDWebServerCompletionBlock  _Nonnull)complete
{
    PnrEntity * entity;
    if (self.infoArray.count > index) {
        entity = self.infoArray[index];
    }
    if (entity) {
        if (index != self.lastIndex) {
            self.lastIndex = index;
            [self startServerUnitEntity:entity index:index];
        }
        NSString * str;
        if ([path isEqualToString:PnrPathList]) {
            str = self.h5List;
        }else if ([path isEqualToString:PnrPathDetail]) {
            str = self.h5Detail;
        }else if([path isEqualToString:PnrPathEdit]){
            str = self.h5Resubmit;
        }
        if (str) {
            complete([GCDWebServerDataResponse responseWithHTML:str]);
        }else{
            complete([GCDWebServerDataResponse responseWithHTML:ErrorUnknow]);
        }
        
    }else{
        complete([GCDWebServerDataResponse responseWithHTML:ErrorEntity]);
    }
}

// MARK: 分析 post 多层
- (void)analysisPost2Index:(NSInteger)index path:(NSString *)path request:(GCDWebServerRequest * _Nonnull)request complete:(GCDWebServerCompletionBlock  _Nonnull)complete {
    
    PnrEntity * entity;
    if (self.infoArray.count > index) {
        entity = self.infoArray[index];
    }
    if (entity) {
        if (index != self.lastIndex) {
            self.lastIndex = index;
            [self startServerUnitEntity:entity index:index];
        }
        NSString * str;
        if([path isEqualToString:PnrPathResubmit]){
            if (self.resubmitBlock) {
                PnrBlockFeedback blockFeedback ;
                blockFeedback = ^(NSString * feedback) {
                    if (!feedback) {
                        feedback = @"NULL";
                    }
                    complete([GCDWebServerDataResponse responseWithHTML:[PnrWebBody resubmitH5:feedback]]);
                };
                GCDWebServerURLEncodedFormRequest * formRequest= (GCDWebServerURLEncodedFormRequest *)request;
                self.resubmitBlock(entity, formRequest.arguments, blockFeedback);
            }else{
                str = @"<html> <head><title>update</title></head> <body><p> 已经重新提交 </p> </body></html>";
                complete([GCDWebServerDataResponse responseWithHTML:str]);
            }
        }else{
            complete([GCDWebServerDataResponse responseWithHTML:ErrorUrl]);
        }
        
    }else{
        complete([GCDWebServerDataResponse responseWithHTML:ErrorEntity]);
    }
}

- (void)analysisPost1Path:(NSString *)path request:(GCDWebServerRequest * _Nonnull)request complete:(GCDWebServerCompletionBlock  _Nonnull)complete {
    
    GCDWebServerURLEncodedFormRequest * formRequest = (GCDWebServerURLEncodedFormRequest *)request;
    NSDictionary * dic = formRequest.arguments;
    if ([path isEqualToString:PnrPathJsonXml]) {
        NSString * str = dic[PnrKeyConent];
        if (str) {
            complete([GCDWebServerDataResponse responseWithHTML:dic[PnrKeyConent]]);
        }else{
            complete([GCDWebServerDataResponse responseWithHTML:ErrorEmpty]);
        }
    }else{
        complete([GCDWebServerDataResponse responseWithHTML:ErrorUrl]);
    }
}

#pragma mark - server 某个单独请求
- (void)startServerUnitEntity:(PnrEntity *)pnrEntity index:(NSInteger)index {
    [PnrWebBody deatilEntity:pnrEntity index:index extra:self.resubmitExtraDic finish:^(NSString * _Nonnull detail, NSString * _Nonnull resubmit) {
        self.h5Detail   = detail;
        self.h5Resubmit = resubmit;
    }];
}

- (void)stopServer {
    [self.webServer stop];
    self.webServer = nil;
}

- (void)clearListWeb {
    self.lastIndex = -1;
    self.h5List    = [PnrWebBody listH5:@""];
}

@end
