//
//  PnrView.m
//  PoporNetRecord
//
//  Created by apple on 2018/5/16.
//  Copyright © 2018年 popor. All rights reserved.
//

#import "PnrView.h"
#import "PnrEntity.h"
#import "PnrWebServer.h"

#import "PnrListVCRouter.h"
#import <PoporUI/UIView+Extension.h>
#import <PoporFoundation/PrefixFun.h>
#import <PoporFoundation/NSDate+Tool.h>
#import <JSONSyntaxHighlight/JSONSyntaxHighlight.h>

#define LL_SCREEN_WIDTH  [[UIScreen mainScreen] bounds].size.width
#define LL_SCREEN_HEIGHT [[UIScreen mainScreen] bounds].size.height

@interface PnrView () <UIGestureRecognizerDelegate>

@end

@implementation PnrView

+ (instancetype)share {
    static dispatch_once_t once;
    static PnrView * instance;
    dispatch_once(&once, ^{
        instance = [self new];

        
    });
    return instance;
}

- (id)init {
    if (self = [super init]) {
        self.sBallHideWidth = 10;
        self.sBallWidth     = 80;
        self.config = [PnrConfig share];
        
        [self addViews];
        [self updateBallHidden];
    }
    return self;
}

- (void)updateBallHidden {
    if (self.config.isRecord) {
        [self addViews];
        if (self.config.isCustomBallBtVisible) {
            self.ballBT.hidden = YES;
        }else{
            self.ballBT.hidden = NO;
        }
    }else{
        // 默认设置的是隐藏,假如设置的时候,不允许recorde,那么设置为隐藏
        self.ballBT.hidden = YES;
    }
}

- (void)addViews {
    if (self.window) {
        return;
    }
    self.window = [[UIApplication sharedApplication] keyWindow];
    self.ballBT = ({
        UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame =  CGRectMake(0, 0, self.sBallWidth, self.sBallWidth);
        [button setTitle:@"网络请求" forState:UIControlStateNormal];
        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [button setBackgroundColor:[UIColor brownColor]];
        button.titleLabel.font = [UIFont systemFontOfSize:15];
        
        button.layer.cornerRadius = button.frame.size.width/2;
        button.layer.borderColor = [UIColor lightGrayColor].CGColor;
        button.layer.borderWidth = 1;
        button.clipsToBounds = YES;
        
        [self.window addSubview:button];
        
        [button addTarget:self action:@selector(showPnrListVCNC) forControlEvents:UIControlEventTouchUpInside];
        
        button;
    });
    NSString * pointString = [self getBallPoint];
    if (pointString) {
        self.ballBT.center = CGPointFromString(pointString);
    }else{
        self.ballBT.center = CGPointMake(self.ballBT.width/2- self.sBallHideWidth, 180);
    }
    if (self.config.isCustomBallBtVisible) {
        self.ballBT.hidden = YES;
    }else{
        self.ballBT.alpha = self.config.normalAlpha;
    }
    
    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(panGR:)];
    [self.ballBT addGestureRecognizer:pan];
}

- (void)showPnrListVCNC {
    if (!self.config.isCustomBallBtVisible) {
        self.ballBT.hidden = YES;
    }
    UINavigationController * oneNC = [[UINavigationController alloc] initWithRootViewController:[self getPnrListVC]];
    oneNC.navigationBar.translucent = NO;
    
    if (self.config.presentNCBlock) {
        self.config.presentNCBlock(oneNC);
    }
    if (self.window.rootViewController.presentationController && self.window.rootViewController.presentedViewController) {
        [self.window.rootViewController.presentedViewController presentViewController:oneNC animated:YES completion:nil];
    }else{
        [self.window.rootViewController presentViewController:oneNC animated:YES completion:nil];
    }
    oneNC.interactivePopGestureRecognizer.delegate = self;
    
    // 打开block事件
    if (self.openBlock) {
        self.openBlock();
    }
    self.nc = oneNC;
}

- (UIViewController *)getPnrListVC {
    __weak typeof(self) weakSelf = self;
    
    BlockPVoid closeBlock = ^() {
        if (weakSelf.config.isRecord) {
            if (!weakSelf.config.isCustomBallBtVisible) {
                weakSelf.ballBT.hidden = NO;
            }
        }
        if (weakSelf.closeBlock) {
            weakSelf.closeBlock();
        }
    };
    UIViewController * vc = [PnrListVCRouter vcWithDic:@{@"title":self.config.vcRootTitle, @"weakInfoArray":self.infoArray, @"closeBlock":closeBlock}];
    
    return vc;
}

#pragma mark - Action
// 侧滑返回判断
- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer {
    if (gestureRecognizer == self.nc.interactivePopGestureRecognizer) {
        if (self.nc.viewControllers.count == 1) {
            [self.nc dismissViewControllerAnimated:YES completion:nil];
            return NO;
        }else{
            return YES;
        }
    }else{
        return YES;
    }
}

// 球移动轨迹
- (void)panGR:(UIPanGestureRecognizer *)gr {
    CGPoint panPoint = [gr locationInView:[[UIApplication sharedApplication] keyWindow]];
    //NSLog(@"panPoint: %f-%f", panPoint.x, panPoint.y);
    if (gr.state == UIGestureRecognizerStateBegan) {
        [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(resignActive) object:nil];
        [self becomeActive];
    } else if (gr.state == UIGestureRecognizerStateChanged) {
        [self changeSBallViewFrameWithPoint:panPoint];
    } else if (gr.state == UIGestureRecognizerStateEnded || gr.state == UIGestureRecognizerStateCancelled || gr.state == UIGestureRecognizerStateFailed) {
        [self resignActive];
    }
}

- (void)becomeActive {
    self.ballBT.alpha = self.config.activeAlpha;
}

- (void)resignActive {
    [UIView animateWithDuration:0.5 delay:0 usingSpringWithDamping:0.5 initialSpringVelocity:2.0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        self.ballBT.alpha = self.config.normalAlpha;
        // Calculate End Point
        CGFloat x = self.ballBT.center.x;
        CGFloat y = self.ballBT.center.y;
        CGFloat x1 = LL_SCREEN_WIDTH / 2.0;
        CGFloat y1 = LL_SCREEN_HEIGHT / 2.0;
        
        CGFloat distanceX = x1 > x ? x : LL_SCREEN_WIDTH - x;
        CGFloat distanceY = y1 > y ? y : LL_SCREEN_HEIGHT - y;
        CGPoint endPoint = CGPointZero;
        
        if (distanceX <= distanceY) {
            // animation to left or right
            endPoint.y = y;
            if (x1 < x) {
                // to right
                endPoint.x = LL_SCREEN_WIDTH - self.ballBT.frame.size.width / 2.0 + self.sBallHideWidth;
            } else {
                // to left
                endPoint.x = self.ballBT.frame.size.width / 2.0 - self.sBallHideWidth;
            }
        } else {
            // animation to top or bottom
            endPoint.x = x;
            if (y1 < y) {
                // to bottom
                endPoint.y = LL_SCREEN_HEIGHT - self.ballBT.frame.size.height / 2.0 + self.sBallHideWidth;
            } else {
                // to top
                endPoint.y = self.ballBT.frame.size.height / 2.0 - self.sBallHideWidth;
            }
        }
        self.ballBT.center = endPoint;
        
        [self saveBallPoint:NSStringFromCGPoint(endPoint)];
    } completion:nil];
}

- (void)changeSBallViewFrameWithPoint:(CGPoint)point {
    self.ballBT.center = CGPointMake(point.x, point.y);
}

#pragma mark - 记录按钮位置
- (void)saveBallPoint:(NSString *)BallPoint {
    [[NSUserDefaults standardUserDefaults] setObject:BallPoint forKey:@"BallPoint"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (NSString *)getBallPoint {
    NSString * info = [[NSUserDefaults standardUserDefaults] objectForKey:@"BallPoint"];
    return info;
}

// 把ballBT提到最高层.
+ (void)bringFrontBallBT {
    PnrView * pnrView = [PnrView share];
    [pnrView.window bringSubviewToFront:pnrView.ballBT];
}

@end
