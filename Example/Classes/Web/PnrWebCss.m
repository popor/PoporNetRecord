//
//  PnrWebCss.m
//  PoporNetRecord
//
//  Created by apple on 2019/3/15.
//  Copyright © 2019 wangkq. All rights reserved.
//

#import "PnrWebCss.h"

@implementation PnrWebCss

+ (NSString *)cssDivWordOneLine {
    return @"\n div.oneLine {\n\
    white-space:nowrap;\n\
    overflow:hidden;\n\
    text-overflow:ellipsis;\n\
    }";
}

+ (NSString *)cssTextarea {
    return @"\n textarea {\n\
    border: 1px solid #909090;\n\
    padding: 5px;\n\
    min-height: 20px;\n\
    width:100%;\n\
    font-size:16px;\n\
    }";
}

+ (NSString *)cssButton:(NSString *)btColor {
    return [NSString stringWithFormat:@"\n button.w180 {\n\
            color:%@; width:180px; font-size:16px;\
            }\n\
            \n button.w100p {\n\
            color:%@; width:100%%; font-size:16px;\
            }\n", btColor, btColor];
}

@end
