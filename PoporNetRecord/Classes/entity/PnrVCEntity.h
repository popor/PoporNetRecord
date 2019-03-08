//
//  PnrVCEntity.h
//  PoporNetRecord
//
//  Created by apple on 2018/5/16.
//  Copyright © 2018年 popor. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^PnrVCEntityBlock) (NSArray *titleArray, NSArray *jsonArray, NSMutableArray *cellAttArray);

@interface PnrVCEntity : NSObject

@property (nonatomic, strong) NSString * title;
@property (nonatomic, strong) NSString * url;
@property (nonatomic, strong) NSString * domain;
@property (nonatomic, strong) NSString * request;
@property (nonatomic, strong) NSString * method;// post get

@property (nonatomic, strong) id       headValue;
@property (nonatomic, strong) id       requesValue;
@property (nonatomic, strong) id       responseValue;

@property (nonatomic, strong) NSString * time;

@property (nonatomic, strong) NSString * listWebH5; // 列表网页html5代码

//@property (nonatomic        ) float cellH;

- (void)createListWebH5:(NSInteger)index;

- (NSArray *)titleArray;
- (NSArray *)jsonArray;

- (void)getJsonArrayBlock:(PnrVCEntityBlock)finish;

@end
