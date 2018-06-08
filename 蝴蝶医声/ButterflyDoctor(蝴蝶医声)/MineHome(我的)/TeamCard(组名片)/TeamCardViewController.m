//
//  TeamCardViewController.m
//  ButterflyDoctorVoice
//
//  Created by 辛书亮 on 2017/7/19.
//  Copyright © 2017年 辛书亮. All rights reserved.
//

#import "TeamCardViewController.h"
#import "GatoBaseHelp.h"
#import "MyTeamHaveTableViewCell.h"
#import "addnewteamViewController.h"
#import "EaseMessageViewController.h"

#import <Foundation/Foundation.h>
#import <Photos/Photos.h>
#import <AssetsLibrary/AssetsLibrary.h>

#import "IMMessageOneForAllViewController.h"
#import "MyTeamModel.h"
#import "MyTeamMemberModel.h"
#import "MyTeamVerifyModel.h"
#import "updateTeamViewController.h"
#import "MyCardViewController.h"

#import "NulllabelModel.h"
#import "NullLabelTableViewCell.h"
@interface TeamCardViewController ()

@end

@implementation TeamCardViewController

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
   
}

- (void)viewDidLoad {
    [super viewDidLoad];
    Gato_Return
    Gato_TableView
    //    self.updataArray = [NSMutableArray array];
    self.GatoTableview.backgroundColor = [UIColor whiteColor];
    //    self.verifyArray = [NSMutableArray array];
    self.title = @"我的小组";
    
    self.updataArray = [NSMutableArray array];
    
    [self updateMyTeam];
    
    
    UIButton*rightButton = [[UIButton alloc]initWithFrame:CGRectMake(0,0,Gato_Width_320_(22),Gato_Height_548_(19))];
    [rightButton setBackgroundImage:[UIImage imageNamed:@"nav_add"] forState:UIControlStateNormal];
    [rightButton addTarget:self action:@selector(addteam)forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem*rightItem = [[UIBarButtonItem alloc]initWithCustomView:rightButton];
    self.navigationItem.rightBarButtonItem= rightItem;
    
}

-(void)updateMyTeam
{
    NSMutableDictionary * dic = [NSMutableDictionary dictionary];
    [dic setObject:TOKEN forKey:@"token"];
    [IWHttpTool postWithURL:HD_chat_myTeam params:dic success:^(id json) {
        
        NSDictionary * dic = [NSJSONSerialization JSONObjectWithData:json options:NSJSONReadingAllowFragments error:nil];
        NSString * success = [dic objectForKey:@"code"];
        if ([success isEqualToString:@"200"]) {
            NSArray * jsonArray = [[[dic objectForKey:@"data"] objectForKey:@"info"] objectForKey:@"groupData"];
            NSArray *conversations = [[EMClient sharedClient].chatManager getAllConversations];
            NSMutableArray * teamConversations = [NSMutableArray array];
            for (int i = 0 ; i < conversations.count; i ++) {
                EMConversation *conversation = [[EMConversation alloc]init];
                conversation = conversations[i];
                if (conversation.type == EMConversationTypeGroupChat) {
                    [teamConversations addObject:conversation];
                }
            }
            for (int i = 0 ; i < jsonArray.count; i ++) {
                MyTeamModel * model = [[MyTeamModel alloc]init];
                [model setValuesForKeysWithDictionary:jsonArray[i]];
                NSArray * memberArray = model.members;
                NSMutableArray * memberMutableArray = [NSMutableArray array];
                for (int j = 0 ; j < memberArray.count; j ++) {
                    MyTeamMemberModel * memberModel = [[MyTeamMemberModel alloc]init];
                    [memberModel setValuesForKeysWithDictionary:memberArray[j]];
                    [memberMutableArray addObject:memberModel];
                    
                }
                for (int j = 0 ; j < teamConversations.count ; j ++) {
                    NSInteger unreadCount = 0;
                    EMConversation *conversation = [[EMConversation alloc]init];
                    conversation = teamConversations[j];
                    if ([conversation.conversationId isEqualToString:model.groupId]) {
                        unreadCount = conversation.unreadMessagesCount;
                        NSLog(@"%@患者未读消息 %ld",conversation.conversationId,unreadCount);
                        model.unreadMessagesCount = [NSString stringWithFormat:@"%ld",unreadCount];
                    }
                }
                
                
                model.members = memberMutableArray;
                
                [self.updataArray addObject:model];
            }
            if (self.updataArray.count < 1) {
                NulllabelModel * model = [[NulllabelModel alloc]init];
                model.label = @"您的科室尚未有带组老师进行注册，如遇到问题请联系医助，感谢您的使用与支持！";
                [self.updataArray addObject:model];
            }
        }else{
            NSString * falseMessage = [dic objectForKey:@"message"];
            [self showHint:falseMessage];
            
            if (self.updataArray.count > 0) {
                if (![self.updataArray[0] isKindOfClass:[NulllabelModel class]]) {
                    [self showHint:falseMessage];
                }
            }else{
                NulllabelModel * model = [[NulllabelModel alloc]init];
                model.label = @"您的科室尚未有带组老师进行注册，如遇到问题请联系医助，感谢您的使用与支持！";
                [self.updataArray addObject:model];
            }
        }
        [self.GatoTableview reloadData];
    } failure:^(NSError *error) {
        NSLog(@"%@",error);
    }];
}


-(void)addteam
{
    addnewteamViewController * vc = [[addnewteamViewController alloc]init];
    vc.returnUpdateHttp = ^{
        self.updataArray = [NSMutableArray array];
        
        [self updateMyTeam];
    };
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return self.updataArray.count;
    
    
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

    if ([self.updataArray[0] isKindOfClass:[NulllabelModel class]]) {
        NullLabelTableViewCell * cell  = [NullLabelTableViewCell cellWithTableView:tableView];
        NulllabelModel * model = [[NulllabelModel alloc]init];
        model = self.updataArray[0];
        [cell setValueWithModel:model];
        return cell;
    }else{
        MyTeamHaveTableViewCell * cell = [MyTeamHaveTableViewCell cellWithTableView:tableView];
        //        NSLog(@"%c",[EMConversation unreadMessagesCount]);
        MyTeamModel * model = [[MyTeamModel alloc]init];
        model = self.updataArray[indexPath.row];
    //    [cell setValueWithTeammembersImageArray:model.memberImages];
        [cell setValueWithPhoto:model.photo WithTitle:model.groupName];
        return cell;
    }
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if ([self.updataArray[0] isKindOfClass:[NulllabelModel class]]) {
        return [NullLabelTableViewCell getHeightWithNullCellWithTableview:tableView];
    }else{
        return Gato_Height_548_(79);
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if ([self.updataArray[0] isKindOfClass:[NulllabelModel class]]) {
        
    }else{
        MyTeamModel * model = [[MyTeamModel alloc]init];
        model = self.updataArray[indexPath.row];
        MyCardViewController *chatController = [[MyCardViewController alloc] init];
        chatController.doctorId = model.doctorId;
        chatController.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:chatController animated:YES];
    }
}

@end
