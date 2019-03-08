
//
//  PnrVCEntity.m
//  PoporNetRecord
//
//  Created by apple on 2018/5/16.
//  Copyright © 2018年 popor. All rights reserved.
//

#import "PnrVCEntity.h"
#import "PnrConfig.h"
#import "PnrPortEntity.h"
#import <JSONSyntaxHighlight/JSONSyntaxHighlight.h>
#import <PoporFoundation/NSString+format.h>

@implementation PnrVCEntity

- (void)createListWebH5:(NSInteger)index {
    PnrConfig * config = [PnrConfig share];
    
    NSString * bgColor = index%2==0 ? config.listColorCell0Hex:config.listColorCell1Hex;
    NSMutableString * h5 = [NSMutableString new];
    
    [h5 appendFormat:@"<div style=\" background:%@; \" onclick= \"javascript:location.href='/%i/%@'\" >", bgColor, (int)index, PnrPathRoot];
    
    if (self.title) {
        [h5 appendFormat:@"<font color='%@'>%@ </font>", config.listColorTitleHex, self.title];
    }
    [h5 appendFormat:@"<font color='%@'>%@ </font>", config.listColorRequestHex, [self.request substringToIndex:MIN(self.request.length, 80)]];
    [h5 appendString:@"<br/>"];
    
    [h5 appendFormat:@"<font color='%@'>%@ </font>", config.listColorDomainHex, self.domain];
    
    [h5 appendString:@"</div>"];
    
    self.listWebH5 = [h5 copy];
}

- (NSArray *)titleArray {
    PnrVCEntity * entity = self;
    NSString * title;
    if (entity.title) {
        title = [NSString stringWithFormat:@" %@\n%@", entity.title, entity.request];
    }else{
        title = [NSString stringWithFormat:@" \n%@",entity.request];
    }
    NSArray * titleArray = @[[NSString stringWithFormat:@"接口:%@", title],
                             [NSString stringWithFormat:@"链接:\n%@", entity.url],
                             [NSString stringWithFormat:@"时间:\n%@", entity.time],
                             [NSString stringWithFormat:@"方法:\n%@", entity.method],
                             
                             @"head参数:\n",
                             @"请求参数:\n",
                             @"返回数据:\n",
                             ];
    return titleArray;
}

- (NSArray *)jsonArray {
    PnrVCEntity * entity = self;
    NSArray * jsonArray = @[[NSNull null],
                            [NSNull null],
                            [NSNull null],
                            [NSNull null],
                            
                            entity.headValue ?:[NSNull null],
                            entity.requesValue ?:[NSNull null],
                            entity.responseValue ?:[NSNull null],
                            ];
    
    return jsonArray;
}

- (void)getJsonArrayBlock:(PnrVCEntityBlock)finish {
    if (!finish) {
        return;
    }
    PnrConfig * config   = [PnrConfig share];
    NSArray * titleArray = [self titleArray];
    NSArray * jsonArray  = [self jsonArray];
    
    NSMutableArray * cellAttArray = [NSMutableArray new];
    for (int i = 0; i<jsonArray.count; i++) {
        NSDictionary * json = jsonArray[i];
        
        NSMutableAttributedString * cellAtt = [[NSMutableAttributedString alloc] initWithString:titleArray[i] attributes:config.titleAttributes];
        
        if (json) {
            if ([json isKindOfClass:[NSDictionary class]]) {
                JSONSyntaxHighlight *jsh = [[JSONSyntaxHighlight alloc] initWithJSON:json];
                jsh.keyAttributes       = config.keyAttributes;
                jsh.stringAttributes    = config.stringAttributes;
                jsh.nonStringAttributes = config.nonStringAttributes;
                NSAttributedString * jsonAtt = [jsh highlightJSON];
                [cellAtt appendAttributedString:jsonAtt];
            }else if ([json isKindOfClass:[NSString class]]) {
                [cellAtt addString:(NSString *)json font:nil color:[UIColor darkGrayColor]];
            }
        }
        
        [cellAttArray addObject:cellAtt];
    }
    
    finish(titleArray, jsonArray, cellAttArray);
}

@end
