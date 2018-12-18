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

static int PoporNetRecordAllPort      = 8080;
static int PoporNetRecordResponsePort = 8081;

@interface PnrWebVC ()

@property (nonatomic, strong) UILabel           * infoL;
@property (nonatomic, strong) UIImageView       * qrCodeIV;

@property (nonatomic, strong) GCDWebServer      * webServerAll;
@property (nonatomic, strong) GCDWebServer      * webServerResponse;

@property (nonatomic        ) int               allPortInt;
@property (nonatomic        ) int               responsePortInt;

@property (nonatomic, strong) UILabel           * allPortL;
@property (nonatomic, strong) UILabel           * responsePortL;
@property (nonatomic, strong) UIInsetsTextField * allPortTF;
@property (nonatomic, strong) UIInsetsTextField * responsePortTF;
@property (nonatomic, strong) UIButton          * allPortBT;
@property (nonatomic, strong) UIButton          * responsePortBT;

@end

@implementation PnrWebVC

- (void)dealloc {
    if (self.webServerAll) {
        [self.webServerAll stop];
    }
    if (self.webServerResponse) {
        [self.webServerResponse stop];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"Web";
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self initPort];
    [self addServer];
}

- (void)initPort {
    NSString * allPortString      = [self getAllPort];
    NSString * responsePortString = [self getResponsePort];
    if (allPortString && allPortString.length>0) {
        self.allPortInt = [allPortString intValue];
    }else{
        self.allPortInt = PoporNetRecordAllPort;
    }
    if (responsePortString && responsePortString.length>0) {
        self.responsePortInt = [responsePortString intValue];
    }else{
        self.responsePortInt = PoporNetRecordResponsePort;
    }
    if (self.allPortInt == self.responsePortInt) {
        self.responsePortInt++;
    }
}

- (void)addServer {
    NSString * responseString;
    if (self.cellAttArray.count == 7) {
        NSMutableAttributedString * att = self.cellAttArray.lastObject;
        responseString = [att.string substringFromIndex:5];
    }
    
    if (!self.webServerResponse && responseString) {
        NSMutableString * h5 = [NSMutableString new];
        [h5 appendString:@"<html> <head><title>返回数据</title></head> <body><br/>"];
        [h5 appendFormat:@"<p>%@</p>", responseString];
        
        [h5 appendString:@"</body></html>"];
        
        GCDWebServer * server = [GCDWebServer new];
        [server addDefaultHandlerForMethod:@"GET" requestClass:[GCDWebServerRequest class] processBlock:^GCDWebServerResponse *(GCDWebServerRequest* request) {
            return [GCDWebServerDataResponse responseWithHTML:h5];
        }];
        [server startWithPort:self.responsePortInt bonjourName:nil];
        //NSLog(@"Visit %@ in your web browser", server.serverURL);
        
        self.webServerResponse = server;
    }
    
    if (!self.webServerAll) {
        NSMutableString * h5 = [NSMutableString new];
        [h5 appendString:@"<html> <head><title>请求详情</title></head> <body><br/>"];
        for (int i=0; i<self.cellAttArray.count; i++) {
            NSMutableAttributedString * cellAtt = self.cellAttArray[i];
            if (i == 6 && self.webServerResponse) {
                NSString * title = [cellAtt.string substringToIndex:4];
                NSString * content = [cellAtt.string substringFromIndex:5];
                //[h5 appendFormat:@"<p><a href=''>%@</a>%@</p>", , cellAtt.string];
                [h5 appendFormat:@"<p><a href='%@'>%@</a>: %@</p>", self.webServerResponse.serverURL.absoluteString, title, content];
            }else{
                [h5 appendFormat:@"<p>%@</p>", cellAtt.string];
            }
        }
        
        [h5 appendString:@"</body></html>"];
        
        GCDWebServer * server = [GCDWebServer new];
        [server addDefaultHandlerForMethod:@"GET" requestClass:[GCDWebServerRequest class] processBlock:^GCDWebServerResponse *(GCDWebServerRequest* request) {
            return [GCDWebServerDataResponse responseWithHTML:h5];
        }];
        [server startWithPort:self.allPortInt bonjourName:nil];
        NSLog(@"Visit %@ in your web browser", server.serverURL);
        
        self.webServerAll = server;
        
        [self setWebUrl:server.serverURL.absoluteString];
        [self addTFs];
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

- (void)addTFs {
    NSArray * titleArray = @[@"主页端口", @"返回数据端口"];
    NSArray * placeArray = @[[NSString stringWithFormat:@"%i", PoporNetRecordAllPort], [NSString stringWithFormat:@"%i", PoporNetRecordResponsePort]];
    NSArray * textArray = @[[NSString stringWithFormat:@"%i", self.allPortInt], [NSString stringWithFormat:@"%i", self.responsePortInt]];
    int height = 30;
    for (int i = 0; i<titleArray.count; i++) {
        UILabel * oneL = ({
            UILabel * l = [UILabel new];
            l.frame              = CGRectMake(0, 0, 0, 44);
            l.backgroundColor    = [UIColor clearColor];
            l.font               = [UIFont systemFontOfSize:15];
            l.textColor          = [UIColor darkGrayColor];

            [self.view addSubview:l];
            l;
        });
        UIInsetsTextField * oneTF = ({
            UIInsetsTextField * tf = [[UIInsetsTextField alloc] initWithFrame:CGRectMake(0, 0, 0, 44) insets:UIEdgeInsetsMake(0, 10, 0, 10)];
            tf.backgroundColor    = [UIColor clearColor];
            tf.font               = [UIFont systemFontOfSize:15];
            tf.textColor          = [UIColor darkGrayColor];
            
            tf.layer.cornerRadius = 5;
            tf.layer.borderColor  = [UIColor lightGrayColor].CGColor;
            tf.layer.borderWidth  = 1;
            tf.clipsToBounds      = YES;
            
            [self.view addSubview:tf];
            tf;
        });
        UIButton * oneBT = ({
            UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
            //button.frame =  CGRectMake(0, 100, 80, 44);
            [button setTitle:@"更新" forState:UIControlStateNormal];
            [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            [button setBackgroundColor:RGB16(0X4585F5)];
            
            button.layer.cornerRadius = 5;
            button.layer.borderColor = [UIColor lightGrayColor].CGColor;
            button.layer.borderWidth = 1;
            button.clipsToBounds = YES;
            button.titleLabel.font = [UIFont systemFontOfSize:15];
            
            [self.view addSubview:button];
            
            [button addTarget:self action:@selector(updateBtAction:) forControlEvents:UIControlEventTouchUpInside];
            
            button;
        });
        
        oneL.text         = titleArray[i];
        oneTF.placeholder = placeArray[i];
        oneTF.text        = textArray[i];
        
        switch (i) {
            case 0: {
                self.allPortL       = oneL;
                self.allPortTF      = oneTF;
                self.allPortBT      = oneBT;
                [oneL mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.left.mas_equalTo(10);
                    make.top.mas_equalTo(self.infoL.mas_bottom).mas_offset(10);
                    make.width.mas_equalTo(100);
                    make.height.mas_equalTo(height);
                }];
                
                break;
            }
            case 1: {
                self.responsePortL  = oneL;
                self.responsePortTF = oneTF;
                self.responsePortBT = oneBT;
                [oneL mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.left.mas_equalTo(10);
                    make.top.mas_equalTo(self.allPortL.mas_bottom).mas_offset(10);
                    make.width.mas_equalTo(100);
                    make.height.mas_equalTo(height);
                }];
                
                break;
            }
                
            default:
                break;
        }
        [oneTF mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(oneL.mas_right).mas_offset(10);
            make.top.mas_equalTo(oneL.mas_top);
            make.bottom.mas_equalTo(oneL.mas_bottom);
            make.width.mas_equalTo(80);
        }];
        [oneBT mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(oneTF.mas_right).mas_offset(20);
            make.top.mas_equalTo(oneTF.mas_top);
            make.bottom.mas_equalTo(oneTF.mas_bottom);
            make.width.mas_equalTo(60);
        }];
    }
    
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
        make.top.mas_equalTo(self.responsePortL.mas_bottom).mas_offset(40);
        make.right.mas_equalTo(-40);
        make.height.mas_equalTo(oneIV.mas_width);
    }];
 
    NSArray *colors = @[RGB16(0X68D3FF), RGB16(0X4585F5)];
    NSString *codeStr = webUrl;
    
    UIImage *img = [JPQRCodeTool generateCodeForString:codeStr withCorrectionLevel:kQRCodeCorrectionLevelHight SizeType:kQRCodeSizeTypeCustom customSizeDelta:20 drawType:kQRCodeDrawTypeSquare gradientType:kQRCodeGradientTypeHorizontal gradientColors:colors];
    
    oneIV.image = img;
}

- (void)updateBtAction:(UIButton *)bt {
    if (bt == self.allPortBT) {
        if (self.allPortTF.text.length > 0) {
            [self saveAllPort:self.allPortTF.text];
            AlertToastTitle(@"重新载入生效");
        }else{
            AlertToastTitle(@"端口号不能为空");
        }
    }else{
        if (self.responsePortTF.text.length > 0) {
            [self saveResponsePort:self.responsePortTF.text];
            AlertToastTitle(@"重新载入生效");
        }else{
            AlertToastTitle(@"端口号不能为空");
        }
    }
}

#pragma mark - plist
- (void)saveAllPort:(NSString *)allPort {
    [[NSUserDefaults standardUserDefaults] setObject:allPort forKey:@"PoporNetRecord_allPort"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (NSString *)getAllPort {
    NSString * info = [[NSUserDefaults standardUserDefaults] objectForKey:@"PoporNetRecord_allPort"];
    return info;
}

- (void)saveResponsePort:(NSString *)responsePort {
    [[NSUserDefaults standardUserDefaults] setObject:responsePort forKey:@"PoporNetRecord_responsePort"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (NSString *)getResponsePort {
    NSString * info = [[NSUserDefaults standardUserDefaults] objectForKey:@"PoporNetRecord_responsePort"];
    return info;
}


@end
