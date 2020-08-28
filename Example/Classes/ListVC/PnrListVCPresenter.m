//
//  PnrListVCPresenter.m
//  PoporNetRecord
//
//  Created by apple on 2018/5/16.
//  Copyright © 2018年 popor. All rights reserved.

#import "PnrListVCPresenter.h"
#import "PnrListVCInteractor.h"

#import "PnrWebServer.h"
#import "PnrConfig.h"
#import "PnrExtraEntity.h"

#import "PnrDetailVC.h"
#import "PnrExtraVC.h"
#import "PnrMessageVC.h"
#import "PnrListVCCell.h"
#import <PoporFoundation/NSMutableAttributedString+pAtt.h>
#import <PoporUI/UIDevice+pTool.h>
#import <PoporUI/UIImage+pCreate.h>

@interface PnrListVCPresenter ()

@property (nonatomic, weak  ) id<PnrListVCProtocol> view;
@property (nonatomic, strong) PnrListVCInteractor  * interactor;
@property (nonatomic, weak  ) PnrConfig * config;
@property (nonatomic, weak  ) PnrExtraEntity * extraEntity;

@property (nonatomic, weak  ) PnrListVCCell * lastSelectCell;
@property (nonatomic, strong) UIImageView * viewImageView;
@end

@implementation PnrListVCPresenter

- (id)init {
    if (self = [super init]) {
        self.config = [PnrConfig share];
        self.extraEntity = [PnrExtraEntity share];
        
        self.viewImageView = [UIImageView new];
        self.viewImageView.image = [UIImage imageFromColor:PnrColorGreen size:CGSizeMake(10, 10) corner:5];
        self.viewImageView.frame = CGRectMake(0, 0, 10, 10);
    }
    return self;
}

// 初始化数据处理
- (void)setMyInteractor:(PnrListVCInteractor *)interactor {
    self.interactor = interactor;
    
}

// 很多操作,需要在设置了view之后才可以执行.
- (void)setMyView:(id<PnrListVCProtocol>)view {
    self.view = view;
    
}

#pragma mark - VC_DataSource

#pragma mark - TV_Delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if (tableView == self.view.infoTV) {
        return 2;
    }else{
        return 1;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (tableView == self.view.infoTV) {
        switch (section) {
            case 0:
                return 2;
            case 1: {
                return self.view.weakInfoArray.count;
            }
            default:
                return 0;
        }
        
    }else{
        return self.view.rightBarArray.count;
    }
}

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    [cell setSeparatorInset:UIEdgeInsetsMake(0, 0, 0, 0)];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (tableView == self.view.infoTV) {
        switch (indexPath.section) {
            case 0: {
                return PnrListVCConfigCellHeight;
            }
            case 1: {
                PnrEntity * entity = self.view.weakInfoArray[self.view.weakInfoArray.count -  indexPath.row - 1];
                if (entity.log) {
                    switch (self.config.jsonViewLogDetail) {
                        case PnrListTypeLogDetail:{
                            if (entity.logDetailH == 0) {
                                entity.logDetailH = [PnrListVCCell cellLogH:entity.log];
                            }
                            return entity.logDetailH;
                            break;
                        }
                        case PnrListTypeLogSimply:{
                            return self.config.listCellHeight;
                            break;
                        }
                        case PnrListTypeLogNull:{
                            return 0.1;
                            break;
                        }
                        default:{
                            return self.config.listCellHeight;
                            break;
                        }
                    }
                }else{
                    if (self.config.jsonViewColorBlack == PnrListTypeTextNull) {
                        return 0.1;
                    }else{
                        return self.config.listCellHeight;
                    }
                }
                break;
            }
            default:
                return 0;
        }
        
    }else{
        return 44;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (tableView == self.view.infoTV) {
        if (section == 0) {
            return 10;
        } else {
            return 0.1;
        }
    }else{
        return 0.1;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    if (tableView == self.view.infoTV) {
        return 10;
    }else{
        return 0.1;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (tableView == self.view.infoTV) {
        switch (indexPath.section) {
            case 0: {
                static NSString * CellID   = @"infoTV_0";
                static UIFont * cellFont15;
                if (!cellFont15) {
                    cellFont15 = [UIFont systemFontOfSize:20];
                }
                UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:CellID];
                if (!cell) {
                    cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellID];
                }
                switch (indexPath.row) {
                    case 0: {
                        [cell.contentView addSubview:self.view.serverBT];
                        break;
                    }
                    case 1: {
                        [cell.contentView addSubview:self.view.transmitBT];
                        break;
                    }
                    default:
                        break;
                }
                
                return cell;
            }
            case 1: {
                static NSString * CellID   = @"infoTV_1";
                static UIFont * cellFont15;
                if (!cellFont15) {
                    cellFont15 = [UIFont systemFontOfSize:20];
                }
                PnrListVCCell * cell = [tableView dequeueReusableCellWithIdentifier:CellID];
                if (!cell) {
                    cell = [[PnrListVCCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellID];
                    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                }
                PnrEntity * entity = self.view.weakInfoArray[self.view.weakInfoArray.count -  indexPath.row - 1];
                
                if (entity.log) {
                    if (self.config.jsonViewLogDetail == PnrListTypeLogNull) {
                        cell.hidden = YES;
                        //cell.accessoryType = UITableViewCellAccessoryNone;
                    }else{
                        cell.hidden = NO;
                        //cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                        
                        NSMutableAttributedString * att = [NSMutableAttributedString new];
                        [att addString:entity.title font:self.config.listFontTitle color:self.config.listColorTitle];
                        cell.requestL.attributedText = att;
                        
                        cell.domainL.text = entity.log;
                    }
                }else{
                    if (self.config.jsonViewColorBlack == PnrListTypeTextNull) {
                        cell.hidden = YES;
                        //cell.accessoryType = UITableViewCellAccessoryNone;
                    }else{
                        cell.hidden = NO;
                        //cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                        
                        if (entity.title) {
                            NSMutableAttributedString * att = [NSMutableAttributedString new];
                            
                            [att addString:entity.title font:self.config.listFontTitle color:self.config.listColorTitle];
                            [att addString:[NSString stringWithFormat:@" %@", entity.path] font:self.config.listFontRequest color:self.config.listColorRequest];
                            
                            cell.requestL.attributedText = att;
                        }else{
                            cell.requestL.text      = entity.path;
                            cell.requestL.font      = self.config.listFontRequest;
                            cell.requestL.textColor = self.config.listColorRequest;
                        }
                        cell.domainL.text  = entity.domain;
                    }
                }
                cell.timeL.text = entity.time;
                
                if (indexPath.row%2 == 0) {
                    cell.backgroundColor = [UIColor whiteColor];
                }else{
                    cell.backgroundColor = [UIColor colorWithRed:0.95 green:0.95 blue:0.95 alpha:1];
                }
                return cell;
            }
            default:
                return nil;
        }
    }else{
        static NSString * CellID = @"alertTV";
        UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:CellID];
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellID];
            cell.backgroundColor     = [UIColor clearColor];
            cell.textLabel.font      = [UIFont systemFontOfSize:16];
            cell.textLabel.textColor = [UIColor whiteColor];
            cell.tintColor           = [UIColor whiteColor];
        }
        PnrCellEntity * cellEntity = self.view.rightBarArray[indexPath.row];
        
        cell.textLabel.text = cellEntity.title;
        
        switch (cellEntity.type) {
            case PnrListTypeClear:
            case PnrListTypeExtra:{
                break;
            }
            case PnrListTypeTextColor:
            case PnrListTypeTextBlack:
            case PnrListTypeTextNull:{
                if (self.config.jsonViewColorBlack == cellEntity.type) {
                    cell.accessoryType = UITableViewCellAccessoryCheckmark;
                }else{
                    cell.accessoryType = UITableViewCellAccessoryNone;
                }
                break;
            }
                
            case PnrListTypeLogDetail:
            case PnrListTypeLogSimply:
            case PnrListTypeLogNull:{
                if (self.config.jsonViewLogDetail == cellEntity.type) {
                    cell.accessoryType = UITableViewCellAccessoryCheckmark;
                }else{
                    cell.accessoryType = UITableViewCellAccessoryNone;
                }
                break;
            }
                
            default:
                break;
        }
        
        return cell;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (tableView == self.view.infoTV) {
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
        if (indexPath.section == 1) {
            PnrListVCCell * cell = [tableView cellForRowAtIndexPath:indexPath];
            if (self.lastSelectCell != cell) {
                self.lastSelectCell.accessoryView = nil;
                self.lastSelectCell = cell;
                self.lastSelectCell.accessoryView = self.viewImageView;
            }
            
            PnrEntity * entity = self.view.weakInfoArray[self.view.weakInfoArray.count -  indexPath.row - 1];
            
            __weak typeof(self) weakSelf = self;
            [entity getJsonArrayBlock:^(NSArray *titleArray, NSArray *jsonArray, NSMutableArray *cellAttArray) {
                
                NSDictionary * vcDic = @{
                    @"title":@"请求详情",
                    @"jsonArray":jsonArray,
                    @"titleArray":titleArray,
                    @"cellAttArray":cellAttArray,
                    @"blockExtraRecord":self.view.blockExtraRecord,
                    @"weakPnrEntity":entity,
                };
                [weakSelf.view.vc.navigationController pushViewController:[[PnrDetailVC alloc] initWithDic:vcDic] animated:YES];
            }];
        }
        
    }else{
        PnrCellEntity * cellEntity = self.view.rightBarArray[indexPath.row];
        switch (cellEntity.type) {
            case PnrListTypeClear:{
                [self clearAction];
                break;
            }
            case PnrListTypeTextColor:
            case PnrListTypeTextBlack:
            case PnrListTypeTextNull:{
                [self.config updateTextColorBlack:cellEntity.type];
                //[self.view.infoTV reloadData];
                break;
            }
                
            case PnrListTypeLogDetail:
            case PnrListTypeLogSimply:
            case PnrListTypeLogNull:{
                [self.config updateLogDetail:cellEntity.type];
                //[self.view.infoTV reloadData];
                break;
            }
            case PnrListTypeExtra:{
                [self.view.vc.navigationController pushViewController:[PnrExtraVC new] animated:YES];
                break;
            }
            default:
                break;
        }
        [self.view.infoTV reloadData];
        [self.view.alertBubbleView closeEvent];
    }
    
}

//- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath {
//    if (tableView == self.view.infoTV) {
//        if (indexPath.section == 1) {
//            PnrListVCCell * cell = [tableView cellForRowAtIndexPath:indexPath];
//
//            cell.accessoryType = UITableViewCellAccessoryCheckmark;
//        }
//
//
//    }
//}


#pragma mark - cell 侧滑功能
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    if (tableView == self.view.infoTV && indexPath.section == 0 && indexPath.row == 1) {
        return YES;
    } else {
        return NO;
    }
}
// 只要实现了这个方法，左滑出现按钮的功能就有了
// (一旦左滑出现了N个按钮，tableView就进入了编辑模式, tableView.editing = YES)
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath { }

- (NSArray *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (tableView == self.view.infoTV && indexPath.section == 0 && indexPath.row == 1) {
        PnrExtraUrlPortEntity * ue = self.extraEntity.urlPortArray[self.extraEntity.selectNum];
        __weak typeof(self) weakSelf = self;
        
        UITableViewRowAction *action01 = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleNormal title:@"域名" handler:^(UITableViewRowAction *action, NSIndexPath *indexPath) {
            [weakSelf updateEntity:ue type:PnrExtraUrlPortEntityType_url indexPath:indexPath];
        }];
        
        UITableViewRowAction *action02 = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleNormal title:@"端口" handler:^(UITableViewRowAction *action, NSIndexPath *indexPath) {
            [weakSelf updateEntity:ue type:PnrExtraUrlPortEntityType_port indexPath:indexPath];
        }];
        UITableViewRowAction *action03 = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleNormal title:@"接口" handler:^(UITableViewRowAction *action, NSIndexPath *indexPath) {
            [weakSelf updateEntity:ue type:PnrExtraUrlPortEntityType_api indexPath:indexPath];
        }];
        
        action01.backgroundColor = [UIColor colorWithRed:0.4 green:0.4 blue:0.4 alpha:1];
        action02.backgroundColor = [UIColor colorWithRed:0.6 green:0.6 blue:0.6 alpha:1];
        
        return @[action03, action02, action01];
       
    }else{
        return nil;
    }
}

- (void)updateEntity:(PnrExtraUrlPortEntity *)ue type:(PnrExtraUrlPortEntityType)type indexPath:(NSIndexPath *)indexPath {
    NSString * title;
    NSString * text;
    switch (type) {
        case PnrExtraUrlPortEntityType_title: {
            title = @"标题";
            text = ue.title;
            break;
        }
        case PnrExtraUrlPortEntityType_url: {
            title = @"域名";
            text = ue.url;
            break;
        }
        case PnrExtraUrlPortEntityType_port: {
            title = @"端口";
            text = ue.port;
            break;
        }
        case PnrExtraUrlPortEntityType_api: {
            title = @"接口";
            text = ue.api;
            break;
        }
        default:
            return;
    }
    __weak typeof(self) weakSelf = self;
    {
        UIAlertController * oneAC = [UIAlertController alertControllerWithTitle:[NSString stringWithFormat:@"修改%@", title] message:nil preferredStyle:UIAlertControllerStyleAlert];
        
        [oneAC addTextFieldWithConfigurationHandler:^(UITextField *textField){
            
            textField.placeholder = title;
            textField.text = text;
        }];
        
        UIAlertAction * cancleAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
        UIAlertAction * changeAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            UITextField * tf = oneAC.textFields[0];
            PnrExtraEntity * pee = [PnrExtraEntity share];
            switch (type) {
                case PnrExtraUrlPortEntityType_title: {
                    ue.title = tf.text;
                    break;
                }
                case PnrExtraUrlPortEntityType_url: {
                    ue.url = tf.text;
                    break;
                }
                case PnrExtraUrlPortEntityType_port: {
                    ue.port = tf.text;
                    break;
                }
                case PnrExtraUrlPortEntityType_api: {
                    ue.api = tf.text;
                    break;
                }
                default:
                    return;
            }
            
            [pee saveArray];
            
            // 刷新数据
            [pee updateSelectUrlPort];
            [weakSelf updateTransmitBT];
            
        }];
        
        [oneAC addAction:cancleAction];
        [oneAC addAction:changeAction];
        
        [self.view.vc presentViewController:oneAC animated:YES completion:nil];
    }
}


#pragma mark - VC_EventHandler
- (void)closeAction {
    UIViewController * topVC = self.view.vc;
    if (topVC.navigationController) {
        if (topVC.navigationController.viewControllers.count == 1) {
            [topVC.navigationController dismissViewControllerAnimated:YES completion:nil];
        }else{
            [topVC.navigationController popViewControllerAnimated:YES];
        }
    }else{
        [topVC dismissViewControllerAnimated:YES completion:nil];
    }
}

- (void)clearAction {
    [self.view.weakInfoArray removeAllObjects];
    [self.view.infoTV reloadData];
    
    // 清空记录
    [[PnrWebServer share] clearListWeb];
}

- (void)settingAction:(UIBarButtonItem *)sender event:(UIEvent *)event {
    //CGRect fromRect = [[event.allTouches anyObject] view].frame;
    UITouch * touch = [event.allTouches anyObject];
    //UIWindow * window = [[UIApplication sharedApplication] keyWindow];
                         
    //CGPoint point = [touch locationInView:window];
    //fromRect.origin = point;
    
    CGRect fromRect = [touch.view.superview convertRect:touch.view.frame toView:self.view.vc.navigationController.view];
    fromRect.origin.y -= 7;
    
    NSDictionary * dic = @{
                           @"direction":@(AlertBubbleViewDirectionTop),
                           @"baseView":self.view.vc.navigationController.view,
                           @"borderLineColor":self.view.alertBubbleTVColor,
                           @"borderLineWidth":@(1),
                           @"corner":@(5),
                           @"trangleHeight":@(8),
                           @"trangleWidth":@(8),
                           
                           @"borderInnerGap":@(15),
                           @"customeViewInnerGap":@(0),
                           
                           @"bubbleBgColor":self.view.alertBubbleTVColor,
                           @"bgColor":[UIColor clearColor],
                           @"showAroundRect":@(NO),
                           @"showLogInfo":@(NO),
                           };
    
    self.view.alertBubbleView = [[AlertBubbleView alloc] initWithDic:dic];
    
    [self.view.alertBubbleView showCustomView:self.view.alertBubbleTV around:fromRect close:nil];
}

- (void)setRightBarAction {
    UIBarButtonItem *item1 = [[UIBarButtonItem alloc] initWithTitle:PoporNetRecordSet style:UIBarButtonItemStylePlain target:self action:@selector(settingAction:event:)];
    UIBarButtonItem *item2 = [[UIBarButtonItem alloc] initWithTitle:@"转发" style:UIBarButtonItemStylePlain target:self action:@selector(forwardeTextAction)];
    if (self.view.blockExtraRecord) {
        self.view.vc.navigationItem.rightBarButtonItems = @[item1, item2];
    } else {
        self.view.vc.navigationItem.rightBarButtonItems = @[item1];
    }
}

- (void)updateServerBT {
    PnrWebServer * tool = [PnrWebServer share];
    UIButton * oneBT = self.view.serverBT;
    if (tool.webServer.serverURL) {
        UIImage * image = [UIImage imageFromColor:PnrColorGreen size:CGSizeMake(10, 10) corner:5];
        [oneBT setImage:image forState:UIControlStateNormal];
        
        NSMutableAttributedString * att = [NSMutableAttributedString new];
        [att addString:@"  已开启 " font:[UIFont systemFontOfSize:15] color:PnrColorGreen];
        
        [att addString:[NSString stringWithFormat:@"%@", tool.webServer.serverURL.absoluteString] font:[UIFont systemFontOfSize:15] color:[UIColor blackColor]];
        
        NSString * wifi = [UIDevice getWifiName];
        if (wifi) {
            [att addString:@" (" font:[UIFont systemFontOfSize:15] color:[UIColor blackColor]];
            [att addString:[NSString stringWithFormat:@"%@", wifi] font:[UIFont systemFontOfSize:15] color:PnrColorGreen];
            [att addString:@") " font:[UIFont systemFontOfSize:15] color:[UIColor blackColor]];
            
        }
        
        [oneBT setAttributedTitle:att forState:UIControlStateNormal];
    }else{
        UIImage * image = [UIImage imageFromColor:PnrColorRed size:CGSizeMake(10, 10) corner:5];
        [oneBT setImage:image forState:UIControlStateNormal];
        
        NSMutableAttributedString * att = [NSMutableAttributedString new];
        [att addString:@"  未开启 " font:[UIFont systemFontOfSize:15] color:PnrColorRed];
        [att addString:@"WIFI 或者无法获得IP地址" font:[UIFont systemFontOfSize:15] color:[UIColor blackColor]];
        
        [oneBT setAttributedTitle:att forState:UIControlStateNormal];
    }
}

- (void)updateTransmitBT {
    PnrExtraEntity * e = [PnrExtraEntity share];
    NSString * title   = e.forward ? @"已打开转发":@"已关闭转发";
    UIColor * color    = e.forward ? PnrColorGreen:PnrColorRed;
    UIButton * bt      = self.view.transmitBT;
    {
        UIImage * image = [UIImage imageFromColor:color size:CGSizeMake(10, 10) corner:5];
        [bt setImage:image forState:UIControlStateNormal];
    }
    {
        PnrExtraEntity * e = [PnrExtraEntity share];
        
        NSMutableAttributedString * att = [NSMutableAttributedString new];
        [att addString:[NSString stringWithFormat:@"  %@ ", title] font:[UIFont systemFontOfSize:15] color:color];
        
        [att addString:e.selectUrlPort font:[UIFont systemFontOfSize:15] color:[UIColor blackColor]];
        
        [bt setAttributedTitle:att forState:UIControlStateNormal];
    }
}

- (void)editPortAction {
    {
        NSString * message = @"日志端口修改后，下次启动生效";// @"Get端口和Post端口\n修改后，下次启动生效"
        UIAlertController * oneAC = [UIAlertController alertControllerWithTitle:nil message:message preferredStyle:UIAlertControllerStyleAlert];
        
        [oneAC addTextFieldWithConfigurationHandler:^(UITextField *textField){
            
            textField.placeholder = [NSString stringWithFormat:@"%i", PnrPortGet];
            textField.text = [NSString stringWithFormat:@"%i", [PnrPortEntity getPort_get]];
        }];
        //        [oneAC addTextFieldWithConfigurationHandler:^(UITextField *textField){
        //
        //            textField.placeholder = [NSString stringWithFormat:@"%i", PnrPortPost];
        //            textField.text = [NSString stringWithFormat:@"%i", [PnrPortEntity getPort_post]];
        //        }];
        
        UIAlertAction * cancleAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
        UIAlertAction * changeAction = [UIAlertAction actionWithTitle:@"修改" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            int portGet  = oneAC.textFields[0].text.intValue;
            if (portGet != 0) {
                [PnrPortEntity savePort_get:portGet];
            }
            //            int portGet  = oneAC.textFields[0].text.intValue;
            //            int portPost = oneAC.textFields[1].text.intValue;
            //            if (portGet!=0 && portPost!=0 && portGet!=portPost) {
            //                [PnrPortEntity savePort_get:portGet];
            //                [PnrPortEntity savePort_post:portPost];
            //            }
        }];
        
        [oneAC addAction:cancleAction];
        [oneAC addAction:changeAction];
        
        [self.view.vc presentViewController:oneAC animated:YES completion:nil];
    }
}

- (void)transmitBTAction {
    // 直接修改, 不再询问了, 麻烦.
    PnrExtraEntity * e = [PnrExtraEntity share];
    e.forward = !e.forward;
    [e saveForward];
    [self updateTransmitBT];
    
    //    PnrExtraEntity * e = [PnrExtraEntity share];
    //    NSString * title = e.forward ? @"关闭":@"打开" ;
    //    __weak typeof(self) weakSelf = self;
    //    {
    //        UIAlertController * oneAC = [UIAlertController alertControllerWithTitle:@"提醒" message:[NSString stringWithFormat:@"确认%@转发功能吗?", title] preferredStyle:UIAlertControllerStyleAlert];
    //
    //        UIAlertAction * cancleAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    //        UIAlertAction * okAction = [UIAlertAction actionWithTitle:title style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
    //            e.forward = !e.forward;
    //
    //            [e saveForward];
    //            [weakSelf updateTransmitBT];
    //        }];
    //
    //        [oneAC addAction:cancleAction];
    //        [oneAC addAction:okAction];
    //
    //        [self.view.vc presentViewController:oneAC animated:YES completion:nil];
    //    }
}

- (void)forwardeTextAction {
    PnrMessageVC * vc   = [PnrMessageVC new];
    vc.blockExtraRecord = self.view.blockExtraRecord;
    
    [self.view.vc.navigationController pushViewController:vc animated:YES];
}

#pragma mark - Interactor_EventHandler

@end
