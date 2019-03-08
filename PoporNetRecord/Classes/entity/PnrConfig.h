//
//  PnrConfig.h
//  PoporNetRecord
//
//  Created by apple on 2018/11/2.
//

#import <Foundation/Foundation.h>
#import <PoporFoundation/PrefixBlock.h>
#import <PoporFoundation/PrefixColor.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(int, PoporNetRecordType) {
    PoporNetRecordAuto = 1, // 开发环境或者虚拟机环境
    PoporNetRecordEnable, // 全部监测
    PoporNetRecordDisable, // 全部忽略
};

typedef void(^PoporNetRecordNcBlock) (UINavigationController * nc);
typedef void(^PoporNetRecordRecordTypeBlock) (PoporNetRecordType type);

#define PnrColorGreen  RGB16(0x4BB748)
#define PnrColorRed    RGB16(0xF76738)
#define PnrListCellGap 7

@interface PnrConfig : NSObject

@property (nonatomic        ) CGFloat   activeAlpha;
@property (nonatomic        ) CGFloat   normalAlpha;
//@property (nonatomic        ) NSInteger recordMaxNum;

// 列表网页刷新设置
@property (nonatomic        ) BOOL      listSwitchIphone;    // 是否开启list网页:模拟器
@property (nonatomic        ) BOOL      listSwitchSimulator; // 是否开启list网页:手机

#pragma mark - 列表配置参数
// = (listFontTitle+3) + (listFontDomain+3) + PnrListCellGap*3,可以通过updateListCellHeight设置
@property (nonatomic        ) float   listCellHeight;

@property (nonatomic, strong) UIFont  * listFontTitle;// 标题
@property (nonatomic, strong) UIFont  * listFontRequest;// 请求
@property (nonatomic, strong) UIFont  * listFontDomain;// 域名
@property (nonatomic, strong) UIFont  * listFontTime;// 时间

@property (nonatomic, strong) UIColor * listColorTitle;// 标题
@property (nonatomic, strong) UIColor * listColorRequest;// 请求
@property (nonatomic, strong) UIColor * listColorDomain;// 域名
@property (nonatomic, strong) UIColor * listColorTime;// 时间


@property (nonatomic, strong) NSString * listColorTitleHex;// 标题
@property (nonatomic, strong) NSString * listColorRequestHex;// 请求
@property (nonatomic, strong) NSString * listColorDomainHex;// 域名
@property (nonatomic, strong) NSString * listColorTimeHex;// 时间


@property (nonatomic, strong) UIColor * listColorCell0;// 列表偶数行背景色
@property (nonatomic, strong) UIColor * listColorCell1;// 列表奇数行背景色

#pragma mark - 请求详情配置
// 详情假如 att font 不为15也需要设置.
@property (nonatomic, strong) UIFont       * cellTitleFont;
@property (nonatomic, strong) NSDictionary * titleAttributes;// title值颜色
@property (nonatomic, strong) NSDictionary * keyAttributes;// key值颜色
@property (nonatomic, strong) NSDictionary * stringAttributes;// value string颜色
@property (nonatomic, strong) NSDictionary * nonStringAttributes;// value int颜色


@property (nonatomic        ) PoporNetRecordType recordType;//监测类型
@property (nonatomic        ) PoporNetRecordType listWebType;//网页显示数据
    
// Block
@property (nonatomic, copy  ) BlockPVoid                    freshBlock;
@property (nonatomic, copy  ) PoporNetRecordRecordTypeBlock recordTypeBlock; // 网络监测类型block
@property (nonatomic, copy  ) PoporNetRecordRecordTypeBlock listWebTypeBlock; // 网页显示数据block

@property (nonatomic, copy  ) PoporNetRecordNcBlock         presentNCBlock;// 用户更新 presentViewController NC的状态

@property (nonatomic        ) BOOL jsonViewColorBlack;// json详情页面是否使用黑白.
    
+ (instancetype)share;

- (void)updateListCellHeight;

- (NSString *)listColorTitleHex;
- (NSString *)listColorRequestHex;
- (NSString *)listColorDomainHex;
- (NSString *)listColorTimeHex;

@end

NS_ASSUME_NONNULL_END
