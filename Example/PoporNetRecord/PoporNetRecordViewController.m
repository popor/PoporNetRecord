//
//  PoporNetRecordViewController.m
//  PoporNetRecord
//
//  Created by wangkq on 07/06/2018.
//  Copyright (c) 2018 wangkq. All rights reserved.
//

#import "PoporNetRecordViewController.h"

#import "PoporNetRecord.h"

#import <CoreGraphics/CoreGraphics.h>
#import <JSONSyntaxHighlight/JSONSyntaxHighlight.h>
#import <PoporFoundation/Color+pPrefix.h>

#import <PoporUI/UIImage+pCreate.h>
#import <PoporUI/IToastPTool.h>

#import <PoporFoundation/NSString+pTool.h>
#import <PoporFoundation/NSDictionary+pTool.h>
#import <PoporAFN/PoporAFN.h>

#import "PnrExtraEntity.h"

@interface PoporNetRecordViewController ()

@property (nonatomic        ) int netIndex;

@end

@implementation PoporNetRecordViewController

- (void)viewDidLoad{
    [super viewDidLoad];
    
    {
        [PnrExtraEntity share];
        
    }
    self.title = @"PoporNetRecord";
    {
        UIBarButtonItem *item = [[UIBarButtonItem alloc] init];
        item.title = @"返回";
        self.navigationItem.backBarButtonItem = item;
    }
    
    [self addTypeBT];
    [self setNcStyle];
    
    // pnr 设置
    [self addPnrSettings];
    
    int gap = 30;
    {
        UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame =  CGRectMake(0, 0, 140, 44);
        button.center = CGPointMake(self.view.frame.size.width/2, self.view.frame.size .height/2 - gap);
        [button setTitle:@"New Request" forState:UIControlStateNormal];
        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [button setBackgroundImage:[UIImage imageFromColor:[UIColor brownColor] size:CGSizeMake(1, 1)] forState:UIControlStateNormal];
        
        button.layer.cornerRadius = 5;
        button.clipsToBounds = YES;
        [self.view addSubview:button];
        
        [button addTarget:self action:@selector(addOneNetRequest) forControlEvents:UIControlEventTouchUpInside];
    }
    {
        UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame =  CGRectMake(0, 0, 140, 44);
        button.center = CGPointMake(self.view.frame.size.width/2, self.view.frame.size .height/2 + gap);
        [button setTitle:@"New Log" forState:UIControlStateNormal];
        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [button setBackgroundImage:[UIImage imageFromColor:[UIColor brownColor] size:CGSizeMake(1, 1)] forState:UIControlStateNormal];
        
        button.layer.cornerRadius = 5;
        button.clipsToBounds = YES;
        [self.view addSubview:button];
        
        [button addTarget:self action:@selector(addOneLog) forControlEvents:UIControlEventTouchUpInside];
    }
    [self addOneNetRequest];
    [self addOneLog];
}

- (void)addOneNetRequest {
    NSString * autoTitle = [NSString stringWithFormat:@"测试数据:%i", self.netIndex++ + 1];
    NSLog(@"auto title : %@ ", autoTitle);
    NSString * value = @"value";
    NSDictionary * pDic =
    @{@"array":@[@{@"a":@"a111111111111", @"b":@"b2222222222222"},
                 @{@"a":@"a111111111111", @"b":@"b2222222222222"},
                 @{@"a":@"a111111111111", @"b":@"b2222222222222"},
                 @{@"a":@"a111111111111", @"b":@"b2222222222222"},
                 @{@"a":@"a111111111111", @"b":@"b2222222222222"},
                 @{@"a":@"a111111111111", @"b":@"b2222222222222"},
                 @{@"a":@"a111111111111", @"b":@"b2222222222222"},
                 @{@"a":@"a111111111111", @"b":@"b2222222222222"}, ],
      @"b":@"b",
      @"f":@"f",
      @"c":@"c",
      @"a":@"a",
      @"x":@"x",
      };
    [PoporNetRecord addUrl:@"http://www.baidu.com/auto?a=a&b=b" title:autoTitle method:@"GET" head:@{@"os":@"iOS", @"key":value} parameter:pDic response:@"responseText"];
    AlertToastTitle(@"增加网路请求");
}

- (void)addOneLog {
    [PoporNetRecord addLog:@"new log, 1111111111, 2222222222, 3333333333, 4444444444, 5555555555." title:@"test"];
    AlertToastTitle(@"增加日志");
}

- (void)Demos {
    NSDictionary * responseDic = @{@"success":@"true", @"child":@{@"name":@"abc", @"age":@(100)}, @"food":@[@"apple", @"orange"], @"device":@[@{@"bicyle":@{@"type":@"2轮子"}}, @{@"car":@{@"type":@"4轮子"}}]};
    
    //NSDictionary * responseDic = @{@"success":@"true", @"child":@{@"name":@"abc", @"age":@(100)}, @"food":@[@"apple", @"orange"], @"device":@[@"bicyle", @"car",]};
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [PoporNetRecord addUrl:@"http://www.baidu.com/testJson1" title:@"测试数据" method:@"POST" head:@{@"os":@"iOS"} parameter:@{@"name":@"popor"} response:responseDic];
    });
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.7 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [PoporNetRecord addUrl:@"http://www.baidu.com/testJson2" method:@"POST" head:@{@"os":@"iOS"} parameter:@{@"name":@"popor"} response:responseDic];
    });
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.9 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [PoporNetRecord addUrl:@"http://www.baidu.com/testJson3" method:@"POST" head:@{@"os":@"iOS"} parameter:@{@"name":@"popor"} response:responseDic];
    });
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [PoporNetRecord addUrl:@"http://www.baidu.com/testJson4" method:@"GET" head:@{@"os":@"iOS"} parameter:nil response:responseDic];
    });
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.4 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [PoporNetRecord addUrl:@"http://www.baidu.com/TestText12345678901234567890" title:@"测试数据" method:@"GET" head:@{@"os":@"iOS"} parameter:nil response:@"responseText"];
    });
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.6 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [PoporNetRecord addUrl:@"http://www.baidu.com/TestText2232423234?a=32&b=1234567890" title:@"测试数据" method:@"GET" head:@"head" parameter:@"request" response:@"responseText"];
    });
    
    for (int i=0; i<8; i++) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)((2+ i*1) * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            NSString * autoTitle = [NSString stringWithFormat:@"测试数据:%i", i+1];
            NSLog(@"auto title : %@ ", autoTitle);
            [PoporNetRecord addUrl:@"http://www.baidu.com/auto_1234567890_1234567890_1234567890_1234567890_1234567890_1234567890_1234567890_1234567890" title:autoTitle method:@"GET" head:@{@"os":@"iOS"} parameter:@"request" response:@"responseText"];
        });
    }
    
}

#pragma mark - nc bar style
- (void)setNcStyle {
    UINavigationController * nc = self.navigationController;
    // 设置标题颜色
    NSMutableDictionary * dict = [[NSMutableDictionary alloc] init];
    [dict setObject:[UIColor whiteColor] forKey:NSForegroundColorAttributeName];
    [dict setObject:[UIFont systemFontOfSize:18] forKey:NSFontAttributeName];
    
    nc.navigationBar.titleTextAttributes = dict;
    
    // 设置bar背景颜色
    //[self.navigationBar setBarTintColor:RGB16(0X4077ED)];
    //[self.navigationBar setBarTintColor:ColorNCBar];
    //RGB16(0X68D3FF)
    [nc.navigationBar setBackgroundImage:[self gradientImageWithBounds:CGRectMake(0, 0, self.view.frame.size.width, 1) andColors:@[PRGB16(0X68D3FF), PRGB16(0X4585F5)] gradientHorizon:YES] forBarMetrics:UIBarMetricsDefault];
    
    // 设置返回按钮字体颜色.
    //[[UINavigationBar appearance] setTintColor:[UIColor whiteColor]];
    nc.navigationBar.tintColor = [UIColor whiteColor];
}

#pragma mark - 设置记录类型
- (void)addTypeBT {
    UIBarButtonItem *item1 = [[UIBarButtonItem alloc] initWithTitle:@"类型" style:UIBarButtonItemStylePlain target:self action:@selector(changeRecordTypeAction)];
    self.navigationItem.leftBarButtonItems = @[item1];
}

- (void)addPnrSettings {
    PnrConfig * config = [PnrConfig share];
    {
        config.webRootTitle = @"PnrTest";
        config.vcRootTitle  = @"PnrTest";
        
        NSString *path = [[NSBundle mainBundle] pathForResource:@"favicon" ofType:@"ico"];
        path = [[NSBundle mainBundle] pathForResource:@"favicon2" ofType:@"ico"];
        NSData *data   = [[NSData alloc] initWithContentsOfFile:path];
        config.webIconData = data;
    }
    {
        // 额外的回调
        [PoporNetRecord share].blockExtraRecord = ^(PnrEntity * entity){
            NSString * url1 = [NSString stringWithFormat:@"%@/add", [PnrExtraEntity share].selectUrlPort];
            
            [[PoporAFN new] title:@"" url:url1 method:PoporMethodPost parameters:entity.desDic afnManager:nil success:nil failure:nil];
        };
    }
    {
        //config.listFontTitle   = [UIFont systemFontOfSize:16];
        //config.listFontRequest = [UIFont systemFontOfSize:14];
        //[config updateListCellHeight];
    }
    {
        // config.recordType = PoporNetRecordDisable;
        // UIFont * font                = [UIFont systemFontOfSize:15];
        // // 假如att font 不为15,也需要设置,不然计算高度会出错.
        // config.cellTitleFont       = font;
        // config.titleAttributes     = @{NSForegroundColorAttributeName:[JSONSyntaxHighlight colorWithRGB:0x000000], NSFontAttributeName:font};
        // config.keyAttributes       = @{NSForegroundColorAttributeName:[JSONSyntaxHighlight colorWithRGB:0xE46F5C], NSFontAttributeName:font};
        // config.stringAttributes    = @{NSForegroundColorAttributeName:[JSONSyntaxHighlight colorWithRGB:0x4BB748], NSFontAttributeName:font};
        // config.nonStringAttributes = @{NSForegroundColorAttributeName:[JSONSyntaxHighlight colorWithRGB:0x4BB748], NSFontAttributeName:font};
    }
    __weak typeof(self) weakSelf = self;
    config.presentNCBlock = ^(UINavigationController *nc) {
        // 设置标题颜色
        NSMutableDictionary * dict = [[NSMutableDictionary alloc] init];
        [dict setObject:[UIColor whiteColor] forKey:NSForegroundColorAttributeName];
        [dict setObject:[UIFont systemFontOfSize:18] forKey:NSFontAttributeName];
        
        nc.navigationBar.titleTextAttributes = dict;
        
        // 设置bar背景颜色
        //[self.navigationBar setBarTintColor:RGB16(0X4077ED)];
        //[self.navigationBar setBarTintColor:ColorNCBar];
        //RGB16(0X68D3FF)
        [nc.navigationBar setBackgroundImage:[weakSelf gradientImageWithBounds:CGRectMake(0, 0, self.view.frame.size.width, 1) andColors:@[PRGB16(0X68D3FF), PRGB16(0X4585F5)] gradientHorizon:YES] forBarMetrics:UIBarMetricsDefault];
        
        // 设置返回按钮字体颜色.
        //[[UINavigationBar appearance] setTintColor:[UIColor whiteColor]];
        nc.navigationBar.tintColor = [UIColor whiteColor];
        
    };
    // 增加重新请求demo
    __block int record = 0;
    [PoporNetRecord setPnrBlockResubmit:^(NSDictionary *formDic, PnrBlockFeedback _Nonnull blockFeedback) {
        NSLog(@"resubmit request dic: %@", formDic);
        
        NSString * title        = formDic[@"title"];
        NSString * urlStr       = formDic[@"url"];
        NSString * methodStr    = formDic[@"method"];
        NSString * headStr      = formDic[@"head"];
        NSString * parameterStr = formDic[@"parameter"];
        //NSString * extraStr   = formDic[@"extra"];
        
        // 将新的网络请求 数据存储到PoporNetRecord
        NSDictionary * resultDic = @{@"key": [NSString stringWithFormat:@"%i: %@", record++, @"新的返回数据:"]};
        resultDic = @{@"array":@[
                               @{@"a":@"a111111111111", @"b":@"b2222222222222"},
                               @{@"a":@"a111111111111", @"b":@"b2222222222222"},
                               @{@"a":@"a111111111111", @"b":@"b2222222222222"},
                               @{@"a":@"a111111111111", @"b":@"b2222222222222"},
                               @{@"a":@"a111111111111", @"b":@"b2222222222222"},
                               @{@"a":@"a111111111111", @"b":@"b2222222222222"},
                               @{@"a":@"a111111111111", @"b":@"b2222222222222"},
                               ]};
        [PoporNetRecord addUrl:urlStr title:title method:methodStr head:headStr.toDic parameter:parameterStr.toDic response:resultDic];
        
        // 结果反馈给PoporNetRecord
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            blockFeedback(resultDic.toJsonString);
        });
    } extraDic:@{@"exKey":@"exValue"}]; 
}

- (void)pushNetRecordListVC {
    PnrView * pnrView = [PnrView share];
    UIViewController * vc = [pnrView getPnrListVC];
    
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)changeRecordTypeAction {
    __weak typeof(self) weakSelf = self;
    {
        UIAlertController * oneAC = [UIAlertController alertControllerWithTitle:@"提醒" message:@"更改记录类型" preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction * cancleAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
        
        UIAlertAction * autoAction = [UIAlertAction actionWithTitle:@"自动" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
            PoporNetRecord * pnr = [PoporNetRecord share];
            pnr.config.customBallBtVisible = NO;
            pnr.view.ballBT.hidden = NO;
            
            weakSelf.navigationItem.rightBarButtonItems = nil;
        }];
        UIAlertAction * customAction = [UIAlertAction actionWithTitle:@"自定义" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
            PoporNetRecord * pnr = [PoporNetRecord share];
            pnr.config.customBallBtVisible = YES;
            pnr.view.ballBT.hidden = YES;
            
            UIBarButtonItem *item1 = [[UIBarButtonItem alloc] initWithTitle:@"网络请求" style:UIBarButtonItemStylePlain target:self action:@selector(pushNetRecordListVC)];
            weakSelf.navigationItem.rightBarButtonItems = @[item1];
        }];
        
        [oneAC addAction:cancleAction];
        [oneAC addAction:autoAction];
        [oneAC addAction:customAction];
        
        [self presentViewController:oneAC animated:YES completion:nil];
    }
}

#pragma mark - 设置图片
- (UIImage*)gradientImageWithBounds:(CGRect)bounds andColors:(NSArray*)colors gradientHorizon:(BOOL)gradientHorizon {
    CGPoint start;
    CGPoint end;
    
    if (gradientHorizon) {
        start = CGPointMake(0.0, 0.0);
        end = CGPointMake(bounds.size.width, 0.0);
    }else{
        start = CGPointMake(0.0, 0.0);
        end = CGPointMake(0.0, bounds.size.height);
    }
    
    UIImage *image = [self gradientImageWithBounds:bounds andColors:colors addStartPoint:start addEndPoint:end];
    return image;
}

- (UIImage*)gradientImageWithBounds:(CGRect)bounds andColors:(NSArray*)colors addStartPoint:(CGPoint)startPoint addEndPoint:(CGPoint)endPoint {
    NSMutableArray *ar = [NSMutableArray array];
    
    for(UIColor *c in colors) {
        [ar addObject:(id)c.CGColor];
    }
    UIGraphicsBeginImageContextWithOptions(bounds.size, YES, 1);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSaveGState(context);
    CGColorSpaceRef colorSpace = CGColorGetColorSpace([[colors lastObject] CGColor]);
    CGGradientRef gradient = CGGradientCreateWithColors(colorSpace, (CFArrayRef)ar, NULL);
    
    CGContextDrawLinearGradient(context, gradient, startPoint, endPoint, kCGGradientDrawsBeforeStartLocation | kCGGradientDrawsAfterEndLocation);
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    CGGradientRelease(gradient);
    CGContextRestoreGState(context);
    CGColorSpaceRelease(colorSpace);
    UIGraphicsEndImageContext();
    return image;
}

@end
