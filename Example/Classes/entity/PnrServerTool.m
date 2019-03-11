//
//  PnrWebPortEntity.m
//  PoporNetRecord
//
//  Created by apple on 2018/12/18.
//

#import "PnrServerTool.h"

#import "PnrEntity.h"
#import "PnrPortEntity.h"
#import "PnrConfig.h"

#import <PoporUI/IToastKeyboard.h>

#import <GCDWebServer/GCDWebServer.h>
#import <GCDWebServer/GCDWebServerDataResponse.h>
#import <GCDWebServer/GCDWebServerPrivate.h>

#import <PoporFoundation/NSDictionary+tool.h>

static NSString * ErrorUrl    = @"<html> <head><title>错误</title></head> <body><p> URL异常 </p> </body></html>";
static NSString * ErrorEntity = @"<html> <head><title>错误</title></head> <body><p> 无法找到对应请求 </p> </body></html>";
static NSString * ErrorUnknow = @"<html> <head><title>错误</title></head> <body><p> 未知bug </p> </body></html>";
static NSString * ErrorEmpty  = @"<html> <head><title>错误</title></head> <body><p> 无 </p> </body></html>";

static NSString * PnrWebCode1 = @"PnrWebCode1";

@interface PnrServerTool ()
@property (nonatomic, strong) NSMutableString * h5List;
@property (nonatomic, strong) NSString * h5Root;
@property (nonatomic, strong) NSString * h5Head;
@property (nonatomic, strong) NSString * h5Request;
@property (nonatomic, strong) NSString * h5Response;

@property (nonatomic        ) NSInteger lastIndex;

@end

@implementation PnrServerTool

+ (instancetype)share {
    static dispatch_once_t once;
    static PnrServerTool * instance;
    dispatch_once(&once, ^{
        instance = [PnrServerTool new];
        instance.h5List     = [NSMutableString new];
        instance.h5Root     = [NSMutableString new];
        instance.h5Head     = [NSMutableString new];
        instance.h5Request  = [NSMutableString new];
        instance.h5Response = [NSMutableString new];
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
- (void)startListServer:(NSString *)body {
    __weak typeof(self) weakSelf = self;
    
    [self.h5List setString:@""];
    [self.h5List appendString:@"<html> <head><title>网络请求</title></head> <body><p>请使用chrome核心浏览器，并且安装JSON-handle插件查看JSON详情页。</p>"];
    [self.h5List appendString:body];
    [self.h5List appendString:@"</body></html>"];
    
    if (!self.webServer) {
        GCDWebServer * server = [GCDWebServer new];
        self.webServer = server;
        
        [self.webServer addDefaultHandlerForMethod:@"GET" requestClass:[GCDWebServerRequest class] asyncProcessBlock:^(__kindof GCDWebServerRequest * _Nonnull request, GCDWebServerCompletionBlock  _Nonnull completionBlock) {
            NSString * path = request.URL.path;
            if (path.length>=2) {
                path = [path substringFromIndex:1];
                NSArray * array = [path componentsSeparatedByString:@"/"];
                if (array.count == 2) {
                    [weakSelf analysisIndex:[array[0] integerValue] path:array[1] complete:completionBlock];
                }else{
                    completionBlock([GCDWebServerDataResponse responseWithHTML:ErrorUrl]);
                }
            }else{
                completionBlock([GCDWebServerDataResponse responseWithHTML:weakSelf.h5List]);
            }
        }];
        PnrPortEntity * port = [PnrPortEntity share];
        [server startWithPort:port.portInt bonjourName:nil];
    }
}

- (void)analysisIndex:(NSInteger)index path:(NSString *)path complete:(GCDWebServerCompletionBlock  _Nonnull)complete {
    
    PnrEntity * entity;
    if (self.infoArray.count > index) {
        entity = self.infoArray[index];
    }
    //NSLog(@"index:%li, all: %li, entity:%@", index, self.infoArray.count, entity);
    if (entity) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if (index != self.lastIndex) {
                self.lastIndex = index;
                [self startServerTitle:entity.titleArray json:entity.jsonArray index:index];
            }
            NSString * str;
            if ([path isEqualToString:PnrPathRoot]) {
                str = self.h5Root;
            }else if ([path isEqualToString:PnrPathHead]){
                str = self.h5Head;
            }else if ([path isEqualToString:PnrPathRequest]){
                str = self.h5Request;
            }else if ([path isEqualToString:PnrPathResponse]){
                str = self.h5Response;
            }
            if (str) {
                complete([GCDWebServerDataResponse responseWithHTML:str]);
            }else{
                complete([GCDWebServerDataResponse responseWithHTML:ErrorUnknow]);
            }
            
        });
        
    }else{
        complete([GCDWebServerDataResponse responseWithHTML:ErrorEntity]);
    }
}

#pragma mark - server
- (void)startServerTitle:(NSArray *)titleArray json:(NSArray *)jsonArray index:(NSInteger)index {
    if (titleArray.count == jsonArray.count) {
        self.titleArray       = titleArray;
        self.jsonArray        = jsonArray;
        
        PnrConfig * config    = [PnrConfig share];
        NSString * colorKey   = config.rootColorKeyHex;
        NSString * colorValue = config.rootColorValueHex;
        
        NSMutableString * h5;
        
        h5 = [NSMutableString new];
        [h5 appendString:@"<html> <head><title>请求详情</title></head> <body><p>请使用chrome核心浏览器，并且安装JSON-handle插件查看JSON详情页。</p>"];
        for (int i=0; i<self.titleArray.count; i++) {
            NSString * title         = self.titleArray[i];
            //NSLog(@"title: %@", title);
            id content               = self.jsonArray[i];
            NSString * secondPath;
            switch (i) {
                case 4:
                    secondPath = PnrPathHead;
                    self.h5Head = [self h5CodeAtIndex:i];
                    break;
                case 5:
                    secondPath = PnrPathRequest;
                    self.h5Request = [self h5CodeAtIndex:i];
                    break;
                case 6:
                    secondPath = PnrPathResponse;
                    self.h5Response = [self h5CodeAtIndex:i];
                    break;
                default:{
                    NSInteger location = [title rangeOfString:@":"].location;
                    if (location > 0) {
                        NSString * title1 = [title substringToIndex:location+1];
                        NSString * title2 = [title substringFromIndex:location+1];
                        [h5 appendFormat:@"<p><font color='%@'>%@</font><font color='%@'>%@</font></p>", colorKey, title1, colorValue, title2];
                    }else{
                        [h5 appendFormat:@"<p>%@</p>", title];
                    }
                    
                    break;
                }
            }
            if (secondPath) {
                if ([content isKindOfClass:[NSDictionary class]]) {
                    [h5 appendFormat:@"<p><a href='/%i/%@'> <font color='%@'> %@ </font></a> <font color='%@'> %@ </font></p>", (int)index, secondPath, colorKey, title, colorValue, [(NSDictionary *)content toJsonString]];
                }else if([content isKindOfClass:[NSString class]]) {
                    [h5 appendFormat:@"<p><a href='/%i/%@'> <font color='%@'> %@ </font></a> <font color='%@'> %@ </font></p>", (int)index, secondPath, colorKey, title, colorValue, (NSString *)content];
                }else{
                    [h5 appendFormat:@"<p>%@ NULL</p>", title];
                }
            }
        }
        
        [h5 appendString:@"</body></html>"];
        self.h5Root = h5;
    }else{
        AlertToastTitle(@"无法开启服务，titleArray与jsonArray数组不一致");
    }
}

- (NSString *)h5CodeAtIndex:(int)index {
    NSString * title = self.titleArray[index];
    id content       = self.jsonArray[index];
    if (content) {
        NSMutableString * h5 = [NSMutableString new];
        [h5 appendFormat:@"<html> <head><title>%@</title></head> <body><br/>", title];
        
        if([content isKindOfClass:[NSDictionary class]]) {
            [h5 appendFormat:@"<p>%@</p>", [(NSDictionary *)content toJsonString]];
        }else if([content isKindOfClass:[NSString class]]){
            [h5 appendFormat:@"<p>%@</p>", (NSString *)content];
        }
        
        [h5 appendString:@"</body></html>"];
        return h5;
    }else{
        return ErrorEmpty;
    }
}

- (void)stopServer {
    [self.webServer stop];
    self.webServer = nil;
}

@end
