//
//  PnrPortEntity.m
//  PoporNetRecord
//
//  Created by apple on 2018/12/18.
//

#import "PnrPortEntity.h"

static NSString * PoporNetRecord_port = @"PoporNetRecord_port";

@implementation PnrPortEntity

+ (instancetype)share {
    static dispatch_once_t once;
    static id instance;
    dispatch_once(&once, ^{
        instance = [self new];
        
    });
    return instance;
}

- (id)init {
    if (self = [super init]) {
        [self initPort];
    }
    return self;
}

- (void)initPort {
    NSString * portString = [PnrPortEntity getPort];
    if (portString && portString.length>0) {
        self.portInt = [portString intValue];
    }else{
        self.portInt = PoporNetRecordPort;
    }
}

#pragma mark - plist
+ (void)savePort:(NSString *)allPort {
    [[NSUserDefaults standardUserDefaults] setObject:allPort forKey:PoporNetRecord_port];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+ (NSString *)getPort {
    NSString * info = [[NSUserDefaults standardUserDefaults] objectForKey:PoporNetRecord_port];
    return info;
}

@end
