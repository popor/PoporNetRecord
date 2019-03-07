
//
//  PnrVCEntity.m
//  PoporNetRecord
//
//  Created by apple on 2018/5/16.
//  Copyright © 2018年 popor. All rights reserved.
//

#import "PnrVCEntity.h"

@implementation PnrVCEntity

- (void)createListWebH5 {
    NSMutableString * h5 = [NSMutableString new];
    [h5 appendString:@"<hr>"];
    [h5 appendString:@"<p>"];
    if (self.title) {
        [h5 appendFormat:@"%@ ", self.title];
    }
    [h5 appendFormat:@"%@ ", [self.request substringToIndex:MIN(self.request.length, 40)]];
    [h5 appendString:@"<br/>"];
    
    [h5 appendString:self.domain];
    
    [h5 appendString:@"</p>"];

    //[h5 appendFormat:@"<p> %@ </p>", self.domain];
    
    self.listWebH5 = [h5 copy];
}

@end
