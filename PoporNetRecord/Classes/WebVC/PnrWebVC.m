//
//  PnrWebVC.m
//  GCDWebServer
//
//  Created by apple on 2018/12/3.
//

#import "PnrWebVC.h"

#import "GCDWebServer.h"
#import "GCDWebServerDataResponse.h"
#import <PoporFoundation/NSString+format.h>
#import <PoporFoundation/PrefixColor.h>
#import <Masonry/Masonry.h>
#import <PoporQRCodeIos/JPQRCodeTool.h>
#import <PoporUI/UIDevice+Tool.h>
#import <PoporUI/IToastKeyboard.h>
#import <PoporUI/UIInsetsTextField.h>
#import "PnrWebPortVC.h"
#import <PoporFoundation/NSDictionary+tool.h>

@interface PnrWebVC ()

@property (nonatomic, strong) UILabel           * infoL;
@property (nonatomic, strong) UIImageView       * qrCodeIV;

@property (nonatomic, strong) GCDWebServer      * webServerAll;
@property (nonatomic, strong) GCDWebServer      * webServerHead;
@property (nonatomic, strong) GCDWebServer      * webServerRequest;
@property (nonatomic, strong) GCDWebServer      * webServerResponse;

@property (nonatomic, strong) PnrWebPortEntity  * portEntity;

@end

@implementation PnrWebVC

- (void)dealloc {
    if (self.webServerAll) {
        [self.webServerAll stop];
    }
    if (self.webServerHead) {
        [self.webServerHead stop];
    }
    if (self.webServerRequest) {
        [self.webServerRequest stop];
    }
    if (self.webServerResponse) {
        [self.webServerResponse stop];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"Web";
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.portEntity = [PnrWebPortEntity new];
    [self addServer];
    {
        UIBarButtonItem *item1 = [[UIBarButtonItem alloc] initWithTitle:@"端口" style:UIBarButtonItemStylePlain target:self action:@selector(showPnrWebPortVC)];
        self.navigationItem.rightBarButtonItems = @[item1];
    }
}

- (void)addServer {
    self.webServerHead     = [self addIndex:4 port:self.portEntity.headPortInt];
    self.webServerRequest  = [self addIndex:5 port:self.portEntity.requestPortInt];
    self.webServerResponse = [self addIndex:6 port:self.portEntity.responsePortInt];
    
    if (!self.webServerAll) {
        NSMutableString * h5 = [NSMutableString new];
        [h5 appendString:@"<html> <head><title>请求详情</title></head> <body><br/>"];
        for (int i=0; i<self.titleArray.count; i++) {
            NSString * title = self.titleArray[i];
            NSString * content = self.jsonArray[i];
            
            switch (i) {
                case 4:{
                    if ([content isKindOfClass:[NSDictionary class]]) {
                        [h5 appendFormat:@"<p><a href='%@'>%@</a> %@</p>", self.webServerHead.serverURL.absoluteString, title,[(NSDictionary *)content toJsonString]];
                    }else{
                        [h5 appendFormat:@"<p>%@</p>", title];
                    }
                    break;
                }
                case 5:{
                    if ([content isKindOfClass:[NSDictionary class]]) {
                        [h5 appendFormat:@"<p><a href='%@'>%@</a> %@</p>", self.webServerRequest.serverURL.absoluteString, title, [(NSDictionary *)content toJsonString]];
                    }else{
                        [h5 appendFormat:@"<p>%@</p>", title];
                    }
                    break;
                }
                case 6:{
                    if ([content isKindOfClass:[NSDictionary class]]) {
                        [h5 appendFormat:@"<p><a href='%@'>%@</a> %@</p>", self.webServerResponse.serverURL.absoluteString, title, [(NSDictionary *)content toJsonString]];
                    }else{
                        [h5 appendFormat:@"<p>%@</p>", title];
                    }
                    break;
                }
                default:{
                    [h5 appendFormat:@"<p>%@</p>", title];
                    break;
                }
            }
        }
        
        [h5 appendString:@"</body></html>"];
        
        GCDWebServer * server = [GCDWebServer new];
        [server addDefaultHandlerForMethod:@"GET" requestClass:[GCDWebServerRequest class] processBlock:^GCDWebServerResponse *(GCDWebServerRequest* request) {
            return [GCDWebServerDataResponse responseWithHTML:h5];
        }];
        [server startWithPort:self.portEntity.allPortInt bonjourName:nil];
        NSLog(@"Visit %@ in your web browser", server.serverURL);
        
        self.webServerAll = server;
        
        [self setWebUrl:server.serverURL.absoluteString];
        [self addQrIV:server.serverURL.absoluteString];
    }
}

- (GCDWebServer *)addIndex:(int)index port:(int)port{
    NSString * title = self.titleArray[index];
    id content = self.jsonArray[index];
    if([content isKindOfClass:[NSDictionary class]]) {
        NSMutableString * h5 = [NSMutableString new];
        [h5 appendFormat:@"<html> <head><title>%@</title></head> <body><br/>", title];
        [h5 appendFormat:@"<p>%@</p>", [(NSDictionary *)content toJsonString]];
        
        [h5 appendString:@"</body></html>"];
        
        GCDWebServer * server = [GCDWebServer new];
        [server addDefaultHandlerForMethod:@"GET" requestClass:[GCDWebServerRequest class] processBlock:^GCDWebServerResponse *(GCDWebServerRequest* request) {
            return [GCDWebServerDataResponse responseWithHTML:h5];
        }];
        [server startWithPort:port bonjourName:nil];
        
        return server;
    }else{
        return nil;
    }
}

- (void)setWebUrl:(NSString *)webUrl {
    UIFont * font1 = [UIFont systemFontOfSize:16];
    if (!self.infoL) {
        self.infoL = [UILabel new];
        self.infoL.backgroundColor = [UIColor clearColor];
        self.infoL.font = font1;
        
        [self.view addSubview:self.infoL];
    }
    
    NSMutableAttributedString * att = [NSMutableAttributedString new];
    if (!webUrl) {
        [att addString:@"通过 WIFI 查看详情\n" font:font1 color:[UIColor blackColor]];
        [att addString:@"未开启 WIFI 或者无法获得IP地址" font:font1 color:[UIColor redColor]];
    }else{
        NSString * wifi = [UIDevice getWifiName];
        if (wifi) {
            [att addString:@"通过 WIFI(" font:font1 color:[UIColor blackColor]];
            [att addString:wifi font:font1 color:[UIColor redColor]];
            [att addString:@") 查看详情，确保其他设备处于同一网段内，访问网址:\n" font:font1 color:[UIColor blackColor]];
        }else{
            [att addString:@"通过 WIFI 查看详情，访问网址:\n" font:font1 color:[UIColor blackColor]];
        }
        
        [att addString:webUrl font:font1 color:[UIColor redColor]];
    }
    
    self.infoL.attributedText = att;
    self.infoL.numberOfLines  = 0;
    self.infoL.frame = CGRectMake(10, 10, self.view.frame.size.width-20, 60);
}

- (void)addQrIV:(NSString *)webUrl {
    UIImageView * oneIV = ({
        UIImageView * iv = [UIImageView new];
        iv.userInteractionEnabled = YES;
        iv.backgroundColor = [UIColor whiteColor];
        [self.view addSubview:iv];
        iv;
    });
    self.qrCodeIV = oneIV;
    [self.qrCodeIV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(40);
        make.top.mas_equalTo(self.infoL.mas_bottom).mas_offset(40);
        make.right.mas_equalTo(-40);
        make.height.mas_equalTo(oneIV.mas_width);
    }];
 
    NSArray *colors = @[RGB16(0X68D3FF), RGB16(0X4585F5)];
    NSString *codeStr = webUrl;
    
    UIImage *img = [JPQRCodeTool generateCodeForString:codeStr withCorrectionLevel:kQRCodeCorrectionLevelHight SizeType:kQRCodeSizeTypeCustom customSizeDelta:20 drawType:kQRCodeDrawTypeSquare gradientType:kQRCodeGradientTypeHorizontal gradientColors:colors];
    
    oneIV.image = img;
}

- (void)showPnrWebPortVC {
    [self.navigationController pushViewController:[PnrWebPortVC new] animated:YES];
}

@end
