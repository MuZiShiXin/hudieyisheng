//
//  MineHomeViewController.m
//  butterflyDoctor
//
//  Created by 辛书亮 on 2017/5/3.
//  Copyright © 2017年 孟小猫. All rights reserved.
//

#import "MineHomeViewController.h"
#import "GatoBaseHelp.h"
#import "MineHomeInfoImageTableViewCell.h"
#import "MineHomeTitleButtonTableViewCell.h"
#import "MineInfoDataViewController.h"
#import "MineHomeSetUpViewController.h"
#import "MyCardViewController.h"
#import "ButterflyMoney.h"
#import "MyTeamViewController.h"
#import "loginViewController.h"
#import "butterflyLevelViewController.h"
#import "APPMessageViewController.h"
#import "MineBankCardViewController.h"
#import "addBankCardViewController.h"
#import "MyAccountViewController.h"
#import "MyAccountDetailVC.h"
#import "PayLoginPasswordViewController.h"
#import "MyTeamAuditViewController.h"
#import "MineHomeModel.h"
#import "validationPasswordViewController.h"
#import "UITabBar+bedge.h"
#import "TeamCardViewController.h"
#import "AppDelegate.h"
#import "MainViewController.h"
#import "AllCommentsViewController.h"
@interface MineHomeViewController ()<UIActionSheetDelegate>
{
    
}
@property (nonatomic ,strong) UIImageView * topUnderImage;//上方半圆背景
@property (nonatomic ,strong) NSArray * titleArray;
@property (nonatomic ,strong) NSArray * imageArray;
@property (nonatomic ,strong) MineHomeModel * model;
@end

@implementation MineHomeViewController


-(void)viewWillAppear:(BOOL)animated
{
    [self updata];
}

+(void)pushIndex:(NSInteger )row
{
    AppDelegate *app = (AppDelegate *)[UIApplication sharedApplication].delegate;
    MainViewController *tab = (MainViewController *)app.window.rootViewController;
    tab.selectedIndex = row;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @" ";
    self.tabBarItem.title = [NSString stringWithFormat:@"我的"];
    
    self.topUnderImage.sd_layout.leftSpaceToView(self.view,0)
    .rightSpaceToView(self.view,0)
    .topSpaceToView(self.view,0)
    .heightIs(Gato_Height_548_(100));
    
    
    //自定义一个NaVIgationBar
    [self.navigationController.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
    //消除阴影
    self.navigationController.navigationBar.shadowImage = [UIImage new];
    Gato_TableView
    self.GatoTableview.height = Gato_Height - Tab_BAr_Height - NAV_BAR_HEIGHT;
    self.GatoTableview.backgroundColor = [UIColor clearColor];
    
    UIButton*right2Button = [[UIButton alloc]initWithFrame:CGRectMake(0,0,Gato_Width_320_(19),Gato_Height_548_(18))];
    [right2Button setBackgroundImage:[UIImage imageNamed:@"nav_set"] forState:UIControlStateNormal];
    right2Button.titleLabel.font = FONT(30);
    [right2Button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [right2Button addTarget:self action:@selector(mineOtherButtonItem)forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem*rightItem2 = [[UIBarButtonItem alloc]initWithCustomView:right2Button];
    self.navigationItem.rightBarButtonItems = @[rightItem2];
    

    
}

+ (void)updataWithMineHome
{
//    __weak __typeof(self) weakSelf = self;
//    [weakSelf updata];
} 
-(void)updata
{
    if (!TOKEN) {
        return;
    }
    if ([GatoMethods getTeamAndPeopleNumberWithunread] > 0) {
        [self.tabBarController.tabBar showBadgeOnItemIndex:0];
    }else{
        [self.tabBarController.tabBar hideBadgeOnItemIndex:0];
    }
    
    self.updateParms = [NSMutableDictionary dictionary];
    [self.updateParms setObject:TOKEN forKey:@"token"];
    self.model = [[MineHomeModel alloc]init];
    [IWHttpTool postWithURL:HD_Mine_Info params:self.updateParms success:^(id json) {
        
        NSDictionary * dic = [NSJSONSerialization JSONObjectWithData:json options:NSJSONReadingAllowFragments error:nil];
        NSString * success = [dic objectForKey:@"code"];
        if ([success isEqualToString:@"200"]) {
            [self.model setValuesForKeysWithDictionary:[[dic objectForKey:@"data"] objectForKey:@"info"]];
            NSInteger  TeamGM = [self.model.isTeam integerValue];//0组员 1组长
            if (TeamGM == 0) {
                //如果是组长 @[@"我的医疗组",@"加组申请审核"],
                self.titleArray = @[@[@"医疗组名片"],
                                    @[@"我的医疗组"],
                                    @[@"我的蝴蝶币",@"我的蝴蝶等级"],
                                    @[@"我的账户",@"提现明细",@"我的提现银行卡"],
                                    @[@"站内消息"],
                                    @[@"退出登录"],
                                    @[]];
                //如果是组长 @[@"mine_icon2",@"mine_icon10"],
                self.imageArray = @[@[@"mine_icon1"],
                                    @[@"mine_icon2"],
                                    @[@"mine_icon3",@"mine_icon4"],
                                    @[@"mine_icon5",@"mine_icon6",@"mine_icon7"],
                                    @[@"mine_icon8"],
                                    @[@"mine_icon9"],
                                    @[]];
            }else{
                //如果是组长 @[@"我的医疗组",@"加组申请审核"],
                self.titleArray = @[@[@"医疗组名片"],
                                    @[@"我的医疗组",@"加组申请审核"],
                                    @[@"我的蝴蝶币",@"我的蝴蝶等级"],
                                    @[@"我的账户",@"提现明细",@"我的提现银行卡"],
                                    @[@"站内消息"],
                                    @[@"退出登录"],
                                    @[]];
                //如果是组长 @[@"mine_icon2",@"mine_icon10"],
                self.imageArray = @[@[@"mine_icon1"],
                                    @[@"mine_icon2",@"mine_icon10"],
                                    @[@"mine_icon3",@"mine_icon4"],
                                    @[@"mine_icon5",@"mine_icon6",@"mine_icon7"],
                                    @[@"mine_icon8"],
                                    @[@"mine_icon9"],
                                    @[]];
            }
            
            NSString * teamApplyCount = self.model.teamApplyCount;
            NSString * noReadMessageCount = self.model.noReadMessageCount;
            if ([teamApplyCount integerValue] + [noReadMessageCount integerValue] > 0) {
                [self.tabBarController.tabBar showBadgeOnItemIndex:3];
            }else{
                [self.tabBarController.tabBar hideBadgeOnItemIndex:3];
            }
            
            [self.GatoTableview reloadData];
        }else{
            NSString * falseMessage = [dic objectForKey:@"message"];
            [self showHint:falseMessage];
        }
        
    } failure:^(NSError *error) {
        NSLog(@"%@",error);
    }];
}

#pragma mark  - 设置
-(void)mineOtherButtonItem
{
    MineHomeSetUpViewController * vc = [[MineHomeSetUpViewController alloc]init];
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{

    return self.titleArray.count + 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0) {
        return 1;
    }
    NSArray * countArray = self.titleArray[section - 1];
    return countArray.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return 0;
    }
    else if(section == 3){
        return 0;
    }
    return Gato_Height_548_(10);
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView * view = [[UIView alloc]initWithFrame:Gato_CGRectMake(0, 0, Gato_Width, Gato_Height_548_(10))];
    view.backgroundColor = [UIColor appAllBackColor];
    
    UIView * fgx = [[UIView alloc]init];
    fgx.backgroundColor = [UIColor HDViewBackColor];
    [view addSubview:fgx];
    fgx.sd_layout.leftSpaceToView(view,0)
    .rightSpaceToView(view,0)
    .topSpaceToView(view,0)
    .heightIs(0.5);
    
    UIView * fgx1 = [[UIView alloc]init];
    fgx1.backgroundColor = [UIColor HDViewBackColor];
    [view addSubview:fgx1];
    fgx1.sd_layout.leftSpaceToView(view,0)
    .rightSpaceToView(view,0)
    .bottomSpaceToView(view,0)
    .heightIs(0.5);
    return view;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        MineHomeInfoImageTableViewCell * cell = [MineHomeInfoImageTableViewCell cellWithTableView:tableView];
        [cell setValueWithModel:self.model];
        return cell;
    }else{
        MineHomeTitleButtonTableViewCell * cell = [MineHomeTitleButtonTableViewCell cellWithTableView:tableView];
        if (indexPath.section == 3) {
            
        }else{
            [cell setValueWithImage:self.imageArray[indexPath.section - 1][indexPath.row] WithTitle:self.titleArray[indexPath.section - 1][indexPath.row]];
        }

        if ([self.model.isTeam isEqualToString:@"1"]) {
            if (indexPath.section == 2) {
                if (indexPath.row == 1) {
                    if (![self.model.teamApplyCount isEqualToString:@"0"]) {
                        [cell setValueWithTeamNumber:self.model.teamApplyCount];
                    }
                }
            }
        }
        if (indexPath.section == 5) {
            if (![self.model.noReadMessageCount isEqualToString:@"0"]) {
                [cell setValueWithTeamNumber:self.model.noReadMessageCount];
            }
        }
        if (indexPath.row == 0) {
            [cell fgxHidden];
        }
        return cell;
    }
    Gato_tableviewcell_new
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0)
    {
        return Gato_Height_548_(300);
    }
    else
    {
        if (indexPath.section == 3)
        {
            return 0;
        }
        return Gato_Height_548_(40);
    }
    return 0;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section > 0) {
        NSLog(@"点击按钮 %@",self.titleArray[indexPath.section - 1][indexPath.row]);
        switch (indexPath.section) {
            case 1:
            {
                if (indexPath.row == 0) {
                    TeamCardViewController *vc = [[TeamCardViewController alloc] init];
                    vc.hidesBottomBarWhenPushed = YES;
                    [self.navigationController pushViewController:vc animated:YES];
                }
            }
                break;
            case 2:{
                if (indexPath.row == 0) {
                    MyTeamViewController * vc = [[MyTeamViewController alloc]init];
                    vc.comeForMine = @"0";
                    vc.hidesBottomBarWhenPushed = YES;
                    [self.navigationController pushViewController:vc animated:YES];
                }else{
                    MyTeamAuditViewController * vc = [[MyTeamAuditViewController alloc]init];
                    vc.hidesBottomBarWhenPushed = YES;
                    [self.navigationController pushViewController:vc animated:YES];
                }
            }
                break;
            case 3:
            {
                if (indexPath.row == 0) {
                    ButterflyMoney *vc = [[ButterflyMoney alloc] init];
                    vc.hidesBottomBarWhenPushed = YES;
                    [self.navigationController pushViewController:vc animated:YES];
                }else{
                    butterflyLevelViewController * vc = [[butterflyLevelViewController alloc]init];
                    vc.hidesBottomBarWhenPushed = YES;
                    [self.navigationController pushViewController:vc animated:YES];
                }
            }
                break;
            case 4:
            {
                if ([self.model.isSetSafePassword isEqualToString:@"1"]) {
                    validationPasswordViewController * vc =[[validationPasswordViewController alloc]init];
                    vc.pushType = indexPath.row;
                    vc.hidesBottomBarWhenPushed = YES;
                    [self.navigationController pushViewController:vc animated:YES];
                }else{
                    [self PushWithPayPasswordWithIndex:indexPath];
                }
                
                
            }
                break;
            case 5:
            {
                APPMessageViewController * vc = [[APPMessageViewController alloc]init];
                vc.isSetSafePassword = self.model.isSetSafePassword;
                vc.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:vc animated:YES];
            }
                break;
            case 6:{
                UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"提示" message:@"是否退出当前登录账号？" preferredStyle:UIAlertControllerStyleAlert];
                [alertController addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                    
                }]];
                [alertController addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
                    EMError *error = [[EMClient sharedClient] logout:YES];
                    if (!error) {
                        NSLog(@"退出成功");
                    }
                    [self logout];
                    
                }]];
                [self presentViewController:alertController animated:YES completion:nil];
            }
                break;
            default:
                break;
        }
        
    }else{
//        AllCommentsViewController * vc = [[AllCommentsViewController alloc]init];
//        vc.doctorId = TOKEN;
//        [self.navigationController pushViewController:vc animated:YES];
        MineInfoDataViewController * vc = [[MineInfoDataViewController alloc]init];
//        vc.updateInfo = ^(){
//            [self updata];
//        };
        vc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:YES];
    }
}
#pragma mark - 退出登录
-(void)logout
{
    if (!TOKEN) {
        return;
    }
    self.updateParms = [NSMutableDictionary dictionary];
    [self.updateParms setObject:TOKEN forKey:@"token"];
    [IWHttpTool postWithURL:HD_OUT_TOKEN params:self.updateParms success:^(id json) {
        
        NSDictionary * dic = [NSJSONSerialization JSONObjectWithData:json options:NSJSONReadingAllowFragments error:nil];
        NSString * success = [dic objectForKey:@"code"];
        if ([success isEqualToString:@"200"]) {
            [[NSUserDefaults standardUserDefaults] removeObjectForKey:GET_TOKEN];
            [[NSUserDefaults standardUserDefaults] setObject:@"1" forKey:GET_Again_Login];
            loginViewController *login = [[loginViewController alloc] init];
            UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:login];
            [self presentViewController:nav animated:NO completion:nil];
        }else{
            NSString * falseMessage = [dic objectForKey:@"message"];
            [self showHint:falseMessage];
        }
        
    } failure:^(NSError *error) {
        NSLog(@"%@",error);
    }];
    
}
-(void)PushWithPayPasswordWithIndex:(NSIndexPath *)indexPath
{
    UIAlertController *alterController = [UIAlertController alertControllerWithTitle:@"提示"
                                                                             message:@"需要设定安全,是否现在设定"
                                                                      preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *actionCancel = [UIAlertAction actionWithTitle:@"取消"
                                                           style:UIAlertActionStyleDefault
                                                         handler:^(UIAlertAction * _Nonnull action) {
                                                             
                                                         }];
    
    UIAlertAction *actionSubmit = [UIAlertAction actionWithTitle:@"确定"
                                                           style:UIAlertActionStyleDefault
                                                         handler:^(UIAlertAction * _Nonnull action) {
                                                             PayLoginPasswordViewController * vc = [[PayLoginPasswordViewController alloc]init];
                                                             vc.hidesBottomBarWhenPushed = YES;
                                                             [self.navigationController pushViewController:vc animated:YES];
                                                         }];
    
    [alterController addAction:actionCancel];
    [alterController addAction:actionSubmit];
    [self presentViewController:alterController animated:YES completion:^{}];
}

-(UIImageView * )topUnderImage
{
    if (!_topUnderImage) {
        _topUnderImage = [[UIImageView alloc]init];
        _topUnderImage.image = [UIImage imageNamed:@"mine_bg_head-portrait"];
        [self.view addSubview:_topUnderImage];
    }
    return _topUnderImage;
}
@end
