//
//  NetMonitorTool.m
//  linRunShengPi
//
//  Created by apple on 2018/5/16.
//  Copyright © 2018年 popor. All rights reserved.
//

#import "PoporNetRecord.h"
#import "PnrVCEntity.h"

#import "PnrListVCRouter.h"
#import <PoporUI/UIView+Extension.h>
#import <PoporFoundation/FunctionPrefix.h>
#import <PoporFoundation/NSDate+Tool.h>


#define LL_SCREEN_WIDTH  [[UIScreen mainScreen] bounds].size.width
#define LL_SCREEN_HEIGHT [[UIScreen mainScreen] bounds].size.height

@interface PoporNetRecord ()

@property (nonatomic, weak  ) UIWindow * window;
@property (nonatomic, strong) NSMutableArray<PnrVCEntity *> * infoArray;
@property (nonatomic, strong) UIButton * ballBT;
@property (nonatomic        ) CGFloat sBallHideWidth;
@property (nonatomic        ) CGFloat sBallWidth;

@end

@implementation PoporNetRecord

+ (instancetype)share {
    static dispatch_once_t once;
    static PoporNetRecord * instance;
    dispatch_once(&once, ^{
        instance = [self new];
        instance.sBallHideWidth = 10;
        instance.sBallWidth     = 80;
        instance.activeAlpha    = 1.0;
        instance.normalAlpha    = 0.6;
        instance.recordMaxNum   = 100;
        
        if (IsDebugVersion) {
            instance.infoArray = [NSMutableArray new];
            dispatch_async(dispatch_get_main_queue(), ^{
                [instance addViews];
            });
            
        }
    });
    return instance;
}

+ (void)addUrl:(NSString *)urlString method:(NSString *)method head:(NSDictionary *)headDic request:(NSDictionary *)requestDic response:(NSDictionary *)responseDic {
    if (IsDebugVersion) {
        PnrVCEntity * entity = [PnrVCEntity new];
        entity.url = urlString;
        if (urlString.length>0) {
            NSURL * url = [NSURL URLWithString:urlString];
            entity.domain = [NSString stringWithFormat:@"%@://%@", url.scheme, url.host];
            if (entity.domain.length < urlString.length) {
                entity.request = [urlString substringFromIndex:entity.domain.length];
            }
        }
        
        entity.method      = method;
        entity.headDic     = headDic;
        entity.requestDic  = requestDic;
        entity.responseDic = responseDic;
        entity.time = [NSDate stringFromDate:[NSDate date] formatter:@"HH:mm:ss"];
        if ([PoporNetRecord share].infoArray.count >= [PoporNetRecord share].recordMaxNum) {
            [[PoporNetRecord share].infoArray removeLastObject];
        }
        [[PoporNetRecord share].infoArray insertObject:entity atIndex:0];
        
        if ([PoporNetRecord share].freshBlock) {
            [PoporNetRecord share].freshBlock();
        }
    }
}

- (void)addViews {
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
        
        [button addTarget:self action:@selector(showPnrListVC) forControlEvents:UIControlEventTouchUpInside];
        
        button;
    });
    NSString * pointString = [self getBallPoint];
    if (pointString) {
        self.ballBT.center = CGPointFromString(pointString);
    }else{
        self.ballBT.center = CGPointMake(self.ballBT.width/2- self.sBallHideWidth, 180);
    }
    self.ballBT.alpha = self.normalAlpha;
    
    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(panGR:)];
    [self.ballBT addGestureRecognizer:pan];
}

- (void)showPnrListVC {
    self.ballBT.hidden = YES;
    __weak typeof(self) weakSelf = self;
    BlockPVoid closeBlock = ^() {
        weakSelf.ballBT.hidden = NO;
    };
    UIViewController * vc = [PnrListVCRouter vcWithDic:@{@"title":@"网络请求", @"weakInfoArray":self.infoArray, @"closeBlock":closeBlock}];
    if (self.window.rootViewController.presentedViewController) {
        UINavigationController * nc = (UINavigationController *)self.window.rootViewController.presentedViewController;
        
        [nc pushViewController:vc animated:YES];
    }else{
        UINavigationController * nc = [[UINavigationController alloc] initWithRootViewController:vc];
        //        {
        //            [nc setVRSNCBarTitleColor];
        //            [nc setInteractivePopGRDelegate];
        //        }
        
        [self.window.rootViewController presentViewController:nc animated:YES completion:nil];
    }
}

#pragma mark - Action
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
    self.ballBT.alpha = self.activeAlpha;
}

- (void)resignActive {
    [UIView animateWithDuration:0.5 delay:0 usingSpringWithDamping:0.5 initialSpringVelocity:2.0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        self.ballBT.alpha = self.normalAlpha;
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
    self.ballBT.center = CGPointMake(point.x, point.y-self.ballBT.height/2);
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


@end
