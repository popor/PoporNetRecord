//
//  PnrWebPortEntity.m
//  GCDWebServer
//
//  Created by apple on 2018/12/18.
//

#import "PnrWebPortEntity.h"

#import <PoporUI/IToastKeyboard.h>

static NSString * PoporNetRecord_allPort      = @"PoporNetRecord_allPort";
static NSString * PoporNetRecord_headPort     = @"PoporNetRecord_headPort";
static NSString * PoporNetRecord_requestPort  = @"PoporNetRecord_requestPort";
static NSString * PoporNetRecord_responsePort = @"PoporNetRecord_responsePort";

static NSString * PoporNetRecord_JsonWindow   = @"PoporNetRecord_JsonWindow";


@implementation PnrWebPortEntity

- (id)init {
    if (self = [super init]) {
        [self initPort];
    }
    return self;
}
- (void)initPort {
    NSString * allPortString      = [PnrWebPortEntity getAllPort];
    NSString * headString         = [PnrWebPortEntity getHeadPort];
    NSString * requestString      = [PnrWebPortEntity getRequestPort];
    NSString * responsePortString = [PnrWebPortEntity getResponsePort];
    
    if (allPortString && allPortString.length>0) {
        self.allPortInt = [allPortString intValue];
    }else{
        self.allPortInt = PoporNetRecordAllPort;
    }
    
    if (headString && headString.length>0) {
        self.headPortInt = [headString intValue];
    }else{
        self.headPortInt = PoporNetRecordHeadPort;
    }
    
    if (requestString && requestString.length>0) {
        self.requestPortInt = [requestString intValue];
    }else{
        self.requestPortInt = PoporNetRecordRequestPort;
    }
    
    if (responsePortString && responsePortString.length>0) {
        self.responsePortInt = [responsePortString intValue];
    }else{
        self.responsePortInt = PoporNetRecordResponsePort;
    }
    
    // 判断
    NSMutableSet * set = [NSMutableSet new];
    [set addObject:[NSString stringWithFormat:@"%i", self.allPortInt]];
    [set addObject:[NSString stringWithFormat:@"%i", self.headPortInt]];
    [set addObject:[NSString stringWithFormat:@"%i", self.requestPortInt]];
    [set addObject:[NSString stringWithFormat:@"%i", self.responsePortInt]];
    if (set.count != 4) {
        AlertToastTitle(@"端口号有重复,请检查!");
        self.allPortInt      = PoporNetRecordAllPort;
        self.headPortInt     = PoporNetRecordHeadPort;
        self.requestPortInt  = PoporNetRecordRequestPort;
        self.responsePortInt = PoporNetRecordResponsePort;
    }
    
    //-------
    self.jsonWindowSwitch = [PnrWebPortEntity getJsonWindowSwitch];
}

#pragma mark - plist
+ (void)saveAllPort:(NSString *)allPort {
    [[NSUserDefaults standardUserDefaults] setObject:allPort forKey:PoporNetRecord_allPort];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+ (NSString *)getAllPort {
    NSString * info = [[NSUserDefaults standardUserDefaults] objectForKey:PoporNetRecord_allPort];
    return info;
}

//
+ (void)saveHeadPort:(NSString *)headPort {
    [[NSUserDefaults standardUserDefaults] setObject:headPort forKey:PoporNetRecord_headPort];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+ (NSString *)getHeadPort {
    NSString * info = [[NSUserDefaults standardUserDefaults] objectForKey:PoporNetRecord_headPort];
    return info;
}

//
+ (void)saveRequestPort:(NSString *)requestPort {
    [[NSUserDefaults standardUserDefaults] setObject:requestPort forKey:PoporNetRecord_requestPort];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+ (NSString *)getRequestPort {
    NSString * info = [[NSUserDefaults standardUserDefaults] objectForKey:PoporNetRecord_requestPort];
    return info;
}

//
+ (void)saveResponsePort:(NSString *)responsePort {
    [[NSUserDefaults standardUserDefaults] setObject:responsePort forKey:PoporNetRecord_responsePort];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+ (NSString *)getResponsePort {
    NSString * info = [[NSUserDefaults standardUserDefaults] objectForKey:PoporNetRecord_responsePort];
    return info;
}

//
+ (void)saveJsonWindowSwitch:(BOOL)JsonWindowSwitch {
    [[NSUserDefaults standardUserDefaults] setObject:[NSString stringWithFormat:@"%i", JsonWindowSwitch] forKey:PoporNetRecord_JsonWindow];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+ (BOOL)getJsonWindowSwitch {
    NSString * info = [[NSUserDefaults standardUserDefaults] objectForKey:PoporNetRecord_JsonWindow];
    if (info) {
        return [info boolValue];
    }else{
        //[self saveJsonWindowSwitch:NO];
        return NO;
    }
}


@end
