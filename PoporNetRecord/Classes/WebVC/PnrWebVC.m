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

@interface PnrWebVC ()

@property (nonatomic, strong) UILabel * infoL;
@property (nonatomic, strong) GCDWebServer * webServer;
@property (nonatomic, strong) UIImageView * qrCodeIV;

@end

@implementation PnrWebVC

- (void)dealloc {
    if (self.webServer) {
        [self.webServer stop];
        NSLog(@"已关闭wifi服务");
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"Web";
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self addServer];
}

- (void)addServer {
    if (!self.webServer) {
        NSMutableString * h5 = [NSMutableString new];
        [h5 appendString:@"<html><body><br/>"];
        for (NSMutableAttributedString * cellAtt in self.cellAttArray) {
            [h5 appendFormat:@"<p>%@</p>", cellAtt.string];
        }
        
        [h5 appendString:@"</body></html>"];
        
        // Create server
        GCDWebServer * server = [[GCDWebServer alloc] init];
        // Add a handler to respond to GET requests on any URL
        [server addDefaultHandlerForMethod:@"GET" requestClass:[GCDWebServerRequest class] processBlock:^GCDWebServerResponse *(GCDWebServerRequest* request) {
            //@"<html><body><p>Hello World</p></body></html>"
            return [GCDWebServerDataResponse responseWithHTML:h5];
        }];
        // Start server on port 8080
        [server startWithPort:8080 bonjourName:nil];
        NSLog(@"Visit %@ in your web browser", server.serverURL);
        
        self.webServer = server;
        
        [self setWebUrl:server.serverURL.absoluteString];
        [self addQrIV:server.serverURL.absoluteString];
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

@end
