//
//  PoporNetRecordViewController.m
//  PoporNetRecord
//
//  Created by wangkq on 07/06/2018.
//  Copyright (c) 2018 wangkq. All rights reserved.
//

#import "PoporNetRecordViewController.h"

#import <PoporNetRecord/PoporNetRecord.h>

#import <CoreGraphics/CoreGraphics.h>
#import <JSONSyntaxHighlight/JSONSyntaxHighlight.h>
#import <PoporFoundation/PrefixColor.h>

#import <PoporUI/UINavigationController+Size.h>

@implementation PoporNetRecordViewController

- (void)viewDidLoad{
    [super viewDidLoad];
    
    self.title = @"PoporNetRecord";
    {
        UIBarButtonItem *item = [[UIBarButtonItem alloc] init];
        item.title = @"返回";
        self.navigationItem.backBarButtonItem = item;
    }
    
    [self addTypeBT];
    [self setNcStyle];
    
    PoporNetRecordConfig * config = [PoporNetRecordConfig share];
    
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
        [nc.navigationBar setBackgroundImage:[weakSelf gradientImageWithBounds:CGRectMake(0, 0, self.view.frame.size.width, 1) andColors:@[RGB16(0X68D3FF), RGB16(0X4585F5)] gradientHorizon:YES] forBarMetrics:UIBarMetricsDefault];
        
        // 设置返回按钮字体颜色.
        //[[UINavigationBar appearance] setTintColor:[UIColor whiteColor]];
        nc.navigationBar.tintColor = [UIColor whiteColor];
        
    };
    
    NSDictionary * responseDic = @{@"success":@"true", @"child":@{@"name":@"abc", @"age":@(100)}, @"food":@[@"apple", @"orange"], @"device":@[@{@"bicyle":@{@"type":@"2轮子"}}, @{@"car":@{@"type":@"4轮子"}}]};
    
    //NSDictionary * responseDic = @{@"success":@"true", @"child":@{@"name":@"abc", @"age":@(100)}, @"food":@[@"apple", @"orange"], @"device":@[@"bicyle", @"car",]};
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [PoporNetRecord addUrl:@"http://www.baidu.com/testJson1" title:@"测试数据" method:@"POST" head:@{@"os":@"iOS"} request:@{@"name":@"popor"} response:responseDic];
    });
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.7 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [PoporNetRecord addUrl:@"http://www.baidu.com/testJson2" method:@"POST" head:@{@"os":@"iOS"} request:@{@"name":@"popor"} response:responseDic];
    });
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.9 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [PoporNetRecord addUrl:@"http://www.baidu.com/testJson3" method:@"POST" head:@{@"os":@"iOS"} request:@{@"name":@"popor"} response:responseDic];
    });
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [PoporNetRecord addUrl:@"http://www.baidu.com/testJson4" method:@"GET" head:@{@"os":@"iOS"} request:nil response:responseDic];
    });
 
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.4 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [PoporNetRecord addUrl:@"http://www.baidu.com/TestText12345678901234567890" title:@"测试数据" method:@"GET" head:@{@"os":@"iOS"} request:nil response:@"responseText"];
    });
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.6 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [PoporNetRecord addUrl:@"http://www.baidu.com/TestText2232423234?a=32&b=1234567890" title:@"测试数据" method:@"GET" head:@"head" request:@"request" response:@"responseText"];
    });
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
    [nc.navigationBar setBackgroundImage:[self gradientImageWithBounds:CGRectMake(0, 0, self.view.frame.size.width, 1) andColors:@[RGB16(0X68D3FF), RGB16(0X4585F5)] gradientHorizon:YES] forBarMetrics:UIBarMetricsDefault];
    
    // 设置返回按钮字体颜色.
    //[[UINavigationBar appearance] setTintColor:[UIColor whiteColor]];
    nc.navigationBar.tintColor = [UIColor whiteColor];
}

#pragma mark - 设置记录类型
- (void)addTypeBT {
    UIBarButtonItem *item1 = [[UIBarButtonItem alloc] initWithTitle:@"类型" style:UIBarButtonItemStylePlain target:self action:@selector(changeRecordTypeAction)];
    self.navigationItem.leftBarButtonItems = @[item1];
}

- (void)pushNetRecordListVC {
    
    PoporNetRecord * pnr = [PoporNetRecord share];
    UIViewController * vc = [pnr getPnrListVC];
    
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)changeRecordTypeAction {
    __weak typeof(self) weakSelf = self;
    {
        UIAlertController * oneAC = [UIAlertController alertControllerWithTitle:@"提醒" message:@"更改记录类型" preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction * cancleAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
        
        UIAlertAction * autoAction = [UIAlertAction actionWithTitle:@"自动" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
            PoporNetRecord * pnr = [PoporNetRecord share];
            pnr.customBallBtVisible = NO;
            pnr.ballBT.hidden = NO;
            
            weakSelf.navigationItem.rightBarButtonItems = nil;
        }];
        UIAlertAction * customAction = [UIAlertAction actionWithTitle:@"自定义" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
            PoporNetRecord * pnr = [PoporNetRecord share];
            pnr.customBallBtVisible = YES;
            pnr.ballBT.hidden = YES;
            
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
