//
//  PnrExtraEntity.m
//  PoporNetRecord_Example
//
//  Created by apple on 2019/11/16.
//  Copyright © 2019 wangkq. All rights reserved.
//

#import "PnrExtraEntity.h"

static NSString * PnrExtraUrlPortEntityKey  = @"PnrExtraUrlPortEntityKey";
static NSString * PnrExtraUrlPortSelectKey  = @"PnrExtraUrlPortSelectKey";
static NSString * PnrExtraUrlPortForwardKey = @"PnrExtraUrlPortForwardKey";

@implementation PnrExtraUrlPortEntity

@end

@interface PnrExtraEntity ()

@end

@implementation PnrExtraEntity

+ (instancetype)shareConfig:(PnrExtraEntityBlock)block {
    PnrExtraEntity * ee = [PnrExtraEntity share];
    if (!ee.urlPortArray) {
        if (block) {
            block(ee);
        }
        [ee initData];
    }
    
    return ee;
}

+ (instancetype)share {
    static dispatch_once_t once;
    static PnrExtraEntity * instance;
    dispatch_once(&once, ^{
        instance = [PnrExtraEntity new];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [instance initData];
        });
    });
    return instance;
}

- (void)initData {
    if (!self.urlPortArray) {
        self.urlPortArray = [NSMutableArray<PnrExtraUrlPortEntity *> new];
        [self updateArray];
        self.selectNum = [self getSelectNum];
        self.forward   = [self get__forward];
        [self updateSelectUrlPort];
    }
}

- (void)saveArray {
    NSMutableString * json = [NSMutableString new];
    [json appendString:@"["];
    for (PnrExtraUrlPortEntity * e in self.urlPortArray) {
        [json appendFormat:@"{\"title\":\"%@\",\"url\":\"%@\",\"port\":\"%@\",\"api\":\"%@\"},", e.title, e.url, e.port, e.api];
    }
    [json deleteCharactersInRange:(NSRange){json.length-1, 1}];
    [json appendString:@"]"];
    
    [[NSUserDefaults standardUserDefaults] setObject:json forKey:PnrExtraUrlPortEntityKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (void)updateArray {
    [self.urlPortArray removeAllObjects];
    NSString * json = [[NSUserDefaults standardUserDefaults] objectForKey:PnrExtraUrlPortEntityKey];
    if (json) {
        NSArray * array = [NSJSONSerialization JSONObjectWithData:[json dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingAllowFragments error:nil];
        
        for (NSDictionary * dic in array) {
            //NSLog(@"one d: %@", dic);
            PnrExtraUrlPortEntity * entity = [PnrExtraUrlPortEntity new];
            entity.title = dic[@"title"]; //@"本地";
            entity.url   = dic[@"url"];   //@"http://127.0.0.1";
            entity.port  = dic[@"port"];  //@"9000";
            entity.api   = dic[@"api"];;
            [self.urlPortArray addObject:entity];
        }
        
    } else {
        self.forward = self.defaultForward;
        [self saveForward];
        PnrExtraUrlPortEntity * entity = [PnrExtraUrlPortEntity new];
        
        entity.title = self.defaultTitle.length >0 ? self.defaultTitle : @"本地";
        entity.url   = self.defaultUrl.length   >0 ? self.defaultUrl   : @"http://127.0.0.1";
        entity.port  = self.defaultPort.length  >0 ? self.defaultPort  : @"9000";
        entity.api   = self.defaultApi.length   >0 ? self.defaultApi   : @"api";
        
        [self.urlPortArray addObject:entity];
        
        [self saveArray];
    }
}

- (void)saveSelectNum:(NSInteger)selectNum {
    self.selectNum = selectNum;
    [[NSUserDefaults standardUserDefaults] setObject:[NSString stringWithFormat:@"%li", selectNum] forKey:PnrExtraUrlPortSelectKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    [self updateSelectUrlPort];
}

- (NSInteger)getSelectNum {
    NSString * text = [[NSUserDefaults standardUserDefaults] objectForKey:PnrExtraUrlPortSelectKey];
    if (text) {
        return [text integerValue];
    } else {
        return 0;
    }
}

- (void)updateSelectUrlPort {
    PnrExtraUrlPortEntity * entity = self.urlPortArray[self.selectNum];
    self.selectUrlPort = [NSString stringWithFormat:@"%@:%@/%@", entity.url, entity.port, entity.api];
}

- (void)saveForward {
    
    [[NSUserDefaults standardUserDefaults] setObject:@(self.forward) forKey:PnrExtraUrlPortForwardKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (BOOL)get__forward {
    NSString * info = [[NSUserDefaults standardUserDefaults] objectForKey:PnrExtraUrlPortForwardKey];
    return [info boolValue];
}


@end
