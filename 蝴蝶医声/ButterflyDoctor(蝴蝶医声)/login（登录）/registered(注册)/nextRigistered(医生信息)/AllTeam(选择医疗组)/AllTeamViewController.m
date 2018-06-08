//
//  AllTeamViewController.m
//  butterflyDoctor
//
//  Created by 辛书亮 on 2017/4/17.
//  Copyright © 2017年 孟小猫. All rights reserved.
//

#import "AllTeamViewController.h"
#import "GatoBaseHelp.h"
#import "AllTeamInfoTableViewCell.h"
#import "SVProgressHUD.h"
#import "MBProgressHUD.h"
#import "ChatUIHelper.h"
#import "AppDelegate.h"
#import<CommonCrypto/CommonDigest.h>
#import "PellTableViewSelect.h"
#define navHeight 64
@interface AllTeamViewController ()
{
    NSString * cellStr;
}
@property (nonatomic ,strong) UIView * navView;
@property (nonatomic ,strong) UIView * underView;
@property (nonatomic ,strong) NSString * nickName;
@property (nonatomic ,strong) NSString * photoUrl;
@end

@implementation AllTeamViewController

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self.navigationController setNavigationBarHidden:YES animated:NO];
}
-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:NO];
}

-(void)addButton:(UIButton *)sender
{
    
    
    for (int i = 0 ; i < self.updataArray.count ; i ++) {
        
        MyTeamVerifyModel * model = [[MyTeamVerifyModel alloc]init];
        model = self.updataArray[i];
        if ([model.select isEqualToString:@"0"]) {
            [self addTeamHttpWithModel:model];
            return;
        }else{
//            [self showHint:@"请选择所加入小组"];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [SVProgressHUD dismiss];
            });
        }
    }
}
-(void)addTeamHttpWithModel:(MyTeamVerifyModel *)model
{
    NSString * doctorsId = @"";
    for (int i = 0 ; i < self.updataArray.count ; i ++) {
        MyTeamVerifyModel * model = [[MyTeamVerifyModel alloc]init];
        model = self.updataArray[i];
        if ([model.select isEqualToString: @"0"]) {
            if (doctorsId.length > 0) {
                doctorsId = [NSString stringWithFormat:@"%@,%@",doctorsId,model.doctorId];
            }else{
                doctorsId = [NSString stringWithFormat:@"%@",model.doctorId];
            }
        }
    }
    if (doctorsId.length < 1) {
        [self showHint:@"您还没有选择想要加入的分组"];
        return;
    }
    NSMutableDictionary * dic = [NSMutableDictionary dictionary];
    [dic setDictionary:self.dict];
    [dic setObject:[NSString stringWithFormat:@"%@,",doctorsId] forKey:@"team"];
    [[NSUserDefaults standardUserDefaults] setObject:@"0" forKey:GET_Login_isVerify];
    [IWHttpTool postWithURL:[HTTP stringByAppendingString:@"doctor/register"] params:dic success:^(id json) {
        
        NSDictionary * dic = [NSJSONSerialization JSONObjectWithData:json options:NSJSONReadingAllowFragments error:nil];
        NSString * success = [dic objectForKey:@"code"];
        if ([success isEqualToString:@"200"]) {
            //注册成功后 就可以显示 审核界面了
            UIImageView * image = [[UIImageView alloc]init];
            NSData *imageData = GATO_ShenHe_Image;
            image.image = [UIImage imageWithData: imageData];
            image.frame = self.view.bounds;
            //            AppDelegate *app = (AppDelegate *)[UIApplication sharedApplication].delegate;
            //            [app.window addSubview:image];
            [[NSUserDefaults standardUserDefaults] setObject:@"1" forKey:Get_registered_Image];
            [[NSUserDefaults standardUserDefaults] setObject:@"0" forKey:GET_HomeAD_Hidden];
            [PellTableViewSelect addPellTableViewSelectWithwithView:image WindowFrame:CGRectMake(0, 0, Gato_Width, Gato_Height) WithViewFrame:CGRectMake(0, 0, Gato_Width, Gato_Height)  selectData:nil action:nil animated:YES];
            
            [[NSUserDefaults standardUserDefaults] setObject:[[[dic objectForKey:@"data"] objectForKey:@"info"] objectForKey:@"token"] forKey:GET_TOKEN];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self dengluButton:nil];
            });
        }else{
            NSString * falseMessage = [dic objectForKey:@"message"];
            [self showHint:falseMessage];
        }
        
    } failure:^(NSError *error) {
        NSLog(@"%@",error);
    }];

}
-(void)noButton :(UIButton * )sender
{
    NSMutableDictionary * dic = [NSMutableDictionary dictionary];
    [dic setDictionary:self.dict];
    [dic setObject:@"" forKey:@"team"];
    [[NSUserDefaults standardUserDefaults] setObject:@"0" forKey:GET_Login_isVerify];
    [IWHttpTool postWithURL:[HTTP stringByAppendingString:@"doctor/register"] params:dic success:^(id json) {
        
        NSDictionary * dic = [NSJSONSerialization JSONObjectWithData:json options:NSJSONReadingAllowFragments error:nil];
        NSString * success = [dic objectForKey:@"code"];
        if ([success isEqualToString:@"200"]) {
            //注册成功后 就可以显示 审核界面了
            UIImageView * image = [[UIImageView alloc]init];
            NSData *imageData = GATO_ShenHe_Image;
            image.image = [UIImage imageWithData: imageData];
            image.frame = self.view.bounds;
            //            AppDelegate *app = (AppDelegate *)[UIApplication sharedApplication].delegate;
            //            [app.window addSubview:image];
            [[NSUserDefaults standardUserDefaults] setObject:@"1" forKey:Get_registered_Image];
            [[NSUserDefaults standardUserDefaults] setObject:@"0" forKey:GET_HomeAD_Hidden];
            [PellTableViewSelect addPellTableViewSelectWithwithView:image WindowFrame:CGRectMake(0, 0, Gato_Width, Gato_Height) WithViewFrame:CGRectMake(0, 0, Gato_Width, Gato_Height)  selectData:nil action:nil animated:YES];
            
            [[NSUserDefaults standardUserDefaults] setObject:[[[dic objectForKey:@"data"] objectForKey:@"info"] objectForKey:@"token"] forKey:GET_TOKEN];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self dengluButton:nil];
            });
        }else{
            NSString * falseMessage = [dic objectForKey:@"message"];
            [self showHint:falseMessage];
        }
        
    } failure:^(NSError *error) {
        NSLog(@"%@",error);
    }];
}

-(void)dengluButton:(UIButton *)sender
{
    
    self.updateParms = [NSMutableDictionary dictionary];
    if (registerId) {
        [self.updateParms setObject:ModelNull(registerId) forKey:@"pushId"];
    }
    [self.updateParms setObject:self.phone forKey:@"phone"];
    [self.updateParms setObject:self.password forKey:@"password"];
    [self.updateParms setObject:self.hospitalDepartment forKey:@"hospitalDepartment"];
    [IWHttpTool postWithURL:HD_Denglu params:self.updateParms success:^(id json) {
        
        NSDictionary * dic = [NSJSONSerialization JSONObjectWithData:json options:NSJSONReadingAllowFragments error:nil];
        NSString * success = [dic objectForKey:@"code"];
        if ([success isEqualToString:@"200"]) {
            [[NSUserDefaults standardUserDefaults] setObject:[[[dic objectForKey:@"data"] objectForKey:@"info"] objectForKey:@"token"] forKey:GET_TOKEN];
            self.nickName = [[[dic objectForKey:@"data"] objectForKey:@"info"] objectForKey:@"name"];
            self.photoUrl = [[[dic objectForKey:@"data"] objectForKey:@"info"] objectForKey:@"photo"];
            [[NSUserDefaults standardUserDefaults] setObject:[[[dic objectForKey:@"data"] objectForKey:@"info"] objectForKey:@"isVerify"] forKey:GET_Login_isVerify];
            [self doLogin:nil];
        }else{
            NSString * falseMessage = [dic objectForKey:@"message"];
            [self showHint:falseMessage];
        }
        
    } failure:^(NSError *error) {
        NSLog(@"%@",error);
    }];
    
    
    NSLog(@"/Users/xinshuliang/Desktop/butterflyDoctor/butterflyDoctor/login（登录）/loginViewController.m  \n 登录");
    
}

//登陆账号
- (void)doLogin:(id)sender {
    
    
    UIImageView * image = [[UIImageView alloc]init];
    NSData *imageData = GATO_ShenHe_Image;
    image.image = [UIImage imageWithData:imageData];
    image.frame = self.view.bounds;
    AppDelegate *app = (AppDelegate *)[UIApplication sharedApplication].delegate;
    [app.window addSubview:image];
    [[NSUserDefaults standardUserDefaults] setObject:@"0" forKey:GET_HomeAD_Hidden];
    
    NSString * password = [self md5:self.password];
    password = [self md5:password];
    [self loginWithUsername:self.phone password:password];
    
}
//点击登陆后的操作
- (void)loginWithUsername:(NSString *)username password:(NSString *)password
{
    [self showHudInView:self.view hint:NSLocalizedString(@"login.ongoing", @"Is Login...")];
    //异步登陆账号
    __weak typeof(self) weakself = self;
    [[EMClient sharedClient] loginWithUsername:username password:password completion:^(NSString *aUsername, EMError *aError) {
        [weakself hideHud];
        if (!aError) {
            
            // -----测试：登录成功后，自动添加martin为好友-----------------
            //            EMError *error = [[EMClient sharedClient].contactManager addContact:@"martin" message:@"江南孤鹜让我加你为好友~"];
            //            if (!error) {
            //                NSLog(@"添加成功");
            //                // 测试发送消息
            //                [self sendChatMsg:@"martin"
            //                             text:@"可否到github上给简版demo一个star？ ☺ https://github.com/mengmakies/ButterflyDoctorVoice0-Simple"];
            //            }
            // -----测试：登录成功后，自动添加martin为好友--------end---------
            
            NSString *userOpenId = username;// 用户环信ID
            NSString *nickName = [NSString stringWithFormat:@"%@",self.nickName];// 用户昵称
            NSString *avatarUrl = [NSString stringWithFormat:@"%@",self.photoUrl];// 用户头像（绝对路径）
            
            
            // 登录成功后，如果后端云没有缓存用户信息，则新增一个用户
            [UserWebManager createUser:userOpenId nickName:nickName avatarUrl:avatarUrl];
            
            // 通过消息的扩展属性传递昵称和头像时，需要调用这句代码缓存
            [UserCacheManager save:userOpenId avatarUrl:avatarUrl nickName:nickName];
            
            [UserCacheManager updateMyAvatar:avatarUrl];
            
            //设置是否自动登录
            [[EMClient sharedClient].options setIsAutoLogin:YES];
            
            //获取数据库中数据
            [MBProgressHUD showHUDAddedTo:weakself.view animated:YES];
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                [[EMClient sharedClient] migrateDatabaseToLatestSDK];
                dispatch_async(dispatch_get_main_queue(), ^{
                    [[ChatUIHelper shareHelper] asyncGroupFromServer];
                    [[ChatUIHelper shareHelper] asyncConversationFromDB];
                    [[ChatUIHelper shareHelper] asyncPushOptions];
                    [MBProgressHUD hideAllHUDsForView:weakself.view animated:YES];
                    //发送自动登陆状态通知
                    [[NSNotificationCenter defaultCenter] postNotificationName:KNOTIFICATION_LOGINCHANGE object:@([[EMClient sharedClient] isLoggedIn])];
                    
                    //保存最近一次登录用户名
                    [weakself saveLastLoginUsername];
                });
            });
            [[NSUserDefaults standardUserDefaults] setObject:self.phone forKey:GET_HYP_PHOTO];
            [[NSUserDefaults standardUserDefaults] setObject:self.password forKey:GET_HYP_PASSWORD];
            //
//            AppDelegate *tempAppDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
//            tempAppDelegate.window.rootViewController = [[MainViewController alloc] init];
            
//            Gato_DismissRootView
        } else {
            [weakself hideHud];
            switch (aError.code)
            {
                case EMErrorUserNotFound:
                    TTAlertNoTitle(NSLocalizedString(@"用户不存在", @"用户不存在"));
                    break;
                case EMErrorNetworkUnavailable:
                    TTAlertNoTitle(NSLocalizedString(@"连接网络失败", @"连接网络失败"));
                    break;
                case EMErrorServerNotReachable:
                    TTAlertNoTitle(NSLocalizedString(@"连接服务器失败", @"连接服务器失败"));
                    break;
                case EMErrorUserAuthenticationFailed:
                    TTAlertNoTitle(NSLocalizedString(@"密码验证失败", @"密码验证失败"));
                    break;
                case EMErrorServerTimeout:
                    TTAlertNoTitle(NSLocalizedString(@"服务器超时", @"服务器超时"));
                    break;
                case EMErrorServerServingForbidden:
                    TTAlertNoTitle(NSLocalizedString(@"服务被禁用", @"服务被禁用"));
                    break;
                default:
                    TTAlertNoTitle(NSLocalizedString(@"登录失败，请重试", @"登录失败，请重试"));
                    break;
            }
        }
    }];
}
- (NSString *) md5:(NSString *) input {
    
    const char *cStr = [input UTF8String];
    
    unsigned char digest[CC_MD5_DIGEST_LENGTH];
    
    CC_MD5( cStr, strlen(cStr), digest ); // This is the md5 call
    
    NSMutableString *output = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH * 2];
    
    for(int i = 0; i < CC_MD5_DIGEST_LENGTH; i++)
        
        [output appendFormat:@"%02x", digest[i]];
    
    return  output;
    
}
#pragma  mark - private
- (void)saveLastLoginUsername
{
    NSString *username = [[EMClient sharedClient] currentUsername];
    if (username && username.length > 0) {
        NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
        [ud setObject:username forKey:[NSString stringWithFormat:@"em_lastLogin_username"]];
        [ud synchronize];
    }
}



- (void)viewDidLoad {
    [super viewDidLoad];
    self.GatoTableview.frame = CGRectMake(0, navHeight + Gato_iPhoneXHeight , Gato_Width, Gato_Height - navHeight - Gato_iPhoneXHeight - Gato_Height_548_(47));\
    [self.view addSubview:self.GatoTableview];
    self.view.backgroundColor = [UIColor whiteColor];
    self.updataArray = [NSMutableArray array];
    [self newFrame];
    [self updateMyTeam];
}

-(void)updateMyTeam
{
    NSMutableDictionary * dic = [NSMutableDictionary dictionary];
    [dic setObject:self.hospitalDepartment forKey:@"hospitalDepartment"];
    [IWHttpTool postWithURL:HD_AllTeam params:dic success:^(id json) {
        
        NSDictionary * dic = [NSJSONSerialization JSONObjectWithData:json options:NSJSONReadingAllowFragments error:nil];
        NSString * success = [dic objectForKey:@"code"];
        if ([success isEqualToString:@"200"]) {
            NSArray * jsonArray = [[dic objectForKey:@"data"] objectForKey:@"info"];
            for (int i = 0 ; i < jsonArray.count; i ++) {
                
                MyTeamVerifyModel * model = [[MyTeamVerifyModel alloc]init];
                [model setValuesForKeysWithDictionary:jsonArray[i]];
                model.select = @"1";
                [self.updataArray addObject:model];
            }
            
        }else{
            
        }
        [self.GatoTableview reloadData];
    } failure:^(NSError *error) {
        NSLog(@"%@",error);
    }];
}

-(void)newFrame
{
    
    
    [self.view addSubview:self.navView];
    self.navView.sd_layout.leftSpaceToView(self.view,0)
    .topSpaceToView(self.view,0)
    .rightSpaceToView(self.view,0)
    .heightIs(64 + Gato_iPhoneXHeight);
    
    self.underView.sd_layout.leftSpaceToView(self.view,0)
    .rightSpaceToView(self.view,0)
    .bottomSpaceToView(self.view,0)
    .heightIs(Gato_Height_548_(47));
    
    
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.updataArray.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return Gato_Height_548_(30);
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView * view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, Gato_Width, Gato_Height_548_(30))];
    view.backgroundColor = [UIColor whiteColor];
    UILabel * label = [[UILabel alloc]init];
    label.font = FONT(30);
    label.textColor = [UIColor HDBlackColor];
    label.text = @"请选择一个医疗组加入";
    [view addSubview:label];
    label.sd_layout.leftSpaceToView(view,Gato_Width_320_(17))
    .rightSpaceToView(view,Gato_Width_320_(17))
    .topSpaceToView(view,0)
    .bottomSpaceToView(view,0);
    return view;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    AllTeamInfoTableViewCell * cell = [AllTeamInfoTableViewCell cellWithTableView: tableView];
    MyTeamVerifyModel * model = [[MyTeamVerifyModel alloc]init];
    model = self.updataArray[indexPath.row];
    [cell setValueWithModel:model];
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return Gato_Height_548_(79);
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
//    for (int i = 0 ; i < self.updataArray.count ; i ++) {
//        MyTeamVerifyModel * model = [[MyTeamVerifyModel alloc]init];
//        model = self.updataArray[i];
//        if ([model.select isEqualToString: @"0"]) {
//            model.select = @"1";
//        }
//        [self.updataArray replaceObjectAtIndex:i withObject:model];
//    }
    MyTeamVerifyModel * model = [[MyTeamVerifyModel alloc]init];
    model = self.updataArray[indexPath.row];
    if ([model.select isEqualToString: @"0"]) {
        model.select = @"1";
    }else{
        model.select = @"0";
    }
    [self.updataArray replaceObjectAtIndex:indexPath.row withObject:model];
    [self.GatoTableview reloadData];
    
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)buttonDidClicked
{
//    [self.navigationController popViewControllerAnimated:YES];
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(UIView *)navView
{
    if (!_navView) {
        _navView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, Gato_Width, navHeight)];;
        _navView.backgroundColor = [UIColor HDThemeColor];
        UIButton *button =  [UIButton buttonWithType:UIButtonTypeSystem];
        //    [button setBackgroundImage:[UIImage imageNamed:@"returnButtonImage"] forState:UIControlStateNormal];
        button.frame = CGRectMake(0, 0, Gato_Width_320_(60), navHeight);
        //    [button setBackgroundColor:[UIColor blueColor]];
        [button addTarget:self action:@selector(buttonDidClicked) forControlEvents:UIControlEventTouchUpInside];
        
        UIImageView * image = [[UIImageView alloc]initWithFrame:CGRectMake(Gato_Width_320_(16), Gato_Height_548_(25) + Gato_iPhoneXHeight,Gato_Width_320_(11), Gato_Height_548_(18))];
        image.image = [UIImage imageNamed:@"nav_back"];
        [button addSubview:image];
        
        UIView * fgx = [[UIView alloc]initWithFrame:CGRectMake(0, navHeight - 1 + Gato_iPhoneXHeight, Gato_Width, 1)];
        fgx.backgroundColor = [UIColor appAllBackColor];
        [self.navView addSubview:fgx];
        
        UILabel * label = [[UILabel alloc]initWithFrame:CGRectMake(0, 20 + Gato_iPhoneXHeight, Gato_Width, 44)];
        label.textAlignment = NSTextAlignmentCenter;
        label.font = FONT(40);
        label.text = @"医疗组";
        label.textColor = [UIColor whiteColor];
        [self.navView addSubview:label];
        [self.navView addSubview:button];
        
        
        image.sd_layout.centerYEqualToView(label);
        
    }
    return _navView;
}
-(UIView *)underView
{
    if (!_underView) {
        _underView = [[UIView alloc]init];
        _underView.backgroundColor = [UIColor whiteColor];
        [self.view addSubview:_underView];
        
        UIButton * addButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [addButton setTitle:@"申请加入" forState:UIControlStateNormal];
        [addButton setBackgroundColor:[UIColor HDThemeColor]];
        [addButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [addButton addTarget:self action:@selector(addButton:) forControlEvents:UIControlEventTouchUpInside];
        [self.underView addSubview:addButton];
        
        addButton.sd_layout.leftSpaceToView(self.underView,Gato_Width_320_(15))
        .topSpaceToView(self.underView,Gato_Height_548_(8))
        .widthIs(Gato_Width_320_(144))
        .heightIs(Gato_Height_548_(32));
        
        UIButton * noButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [noButton setTitle:@"以后再说" forState:UIControlStateNormal];
        [noButton setBackgroundColor:[UIColor HDThemeColor]];
        [noButton addTarget:self action:@selector(noButton:) forControlEvents:UIControlEventTouchUpInside];
        [noButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [self.underView addSubview:noButton];
        
        noButton.sd_layout.leftSpaceToView(addButton,Gato_Width_320_(10))
        .topSpaceToView(self.underView,Gato_Height_548_(8))
        .widthIs(Gato_Width_320_(144))
        .heightIs(Gato_Height_548_(32));
        
        GatoViewBorderRadius(addButton, 5, 0, [UIColor redColor]);
        GatoViewBorderRadius(noButton, 5, 0, [UIColor redColor]);
    }
    return _underView;
}

@end
