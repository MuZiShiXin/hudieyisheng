//
//  updateTeamViewController.m
//  ButterflyDoctorVoice
//
//  Created by 辛书亮 on 2017/6/16.
//  Copyright © 2017年 辛书亮. All rights reserved.
//

#import "updateTeamViewController.h"
#import "GatoBaseHelp.h"
#import "TeamImageView.h"
#import "TeamImageModel.h"
#import "TeamInfoImageTableViewCell.h"
#import "DoctorHomeViewController.h"
#import "TeamInfoMessageTableViewCell.h"
#import "TeamTextViewViewController.h"
#import "MyTeamMemberModel.h"
#import "updateTeamTableViewCell.h"
#import "updateTeamAnnouncementTableViewCell.h"

#define get_team_disturb @"http://api.hudieyisheng.com/v1/home/get-team-disturb"
#define set_team_disturb @"http://api.hudieyisheng.com/v1/home/set-team-disturb"

@interface updateTeamViewController ()
{
    BOOL nowGroupIdPush ;
    CGFloat imageCellHeight;
    CGFloat centerCellHeight;
    BOOL imageCellZhankai;//defund NO;
    NSString * GoodCellZhankai;
    CGFloat cellHeightWithGood;
}
@property (nonatomic ,strong) UIButton * deleteButton;
@property (nonatomic ,strong) NSMutableArray * teamArray;
@end

@implementation updateTeamViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    Gato_Return
    self.title = @"组内成员";
    self.view.backgroundColor = [UIColor appAllBackColor];
    imageCellZhankai = NO;
    [self newData];
    [self oldMessage];
    self.teamArray = [NSMutableArray array];
    self.GatoTableview.frame = CGRectMake(0, 0, Gato_Width, Gato_Height - NAV_BAR_HEIGHT - Gato_Height_548_(96));\
    [self.view addSubview:self.GatoTableview];
//    Gato_TableView
    GoodCellZhankai = @"0";
    
    if (![self.teamModel.owner isEqualToString:GATO_PHOTO]){
        self.deleteButton.sd_layout.centerXEqualToView(self.view)
        .bottomSpaceToView(self.view,Gato_Height_548_(30))
        .widthIs(Gato_Width_320_(228))
        .heightIs(Gato_Height_548_(36));
        GatoViewBorderRadius(self.deleteButton, 3, 0, [UIColor redColor]);
    }else{
        self.GatoTableview.height = Gato_Height - NAV_BAR_HEIGHT;
    }
    
    
    MyTeamMemberModel * teamModel = [[MyTeamMemberModel alloc]init];
    for (int i = 0 ; i < self.teamModel.members.count ; i ++) {
        MyTeamMemberModel * model = [[MyTeamMemberModel alloc]init];
        model = self.teamModel.members[i];
        if ([model.phone isEqualToString:self.teamModel.owner]) {
            teamModel = model;
            break;
        }
    }
    for (int i = 0 ; i < self.teamModel.members.count ; i ++) {
        if (i == 0) {
            [self.teamArray addObject:teamModel];
        }
        MyTeamMemberModel * model = [[MyTeamMemberModel alloc]init];
        model = self.teamModel.members[i];
        if (![model.phone isEqualToString:self.teamModel.owner]) {
            [self.teamArray addObject:model];
        }
    }
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
            [self.navigationController popToRootViewControllerAnimated:YES];
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
    return self.teamArray.count + 4;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    __weak typeof(self) weakSelf = self;
    if (indexPath.row == 0){
        if (![self.teamModel.owner isEqualToString:GATO_PHOTO]) {
            updateTeamAnnouncementTableViewCell * cell = [updateTeamAnnouncementTableViewCell cellWithTableView:tableView];
            [cell setValueWithModel:self.teamModel.noticeContent WithZhankai:GoodCellZhankai];
            cell.zhankaigonggaoBlock = ^(){
                if ([self->GoodCellZhankai isEqualToString:@"0"]) {
                   self->GoodCellZhankai = @"1";
                }else{
                   self->GoodCellZhankai = @"0";
                }
                [weakSelf.GatoTableview reloadData];
            };
            cellHeightWithGood = cell.height;
            return cell;
        }else{
            TeamInfoMessageTableViewCell * cell = [TeamInfoMessageTableViewCell cellWithTableView:tableView];
            [cell setValueWithTitle:@"群公告" WithType:0 WithCenter:self.teamModel.noticeContent];
            centerCellHeight = cell.height;
            return cell;
        }
    }else if (indexPath.row == 1){
        TeamInfoMessageTableViewCell * cell = [TeamInfoMessageTableViewCell cellWithTableView:tableView];
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
    }else if (indexPath.row == 2){
        TeamInfoMessageTableViewCell * cell = [TeamInfoMessageTableViewCell cellWithTableView:tableView];
        [cell setValueWithTitle:@"清空聊天记录" WithType:2 WithCenter:@""];
        return cell;
    }else if (indexPath.row == 3){
        static NSString * cell_id03 = @"UITableViewCell";\
        UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:cell_id03];\
        if (cell == nil) {\
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cell_id03];\
        }\
        cell.backgroundColor = [UIColor appAllBackColor];\
        UIView * fgx = [[UIView alloc]init];
        fgx.backgroundColor = [UIColor HDViewBackColor];
        [cell addSubview:fgx];
        fgx.frame = CGRectMake(0, Gato_Height_548_(9.5), Gato_Width, Gato_Height_548_(0.5));
        return cell;
    }else{
        updateTeamTableViewCell * cell = [updateTeamTableViewCell cellWithTableView:tableView];
        [cell setValueWithModel:self.teamArray[indexPath.row - 4] WithGodPhone:self.teamModel.owner];
        return cell;
    }
    
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
//    if (indexPath.row == 0) {
//        return imageCellHeight;
//    }else
    if (indexPath.row == 0){
        if (![self.teamModel.owner isEqualToString:GATO_PHOTO]) {
            if (self.teamModel.noticeContent.length < 1) {
                return 0;
            }
            return cellHeightWithGood;
        }else{
            return Gato_Height_548_(42);
        }
        
    }else if(indexPath.row == 1){
        return Gato_Height_548_(42);
    }else if(indexPath.row == 2){
        return Gato_Height_548_(42);
    }else if(indexPath.row == 3){
        return Gato_Height_548_(10);
    }
    return Gato_Height_548_(85);
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0) {
        if (![self.teamModel.owner isEqualToString:GATO_PHOTO]) {
        }else{
            TeamTextViewViewController *vc = [[TeamTextViewViewController alloc]init];
            vc.teamModel = self.teamModel;
            vc.updateTeamModel = ^(MyTeamModel *teamModel) {
                self.teamModel = teamModel;
            };
            [self.navigationController pushViewController:vc animated:YES];
        }
    }else if (indexPath.row == 1){
        
    }else if (indexPath.row == 2){
        [EMAlertView showAlertWithTitle:NSLocalizedString(@"prompt", @"Prompt")
                                message:@"清空聊天记录将无法恢复！是否确认"
                        completionBlock:^(NSUInteger buttonIndex, EMAlertView *alertView) {
                            if (buttonIndex == 1) {
                                [[NSNotificationCenter defaultCenter] postNotificationName:@"RemoveAllMessages" object:self.groupId];
                            }
                        } cancelButtonTitle:NSLocalizedString(@"cancel", @"Cancel")
                      otherButtonTitles:NSLocalizedString(@"ok", @"OK"), nil];
        
        
    }else if (indexPath.row == 3){
        
    }else{
        MyTeamMemberModel * model = [[MyTeamMemberModel alloc]init];
        model = self.teamArray[indexPath.row - 4];
        DoctorHomeViewController * vc = [[DoctorHomeViewController alloc]init];
        vc.doctorId = model.doctorId;
        vc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:YES];
    }
}

//先要设Cell可编辑
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([self.teamModel.owner isEqualToString:GATO_PHOTO])
    {
        if (indexPath.row > 4) {
            return YES;
        }
        return NO;
    }else{
        return NO;
    }
    
}
//定义编辑样式
- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewCellEditingStyleDelete;
}
//进入编辑模式，按下出现的编辑按钮后,进行操作
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    //召回患者
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"提示" message:@"是否删除该成员？" preferredStyle:UIAlertControllerStyleAlert];
    [alertController addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
    }]];
    [alertController addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        MyTeamMemberModel * memberModel = [[MyTeamMemberModel alloc]init];
        memberModel = self.teamArray[indexPath.row - 4];
        [self deleteOnePeopleWithID:memberModel.doctorId];
        
//        EMError *error = nil;
//        [[EMClient sharedClient].groupManager removeOccupants:@[memberModel.photo] fromGroup:self.groupId error:&error];
    }]];
    [self presentViewController:alertController animated:YES completion:nil];
}
//修改编辑按钮文字
- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return @"删除\n成员";
}

-(void)deleteOnePeopleWithID:(NSString *)doctorId
{
    NSMutableDictionary * dic = [NSMutableDictionary dictionary];
    [dic setObject:TOKEN forKey:@"token"];
    [dic setObject:self.teamModel.groupId forKey:@"groupId"];
    [dic setObject:doctorId forKey:@"passivityRemoveDoctorId"];
    [IWHttpTool postWithURL:HD_chat_Team_DeleteOne params:dic success:^(id json) {
        
        NSDictionary * dic = [NSJSONSerialization JSONObjectWithData:json options:NSJSONReadingAllowFragments error:nil];
        NSString * success = [dic objectForKey:@"code"];
        if ([success isEqualToString:@"200"]) {
            [self showHint:@"删除成功"];
            for (int i = 0 ; i < self.teamArray.count ; i ++) {
                MyTeamMemberModel * teammodel = [[MyTeamMemberModel alloc]init];
                teammodel = self.teamArray[i];
                if ([teammodel.doctorId isEqualToString:doctorId]) {
                    [self.teamArray removeObjectAtIndex:i];
                    [self.GatoTableview reloadData];
                }
            }
        }else{
            
        }
        [self.GatoTableview reloadData];
    } failure:^(NSError *error) {
        NSLog(@"%@",error);
    }];
}
#pragma mark - 屏蔽消息
-(void)pingbixiaoxi
{
//    [[EMClient sharedClient].groupManager blockGroup:self.groupId completion:^(EMGroup *aGroup, EMError *aError) {
//        
//        if (aError) {
//            [self showHint:NSLocalizedString(@"设置失败", @"set failure")];
//        } else {
//            [self showHint:NSLocalizedString(@"已屏蔽群消息", @"set success")];
//        }
//    }];
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
//    [[EMClient sharedClient].groupManager unblockGroup:self.groupId completion:^(EMGroup *aGroup, EMError *aError) {
//        
//        if (aError) {
//            [self showHint:NSLocalizedString(@"设置失败", @"set failure")];
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
