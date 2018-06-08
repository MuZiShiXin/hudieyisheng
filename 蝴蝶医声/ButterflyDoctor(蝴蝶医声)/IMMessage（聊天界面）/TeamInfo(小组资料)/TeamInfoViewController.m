//
//  TeamInfoViewController.m
//  ButterflyDoctorVoice
//
//  Created by 辛书亮 on 2017/5/11.
//  Copyright © 2017年 辛书亮. All rights reserved.
//

#import "TeamInfoViewController.h"
#import "GatoBaseHelp.h"
#import "TeamImageView.h"
#import "TeamImageModel.h"
#import "TeamInfoImageTableViewCell.h"
#import "DoctorHomeViewController.h"
#import "TeamInfoMessageTableViewCell.h"
#import "TeamTextViewViewController.h"
#import "MyTeamMemberModel.h"
#import "EMChooseViewController.h"
#import "MyTeamViewController.h"
#define get_team_disturb @"http://api.hudieyisheng.com/v1/home/get-team-disturb"
#define set_team_disturb @"http://api.hudieyisheng.com/v1/home/set-team-disturb"
@interface TeamInfoViewController ()<EMGroupManagerDelegate, EMChooseViewDelegate>
{
    BOOL nowGroupIdPush ;
    CGFloat imageCellHeight;
    CGFloat centerCellHeight;
    BOOL imageCellZhankai;//defund NO;
}
@property (nonatomic ,strong) UIButton * deleteButton;
@end

@implementation TeamInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    Gato_Return
    self.title = @"组内信息";
    self.view.backgroundColor = [UIColor appAllBackColor];
    imageCellZhankai = NO;
    [self newData];
    [self oldMessage];
    self.GatoTableview.frame = CGRectMake(0, 0, Gato_Width, Gato_Height - NAV_BAR_HEIGHT - Gato_Height_548_(96));\
    [self.view addSubview:self.GatoTableview];
    
    
    self.deleteButton.sd_layout.centerXEqualToView(self.view)
    .bottomSpaceToView(self.view,Gato_Height_548_(30))
    .widthIs(Gato_Width_320_(228))
    .heightIs(Gato_Height_548_(36));
    GatoViewBorderRadius(self.deleteButton, 3, 0, [UIColor redColor]);
    
    if ([self.teamModel.doctorId isEqualToString:TOKEN]) {
        self.deleteButton.hidden = YES;
    }
}
-(void)oldMessage
{
    NSMutableDictionary * Get_dic = [NSMutableDictionary dictionary];
    [Get_dic setObject:TOKEN forKey:@"doctorId"];
    [Get_dic setObject:self.teamModel.groupId forKey:@"groupId"];
    [IWHttpTool postWithURL:get_team_disturb params:Get_dic success:^(id json) {
        NSDictionary * dic = [NSJSONSerialization JSONObjectWithData:json options:NSJSONReadingAllowFragments error:nil];
        NSString * success = [dic objectForKey:@"code"];
        if ([success isEqualToString:@"200"]) {
            if ([[[[dic objectForKey:@"data"] objectForKey:@"info"] objectForKey:@"notDisturb"] isEqualToString:@"1"]) {
                nowGroupIdPush = YES;
            }else{
                nowGroupIdPush = NO;
            }
        }else{
            
        }
        [self.GatoTableview reloadData];
    } failure:^(NSError *error) {
        NSLog(@"%@",error);
    }];
}
-(void)newData
{
    self.updataArray = [NSMutableArray array];
    for (int i = 0 ; i < self.teamModel.members.count; i ++) {
        MyTeamMemberModel * memberModel = [[MyTeamMemberModel alloc]init];
        memberModel = self.teamModel.members[i];
        TeamImageModel * model = [[TeamImageModel alloc]init];
        model.name = memberModel.name;
        model.imageUrl = memberModel.photo;
        model.doctorId = memberModel.doctorId;
        [self.updataArray addObject:model];
    }
    [self.GatoTableview reloadData];
    
    
    
}


-(void)deleteButtonDidClicked
{
    
    for (int i = 0 ; i < self.teamModel.members.count; i ++) {
        MyTeamMemberModel * memberModel = [[MyTeamMemberModel alloc]init];
        memberModel = self.teamModel.members[i];
        if ([self.teamModel.owner isEqualToString:memberModel.phone]) {
            NSString * message = [NSString stringWithFormat:@"是否确认退出%@医生的医疗组",memberModel.name];
            [EMAlertView showAlertWithTitle:NSLocalizedString(@"prompt", @"Prompt")
                                    message:message
                            completionBlock:^(NSUInteger buttonIndex, EMAlertView *alertView) {
                                if (buttonIndex == 1) {
                                    EMError *error = nil;
                                    [[EMClient sharedClient].groupManager leaveGroup:self.groupId error:&error];
                                    if (error) {
                                        [self showHint:error.errorDescription];
                                    }
                                    [self deleteHttp];
                                }
                            } cancelButtonTitle:NSLocalizedString(@"cancel", @"Cancel")
                          otherButtonTitles:NSLocalizedString(@"ok", @"OK"), nil];
        }
    }

}
-(void)deleteHttp
{
    
    NSMutableDictionary * dic = [NSMutableDictionary dictionary];
    [dic setObject:TOKEN forKey:@"token"];
    [dic setObject:self.teamModel.groupId forKey:@"groupId"];
    [IWHttpTool postWithURL:HD_chat_Team_Delete params:dic success:^(id json) {
        
        NSDictionary * dic = [NSJSONSerialization JSONObjectWithData:json options:NSJSONReadingAllowFragments error:nil];
        NSString * success = [dic objectForKey:@"code"];
        if ([success isEqualToString:@"200"]) {
            [self showHint:@"退出成功"];
            for (UIViewController *temp in self.navigationController.viewControllers) {
                if ([temp isKindOfClass:[MyTeamViewController class]]) {
                    [self.navigationController popToViewController:temp animated:YES];
                }
            }
//            [self.navigationController popToRootViewControllerAnimated:YES];
        }else{
            
        }
        [self.GatoTableview reloadData];
    } failure:^(NSError *error) {
        NSLog(@"%@",error);
    }];
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 10;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    __weak typeof(self) weakSelf = self;

    if (indexPath.row == 0) {
        TeamInfoImageTableViewCell * cell = [TeamInfoImageTableViewCell cellWithTableView:tableView];
        [cell setValueWithModelArray:self.updataArray Withzhankai:imageCellZhankai];
        imageCellHeight = cell.height;
        cell.zhankaiBlock = ^(BOOL selete){
            self->imageCellZhankai = selete;
            [weakSelf.GatoTableview reloadData];
        };
        cell.imageBlock = ^(TeamImageModel * model){
            DoctorHomeViewController * vc = [[DoctorHomeViewController alloc]init];
            vc.doctorId = model.doctorId;
            vc.hidesBottomBarWhenPushed = YES;
            [weakSelf.navigationController pushViewController:vc animated:YES];
        };
        GatoViewBorderRadius(cell, 0, 1, [UIColor appAllBackColor]);
        return cell;
    }else if (indexPath.row == 1){
        TeamInfoMessageTableViewCell * cell = [TeamInfoMessageTableViewCell cellWithTableView:tableView];
        [cell setValueWithTitle:@"群公告" WithType:0 WithCenter:self.teamModel.noticeContent];
        centerCellHeight = cell.height;
        return cell;
    }else if (indexPath.row == 2){
        TeamInfoMessageTableViewCell * cell = [TeamInfoMessageTableViewCell cellWithTableView:tableView];
//        BOOL nowGroupIdPush = NO;
//        NSArray * groupArray = [[EMClient sharedClient].groupManager getJoinedGroups];
//        for (int i = 0 ; i < groupArray.count ; i ++) {
//            EMGroup * group = groupArray[i];
//            NSLog(@"%@",group);
//            if ([group.groupId isEqualToString:self.groupId]) {
//                nowGroupIdPush = !group.isPushNotificationEnabled;
//            }
//        }
        [cell setValueWithGroupPush:nowGroupIdPush];
        [cell setValueWithTitle:@"消息免打扰" WithType:1 WithCenter:@""];
        cell.switchBlock = ^(BOOL isButtonOn){
            if (isButtonOn) {
                NSLog(@"VC-屏蔽") ;
                [weakSelf pingbixiaoxi];
            }else {
                NSLog(@"VC-取消屏蔽") ;
                [weakSelf quxiaopingbi];
            }
        };
        return cell;
    }else if (indexPath.row == 3){
        TeamInfoMessageTableViewCell * cell = [TeamInfoMessageTableViewCell cellWithTableView:tableView];
        [cell setValueWithTitle:@"清空聊天记录" WithType:2 WithCenter:@""];
        return cell;
    }else{
        Gato_tableviewcell_new
    }
  
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0) {
        return imageCellHeight;
    }else if (indexPath.row == 1){
        return Gato_Height_548_(42);
    }else if(indexPath.row == 2){
        return Gato_Height_548_(42);
    }else if(indexPath.row == 3){
        return Gato_Height_548_(42);
    }
    return 0;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 1) {
        if (![TOKEN isEqualToString:self.teamModel.doctorId] && self.teamModel.noticeContent.length < 1) {
            [self showHint:@"只有群主才能修改或设置群公告"];
        }else{
            TeamTextViewViewController *vc = [[TeamTextViewViewController alloc]init];
            vc.teamModel = self.teamModel;
            vc.updateTeamModel = ^(MyTeamModel *teamModel) {
                self.teamModel = teamModel;
            };
            vc.HomeTeamCome = @"1";
            [self.navigationController pushViewController:vc animated:YES];
        }
        
    }else if (indexPath.row == 2){
        
    }else if (indexPath.row == 3){
        [EMAlertView showAlertWithTitle:NSLocalizedString(@"prompt", @"Prompt")
                                message:@"清空聊天记录将无法恢复！是否确认"
                        completionBlock:^(NSUInteger buttonIndex, EMAlertView *alertView) {
                            if (buttonIndex == 1) {
                                [[NSNotificationCenter defaultCenter] postNotificationName:@"RemoveAllMessages" object:self.teamModel.groupId];
                            }
                        } cancelButtonTitle:NSLocalizedString(@"cancel", @"Cancel")
                      otherButtonTitles:NSLocalizedString(@"ok", @"OK"), nil];

    
    }
}

#pragma mark - 屏蔽消息
-(void)pingbixiaoxi
{
    
    NSMutableDictionary * Get_dic = [NSMutableDictionary dictionary];
    [Get_dic setObject:TOKEN forKey:@"doctorId"];
    [Get_dic setObject:self.teamModel.groupId forKey:@"groupId"];
    [Get_dic setObject:@"1" forKey:@"notDisturb"];
    [IWHttpTool postWithURL:set_team_disturb params:Get_dic success:^(id json) {
        NSDictionary * dic = [NSJSONSerialization JSONObjectWithData:json options:NSJSONReadingAllowFragments error:nil];
        NSString * success = [dic objectForKey:@"code"];
        if ([success isEqualToString:@"200"]) {
            [self showHint:@"设置成功"];
            nowGroupIdPush = YES;
        }else{
            
        }
        [self.GatoTableview reloadData];
    } failure:^(NSError *error) {
        NSLog(@"%@",error);
    }];
    
//    
//    [[EMClient sharedClient].groupManager updatePushServiceForGroup:self.groupId isPushEnabled:NO completion:^(EMGroup *aGroup, EMError *aError) {
//        if (aError) {
//            [self showHint:NSLocalizedString(@"屏蔽群消息失败，请重新尝试。", @"set failure")];
//        } else {
//            [self showHint:NSLocalizedString(@"已屏蔽群消息", @"set success")];
//        }
//    }];
    
//    [[EMClient sharedClient].groupManager blockGroup:self.groupId completion:^(EMGroup *aGroup, EMError *aError) {
//        
//        if (aError) {
//            [self showHint:NSLocalizedString(@"group.setting.fail", @"set failure")];
//        } else {
//            [self showHint:NSLocalizedString(@"已屏蔽群消息", @"set success")];
//        }
//    }];

}
#pragma mark - 取消屏蔽
-(void)quxiaopingbi
{
    
    NSMutableDictionary * Get_dic = [NSMutableDictionary dictionary];
    [Get_dic setObject:TOKEN forKey:@"doctorId"];
    [Get_dic setObject:self.teamModel.groupId forKey:@"groupId"];
    [Get_dic setObject:@"2" forKey:@"notDisturb"];
    [IWHttpTool postWithURL:set_team_disturb params:Get_dic success:^(id json) {
        NSDictionary * dic = [NSJSONSerialization JSONObjectWithData:json options:NSJSONReadingAllowFragments error:nil];
        NSString * success = [dic objectForKey:@"code"];
        if ([success isEqualToString:@"200"]) {
            [self showHint:@"设置成功"];
            nowGroupIdPush = NO;
            
        }else{
            
        }
        [self.GatoTableview reloadData];
    } failure:^(NSError *error) {
        NSLog(@"%@",error);
    }];
    
//    [[EMClient sharedClient].groupManager updatePushServiceForGroup:self.groupId isPushEnabled:YES completion:^(EMGroup *aGroup, EMError *aError) {
//        if (aError) {
//            [self showHint:NSLocalizedString(@"取消屏蔽群消息失败，请重新尝试。", @"set failure")];
//        } else {
//            [self showHint:NSLocalizedString(@"已取消屏蔽群消息", @"set success")];
//        }
//    }];
//    [[EMClient sharedClient].groupManager unblockGroup:self.groupId completion:^(EMGroup *aGroup, EMError *aError) {
//        
//        if (aError) {
//            [self showHint:NSLocalizedString(@"group.setting.fail", @"set failure")];
//        } else {
//            [self showHint:NSLocalizedString(@"已取消屏蔽群消息", @"set success")];
//        }
//    }];
}

-(UIButton *)deleteButton
{
    if (!_deleteButton) {
        _deleteButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_deleteButton setBackgroundColor:[UIColor HDTitleRedColor]];
        [_deleteButton setTitle:@"退出医疗组" forState:UIControlStateNormal];
        [_deleteButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _deleteButton.titleLabel.font = FONT(30);
        [_deleteButton addTarget:self action:@selector(deleteButtonDidClicked) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:_deleteButton];
    }
    return _deleteButton;
}
@end
