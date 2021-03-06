//
//  UIDevice+pTool.h
//  PoporUI
//
//  Created by popor on 2018/6/19.
//  Copyright © 2018年 popor. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, NetStatusType)
{
    NetStatusType_nil,
    NetStatusType_2G,
    NetStatusType_3G,
    NetStatusType_4G,
    NetStatusType_Wifi,
};

@interface UIDevice (pTool)

#pragma mark [获取设备 Retina 信息]
+ (BOOL)isRetinaScreen;

#pragma mark - 检测推送开关是否打开
+ (BOOL)pushNotificationsEnabled;

//#pragma mark - 获得渐变颜色
//+ (UIImage*)imageFromColors:(NSArray*)colors frame:(CGRect)frame;

/**
 * 获取ios设备状态栏网络状态，检测2G、3G、4G、wifi都是正常的。
 */
+ (NSString *)getIOSStatusBarNetWorkTypeStr;
+ (NetStatusType)getIOSStatusBarNetWorkTypeInt;

+ (NSString *)getAppName;

#pragma mark - APP Plist 版本
/**
 *  对外版本号
 */
+ (NSString *)getAppVersion_short;

/**
 *  对内build号
 */
+ (NSString *)getAppVersion_build;

+ (NSString *)devicePlatform;
+ (BOOL)isIPhone6SOrNewer;
+ (BOOL)isIPhone5S;

+ (NSString *)getWifiName;

#pragma mark [获取设备版本号]
+ (NSString *)getDeviceNormalPlatform;

/**
 * 获取当前可用内存
 */
// root 用户可用磁盘空间
+ (long long)diskAvailableSize:(BOOL)root;

+ (long long)diskTotalSize;

#pragma mark 【获取人性化容量】
+ (NSString *)getHumanSize:(CGFloat)fileSizeFloat;
+ (void)fileSize:(NSInteger)fileSize complete:(void (^ __nullable)(CGFloat sizeFloat, NSString * sizeUnit))complete ;

@end
