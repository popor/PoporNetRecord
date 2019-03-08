//
//  PnrWebPortEntity.m
//  PoporNetRecord
//
//  Created by apple on 2018/12/18.
//

#import "PnrServerTool.h"

#import "PnrVCEntity.h"
#import "PnrPortEntity.h"

#import <PoporUI/IToastKeyboard.h>

#import <GCDWebServer/GCDWebServer.h>
#import <GCDWebServer/GCDWebServerDataResponse.h>
#import <GCDWebServer/GCDWebServerPrivate.h>

#import <PoporFoundation/NSDictionary+tool.h>

static NSString * ErrorUrl    = @"<html> <head><title>错误</title></head> <body><p> URL异常 </p> </body></html>";
static NSString * ErrorEntity = @"<html> <head><title>错误</title></head> <body><p> 无法找到对应请求 </p> </body></html>";
static NSString * ErrorUnknow = @"<html> <head><title>错误</title></head> <body><p> 未知bug </p> </body></html>";

@interface PnrServerTool ()
@property (nonatomic, strong) NSMutableString * listH5;
@end

@implementation PnrServerTool

+ (instancetype)share {
    static dispatch_once_t once;
    static PnrServerTool * instance;
    dispatch_once(&once, ^{
        instance = [PnrServerTool new];
        instance.listH5 = [NSMutableString new];
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
- (void)startListServer:(NSString *)body {
    __weak typeof(self) weakSelf = self;
    
    if (!self.webServerUnit) {
        GCDWebServer * server = [GCDWebServer new];
        self.webServerUnit = server;
        
        [server addDefaultHandlerForMethod:@"GET" requestClass:[GCDWebServerRequest class] asyncProcessBlock:^(__kindof GCDWebServerRequest * _Nonnull request, GCDWebServerCompletionBlock  _Nonnull completionBlock) {
            
            NSLog(@"list request : %@", request.URL.absoluteString);
            NSLog(@"list request : %@", request.URL.path);
            NSString * path = request.URL.path;
            if (path.length > 1) {
                path = [path substringFromIndex:1];
                NSInteger index = [path integerValue];
                PnrVCEntity * entity = weakSelf.infoArray[index];
                NSLog(@"index:%li, all: %li, entity:%@", index, weakSelf.infoArray.count, entity);
                
                if (entity) {
                    NSMutableString * h5unit = [weakSelf startServerTitle:entity.titleArray json:entity.jsonArray];
                    if (h5unit) {
                        completionBlock([GCDWebServerDataResponse responseWithHTML:h5unit]);
                    }else{
                        completionBlock([GCDWebServerDataResponse responseWithHTML:ErrorUnknow]);
                    }
                }else{
                    completionBlock([GCDWebServerDataResponse responseWithHTML:ErrorEntity]);
                }
            }else{
                completionBlock([GCDWebServerDataResponse responseWithHTML:ErrorUrl]);
            }
        }];
        
        [server startWithPort:8080 bonjourName:nil];
    }
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.listH5 setString:@""];
        [self.listH5 appendString:@"<html> <head><title>网络请求</title></head> <body><p>请使用chrome核心浏览器，并且安装JSON-handle插件查看JSON详情页。</p>"];
        [self.listH5 appendString:body];
        [self.listH5 appendString:@"</body></html>"];
    });
    
    if (!self.webServerList) {
        GCDWebServer * server = [GCDWebServer new];
        self.webServerList = server;
        
        [self.webServerList addDefaultHandlerForMethod:@"GET" requestClass:[GCDWebServerRequest class] asyncProcessBlock:^(__kindof GCDWebServerRequest * _Nonnull request, GCDWebServerCompletionBlock  _Nonnull completionBlock) {
            completionBlock([GCDWebServerDataResponse responseWithHTML:weakSelf.listH5]);
        }];
        
        [server startWithPort:9000 bonjourName:nil];
    }
    
}

#pragma mark - server
- (NSMutableString *)startServerTitle:(NSArray *)titleArray json:(NSArray *)jsonArray {
    if (titleArray.count == jsonArray.count) {
        self.titleArray = titleArray;
        self.jsonArray  = jsonArray;
        
        return [self addServer];
    }else{
        AlertToastTitle(@"无法开启服务，titleArray与jsonArray数组不一致");
        return nil;
    }
}

- (NSMutableString *)addServer {
    NSMutableString * h5;
    
    NSMutableArray * webServerArray = [NSMutableArray new];
    [webServerArray addObjectsFromArray:@[[NSNull null], [NSNull null], [NSNull null], [NSNull null]]];
    
    self.webServerHead     = [self addIndex:4 port:self.portEntity.headPortInt array:webServerArray];
    self.webServerRequest  = [self addIndex:5 port:self.portEntity.requestPortInt array:webServerArray];
    self.webServerResponse = [self addIndex:6 port:self.portEntity.responsePortInt array:webServerArray];
    
    NSString * target = self.portEntity.jsonWindow ? @" target='_blank'" : @"";
    if (!self.webServerAll) {
        h5 = [NSMutableString new];
        [h5 appendString:@"<html> <head><title>请求详情</title></head> <body><p>请使用chrome核心浏览器，并且安装JSON-handle插件查看JSON详情页。</p>"];
        for (int i=0; i<self.titleArray.count; i++) {
            NSString * title         = self.titleArray[i];
            id content               = self.jsonArray[i];
            GCDWebServer * webServer = webServerArray[i];
            
            if ([webServer isKindOfClass:[NSNull class]]) {
                [h5 appendFormat:@"<p>%@</p>", title];
            }else{
                if ([content isKindOfClass:[NSDictionary class]]) {
                    [h5 appendFormat:@"<p><a href='%@'%@>%@</a> %@</p>", webServer.serverURL.absoluteString, target, title, [(NSDictionary *)content toJsonString]];
                }else if([content isKindOfClass:[NSString class]]) {
                    [h5 appendFormat:@"<p><a href='%@'%@>%@</a> %@</p>", webServer.serverURL.absoluteString, target, title, (NSString *)content];
                }else{
                    [h5 appendFormat:@"<p>%@ NULL</p>", title];
                }
            }
        }
        
        [h5 appendString:@"</body></html>"];
    }
    return h5;
}

- (GCDWebServer *)addIndex:(int)index port:(int)port array:(NSMutableArray *)array {
    NSString * title = self.titleArray[index];
    id content = self.jsonArray[index];
    if (content) {
        NSMutableString * h5 = [NSMutableString new];
        [h5 appendFormat:@"<html> <head><title>%@</title></head> <body><br/>", title];
        
        if([content isKindOfClass:[NSDictionary class]]) {
            [h5 appendFormat:@"<p>%@</p>", [(NSDictionary *)content toJsonString]];
        }else if([content isKindOfClass:[NSString class]]){
            [h5 appendFormat:@"<p>%@</p>", (NSString *)content];
        }
        
        [h5 appendString:@"</body></html>"];
        
        GCDWebServer * server = [GCDWebServer new];
        [server addDefaultHandlerForMethod:@"GET" requestClass:[GCDWebServerRequest class] processBlock:^GCDWebServerResponse *(GCDWebServerRequest* request) {
            return [GCDWebServerDataResponse responseWithHTML:h5];
        }];
        [server startWithPort:port bonjourName:nil];
        
        // 增加到数组中
        [array addObject:server];
        
        return server;
    }else{
        // 增加一个普通数组
        [array addObject:[NSNull null]];
        
        return nil;
    }
}

- (void)stopServer {
    [self.webServerList     stop];
    [self.webServerUnit     stop];
    [self.webServerAll      stop];
    [self.webServerHead     stop];
    [self.webServerRequest  stop];
    [self.webServerResponse stop];
    
    self.webServerList     = nil;
    self.webServerUnit     = nil;
    self.webServerAll      = nil;
    self.webServerHead     = nil;
    self.webServerRequest  = nil;
    self.webServerResponse = nil;
}

@end
