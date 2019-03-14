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
//static NSString * JsJsonXml   =

static NSString * PnrWebCode1 = @"PnrWebCode1";

@interface PnrServerTool ()

@property (nonatomic        ) NSInteger lastIndex;

@property (nonatomic, strong) NSMutableString * h5Root;
@property (nonatomic, strong) NSMutableString * h5List;

@property (nonatomic, strong) NSString * h5Detail;
@property (nonatomic, strong) NSString * h5Edit;

@end

@implementation PnrServerTool

+ (instancetype)share {
    static dispatch_once_t once;
    static PnrServerTool * instance;
    dispatch_once(&once, ^{
        instance = [PnrServerTool new];
        instance.h5List = [NSMutableString new];
        {
            NSMutableString * h5 = [NSMutableString new];
            [h5 appendString:@"<html> <head><title>网络请求</title></head> <body><p>请使用chrome核心浏览器，并且安装JSON-handle插件查看JSON详情页。</p>"];
            
            [h5 appendString:@"<script>"];
            {
                // 方便 xcode 查看代码
                // [h5 appendFormat:@"\
                //  function detail(row) {\
                //  var src = '/' +row + '/%@';\
                //  document.getElementById('%@').src = src;\
                //  }\
                //  ", PnrPathDetail, PnrIframeDetail];
                
                //[h5 appendFormat:@"\
                // function resubmit() {\
                // var form = document.getElementById('%@').contentWindow.document.getElementById('%@');\
                // form.submit();\
                // setTimeout(function(){\
                // document.getElementById('%@').contentWindow.location.reload(true);\
                // },2000);\
                // }\
                // ", PnrIframeDetail, PnrFormResubmit, PnrIframeList];
                
                //[h5 appendFormat:@"\
                // function json() {\
                // var form = document.getElementById('%@').contentWindow.document.getElementById('%@');\
                // form.submit();\
                // setTimeout(function(){\
                // document.getElementById('%@').contentWindow.location.reload(true);\
                // },2000);\
                // }\
                // ", PnrIframeDetail, PnrFormResubmit, PnrIframeList];
                
                // [h5 appendFormat:@"\
                //  function xml(formKey) {\
                //  var form = document.getElementById('formKey');\
                //  form.submit();\
                //  }\
                //  "];
                
            }
            {
                // 方便 浏览器查看 代码
                [h5 appendFormat:@"\n  function detail(row) {\n  var src = '/' +row + '/%@';\n  document.getElementById('%@').src = src;\n  }", PnrPathDetail, PnrIframeDetail];
                
                //[h5 appendFormat:@"\n\n  function resubmit() {\n  var form = document.getElementById('%@').contentWindow.document.getElementById('%@');\n  form.submit();\n  setTimeout(function(){\n  document.getElementById('%@').contentWindow.location.reload(true);\n  },2000);\n  }", PnrIframeDetail, PnrFormResubmit, PnrIframeList];
                
                [h5 appendFormat:@"\n\n  function resubmit() {\n  var form = document.getElementById('%@').contentWindow.document.getElementById('%@');\n  form.submit();\n }", PnrIframeDetail, PnrFormResubmit];
                
                [h5 appendFormat:@"\n\n  function freshList() {\n  document.getElementById('%@').contentWindow.location.reload(true);\n  }", PnrIframeList];
            }
            [h5 appendString:@"\n\n</script>"];
            
            [h5 appendFormat:@"<iframe id='%@' name='%@'  src='/%@' width ='400' height= '94%%' ></iframe>", PnrIframeList, PnrIframeList, PnrPathList];
            [h5 appendFormat:@"<iframe id='%@' name='%@' width ='900' height= '94%%' ></iframe>", PnrIframeDetail, PnrIframeDetail];
            
            [h5 appendString:@"</body></html>"];
            
            instance.h5Root = h5;
        }
        
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
    {
        NSMutableString * h5 = self.h5List;
        [h5 setString:@""];
        [h5 appendString:@"<html> <head><title>网络请求</title></head> <body>"];
        {
            [h5 appendFormat:@"<div style=\" background-color:#eeeeee; height:100%%; width:400px; float:left; padding:5px; \">"];
            
            //[self.h5List appendFormat:@"<div style=\"line-height:%ipx; background-color:#eeeeee; height:100%%; width:500px; float:left; padding:5px; \">", PnrListHeight];
            
            [h5 appendString:listBodyH5];
            [h5 appendString:@"</div>"];
        }
        
        [h5 appendString:@"</body></html>"];
    }
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
- (void)analysisGetIndex:(NSInteger)index path:(NSString *)path request:(GCDWebServerRequest * _Nonnull)request complete:(GCDWebServerCompletionBlock  _Nonnull)complete {
    
    PnrEntity * entity;
    if (self.infoArray.count > index) {
        entity = self.infoArray[index];
    }
    //NSLog(@"index:%li, all: %li, entity:%@", index, self.infoArray.count, entity);
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
            str = self.h5Edit;
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
                    PnrConfig * config      = [PnrConfig share];
                    NSString * colorKey     = config.rootColorKeyHex;
                    
                    NSMutableString * h5 = [NSMutableString new];
                    [h5 setString:@"<html> <head><title>update</title></head>"];
                    
                    // css
                    [h5 appendString:@"\n<style type='text/css'>"];
                    [h5 appendString:[self cssTextarea]];
                    [h5 appendString:[self cssButton:colorKey]];
                    [h5 appendString:@"\n</style>"];
                    
                    // body
                    [h5 appendString:@"\n<body>"];
                    [h5 appendString:[self jsonReadForm:@"feedback" key:PnrKeyConent name:@"返回数据" content:feedback]];
                    
                    [h5 appendString:@"\n<script>"];
                    
                    // js
                    [h5 appendString:@"\n window.onload=function (){\
                     parent.parent.freshList();\
                     } "];
                    [h5 appendFormat:@"\n %@ \n %@ \n", [self textareaAutoHeightFuntion], [self textareaAuhoHeigtEventClass:PnrClassTaAutoH]];
                    
                    [h5 appendString:[self jsJsonStatic]];
                    [h5 appendString:@"\n </script>"];
                    
                    [h5 appendString:@"\n</body></html>"];
                    complete([GCDWebServerDataResponse responseWithHTML:h5]);
                };
                GCDWebServerURLEncodedFormRequest * formRequest= (GCDWebServerURLEncodedFormRequest *)request;
                self.resubmitBlock(entity, formRequest.arguments, blockFeedback);
            }else{
                str = @"<html> <head><title>update</title></head> <body><p> 已经重新提交 </p> </body></html>";
                complete([GCDWebServerDataResponse responseWithHTML:str]);
            }
        }
        else{
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
    NSArray * titleArray = pnrEntity.titleArray;
    NSArray * jsonArray  = pnrEntity.jsonArray;
    if (titleArray.count == jsonArray.count) {
        self.titleArray         = titleArray;
        self.jsonArray          = jsonArray;
        
        PnrConfig * config      = [PnrConfig share];
        NSString * colorKey     = config.rootColorKeyHex;
        NSString * colorValue   = config.rootColorValueHex;
        
        NSString * pnrTitle     = pnrEntity.title? [NSString stringWithFormat:@"%@: ", pnrEntity.title]: @"";
        NSString * headStr      = [self contentString:pnrEntity.headValue];
        NSString * parameterStr = [self contentString:pnrEntity.parameterValue];
        //NSLog(@"parameterStr : %@", parameterStr);
        NSString * responseStr  = [self contentString:pnrEntity.responseValue];
        NSString * extraStr     = self.resubmitExtraDic ? self.resubmitExtraDic.toJsonString : @"{\"extraKey\":\"extraValue\"}";
        
        {
            // 设置 h5Root
            NSMutableString * h5;
            
            h5 = [NSMutableString new];
            [h5 appendFormat:@"<html> <head><title>%@ 请求详情</title></head>", pnrTitle];
            
            // css
            [h5 appendString:@"\n<style type='text/css'>"];
            [h5 appendString:[self cssTextarea]];
            [h5 appendString:[self cssButton:colorKey]];
            [h5 appendString:@"\n</style>"];
            
            // body
            [h5 appendString:@"\n<body>"];
            // 是否开启了重新提交
            if (self.resubmitBlock) {
                [h5 appendFormat:@"<p> <a href='/%i/%@'> <button type='button' style=\"width:200px;\" > 重新请求 </button> </a> </p>", (int)index, PnrPathEdit];
            }
            [h5 appendFormat:@"<p><font color='%@'>%@</font><font color='%@'>%@</font></p>", colorKey, PnrRootPath1, colorValue, pnrEntity.path];
            [h5 appendFormat:@"<p><font color='%@'>%@</font><font color='%@'>%@</font></p>", colorKey, PnrRootUrl1, colorValue, pnrEntity.url];
            [h5 appendFormat:@"<p><font color='%@'>%@</font><font color='%@'>%@</font></p>", colorKey, PnrRootTime2, colorValue, pnrEntity.time];
            [h5 appendFormat:@"<p><font color='%@'>%@</font><font color='%@'>%@</font></p>", colorKey, PnrRootMethod3, colorValue, pnrEntity.method];
            
            void (^ hrefBlock)(NSString*, id, NSString*) = ^(NSString * title, NSString * content, NSString * secondPath){
                [h5 appendString:[self jsonReadForm:secondPath key:PnrKeyConent name:title content:content]];
            };
            
            hrefBlock(PnrRootHead4,      [self contentString:headStr],      PnrPathHead);
            hrefBlock(PnrRootParameter5, [self contentString:parameterStr], PnrPathParameter);
            hrefBlock(PnrRootResponse6,  [self contentString:responseStr],  PnrPathResponse);
            
            // js
            [h5 appendFormat:@"\n<script> %@", [self jsJsonStatic]];
            [h5 appendFormat:@"\n %@ %@", [self textareaAutoHeightFuntion], [self textareaAuhoHeigtEventClass:PnrClassTaAutoH]];
            [h5 appendString:@"</script>"];
            
            [h5 appendString:@"</body></html>"];
            self.h5Detail = h5;
        }
        // MARK: 重新提交
        if (self.resubmitBlock) {
            // 设置 h5Edit
            NSMutableString * h5;
            
            h5 = [NSMutableString new];
            [h5 appendFormat:@"<html> <head><title>%@重新提交</title></head>", pnrTitle];
            
            // css
            [h5 appendString:@"\n<style type='text/css'>"];
            [h5 appendString:[self cssTextarea]];
            [h5 appendString:[self cssButton:colorKey]];
            [h5 appendString:@"\n</style>"];
            
            // body
            [h5 appendString:@"\n<body>"];
            
            [h5 appendFormat:@"<p> <a href='/%i/%@'> <button type='button' style=\"width:200px;\" > <==返回 </button> </a> </p>", (int)index, PnrPathDetail];
            
            [h5 appendFormat:@"<form id='%@' name='%@' action='/%i/%@' method='POST' target='%@' >", PnrFormResubmit, PnrFormResubmit, (int)index, PnrPathResubmit, PnrIframeFeedback];
            
            void (^ hrefBlock)(NSString*, NSString*, NSString*, int) = ^(NSString* title, NSString* key, NSString* value, int rows){
                
                [h5 appendFormat:@"\n<br> <button type='button' \" onclick=\"jsonDynamic('%@', '%@')\" > %@ 查看详情 </button> ",
                 PnrFormResubmit, key, title
                 ];
                //[h5 appendFormat:@"\n <br><font color='%@'>%@</font><br>",
                //colorKey, title];
                [h5 appendFormat:@"\n <textarea id='%@' name='%@' class='%@'>%@</textarea>",
                 key, key, PnrClassTaAutoH, value];
            };
            
            hrefBlock(PnrRootPath1, @"url", [NSString stringWithFormat:@"%@/%@", pnrEntity.domain, pnrEntity.path], 1);
            hrefBlock(PnrRootMethod3, @"method", pnrEntity.method, 1);
            hrefBlock(PnrRootHead4, @"head", headStr, 6);
            hrefBlock(PnrRootParameter5, @"parameter", parameterStr, 6);
            hrefBlock(@"额外参数", @"extra", extraStr, 4);
            
            //[h5 appendString:@"<br><input type=\"submit\" style=\"width:200px;\" value=\"  提交  \"> <br><br>"];
            [h5 appendFormat:@"<p> <button type='button' onclick=\"parent.resubmit()\" > 重新请求 </button>"];
            [h5 appendFormat:@"&nbsp; <button type='button' onclick=\"parent.freshList()\" > 刷新列表 </button> </p>"];
            [h5 appendString:@"</form>"];
            
            [h5 appendFormat:@"<iframe id='%@' name='%@' width ='800' height='400'></iframe>", PnrIframeFeedback, PnrIframeFeedback];
            
            // js
            [h5 appendFormat:@"\n<script> \n%@", [self jsJsonDynamic]];
            [h5 appendFormat:@"\n %@ %@", [self textareaAutoHeightFuntion], [self textareaAuhoHeigtEventClass:PnrClassTaAutoH]];
            
            [h5 appendString:@"</script>"];
            
            
            [h5 appendString:@"\n</body></html>"];
            self.h5Edit = h5;
        }
        
    }else{
        AlertToastTitle(@"无法开启服务，titleArray与jsonArray数组不一致");
    }
}

- (NSString *)contentString:(id)content {
    if ([content isKindOfClass:[NSDictionary class]]) {
        return [(NSDictionary *)content toJsonString];
    }else if([content isKindOfClass:[NSString class]]) {
        return (NSString *)content;
    }else{
        return @"NULL";
    }
}

- (NSString *)jsonReadForm:(NSString *)form key:(NSString *)key name:(NSString *)keyName content:(NSString *)content {
    return [NSString stringWithFormat:@"\n<form id='%@' name='%@' method='POST' target='_blank' > \n <button type='button' \" onclick=\"jsonStatic('%@')\" > %@ 查看详情 </button> <br> \n <textarea id='%@' name='%@' class='%@'>%@</textarea> \n</form>",
            form, form, form, keyName, key, key, PnrClassTaAutoH, content
            ];
}

// MARK: 固定的查看json js代码
- (NSString *)jsJsonStatic {
    return [NSString stringWithFormat: @"\n\
            function jsonStatic(formKey) {\n\
            var form = document.getElementById(formKey);\n form.action='/%@';\n form.submit();\n\
            }\n\
            ", PnrPathJsonXml];
}

// MARK: 动态的查看json js代码
- (NSString *)jsJsonDynamic {
    return [NSString stringWithFormat: @"\n\
            function jsonDynamic(formKey, contentkey) {\n\
            var valueFrom =  document.forms[formKey].elements[contentkey].value;\n\
            var formNew =  new FormData();\n\
            formNew.append(%@, valueFrom);\n\
            formNew.method='post';\n\
            formNew.action='/%@';\n\
            formNew.submit();\n\
            }\n\
            ", PnrKeyConent, PnrPathJsonXml];
}

- (NSString *)cssTextarea {
    return @"\ntextarea {\n\
    border: 1px solid #eee;\n\
    padding: 5px;\n\
    min-height: 20px;\n\
    width:100%;\n\
    font-size:16px;\n\
    }";
}

- (NSString *)cssButton:(NSString *)btColor {
    return [NSString stringWithFormat:@"\nbutton {\n\
            color:%@; width:180px; font-size:16px;\
            }\n", btColor];
}

// MARK: 高度自适应的textarea
- (NSString *)textareaAutoHeightFuntion {
    // http://caibaojian.com/textarea-autoheight.html
    
    return @" function makeExpandingArea(el) { var setStyle = function (el) { el.style.height = 'auto'; el.style.height = el.scrollHeight + 'px'; }; var delayedResize = function (el) { window.setTimeout(function () { setStyle(el); }, 0); }; if (el.addEventListener) { el.addEventListener('input', function () { setStyle(el) }, false); setStyle(el); } else if (el.attachEvent) { el.attachEvent('onpropertychange', function () { setStyle(el); }); setStyle(el); } if (window.VBArray && window.addEventListener) { el.attachEvent('onkeydown', function () { var key = window.event.keyCode; if (key == 8 || key == 46) {delayedResize(el);} }); el.attachEvent('oncut', function () { delayedResize(el); }); } } ";
}

- (NSString *)textareaAuhoHeigtEventClass:(NSString *)className {
    return [NSString stringWithFormat:@"\n var taArray = document.getElementsByClassName('%@'); for (var i = 0; i < taArray.length; i++) { makeExpandingArea(taArray[i]); } \n", className];
}

- (void)stopServer {
    [self.webServer stop];
    self.webServer = nil;
}

- (void)clearListWeb {
    self.lastIndex = -1;
    {
        [self.h5Root setString:@""];
        [self.h5Root appendString:@"<html> <head><title>网络请求</title></head> <body><p>请使用chrome核心浏览器，并且安装JSON-handle插件查看JSON详情页。</p>"];
        [self.h5Root appendString:@"暂无数据"];
        [self.h5Root appendString:@"</body></html>"];
    }
}

@end
