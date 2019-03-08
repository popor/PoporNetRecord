//
//  PnrConfig.m
//  PoporNetRecord
//
//  Created by apple on 2018/11/2.
//

#import "PnrConfig.h"

#import "PnrServerTool.h"

@interface PnrConfig ()
// 是否开启监测
@property (nonatomic) BOOL record;
@property (nonatomic) BOOL showListWeb;

@end

@implementation PnrConfig

+ (instancetype)share {
    static dispatch_once_t once;
    static PnrConfig * instance;
    dispatch_once(&once, ^{
        instance = [self new];
        
        // 基础设置
        instance.activeAlpha         = 1.0;
        instance.normalAlpha         = 0.6;
        //instance.recordMaxNum        = 100;

        // list网页设置
        instance.listSwitchIphone    = YES;
        instance.listSwitchSimulator = YES;

        instance.recordType          = PoporNetRecordAuto;
        instance.listWebType         = PoporNetRecordAuto;
        UIFont * font                = [UIFont systemFontOfSize:15];
        //NSMutableParagraphStyle *paraStyle = [[NSMutableParagraphStyle alloc] init];
        //paraStyle.lineSpacing = 1;

        instance.cellTitleFont       = font;
        // instance.titleAttributes     = @{NSForegroundColorAttributeName:[JSONSyntaxHighlight colorWithRGB:0x000000], NSFontAttributeName:font, NSParagraphStyleAttributeName:paraStyle};
        // instance.keyAttributes       = @{NSForegroundColorAttributeName:[JSONSyntaxHighlight colorWithRGB:0xE46F5C], NSFontAttributeName:font, NSParagraphStyleAttributeName:paraStyle};
        // instance.stringAttributes    = @{NSForegroundColorAttributeName:[JSONSyntaxHighlight colorWithRGB:0x4BB748], NSFontAttributeName:font, NSParagraphStyleAttributeName:paraStyle};
        // instance.nonStringAttributes = @{NSForegroundColorAttributeName:[JSONSyntaxHighlight colorWithRGB:0x4BB748], NSFontAttributeName:font, NSParagraphStyleAttributeName:paraStyle};
        
        // ---
        instance.titleAttributes     = @{NSForegroundColorAttributeName:[UIColor blackColor], NSFontAttributeName:font};
        instance.keyAttributes       = @{NSForegroundColorAttributeName:PnrColorGreen, NSFontAttributeName:font};
        instance.stringAttributes    = @{NSForegroundColorAttributeName:PnrColorRed, NSFontAttributeName:font};
        instance.nonStringAttributes = @{NSForegroundColorAttributeName:PnrColorRed, NSFontAttributeName:font};
        
        {
            // instance.listCellHeight = 55;

            instance.listFontTitle    = [UIFont systemFontOfSize:16];
            instance.listFontRequest  = [UIFont systemFontOfSize:14];
            instance.listFontDomain   = [UIFont systemFontOfSize:15];
            instance.listFontTime     = [UIFont systemFontOfSize:15];

            instance.listColorTitle   = PnrColorGreen;
            instance.listColorRequest = PnrColorRed;
            instance.listColorDomain  = ColorBlack3;
            instance.listColorTime    = ColorBlack6;

            instance.listColorCell0   = [UIColor whiteColor];
            instance.listColorCell1   = [UIColor colorWithRed:0.95 green:0.95 blue:0.95 alpha:1];
            
            [instance updateListCellHeight];
        }
    });
    return instance;
}

// 开关
- (void)setRecordType:(PoporNetRecordType)recordType {
    if (_recordType == 0 || _recordType != recordType) {
        _recordType = recordType;
        
        switch (recordType) {
            case PoporNetRecordAuto:
#if TARGET_IPHONE_SIMULATOR
                _record = YES;
#else
                if (IsDebugVersion) {
                    _record = YES;
                }else{
                    _record = NO;
                }
#endif
                break;
            case PoporNetRecordEnable:
                _record = YES;
                break;
                
            case PoporNetRecordDisable:
                _record = NO;
                break;
                
            default:
                break;
        }
        
    }
}

- (void)setListWebType:(PoporNetRecordType)listWebType {
    if (_listWebType == 0 || _listWebType != listWebType) {
        _listWebType = listWebType;
        
        switch (listWebType) {
            case PoporNetRecordAuto:
#if TARGET_IPHONE_SIMULATOR
                _showListWeb = YES;
#else
                if (IsDebugVersion) {
                    _showListWeb = YES;
                }else{
                    _showListWeb = NO;
                    [self stopListWebEvent];
                }
#endif
                break;
            case PoporNetRecordEnable:
                _showListWeb = YES;
                break;
                
            case PoporNetRecordDisable:
                _showListWeb = NO;
                [self stopListWebEvent];
                break;
                
            default:
                break;
        }
        
    }
}

- (void)stopListWebEvent {
    PnrServerTool * serverTool = [PnrServerTool share];
    [serverTool stopServer];
}

- (BOOL)isRecord {
    return _record;
}

- (BOOL)isShowListWeb {
    return _showListWeb;
}

- (void)updateListCellHeight {
    self.listCellHeight = PnrListCellGap*3 + 6 + MAX(self.listFontTitle.pointSize, self.listFontRequest.pointSize) + self.listFontDomain.pointSize;
}

- (void)setListColorTitle:(UIColor *)listColorTitle {
    _listColorTitle = listColorTitle;
    _listColorTitleHex = [self hexStringColorNoAlpha:listColorTitle];
}

- (void)setListColorRequest:(UIColor *)listColorRequest {
    _listColorRequest = listColorRequest;
    _listColorRequestHex = [self hexStringColorNoAlpha:listColorRequest];
}

- (void)setListColorDomain:(UIColor *)listColorDomain {
    _listColorDomain = listColorDomain;
    _listColorDomainHex = [self hexStringColorNoAlpha:listColorDomain];
}

- (void)setListColorTime:(UIColor *)listColorTime {
    _listColorTime = listColorTime;
    _listColorTimeHex = [self hexStringColorNoAlpha:listColorTime];
}

- (NSString *)hexStringColorNoAlpha: (UIColor*) color {
    //颜色值个数，rgb和alpha
    NSInteger cpts = CGColorGetNumberOfComponents(color.CGColor);
    const CGFloat *components = CGColorGetComponents(color.CGColor);
    CGFloat r = components[0];//红色
    CGFloat g = components[1];//绿色
    CGFloat b = components[2];//蓝色
    
    return [NSString stringWithFormat:@"#%02lX%02lX%02lX", lroundf(r * 255), lroundf(g * 255), lroundf(b * 255)];
}

- (NSString *)hexStringColor: (UIColor*) color {
    //颜色值个数，rgb和alpha
    NSInteger cpts = CGColorGetNumberOfComponents(color.CGColor);
    const CGFloat *components = CGColorGetComponents(color.CGColor);
    CGFloat r = components[0];//红色
    CGFloat g = components[1];//绿色
    CGFloat b = components[2];//蓝色
    if (cpts == 4) {
        CGFloat a = components[3];//透明度
        return [NSString stringWithFormat:@"#%02lX%02lX%02lX%02lX", lroundf(a * 255), lroundf(r * 255), lroundf(g * 255), lroundf(b * 255)];
    } else {
        return [NSString stringWithFormat:@"#%02lX%02lX%02lX", lroundf(r * 255), lroundf(g * 255), lroundf(b * 255)];
    }
}

@end
