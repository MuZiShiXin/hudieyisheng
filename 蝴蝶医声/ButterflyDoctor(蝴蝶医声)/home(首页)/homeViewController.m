//
//  homeViewController.m
//  butterflyDoctor
//
//  Created by 辛书亮 on 2017/4/18.
//  Copyright © 2017年 孟小猫. All rights reserved.
//

#import "homeViewController.h"
#import "GatoBaseHelp.h"
#import "HomeLBTTableViewCell.h"
#import "HomeInfoTableViewCell.h"
#import "HomeTopButtonTableViewCell.h"
#import "HomeFivePushTableViewCell.h"
#import "HomeTitleAndMoreTableViewCell.h"
#import "HomeDoctorTableViewCell.h"
#import "AllNumberViewController.h"
#import "TheArticleViewController.h"
#import "releaseStopWorkViewController.h"
#import "MyTeamViewController.h"
#import "AppDelegate.h"
#import "DLTabBarController.h"
#import "WaitingSurgeryViewController.h"
#import "AfterDischargeViewController.h"
#import "ImageMessageViewController.h"
#import "DoctorHomeViewController.h"
#import "MainViewController.h"
#import "EMNavigationController.h"
#import "HospitalizedPatientsViewController.h"
#import "HomeInfoModel.h"
#import <OpenUDID.h>
#import "PellTableViewSelect.h"
#import "MineInfoDataViewController.h"
#import "nextRigisteredViewController.h"
#import "PushPhoneTitleViewController.h"
#import "HomeWebViewController.h"
#import "MainViewController.h"
#import "UITabBar+bedge.h"
#import "MineHomeModel.h"
#import "AllTeamViewController.h"
#import "makeArticleViewController.h"
#import "AllTitleWebViewController.h"
#import "nextRigisteredViewController.h"
#import "loginViewController.h"
#import "LookMessageView.h"
#import "HomeInformationPatientsTableViewCell.h"
@interface homeViewController ()<UITextFieldDelegate>
{
    CGFloat page;
    BOOL adimageShow;//define No
    NSString * updateAppUrl;//如果有 证明需要更新
    CGFloat  cellH;
}
@property (nonatomic ,strong) UIImageView * guanggaoImage;//广告页面image
@property (strong, nonatomic) MainViewController *mainController;
@property (nonatomic ,strong) HomeInfoModel * topInfoModel;
@property (nonatomic ,strong) NSString * phoneNumber;
@property (nonatomic ,strong) NSMutableArray * bannerArray;
@property (nonatomic ,strong) UIView * phoneOLView;//呼叫客服
@property (nonatomic ,strong)UITextField * textfield;
@property (nonatomic ,strong)NSString * ImageMessageCount;
@property (nonatomic ,strong)NSString * teamMessageCount;

@end

homeViewController * DeleteTokenSele;

@implementation homeViewController
+ (void)deleteToken
{
    AppDelegate *app = (AppDelegate *)[UIApplication sharedApplication].delegate;
    MainViewController *tab = (MainViewController *)app.window.rootViewController;
    tab.selectedIndex = 0;
    
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:GET_TOKEN];
//    UINavigationController *ANavigationController = [[UINavigationController alloc] initWithRootViewController:[[loginViewController alloc] init]];
//    [DeleteTokenSele presentViewController:ANavigationController animated:NO completion:nil];
    
    loginViewController *login = [[loginViewController alloc] init];
    app.window.rootViewController = [[UINavigationController alloc] initWithRootViewController:login];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"蝴蝶医声";
    self.tabBarItem.title = [NSString stringWithFormat:@"工作站"];
    self.GatoTableview.frame = CGRectMake(0, 0, Gato_Width, Gato_Height - NAV_BAR_HEIGHT);
    [self.view addSubview:self.GatoTableview];
    self.updataArray = [NSMutableArray array];
    self.bannerArray = [NSMutableArray array];
    cellH=25;
    page = 0;
    self.teamMessageCount = @"0";
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        //       更新医生信息
        [self updataDoctor];
        //        [self updateBanner];
        //        获取版本信息
        [self updateHttp];
        //        活跃度上传
        [self updateactive];
    });
    
    //监控程序在后台进入掉起
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(appDidEnterPlayGround) name:UIApplicationDidBecomeActiveNotification object:nil];
    
    //下拉刷新
    self.GatoTableview.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewTopic)];
    //自动更改透明度
    self.GatoTableview.mj_header.automaticallyChangeAlpha = YES;
    //获取欢迎页图片
    [self welcomeImage];
    
    //显示
    [self.tabBarController.tabBar showBadgeOnItemIndex:3];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(payShoppingPayOK:) name:@"homeMessage" object:nil];
    
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    self.tabBarController.tabBar.hidden = NO;
    
//    获取头部个人信息
    [self updataInfo];
//   图文资讯未读数量
    [self addMessageNumberHttp];
//   我的小红点处理
    [self mineMessage];
//    请求banner图片
    [self updateBanner];

    [SVProgressHUD dismiss];
    if ([Gato_HomeAD_Hidden isEqualToString:@"0"])
    {
        
    }
    else
    {
        //延时操作方法
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(10 * NSEC_PER_SEC)),dispatch_get_main_queue(), ^{
            if (self.guanggaoImage)
            {
                NSLog(@"超过10s 销毁广告页");
                [self.guanggaoImage removeFromSuperview];
            }
        });
        NSLog(@"GATO_Again_Login %@",GATO_Again_Login);
//        如果是正常进入 无所谓 如果是通过jpush 进入app 那么 不再运行首页广告 当 1 就是jpush进入  其他正常
        if (![GATO_JPush_Welcome_AD isEqualToString:@"1"])
        {
//            要求每次登录都要有广告，所有 当退出登录后【非首次登陆】 就记录为 1  当触发1状态 显示广告 然后remove
            if ([GATO_Again_Login isEqualToString:@"1"])
            {
                adimageShow = YES;
                [[NSUserDefaults standardUserDefaults] removeObjectForKey:GET_Again_Login];
                UIWindow *win = [UIApplication sharedApplication].keyWindow;
                self.guanggaoImage = [[UIImageView alloc]initWithFrame:win.bounds];
                NSLog(@"%@",TOKEN);
                NSData *imageData = GATO_HOME_Image;
                UIImage *image = [UIImage imageWithData: imageData];
                self.guanggaoImage.image = image;
                [win addSubview:self.guanggaoImage];
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [UIView animateWithDuration:0.5 animations:^{
                        NSLog(@"隐藏广告页面");
                        self.guanggaoImage.y = Gato_Height;
                    }];
                });
            }
            else
            {
                if (adimageShow == NO)
                {
                    static dispatch_once_t disOnce;
                    dispatch_once(&disOnce,  ^ {
                        [[NSUserDefaults standardUserDefaults] removeObjectForKey:GET_Again_Login];
                        UIWindow *win = [UIApplication sharedApplication].keyWindow;
                        self.guanggaoImage = [[UIImageView alloc]initWithFrame:win.bounds];
                        NSLog(@"%@",TOKEN);
                        NSData *imageData = GATO_HOME_Image;
                        UIImage *image = [UIImage imageWithData: imageData];
                        self.guanggaoImage.image = image;
                        [win addSubview:self.guanggaoImage];
                        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                            [UIView animateWithDuration:0.5 animations:^{
                                NSLog(@"隐藏广告页面");
                                self.guanggaoImage.y = Gato_Height;
                            }];
                        });
                    });
                }
            }
        }
    }
}


- (void)payShoppingPayOK:(NSNotification *)notification
{
    NSLog(@"我收到了MainViewController 发来的 homeMessage 通知");
    if ([notification.object isEqualToString:@"success"])
    {
        //刷新首页聊天数通知
        [self addMessageNumberHttp];
        [self mineMessage];
    }
}
#pragma mark - 我的小红点处理
-(void)mineMessage
{
    if ([GatoMethods getTeamAndPeopleNumberWithunread] > 0) {
        [self.tabBarController.tabBar showBadgeOnItemIndex:0];
    }else{
        [self.tabBarController.tabBar hideBadgeOnItemIndex:0];
    }
    if (!TOKEN)
    {
        return;
    }
    self.updateParms = [NSMutableDictionary dictionary];
    [self.updateParms setObject:TOKEN forKey:@"token"];
    [IWHttpTool postWithURL:HD_Mine_Info params:self.updateParms success:^(id json) {
        
        NSDictionary * dic = [NSJSONSerialization JSONObjectWithData:json options:NSJSONReadingAllowFragments error:nil];
        NSString * success = [dic objectForKey:@"code"];
        if ([success isEqualToString:@"200"]) {
            MineHomeModel * model = [[MineHomeModel alloc]init];
            [model setValuesForKeysWithDictionary:[[dic objectForKey:@"data"] objectForKey:@"info"]];
            NSString * teamApplyCount = model.teamApplyCount;
            NSString * noReadMessageCount = model.noReadMessageCount;
            
            if ([teamApplyCount integerValue] + [noReadMessageCount integerValue] > 0) {
                [self.tabBarController.tabBar showBadgeOnItemIndex:3];
            }else{
                [self.tabBarController.tabBar hideBadgeOnItemIndex:3];
            }
            
        }else{
            NSString * falseMessage = [dic objectForKey:@"message"];
            [self showHint:falseMessage];
        }
        
    } failure:^(NSError *error) {
        NSLog(@"%@",error);
    } WithFlash:NO];
}

#pragma mark - 应用从后台进入前台
-(void)appDidEnterPlayGround
{
    if (updateAppUrl.length > 0) {
        [GatoMethods AlertControllerWithtitle:@"提示" WithMessage:@"已有新版本，是否前往更新" success:^{
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:updateAppUrl]];
        } error:^{
            exit(0);
        }  WithVC:self];
        return;
    }
    NSLog(@"应用从后台进入前台");
    [self addMessageNumberHttp];
    if (![self.topInfoModel.isVerify isEqualToString:@"1"]) {
        [self updataInfo];
    }
    
}
#pragma mark - 获取欢迎页医生图片
-(void)welcomeImage
{
    NSMutableDictionary * dic = [NSMutableDictionary dictionary];
    [IWHttpTool postWithURL:HD_Home_Welcome params:dic success:^(id json) {
        
        NSDictionary * dic = [NSJSONSerialization JSONObjectWithData:json options:NSJSONReadingAllowFragments error:nil];
        NSString * success = [dic objectForKey:@"code"];
        if ([success isEqualToString:@"200"])
        {
            NSString * imageUrl = [[[dic objectForKey:@"data"] objectForKey:@"info"] objectForKey:@"picUrl"];
            if (Gato_iPhoneXHeight > 0)
            {
                imageUrl = [[[dic objectForKey:@"data"] objectForKey:@"info"] objectForKey:@"picUrlx"];
            }
            UIImage * welcomeImage = [UIImage imageWithData: [NSData dataWithContentsOfURL:[NSURL URLWithString:imageUrl]]];
            [[NSUserDefaults standardUserDefaults] setObject:UIImagePNGRepresentation(welcomeImage) forKey:GET_Home_Image];
        }
        else
        {
            
        }
        NSLog(@"GATO_HOME_Image%@",GATO_HOME_Image);
    } failure:^(NSError *error) {
        NSLog(@"%@",error);
    } WithFlash:NO];
}

//刷新
-(void)loadNewTopic
{
    page = 0;
    self.updataArray = [NSMutableArray array];
    [self updataInfo];
    [self updataDoctor];
    [self mineMessage];
    [self addMessageNumberHttp];
    [self.GatoTableview.mj_header beginRefreshing];
    [self.GatoTableview.mj_header setHidden:NO];
}
#pragma mark - 获取新版本
-(void)updateHttp
{
    NSMutableDictionary * dic = [NSMutableDictionary dictionary];
    [dic setObject:@"ios" forKey:@"type"];
    [IWHttpTool postWithURL:HD_NewApp params:dic success:^(id json) {
        
        NSDictionary * dic = [NSJSONSerialization JSONObjectWithData:json options:NSJSONReadingAllowFragments error:nil];
        NSString * success = [dic objectForKey:@"code"];
        if ([success isEqualToString:@"200"]) {
            NSString * BundleString = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
            NSString * successBundle = [[[dic objectForKey:@"data"] objectForKey:@"info"] objectForKey:@"version"];
            NSString * updateUrl = [[[dic objectForKey:@"data"] objectForKey:@"info"] objectForKey:@"path"];
            NSString * updateContent =  [[[dic objectForKey:@"data"] objectForKey:@"info"] objectForKey:@"updateContent"];
            NSLog(@"BundleString %.2f   successBundle%.2f   updateUrl%@",[BundleString floatValue],[successBundle floatValue],updateUrl);
            if ([BundleString floatValue] < [successBundle floatValue]) {
                LookMessageView * view = [[LookMessageView alloc]init];
                [view setValueWithNumber:[NSString stringWithFormat:@"最新版本【%@】",successBundle] WithContent:updateContent];
                view.okButtonBlock = ^{
                    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:updateUrl]];
                };
                [PellTableViewSelect addPellTableViewSelectWithwithView:view WindowFrame:CGRectMake(0,0, Gato_Width, Gato_Height) WithViewFrame:CGRectMake(0,0, Gato_Width, Gato_Height) selectData:nil action:nil animated:YES];
            }
        }else{
            NSString * falseMessage = [dic objectForKey:@"message"];
        }
    } failure:^(NSError *error) {
        NSLog(@"%@",error);
    }];
}
#pragma mark - 活跃度上传
-(void)updateactive
{
    NSMutableDictionary * dic = [NSMutableDictionary dictionary];
    NSString * openUdid = [OpenUDID value];
    NSString * BundleString = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
    [dic setObject:@"ios" forKey:@"type"];
    [dic setObject:openUdid forKey:@"deviceId"];
    [dic setObject:BundleString forKey:@"version"];
    [IWHttpTool postWithURL:HD_NewApp_Down params:dic success:^(id json) {
        
        NSDictionary * dic = [NSJSONSerialization JSONObjectWithData:json options:NSJSONReadingAllowFragments error:nil];
        NSString * success = [dic objectForKey:@"code"];
        if ([success isEqualToString:@"200"]) {
           
        }else{
            
        }
        
    } failure:^(NSError *error) {
        NSLog(@"%@",error);
    }];
}
#pragma mark - 首页轮播图／荣誉轮播图
-(void)updateBanner
{
    self.updateParms = [NSMutableDictionary dictionary];
    [self.updateParms setObject:@"1" forKey:@"location"];
    [IWHttpTool postWithURL:HD_Home_Banner params:self.updateParms success:^(id json) {
        NSDictionary * dic = [NSJSONSerialization JSONObjectWithData:json options:NSJSONReadingAllowFragments error:nil];
        NSString * success = [dic objectForKey:@"code"];
        if ([success isEqualToString:@"200"]) {
            NSArray * jsonArray = [[dic objectForKey:@"data"] objectForKey:@"info"];
            [[NSUserDefaults standardUserDefaults] setObject:jsonArray forKey:GET_Mine_Banner];
            [self.bannerArray removeAllObjects];
            for (int i = 0 ; i < jsonArray.count; i ++)
            {
                HomeLBTModel *model = [[HomeLBTModel alloc]init];
                [model setValuesForKeysWithDictionary:jsonArray[i]];
                model.WebId = [jsonArray[i] objectForKey:@"id"];
                [self.bannerArray addObject:model];
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
#pragma mark - 获取头部个人信息 - 首页
-(void)updataInfo
{
    if (!TOKEN)
    {
//        审核未通过跳转登录页面
        [self shenheReturnNO];
        return;
    }
    self.updateParms = [NSMutableDictionary dictionary];
    [self.updateParms setObject:TOKEN forKey:@"token"];
    __weak __typeof(self) weakSelf = self;
    [IWHttpTool postWithURL:HD_Home_info params:self.updateParms success:^(id json) {
        
        NSDictionary * dic = [NSJSONSerialization JSONObjectWithData:json options:NSJSONReadingAllowFragments error:nil];
        NSString * success = [dic objectForKey:@"code"];
        if ([success isEqualToString:@"200"]) {
            self.topInfoModel = [[HomeInfoModel alloc]init];
            [self.topInfoModel setValuesForKeysWithDictionary:[[dic objectForKey:@"data"] objectForKey:@"info"]];
            [[NSUserDefaults standardUserDefaults] setObject:[[dic objectForKey:@"data"] objectForKey:@"info"] forKey:GET_Mine_Info];
            NSString *userOpenId = GATO_PHOTO;// 用户环信ID
            NSString *nickName = [NSString stringWithFormat:@"%@",self.topInfoModel.name];// 用户昵称
            NSString *avatarUrl = [NSString stringWithFormat:@"%@",self.topInfoModel.photo];// 用户头像（绝对路径）
            //   ???
            // 登录成功后，如果后端云没有缓存用户信息，则新增一个用户
            [UserWebManager createUser:userOpenId nickName:nickName avatarUrl:avatarUrl];
            
            if ([self.topInfoModel.isVerify isEqualToString:@"0"])
            {
                UIImageView * image = [[UIImageView alloc]init];
                NSData *imageData = GATO_HOME_Image;
                image.image = [UIImage imageWithData:imageData];
                
                [PellTableViewSelect addPellTableViewSelectWithwithView:image WindowFrame:CGRectMake(0, 0, Gato_Width, Gato_Height) WithViewFrame:CGRectMake(0, 0, Gato_Width, Gato_Height) selectData:nil action:nil animated:YES];
                
            }else if([self.topInfoModel.isVerify isEqualToString:@"-1"])
            {
                [self shenheReturnNO];
            }
            else
            {
                [PellTableViewSelect hiden];
            }
        }
        else
        {
            NSString * falseMessage = [dic objectForKey:@"message"];
            [self showHint:falseMessage];
        }
        [self.GatoTableview.mj_header endRefreshing];
        [weakSelf.GatoTableview reloadData];
    } failure:^(NSError *error) {
        NSLog(@"%@",error);
    } WithFlash:NO];
}
#pragma mark - 图文资讯未读数量
-(void)addMessageNumberHttp
{
    if (!TOKEN)
    {
        return;
    }
//    获取群组聊天未读数
    [self countNumberWithteam];
    self.updateParms = [NSMutableDictionary dictionary];
    [self.updateParms setObject:TOKEN forKey:@"token"];
    [IWHttpTool postWithURL:HD_Home_TWZX_Number params:self.updateParms success:^(id json) {
        
        NSDictionary * dic = [NSJSONSerialization JSONObjectWithData:json options:NSJSONReadingAllowFragments error:nil];
        NSLog(@"%@",dic);
        NSString * success = [dic objectForKey:@"code"];
        if ([success isEqualToString:@"200"])
        {
            self.ImageMessageCount = [[dic objectForKey:@"data"] objectForKey:@"info"];
        }
        else
        {
            NSString * falseMessage = [dic objectForKey:@"message"];
            [self showHint:falseMessage];
        }
//        刷新tableview
        [self.GatoTableview reloadData];
        if ([self.ImageMessageCount integerValue] + [self.teamMessageCount integerValue] == 0)
        {
            [self.tabBarController.tabBar hideBadgeOnItemIndex:0];
            //清空所有未读消息哦
            NSArray * array = [GatoMethods getAllMessageNumberEMC];
            for (int i = 0 ; i < array.count;i ++) {
                EMConversation *conversation = [[EMClient sharedClient].chatManager getConversation:array[i] type:EMConversationTypeChat createIfNotExist:NO];
                [conversation markAllMessagesAsRead:nil];
            }
        }
    } failure:^(NSError *error)
    {
        NSLog(@"%@",error);
    } WithFlash:NO];
    
}
#pragma mark - 获取群组聊天未读数
-(void)countNumberWithteam
{
    self.teamMessageCount = [NSString stringWithFormat:@"%ld",[GatoMethods getTeamNumberWithunread]];
    NSLog(@"群组消息未读数 %@",self.teamMessageCount);
    [self.GatoTableview reloadData];
}
-(void)updataDoctor
{
    if (!TOKEN)
    {
        return;
    }
    self.updateParms = [NSMutableDictionary dictionary];
    [self.updateParms setObject:TOKEN forKey:@"token"];
    [self.updateParms setObject:@"0" forKey:@"more"];
    [self.updateParms setObject:[NSString stringWithFormat:@"%.0f",page] forKey:@"page"];
//    __weak __typeof(self) weakSelf = self;
    [IWHttpTool postWithURL:HD_Home_info_Doctor params:self.updateParms success:^(id json) {
        
        NSDictionary * dic = [NSJSONSerialization JSONObjectWithData:json options:NSJSONReadingAllowFragments error:nil];
        NSString * success = [dic objectForKey:@"code"];
        if ([success isEqualToString:@"200"]) {
            NSArray * jsonArray = [[dic objectForKey:@"data"] objectForKey:@"info"];
            for (int i = 0 ; i < jsonArray.count ; i ++) {
                HonorHomeModel * model = [[HonorHomeModel alloc]init];
                [model setValuesForKeysWithDictionary:jsonArray[i]];
                [self.updataArray addObject:model];
            }
        }else{
//            NSString * falseMessage = [dic objectForKey:@"message"];
//            [self showHint:falseMessage];
        }
        [self.GatoTableview.mj_header endRefreshing];
        [self.GatoTableview reloadData];
    } failure:^(NSError *error) {
        NSLog(@"%@",error);
    }];
}
//打电话
-(void)updataPhoneNumber
{
    if (!TOKEN) {
        return;
    }
    self.updateParms = [NSMutableDictionary dictionary];
    [self.updateParms setObject:TOKEN forKey:@"token"];
    [self.updateParms setObject:@"" forKey:@"content"];
    [IWHttpTool postWithURL:HD_Home_PhoneNumber params:self.updateParms success:^(id json) {
        
        NSDictionary * dic = [NSJSONSerialization JSONObjectWithData:json options:NSJSONReadingAllowFragments error:nil];
        NSString * success = [dic objectForKey:@"code"];
        if ([success isEqualToString:@"200"]) {
            UIAlertController *alert1 = [UIAlertController alertControllerWithTitle:nil message:@"我们已收到您的反馈信息，我们将会在工作时间内与您取得联系" preferredStyle:(UIAlertControllerStyleAlert)];
            UIAlertAction *cancel1 = [UIAlertAction actionWithTitle:@"我知道了" style:(UIAlertActionStyleCancel) handler:nil];
            if ([cancel1 valueForKey:@"titleTextColor"]) {
                [cancel1 setValue:[UIColor HDThemeColor] forKey:@"titleTextColor"];
            }
            [alert1 addAction:cancel1];
            [self showDetailViewController:alert1 sender:nil];

        }else{
//            NSString * falseMessage = [dic objectForKey:@"message"];
//            [self showHint:falseMessage];
        }
        
    } failure:^(NSError *error) {
        NSLog(@"%@",error);
    }];
}
#pragma mark - 审核未通过-跳转重新登录
-(void)shenheReturnNO
{
//    [self showHint:@"审核被驳回，请重新注册，如有问题请联系客户"];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:GET_TOKEN];
    loginViewController *login = [[loginViewController alloc] init];
    [self presentViewController:login animated:NO completion:nil];
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    //隐藏下方热门医生标题+内容
//    return 5 + self.updataArray.count;
    return 5;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    __weak typeof(self) weakSelf =self;

    if (indexPath.row == 0)
    {
        HomeInfoTableViewCell * cell = [HomeInfoTableViewCell cellWithTableView:tableView];
        [cell setValueWithModel:self.topInfoModel];
        return cell;
    } else if (indexPath.row == 1)
    {
        HomeInformationPatientsTableViewCell* cell=[HomeInformationPatientsTableViewCell cellWithTableView:tableView];
       
        cell.upcell = ^{
            
            if (self->cellH==25) {
               self->cellH=4*Gato_Height_548_(16)+Gato_Height_548_(10);
            }
            else
            {
                self->cellH=25;
            }
        
            //一个cell刷新
            NSIndexPath *indexPath=[NSIndexPath indexPathForRow:1 inSection:0];
            [tableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath,nil] withRowAnimation:UITableViewRowAnimationNone];
        };
         cell.cellH=cellH;
        return cell;
    }
    
    else if (indexPath.row == 2)
    {
        HomeLBTTableViewCell * cell = [HomeLBTTableViewCell cellWithTableView:tableView];
        if (![self.topInfoModel.isVerify isEqualToString:@"1"])
        {
            if (self.bannerArray.count > 0) {
                NSMutableArray * array = [NSMutableArray array];
                [array addObject: self.bannerArray[0]];
                [cell setValueWithModel:array];
            }
        }
        else
        {
            [cell setValueWithModel:self.bannerArray];
        }
        
        cell.imageBlock = ^(HomeLBTModel *model)
        {
            HomeWebViewController * vc = [[HomeWebViewController alloc]init];
            if (model.linkurl.length > 0) {
                vc.pushUrl = model.linkurl;
            }
            else
            {
                vc.ContentId = model.WebId;
            }
            vc.hidesBottomBarWhenPushed = YES;
            [weakSelf.navigationController pushViewController:vc animated:YES];
        };
        return cell;
    }else if (indexPath.row == 3){
        HomeTopButtonTableViewCell * cell = [HomeTopButtonTableViewCell cellWithTableView:tableView];
        Gato_WeakSelf(self)
        cell.buttonBlock = ^(NSInteger row){
            switch (row) {
                case 0:
                    //住院患者
                {
                    AppDelegate *app = (AppDelegate *)[UIApplication sharedApplication].delegate;
                    MainViewController *tab = (MainViewController *)app.window.rootViewController;
                    tab.selectedIndex = 1;
                    
                }
                    break;
                case 1:
                    //等待病理
                {
                    WaitingSurgeryViewController * vc = [[WaitingSurgeryViewController alloc]init];
                    vc.hidesBottomBarWhenPushed = YES;
                    [weakself.navigationController pushViewController:vc animated:YES];
                }
                    break;
                case 2:
                    //随访
                {
                    AfterDischargeViewController * vc = [[AfterDischargeViewController alloc]init];
                    vc.hidesBottomBarWhenPushed = YES;
                    [weakself.navigationController pushViewController:vc animated:YES];
                }
                    break;
                case 3:
                    //图文资讯
                {
                    ImageMessageViewController * vc = [[ImageMessageViewController alloc]init];
                    vc.hidesBottomBarWhenPushed = YES;
                    [weakself.navigationController pushViewController:vc animated:YES];
                }
                    break;
                default:
                    break;
            }
        };
        
        [cell setValueWithImageMessageCount:self.ImageMessageCount];
        
        return cell;
    }else if (indexPath.row == 4)
    {
        HomeFivePushTableViewCell * cell = [HomeFivePushTableViewCell cellWithTableView:tableView];
        [cell teamMessageNumberWithCount:self.teamMessageCount];
        Gato_WeakSelf(self)
        cell.FiveButtonBlock = ^(NSInteger row){
            switch (row) {
                case 0:
                    //组内信息
                {
                    MyTeamViewController * vc = [[MyTeamViewController alloc]init];
                    [weakself pushNextViewControllerWithVC:vc];
//                    AppDelegate *app = (AppDelegate *)[UIApplication sharedApplication].delegate;
//                    MainViewController *tab = (MainViewController *)app.window.rootViewController;
//                    tab.selectedIndex = 2;
                }
                    break;
                case 1:
                    //数据统计
                {
                    AllNumberViewController * vc = [[AllNumberViewController alloc]init];
                    [weakself pushNextViewControllerWithVC:vc];
                }
                    break;
                case 2:
                    //文章
                {
                    TheArticleViewController * vc = [[TheArticleViewController alloc]init];
                    [weakself pushNextViewControllerWithVC:vc];
                }
                    break;
                case 3:
                    //我的助理
                {
//                     弹出封装
                    [PellTableViewSelect addPellTableViewSelectWithwithView:weakself.phoneOLView WindowFrame:CGRectMake(0, 0, Gato_Width, Gato_Height_548_(200)) WithViewFrame:CGRectMake(0, Gato_Height - Gato_Height_548_(200), Gato_Width, Gato_Height_548_(200)) selectData:nil action:nil animated:YES];
                }
                    break;
                case 4:
                    //发布出停诊
                {
                    releaseStopWorkViewController * vc = [[releaseStopWorkViewController alloc]init];
                    [weakself pushNextViewControllerWithVC:vc];
                }
                    break;
                default:
                    break;
            }
        };
        return cell;
    }else if (indexPath.row == 5){
        HomeTitleAndMoreTableViewCell * cell = [HomeTitleAndMoreTableViewCell cellWithTableView:tableView];
        [cell setValueWithTitle:@"热门医生"];
        cell.moreBlock = ^(){
            AppDelegate *app = (AppDelegate *)[UIApplication sharedApplication].delegate;
            MainViewController *tab = (MainViewController *)app.window.rootViewController;
            tab.selectedIndex = 2;
        };
        return cell;
    }else{
        HomeDoctorTableViewCell * cell = [HomeDoctorTableViewCell cellWithTableView:tableView];
        HonorHomeModel * model = [[HonorHomeModel alloc]init];
        model = self.updataArray[indexPath.row - 5];
//        [cell setValueWithTitle:indexPath.row - 5];
        [cell setValueWithModel:model WithTitle:indexPath.row - 5];
        return cell;
    }
    Gato_tableviewcell_new
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0) {
        return [HomeInfoTableViewCell getHeight];
    }else if (indexPath.row == 1)
    {
       return  Gato_Height_548_(cellH);
    }
    else if (indexPath.row == 2){
        return [HomeLBTTableViewCell getHeightForCell];
    }else if (indexPath.row == 3){
        return [HomeTopButtonTableViewCell getHeight];
    }else if (indexPath.row == 4){
        return [HomeFivePushTableViewCell getHetigh];
    }else if (indexPath.row == 5){
        return [HomeTitleAndMoreTableViewCell getHetigh];
    }else{
        return [HomeDoctorTableViewCell getHetigh];
    }
    return 0;
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0) {
//        nextRigisteredViewController * vc = [[nextRigisteredViewController alloc]init];
//        [self presentViewController:vc animated:YES completion:nil];
        MineInfoDataViewController * vc = [[MineInfoDataViewController alloc]init];
        vc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:YES];
    }
    if (indexPath.row > 4) {
        DoctorHomeViewController * vc = [[DoctorHomeViewController alloc]init];
        HonorHomeModel * model = [[HonorHomeModel alloc]init];
        model = self.updataArray[indexPath.row - 5];
        vc.doctorId = model.doctorId;
        vc.paimingNumber = [NSString stringWithFormat:@"%ld",indexPath.row - 4];
        vc.paiming = @"0";
        vc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:YES];
    }
}
#pragma mark - 打电话
-(void)MyHelpClicked
{
    [self updataPhoneNumber];
    [PellTableViewSelect hiden];
}
-(void)quxiaoMyHelpClicked
{
    [PellTableViewSelect hiden];
}

-(void)pushNextViewControllerWithVC:(UIViewController *)viewc
{
    viewc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:viewc animated:YES];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - 跳转留言
-(void)pushliuyanDidClicked
{
    [PellTableViewSelect hiden];
    
    PushPhoneTitleViewController * vc = [[PushPhoneTitleViewController alloc]init];

    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}

-(UIView * )phoneOLView
{
    if (!_phoneOLView) {
        _phoneOLView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, Gato_Width, Gato_Height_548_(140))];
        _phoneOLView.backgroundColor = [UIColor appAllBackColor];
        [self.view addSubview:_phoneOLView];
        
        
        UIView * imageButtonView = [[UIView alloc]init];
        imageButtonView.backgroundColor = [UIColor whiteColor];
        [self.phoneOLView addSubview:imageButtonView];
        imageButtonView.sd_layout.leftSpaceToView(self.phoneOLView, Gato_Width_320_(20))
        .rightSpaceToView(self.phoneOLView, Gato_Width_320_(20))
        .topSpaceToView(self.phoneOLView, Gato_Height_548_(15))
        .heightIs(Gato_Height_548_(45));
        
        GatoViewBorderRadius(imageButtonView, 3, 1, [UIColor HDViewBackColor]);
        
        UIImageView * image = [[UIImageView alloc]init];
        image.image = [UIImage imageNamed:@"zhaokefu0"];
        [imageButtonView addSubview:image];
        image.sd_layout.leftSpaceToView(imageButtonView, Gato_Width_320_(20))
        .centerYEqualToView(imageButtonView)
        .widthIs(Gato_Width_320_(26))
        .heightIs(Gato_Height_548_(26));
        
        UILabel * label = [[UILabel alloc]init];
        label.text = @"请医生助理回电话";
        label.font = FONT_Bold_(34);
        [imageButtonView addSubview:label];
        label.sd_layout.leftSpaceToView(image, Gato_Width_320_(15))
        .rightSpaceToView(imageButtonView, Gato_Width_320_(10))
        .centerYEqualToView(imageButtonView)
        .heightIs(Gato_Height_548_(45));
        
        
        UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button addTarget:self action:@selector(MyHelpClicked) forControlEvents:UIControlEventTouchUpInside];
        [imageButtonView addSubview:button];
        button.sd_layout.leftSpaceToView(imageButtonView, 0)
        .rightSpaceToView(imageButtonView, 0)
        .topSpaceToView(imageButtonView, 0)
        .bottomEqualToView(imageButtonView);
        
        
        UIView * tfview = [[UIView alloc]init];
        tfview.backgroundColor = [UIColor whiteColor];
        [self.phoneOLView addSubview:tfview];
        tfview.sd_layout.leftSpaceToView(self.phoneOLView, Gato_Width_320_(20))
        .rightSpaceToView(self.phoneOLView, Gato_Width_320_(20))
        .topSpaceToView(self.phoneOLView, Gato_Height_548_(75))
        .heightIs(Gato_Height_548_(45));
        
        GatoViewBorderRadius(tfview, 3, 1, [UIColor HDViewBackColor]);
        
        UIImageView * image1 = [[UIImageView alloc]init];
        image1.image = [UIImage imageNamed:@"zhaokefu1"];
        [tfview addSubview:image1];
        image1.sd_layout.leftSpaceToView(tfview, Gato_Width_320_(20))
        .centerYEqualToView(tfview)
        .widthIs(Gato_Width_320_(26))
        .heightIs(Gato_Height_548_(26));
        
        
        self.textfield = [[UITextField alloc]init];
        self.textfield.text = @"平台留言";
        self.textfield.delegate = self;
        self.textfield.font = FONT_Bold_(34);
        [tfview addSubview:self.textfield];
        self.textfield.sd_layout.leftSpaceToView(image1, Gato_Width_320_(15))
        .rightSpaceToView(tfview, Gato_Width_320_(10))
        .centerYEqualToView(tfview)
        .heightIs(Gato_Height_548_(45));
        
        UIButton * button1 = [UIButton buttonWithType:UIButtonTypeCustom];
        [button1 addTarget:self action:@selector(pushliuyanDidClicked) forControlEvents:UIControlEventTouchUpInside];
        [tfview addSubview:button1];
        button1.sd_layout.leftSpaceToView(image1, Gato_Width_320_(15))
        .rightSpaceToView(tfview, Gato_Width_320_(10))
        .centerYEqualToView(tfview)
        .heightIs(Gato_Height_548_(45));
        
        
        UIButton * quxiao = [UIButton buttonWithType:UIButtonTypeCustom];
        [quxiao setTitle:@"取 消" forState:UIControlStateNormal];
        [quxiao setBackgroundColor:Gato_(146, 146, 146)];
        [quxiao setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [quxiao addTarget:self action:@selector(quxiaoMyHelpClicked) forControlEvents:UIControlEventTouchUpInside];
        [self.phoneOLView addSubview:quxiao];
        quxiao.sd_layout.leftSpaceToView(self.phoneOLView, Gato_Width_320_(20))
        .rightSpaceToView(self.phoneOLView, Gato_Width_320_(20))
        .topSpaceToView(self.phoneOLView, Gato_Height_548_(135))
        .heightIs(Gato_Height_548_(45));
        
        GatoViewBorderRadius(quxiao, 3, 0, [UIColor appAllBackColor]);
    }
    return _phoneOLView;
}


@end
