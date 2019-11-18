//
//  PnrExtraVCPresenter.m
//  PoporNetRecord
//
//  Created by apple on 2019/11/16.
//  Copyright © 2019 wangkq. All rights reserved.

#import "PnrExtraVCPresenter.h"
#import "PnrExtraVCInteractor.h"

#import "PnrExtraEntity.h"

@interface PnrExtraVCPresenter ()

@property (nonatomic, weak  ) id<PnrExtraVCProtocol> view;
@property (nonatomic, strong) PnrExtraVCInteractor * interactor;

@property (nonatomic, weak  ) PnrExtraEntity * extraEntity;

@end

@implementation PnrExtraVCPresenter


- (id)init {
    if (self = [super init]) {
        self.extraEntity = [PnrExtraEntity share];
    }
    return self;
}

- (void)setMyInteractor:(PnrExtraVCInteractor *)interactor {
    self.interactor = interactor;
    
}

- (void)setMyView:(id<PnrExtraVCProtocol>)view {
    self.view = view;
    
}

// 开始执行事件,比如获取网络数据
- (void)startEvent {
    
    
}

#pragma mark - VC_DataSource
#pragma mark - TV_Delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.extraEntity.urlPortArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 50;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 10;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 10;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString * CellID = @"CellID";
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:CellID];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellID];
        cell.accessoryType        = UITableViewCellAccessoryCheckmark;
        
        cell.textLabel.font       = [UIFont systemFontOfSize:14];
        cell.detailTextLabel.font = [UIFont systemFontOfSize:16];
        
        cell.textLabel.textColor  = [UIColor grayColor];
    }
    PnrExtraUrlPortEntity * ue = self.extraEntity.urlPortArray[indexPath.row];
    cell.textLabel.text        = ue.title;
    cell.detailTextLabel.text  = [NSString stringWithFormat:@"%@:%@", ue.url, ue.port];
    
    if (self.extraEntity.selectNum == indexPath.row) {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    } else {
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.row != self.extraEntity.selectNum) {
        
        UITableViewCell * cellOld = [tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:self.extraEntity.selectNum inSection:0]];
        UITableViewCell * cellNew = [tableView cellForRowAtIndexPath:indexPath];
        
        cellOld.accessoryType = UITableViewCellAccessoryNone;
        cellNew.accessoryType = UITableViewCellAccessoryCheckmark;
        
        [[PnrExtraEntity share] saveSelectNum:indexPath.row];
    }
}

#pragma mark - tv 删除
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}
// 只要实现了这个方法，左滑出现按钮的功能就有了
// (一旦左滑出现了N个按钮，tableView就进入了编辑模式, tableView.editing = YES)
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}

- (NSArray *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == self.view.infoTV) {
        PnrExtraUrlPortEntity * ue = self.extraEntity.urlPortArray[indexPath.row];
        __weak typeof(self) weakSelf = self;
        
        UITableViewRowAction *action00 = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleNormal title:@"标题" handler:^(UITableViewRowAction *action, NSIndexPath *indexPath) {
            [weakSelf updateEntity:ue type:0];
        }];
        
        UITableViewRowAction *action01 = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleNormal title:@"域名" handler:^(UITableViewRowAction *action, NSIndexPath *indexPath) {
            [weakSelf updateEntity:ue type:1];
        }];
        
        UITableViewRowAction *action02 = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleNormal title:@"端口" handler:^(UITableViewRowAction *action, NSIndexPath *indexPath) {
            [weakSelf updateEntity:ue type:2];
        }];
        
        action00.backgroundColor = [UIColor colorWithRed:0.2 green:0.2 blue:0.2 alpha:1];
        action01.backgroundColor = [UIColor colorWithRed:0.4 green:0.4 blue:0.4 alpha:1];
        action02.backgroundColor = [UIColor colorWithRed:0.6 green:0.6 blue:0.6 alpha:1];
        
        UITableViewRowAction *action1 = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDefault title:@"删除" handler:^(UITableViewRowAction *action, NSIndexPath *indexPath) {
            
            [weakSelf deleteEntity:ue];
        }];
        if (indexPath.row == 0) {
            return @[action01];
        } else {
            return @[action1, action02, action01, action00];
        }
        
    }else{
        return nil;
    }
}

- (void)updateEntity:(PnrExtraUrlPortEntity *)ue type:(PnrExtraUrlPortEntityType)type {
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
                default:
                    return;
            }
            
            [[PnrExtraEntity share] saveArray];
            
            [weakSelf.view.infoTV reloadData];
        }];
        
        [oneAC addAction:cancleAction];
        [oneAC addAction:changeAction];
        
        [self.view.vc presentViewController:oneAC animated:YES completion:nil];
    }
}

- (void)deleteEntity:(PnrExtraUrlPortEntity *)ue {
    [self.extraEntity.urlPortArray removeObject:ue];
    [self.extraEntity saveArray];
    if (self.extraEntity.selectNum >= self.extraEntity.urlPortArray.count) {
        self.extraEntity.selectNum = 0;
    }
    [self.view.infoTV reloadData];
}

#pragma mark - VC_EventHandler
- (void)addUrlPortAction {
    __weak typeof(self) weakSelf = self;
    {
        UIAlertController * oneAC = [UIAlertController alertControllerWithTitle:@"新增配置" message:nil preferredStyle:UIAlertControllerStyleAlert];
        
        [oneAC addTextFieldWithConfigurationHandler:^(UITextField *textField){
            
            textField.placeholder = @"标题";
            textField.text = @"新增标题";
        }];
        
        [oneAC addTextFieldWithConfigurationHandler:^(UITextField *textField){
            
            textField.placeholder = @"域名";
            textField.text = @"http://1";
        }];
        [oneAC addTextFieldWithConfigurationHandler:^(UITextField *textField){
            
            textField.placeholder = @"端口号";
            textField.text = @"";
        }];
        
        UIAlertAction * cancleAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
        UIAlertAction * changeAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            UITextField * titleTF = oneAC.textFields[0];
            UITextField * urlTF   = oneAC.textFields[1];
            UITextField * portTF  = oneAC.textFields[2];
            PnrExtraUrlPortEntity * ue = [PnrExtraUrlPortEntity new];
            ue.title = titleTF.text;
            ue.url   = urlTF.text;
            ue.port  = portTF.text;
            
            [[PnrExtraEntity share].urlPortArray addObject:ue];
            
            [[PnrExtraEntity share] saveArray];
            
            [weakSelf.view.infoTV reloadData];
        }];
        
        [oneAC addAction:cancleAction];
        [oneAC addAction:changeAction];
        
        [self.view.vc presentViewController:oneAC animated:YES completion:nil];
    }
    
}

#pragma mark - Interactor_EventHandler

@end
