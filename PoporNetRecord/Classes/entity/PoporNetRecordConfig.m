//
//  PoporNetRecordConfig.m
//  JSONSyntaxHighlight
//
//  Created by apple on 2018/11/2.
//

#import "PoporNetRecordConfig.h"
#import <JSONSyntaxHighlight/JSONSyntaxHighlight.h>

@implementation PoporNetRecordConfig

+ (instancetype)share {
    static dispatch_once_t once;
    static PoporNetRecordConfig * instance;
    dispatch_once(&once, ^{
        instance = [self new];
        
        instance.activeAlpha         = 1.0;
        instance.normalAlpha         = 0.6;
        instance.recordMaxNum        = 100;
        
        instance.recordType          = PoporNetRecordAuto;
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
        if (self.recordTypeBlock) {
            self.recordTypeBlock(recordType);
        }
    }
}

- (void)updateListCellHeight {
    self.listCellHeight = PnrListCellGap*3 + 6 + MAX(self.listFontTitle.pointSize, self.listFontRequest.pointSize) + self.listFontDomain.pointSize;
}

@end
