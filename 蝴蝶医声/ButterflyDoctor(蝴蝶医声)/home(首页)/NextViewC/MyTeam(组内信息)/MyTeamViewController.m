//
//  MyTeamViewController.m
//  butterflyDoctor
//
//  Created by 辛书亮 on 2017/4/21.
//  Copyright © 2017年 孟小猫. All rights reserved.
//

#import "MyTeamViewController.h"
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
@interface MyTeamViewController ()

@property (nonatomic ,strong) NSMutableArray * verifyArray;
@end

@implementation MyTeamViewController


-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self updateMyTeam];

//    [GatoMethods AleartViewWithMessage:@"38"];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    Gato_Return
    Gato_TableView
//    self.updataArray = [NSMutableArray array];
    self.GatoTableview.backgroundColor = [UIColor whiteColor];
//    self.verifyArray = [NSMutableArray array];
    self.title = @"我的小组";
    
    UIButton*rightButton = [[UIButton alloc]initWithFrame:CGRectMake(0,0,Gato_Width_320_(22),Gato_Height_548_(19))];
    [rightButton setBackgroundImage:[UIImage imageNamed:@"nav_add"] forState:UIControlStateNormal];
    [rightButton addTarget:self action:@selector(addteam)forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem*rightItem = [[UIBarButtonItem alloc]initWithCustomView:rightButton];
    self.navigationItem.rightBarButtonItem= rightItem;
   
    
     [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(payShoppingPayOK:) name:@"homeMessage" object:nil];
}


- (void)payShoppingPayOK:(NSNotification *)notification
{
    NSLog(@"我收到了MainViewController 发来的 homeMessage 通知");
    if ([notification.object isEqualToString:@"success"])
    {
            //刷新首页聊天数通知
        [self updateMyTeam];

//         [GatoMethods AleartViewWithMessage:@"71"];
    }
    
    
    
}

-(void)updateMyTeam
{
    NSMutableDictionary * dic = [NSMutableDictionary dictionary];
    [dic setObject:TOKEN forKey:@"token"];
    [IWHttpTool postWithURL:HD_chat_myTeam params:dic success:^(id json) {
        
        self.updataArray = [NSMutableArray array];
        self.verifyArray = [NSMutableArray array];
        
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
            
            
            
            NSArray * verifyArray = [[[dic objectForKey:@"data"] objectForKey:@"info"] objectForKey:@"verifyData"];
            for (int i = 0 ; i < verifyArray.count; i ++) {
                MyTeamVerifyModel * model = [[MyTeamVerifyModel alloc]init];
                [model setValuesForKeysWithDictionary:verifyArray[i]];
                [self.verifyArray addObject:model];
            }
        }else{
            NSString * falseMessage = [dic objectForKey:@"message"];
            [self showHint:falseMessage];
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
//        self.updataArray = [NSMutableArray array];
//        self.verifyArray = [NSMutableArray array];
//        [self updateMyTeam];
    };
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0) {
        return self.updataArray.count;
    }
    return self.verifyArray.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return Gato_Height_548_(30);
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView * view = [[UIView alloc]initWithFrame:Gato_CGRectMake(0, 0, 750, 30)];
    view.backgroundColor = [UIColor appAllBackColor];
    UIImageView * image = [[UIImageView alloc]init];
    [view addSubview:image];
    image.sd_layout.leftSpaceToView(view,Gato_Width_320_(15))
    .topSpaceToView(view,Gato_Height_548_(10))
    .widthIs(Gato_Width_320_(12))
    .heightIs(Gato_Height_548_(12));
    UILabel * label = [[UILabel alloc]init];
    label.font = FONT(30);
    label.textColor = [UIColor HDBlackColor];
    [view addSubview:label];
    label.sd_layout.leftSpaceToView(image,Gato_Width_320_(10))
    .topSpaceToView(view,0)
    .bottomSpaceToView(view,0)
    .rightSpaceToView(view,0);
    if (section == 0) {
        label.text = @"已有小组";
        image.image = [UIImage imageNamed:@"group_icon_group"];
    }else{
        label.text = @"等待审核";
        image.image = [UIImage imageNamed:@"group_icon_group"];
    }
    UIView * fgx = [[UIView alloc]init];
    fgx.backgroundColor = [UIColor HDViewBackColor];
    [view addSubview:fgx];
    fgx.sd_layout.leftSpaceToView(view,0)
    .rightSpaceToView(view,0)
    .bottomSpaceToView(view,0)
    .heightIs(1);
    
    return view;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        MyTeamHaveTableViewCell * cell = [MyTeamHaveTableViewCell cellWithTableView:tableView];
//        NSLog(@"%c",[EMConversation unreadMessagesCount]);
        MyTeamModel * model = [[MyTeamModel alloc]init];
        model = self.updataArray[indexPath.row];
        [cell setValueWithTeammembersImageArray:model.memberImages];
        [cell setValueWithPhoto:model.photo WithTitle:model.groupName];
        if (![self.comeForMine isEqualToString:@"0"]) {
            [cell setValueWithRedLabelWithNumberstr:model.unreadMessagesCount];
        }
        return cell;
    }else{
        MyTeamHaveTableViewCell * cell = [MyTeamHaveTableViewCell cellWithTableView:tableView];
        MyTeamVerifyModel * model = [[MyTeamVerifyModel alloc]init];
        model = self.verifyArray[indexPath.row];
        [cell setValueWithPhoto:model.photo WithTitle:model.name];
        [cell setValueWithHospital:[GatoMethods getStringWithLeftStr:model.hospital WithRightStr:model.hospitalDepartment]];
        return cell;
    }
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return Gato_Height_548_(79);
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (!self.comeForMine) {
        if (indexPath.section == 0) {
            [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeBlack];
            [SVProgressHUD show]; 
            MyTeamModel * model = [[MyTeamModel alloc]init];
            model = self.updataArray[indexPath.row];
            model.unreadMessagesCount = @"0";
            
            IMMessageOneForAllViewController *chatController = [[IMMessageOneForAllViewController alloc] initWithConversationChatter:model.groupId conversationType:EMConversationTypeGroupChat];
            chatController.teamModel = model;
            chatController.groupId = model.groupId ;
            chatController.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:chatController animated:YES];
            
        }
    }else{
        if (indexPath.section == 0) {
            MyTeamModel * model = [[MyTeamModel alloc]init];
            model = self.updataArray[indexPath.row];
            updateTeamViewController *chatController = [[updateTeamViewController alloc] init];
            chatController.teamModel = model;
            chatController.groupId = model.groupId ;
            chatController.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:chatController animated:YES];
        }
        
    }
    
}
- (void)dealloc
{
    NSLog(@"释放了");
}

@end
