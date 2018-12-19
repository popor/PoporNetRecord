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

CG_INLINE UIColor * RGB16(unsigned long rgbValue) {
    return [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0];
};

@interface PoporNetRecordViewController ()

@end

@implementation PoporNetRecordViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    PoporNetRecordConfig * config = [PoporNetRecordConfig share];
    
    //    config.recordType = PoporNetRecordDisable;
    //    UIFont * font                = [UIFont systemFontOfSize:15];
    //    // 假如att font 不为15,也需要设置,不然计算高度会出错.
    //    config.cellTitleFont       = font;
    //    config.titleAttributes     = @{NSForegroundColorAttributeName:[JSONSyntaxHighlight colorWithRGB:0x000000], NSFontAttributeName:font};
    //    config.keyAttributes       = @{NSForegroundColorAttributeName:[JSONSyntaxHighlight colorWithRGB:0xE46F5C], NSFontAttributeName:font};
    //    config.stringAttributes    = @{NSForegroundColorAttributeName:[JSONSyntaxHighlight colorWithRGB:0x4BB748], NSFontAttributeName:font};
    //    config.nonStringAttributes = @{NSForegroundColorAttributeName:[JSONSyntaxHighlight colorWithRGB:0x4BB748], NSFontAttributeName:font};
    
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
        [[UINavigationBar appearance] setTintColor:[UIColor whiteColor]];
    };
    
    NSDictionary * responseDic = @{@"success":@"true", @"child":@{@"name":@"abc", @"age":@(100)}, @"food":@[@"apple", @"orange"], @"device":@[@{@"bicyle":@{@"type":@"2轮子"}}, @{@"car":@{@"type":@"4轮子"}}]};
    
    //NSDictionary * responseDic = @{@"success":@"true", @"child":@{@"name":@"abc", @"age":@(100)}, @"food":@[@"apple", @"orange"], @"device":@[@"bicyle", @"car",]};
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [PoporNetRecord addUrl:@"http://www.baidu.com/test0.5" method:@"POST" head:@{@"os":@"iOS"} request:@{@"name":@"popor"} response:responseDic];
    });
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [PoporNetRecord addUrl:@"http://www.baidu.com/test1.5" method:@"POST" head:@{@"os":@"iOS"} request:@{@"name":@"popor"} response:responseDic];
    });
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [PoporNetRecord addUrl:@"http://www.baidu.com/test2.5" method:@"POST" head:@{@"os":@"iOS"} request:@{@"name":@"popor"} response:responseDic];
    });
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.6 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [PoporNetRecord addUrl:@"http://www.baidu.com/test2.6" method:@"GET" head:@{@"os":@"iOS"} request:nil response:responseDic];
    });
    
}


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
