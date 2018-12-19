//
//  PnrWebPortVC.m
//  GCDWebServer
//
//  Created by apple on 2018/12/18.
//

#import "PnrWebPortVC.h"
#import <Masonry/Masonry.h>
#import <PoporUI/UIInsetsTextField.h>
#import <PoporFoundation/PrefixColor.h>
#import <PoporUI/IToastKeyboard.h>

@interface PnrWebPortVC ()

@property (nonatomic, strong) PnrWebPortEntity  * portEntity;

@property (nonatomic, strong) UIInsetsTextField * allPortTF;
@property (nonatomic, strong) UIInsetsTextField * headPortTF;
@property (nonatomic, strong) UIInsetsTextField * requestPortTF;
@property (nonatomic, strong) UIInsetsTextField * responsePortTF;


@end

@implementation PnrWebPortVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"端口";
    self.view.backgroundColor = [UIColor whiteColor];
    self.portEntity = [PnrWebPortEntity new];
    [self addTFs];
}

- (void)addTFs {
    NSArray * titleArray = @[@"主页端口", @"head端口", @"参数端口", @"返回数据端口"];
    NSArray * placeArray = @[[NSString stringWithFormat:@"%i", PoporNetRecordAllPort],
                             [NSString stringWithFormat:@"%i", PoporNetRecordHeadPort],
                             [NSString stringWithFormat:@"%i", PoporNetRecordRequestPort],
                             [NSString stringWithFormat:@"%i", PoporNetRecordResponsePort],
                             ];
    NSArray * textArray = @[[NSString stringWithFormat:@"%i", self.portEntity.allPortInt],
                            [NSString stringWithFormat:@"%i", self.portEntity.headPortInt],
                            [NSString stringWithFormat:@"%i", self.portEntity.requestPortInt],
                            [NSString stringWithFormat:@"%i", self.portEntity.responsePortInt],
                            ];
    int height = 30;
    UILabel * lastL;
    for (int i = 0; i<titleArray.count; i++) {
        UILabel * oneL = ({
            UILabel * l = [UILabel new];
            l.frame              = CGRectMake(0, 0, 0, 44);
            l.backgroundColor    = [UIColor clearColor];
            l.font               = [UIFont systemFontOfSize:15];
            l.textColor          = [UIColor darkGrayColor];
            
            [self.view addSubview:l];
            l;
        });
        UIInsetsTextField * oneTF = ({
            UIInsetsTextField * tf = [[UIInsetsTextField alloc] initWithFrame:CGRectMake(0, 0, 0, 44) insets:UIEdgeInsetsMake(0, 10, 0, 10)];
            tf.backgroundColor    = [UIColor clearColor];
            tf.font               = [UIFont systemFontOfSize:15];
            tf.textColor          = [UIColor darkGrayColor];
            
            tf.layer.cornerRadius = 5;
            tf.layer.borderColor  = [UIColor lightGrayColor].CGColor;
            tf.layer.borderWidth  = 1;
            tf.clipsToBounds      = YES;
            
            [self.view addSubview:tf];
            tf;
        });
        UIButton * oneBT = ({
            UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
            [button setTitle:@"更新" forState:UIControlStateNormal];
            [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            [button setBackgroundColor:RGB16(0X4585F5)];
            
            button.layer.cornerRadius = 5;
            button.layer.borderColor = [UIColor lightGrayColor].CGColor;
            button.layer.borderWidth = 1;
            button.clipsToBounds = YES;
            button.titleLabel.font = [UIFont systemFontOfSize:15];
            
            [self.view addSubview:button];
            
            [button addTarget:self action:@selector(updateBtAction:) forControlEvents:UIControlEventTouchUpInside];
            
            button;
        });
        oneBT.tag         = i;
        oneL.text         = titleArray[i];
        oneTF.placeholder = placeArray[i];
        oneTF.text        = textArray[i];
        
        switch (i) {
            case 0: {
                self.allPortTF      = oneTF;
                break;
            }
            case 1: {
                self.headPortTF = oneTF;
                break;
            }
            case 2: {
                self.requestPortTF = oneTF;
                break;
            }
            case 3: {
                self.responsePortTF = oneTF;
                break;
            }
                
            default:
                break;
        }
        [oneL mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(10);
            if (lastL) {
                make.top.mas_equalTo(lastL.mas_bottom).mas_offset(10);
            }else{
                make.top.mas_equalTo(20).mas_offset(10);
            }
            
            make.width.mas_equalTo(100);
            make.height.mas_equalTo(height);
        }];
        
        [oneTF mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(oneL.mas_right).mas_offset(10);
            make.top.mas_equalTo(oneL.mas_top);
            make.bottom.mas_equalTo(oneL.mas_bottom);
            make.width.mas_equalTo(80);
        }];
        [oneBT mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(oneTF.mas_right).mas_offset(20);
            make.top.mas_equalTo(oneTF.mas_top);
            make.bottom.mas_equalTo(oneTF.mas_bottom);
            make.width.mas_equalTo(60);
        }];
        lastL = oneL;
    }
    
}


- (void)updateBtAction:(UIButton *)bt {
    switch (bt.tag) {
        case 0:{
            if (self.allPortTF.text.length > 0) {
                [PnrWebPortEntity saveAllPort:self.allPortTF.text];
                AlertToastTitle(@"重新载入生效");
            }else{
                AlertToastTitle(@"端口号不能为空");
            }
            break;
        }
        case 1:{
            if (self.headPortTF.text.length > 0) {
                [PnrWebPortEntity saveHeadPort:self.headPortTF.text];
                AlertToastTitle(@"重新载入生效");
            }else{
                AlertToastTitle(@"端口号不能为空");
            }
            break;
        }
        case 2:{
            if (self.requestPortTF.text.length > 0) {
                [PnrWebPortEntity saveRequestPort:self.requestPortTF.text];
                AlertToastTitle(@"重新载入生效");
            }else{
                AlertToastTitle(@"端口号不能为空");
            }
            break;
        }
        case 3:{
            if (self.responsePortTF.text.length > 0) {
                [PnrWebPortEntity saveResponsePort:self.responsePortTF.text];
                AlertToastTitle(@"重新载入生效");
            }else{
                AlertToastTitle(@"端口号不能为空");
            }
            break;
        }
        default:
            break;
    }
    
}

@end
