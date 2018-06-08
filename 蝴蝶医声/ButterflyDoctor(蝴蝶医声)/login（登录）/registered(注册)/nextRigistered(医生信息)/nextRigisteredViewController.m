//
//  nextRigisteredViewController.m
//  butterflyDoctor
//
//  Created by 辛书亮 on 2017/4/17.
//  Copyright © 2017年 孟小猫. All rights reserved.
//

#import "nextRigisteredViewController.h"
#import "GatoBaseHelp.h"
#import "SVProgressHUD.h"
#import "AllTeamViewController.h"
//Full版本
#import <Hyphenate/Hyphenate.h>
#import "MBProgressHUD.h"
#import "ChatUIHelper.h"
#import<CommonCrypto/CommonDigest.h>
#import "SecondViewController.h"
#import "tishiXiaoShiViewController.h"
#import "PellTableViewSelect.h"
#import "AppDelegate.h"
#define buttonTag 4171611
#define TextFieldTag 4171600
#define navHeight 64 + Gato_iPhoneXHeight
@interface nextRigisteredViewController ()<UIActionSheetDelegate,UITextFieldDelegate,UIScrollViewDelegate>
{
    UIAlertController * doctorSheet;
    UIAlertController * classSheet;
    UIAlertController * levelSheet;
    
    NSMutableArray * hospitalArray;
    NSMutableDictionary * hospitalDic;
    NSMutableArray * departmentArray;
    NSMutableDictionary * departmentDic;
    NSMutableArray * workArray;
    NSMutableDictionary * workDic;
}
@property (nonatomic ,strong) UIScrollView * underView;
@property (nonatomic ,strong) UIView * navView;
@property (nonatomic ,strong) UIView * TwoButtonView;
@property (nonatomic ,strong) UIButton * yesButton;
@property (nonatomic ,strong) UIButton * noButton;
@property (nonatomic ,strong) UIButton * nextButton;
@property (nonatomic ,strong) NSString * daizuStr;//yes = 0 ; no = 1

@property (nonatomic ,strong) NSString * nickName;
@property (nonatomic ,strong) NSString * photoUrl;
@property (nonatomic ,strong) NSString * city;
@property (nonatomic ,assign) NSInteger sheng;
@property (nonatomic ,assign) NSInteger shi;
@end

@implementation nextRigisteredViewController

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

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self newFrame];
    [self addLabel];
    self.daizuStr = @"0";
}
-(void)newFrame
{
    self.underView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, Gato_Width , Gato_Height)];
    self.underView.delegate = self;
    [self.view addSubview:self.underView];
    self.underView.contentSize = CGSizeMake(Gato_Width, 5 * Gato_Height_548_(69) + navHeight + 20 + Gato_Height_548_(92));
    
    [self.view addSubview:self.navView];
    self.navView.sd_layout.leftSpaceToView(self.view,0)
    .topSpaceToView(self.view,0)
    .rightSpaceToView(self.view,0)
    .heightIs(64 + Gato_iPhoneXHeight);
    
    self.TwoButtonView.sd_layout.leftSpaceToView(self.underView,0)
    .rightSpaceToView(self.underView,0)
    .topSpaceToView(self.underView, 5 * Gato_Height_548_(69) + navHeight + 20)
    .heightIs(Gato_Height_548_(37));
    
    UILabel * label = [[UILabel alloc]init];
    label.text = @"是否带组";
    label.font = FONT(30);
    label.textColor = [UIColor HDBlackColor];
    [self.TwoButtonView addSubview:label];
    label.sd_layout.leftSpaceToView(self.TwoButtonView,Gato_Width_320_(30))
    .widthIs(Gato_Width_320_(150))
    .heightIs(Gato_Height_548_(37))
    .topSpaceToView(self.TwoButtonView,Gato_Height_548_(0));
    
    
    self.noButton.sd_layout.rightSpaceToView(self.underView,Gato_Width_320_(20))
    .centerYEqualToView(self.TwoButtonView)
    .widthIs(Gato_Width_320_(43))
    .heightIs(Gato_Height_548_(20));
    
    self.yesButton.sd_layout.rightSpaceToView(self.noButton,Gato_Width_320_(10))
    .topEqualToView(self.noButton)
    .bottomEqualToView(self.noButton)
    .widthRatioToView(self.noButton,1);
    
    self.nextButton.sd_layout.leftSpaceToView(self.underView,Gato_Width_320_(20))
    .rightSpaceToView(self.underView,Gato_Width_320_(20))
    .topSpaceToView(self.TwoButtonView, Gato_Height_548_(20))
    .heightIs(Gato_Height_548_(32));
    
    GatoViewBorderRadius(self.nextButton, 5, 0, [UIColor redColor]);
    GatoViewBorderRadius(self.TwoButtonView, 0, 1, [UIColor appAllBackColor]);
    GatoViewBorderRadius(self.yesButton, 5, 1, [UIColor appAllBackColor]);
    GatoViewBorderRadius(self.noButton, 5, 1, [UIColor appAllBackColor]);
    
}
#pragma mark - 提交注册
-(void)nextButtonDidClicked:(UIButton *)sender
{
    if (!self.city) {
        [self showHint:@"请选择所在地区"];
        return;
    }
    if (!hospitalDic) {
        [self showHint:@"请选择医院"];
        return;
    }
    if (!departmentDic) {
        [self showHint:@"请选择科室"];
        return;
    }
    if (!workDic) {
        [self showHint:@"请选择职称"];
        return;
    }
    if ([self getTextFieldWithTag:10].length < 3) {
        [self showHint:@"请输入区号"];
        return;
    }
    
    if ([self getTextFieldWithTag:4].length < 6) {
        [self showHint:@"请输入科室电话"];
        return;
    }
    
    if ([self.daizuStr isEqualToString:@"1"]) {
        
        EMError *error = nil;
        EMGroupOptions *setting = [[EMGroupOptions alloc] init];
        setting.maxUsersCount = 500;
        setting.style = EMGroupStylePublicJoinNeedApproval;// 创建不同类型的群组，这里需要才传入不同的类型
        EMGroup *group = [[EMClient sharedClient].groupManager createGroupWithSubject:[NSString stringWithFormat:@"%@的医疗小组",self.name] description:@" " invitees:@[self.phone] message:@" " setting:setting error:&error];
        if(!error){
            //群组ID 应该交给后台管理
            NSLog(@"创建成功 -- groupId:%@",group.groupId);
        }
        
        [self nextView];
    }else{
        AllTeamViewController * vc = [[AllTeamViewController alloc]init];
        vc.name = self.name;
        vc.phone = self.phone;
        vc.password = self.password;
        self.updateParms = [NSMutableDictionary dictionary];
        [self.updateParms setObject:self.phone forKey:@"phone"];
        [self.updateParms setObject:self.code forKey:@"code"];
        [self.updateParms setObject:self.name forKey:@"name"];
        [self.updateParms setObject:self.password forKey:@"password"];
        [self.updateParms setObject:[hospitalDic objectForKey:@"hospitalId"] forKey:@"hospital"];
        [self.updateParms setObject:[departmentDic objectForKey:@"hospitalDepartmentId"] forKey:@"hospitalDepartment"];
        [self.updateParms setObject:[workDic objectForKey:@"workId"] forKey:@"work"];
        [self.updateParms setObject:[NSString stringWithFormat:@"%@-%@",[self getTextFieldWithTag:10],[self getTextFieldWithTag:4]] forKey:@"hospitalDepartmentTel"];
        [self.updateParms setObject:self.daizuStr forKey:@"isTeam"];
        [self.updateParms setObject:self.city forKey:@"search"];
        if (registerId) {
            [self.updateParms setObject:ModelNull(registerId)  forKey:@"pushId"];
        }
        vc.dict = self.updateParms;
        vc.hospitalDepartment = [departmentDic objectForKey:@"hospitalDepartmentId"];
        [self presentViewController:vc animated:YES completion:nil];
    }
    
   
    
   
}
-(void)nextView
{
    self.updateParms = [NSMutableDictionary dictionary];
    [self.updateParms setObject:self.phone forKey:@"phone"];
    [self.updateParms setObject:self.code forKey:@"code"];
    [self.updateParms setObject:self.name forKey:@"name"];
    [self.updateParms setObject:self.password forKey:@"password"];
    [self.updateParms setObject:[hospitalDic objectForKey:@"hospitalId"] forKey:@"hospital"];
    [self.updateParms setObject:[departmentDic objectForKey:@"hospitalDepartmentId"] forKey:@"hospitalDepartment"];
    [self.updateParms setObject:[workDic objectForKey:@"workId"] forKey:@"work"];
    [self.updateParms setObject:[NSString stringWithFormat:@"%@-%@",[self getTextFieldWithTag:10],[self getTextFieldWithTag:4]] forKey:@"hospitalDepartmentTel"];
    [self.updateParms setObject:self.daizuStr forKey:@"isTeam"];
    [self.updateParms setObject:self.city forKey:@"search"];
    if (registerId) {
        [self.updateParms setObject:ModelNull(registerId)  forKey:@"pushId"];
    }
    [[NSUserDefaults standardUserDefaults] setObject:@"0" forKey:GET_Login_isVerify];
    [IWHttpTool postWithURL:[HTTP stringByAppendingString:@"doctor/register"] params:self.updateParms success:^(id json) {
        
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
    [IWHttpTool postWithURL:HD_Denglu params:self.updateParms success:^(id json) {
        
        NSDictionary * dic = [NSJSONSerialization JSONObjectWithData:json options:NSJSONReadingAllowFragments error:nil];
        NSString * success = [dic objectForKey:@"code"];
        if ([success isEqualToString:@"200"]) {
            [[NSUserDefaults standardUserDefaults] setObject:[[[dic objectForKey:@"data"] objectForKey:@"info"] objectForKey:@"token"] forKey:GET_TOKEN];
            self.nickName = [[[dic objectForKey:@"data"] objectForKey:@"info"] objectForKey:@"name"];
            self.photoUrl = [[[dic objectForKey:@"data"] objectForKey:@"info"] objectForKey:@"photo"];
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

            
//            AppDelegate *tempAppDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
//            tempAppDelegate.window.rootViewController = [[MainViewController alloc] init];
//            Gato_DismissRootView
        } else {            [weakself hideHud];
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



-(void)noButton:(UIButton *)sender
{
    self.daizuStr = @"0";
    [self.yesButton setBackgroundColor:[UIColor whiteColor]];
    [self.yesButton setTitleColor:[UIColor HDBlackColor] forState:UIControlStateNormal];
    
    [self.noButton setBackgroundColor:[UIColor HDThemeColor]];
    [self.noButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
}
-(void)yesButton:(UIButton *)sender
{
    
    if ([[self getTextFieldWithTag:3] isEqualToString:@"主任医师"] ||[[self getTextFieldWithTag:3] isEqualToString:@"副主任医师"] ) {
        self.daizuStr = @"1";
        [self.noButton setBackgroundColor:[UIColor whiteColor]];
        [self.noButton setTitleColor:[UIColor HDBlackColor] forState:UIControlStateNormal];
        
        [self.yesButton setBackgroundColor:[UIColor HDThemeColor]];
        [self.yesButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];

    }else{
        if ([[self getTextFieldWithTag:3] isEqualToString:@""]) {
            [self showHint:@"请先选择职称"];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [SVProgressHUD dismiss];
            });
            return;
        }else{
            [tishiXiaoShiViewController showMessage:@"您当前职称不可带组，请选择小组加入"];
//            [self showHint:@"您当前职称不可带组，请选择小组加入。"];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [SVProgressHUD dismiss];
            });
            return;
        }
        
    }
    
   
}
#pragma mark - 返回textfield 内容
-(NSString * )getTextFieldWithTag:(NSInteger )tag
{
    UITextField * textfield = (UITextField *)[self.view viewWithTag:tag + TextFieldTag];
    if (textfield.text.length > 0) {
        return textfield.text;
    }
    return @"";
}


- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    
    if (textField.tag - TextFieldTag == 10)  {
        //这里的if时候为了获取删除操作,如果没有次if会造成当达到字数限制后删除键也不能使用的后果.
        if (range.length == 1 && string.length == 0) {
            return YES;
        }
        //so easy
        else if (textField.text.length >= 5) {
            textField.text = [textField.text substringToIndex:5];
            return NO;
        }
    }else{
        if (range.length == 1 && string.length == 0) {
            return YES;
        }
        //so easy
        else if (textField.text.length >= 8) {
            textField.text = [textField.text substringToIndex:8];
            return NO;
        }
    }
    return YES;
}

-(void)buttonDidClicked:(UIButton *)sender
{

    if (sender.tag - buttonTag == 0) {
        SecondViewController *address = [[SecondViewController alloc]init];
        address.sheng = self.sheng;
        address.shi = self.shi;
        address.blockAddress = ^(NSDictionary *newAddress ,NSInteger sheng ,NSInteger shi){
            UITextField * textfield = (UITextField *)[self.view viewWithTag:0 + TextFieldTag];
            if (newAddress.count == 2) {
                textfield.text = [NSString stringWithFormat:@"%@ %@ ",newAddress[@"province"],newAddress[@"city"]];
                self.city = textfield.text;
                self.sheng = sheng;
                self.shi = shi;
            }
            else if (newAddress.count == 3){
                textfield.text = [NSString stringWithFormat:@"%@ %@ %@ ",newAddress[@"province"],newAddress[@"city"],newAddress[@"area"]];
                self.city = textfield.text;
            }
            UITextField * yiyuan = (UITextField * )[self.view viewWithTag:1 + TextFieldTag];
            yiyuan.text = @"";
            UITextField * keshi = (UITextField * )[self.view viewWithTag:2 + TextFieldTag];
            keshi.text = @"";
            UITextField * zhicheng = (UITextField * )[self.view viewWithTag:3 + TextFieldTag];
            zhicheng.text = @"";
        };
        [self presentViewController:address animated:YES completion:^{
        
        }];
    }else if (sender.tag - buttonTag == 1) {
        if (!self.city) {
            [self showHint:@"请先选择所在地区"];
            return;
        }
        self.updateParms = [NSMutableDictionary dictionary];
        hospitalArray = [NSMutableArray array];
        [self.updateParms setObject:self.city forKey:@"search"];
        [IWHttpTool postWithURL:HD_ZhuCe_Doctor params:self.updateParms success:^(id json) {
            
            NSDictionary * dic = [NSJSONSerialization JSONObjectWithData:json options:NSJSONReadingAllowFragments error:nil];
            NSString * success = [dic objectForKey:@"code"];
            if ([success isEqualToString:@"200"]) {
                
                doctorSheet = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
                hospitalArray = [[dic objectForKey:@"data"] objectForKey:@"info"];
                NSMutableArray * titleArray = [NSMutableArray array];
                for (int i = 0 ; i < hospitalArray.count;  i ++) {
                    [titleArray addObject: [hospitalArray[i] objectForKey:@"name"]];
                }
                [self addActionTarget:doctorSheet titles:titleArray];
                [self addCancelActionTarget:doctorSheet title:@"取消"];
                [self presentViewController:doctorSheet animated:YES completion:nil];

            }else{
                NSString * falseMessage = [dic objectForKey:@"message"];
                [self showHint:falseMessage];
            }
            
        } failure:^(NSError *error) {
            NSLog(@"%@",error);
        }];

    }else if (sender.tag - buttonTag == 2){
        if (![hospitalDic objectForKey:@"hospitalId"]) {
            [self showHint:@"请先选择医院"];
            return;
        }
        self.updateParms = [NSMutableDictionary dictionary];
        departmentArray = [NSMutableArray array];
        [self.updateParms setObject:[hospitalDic objectForKey:@"hospitalId"] forKey:@"hospitalId"];
        [IWHttpTool postWithURL:HD_ZhuCe_Department params:self.updateParms success:^(id json) {
            
            NSDictionary * dic = [NSJSONSerialization JSONObjectWithData:json options:NSJSONReadingAllowFragments error:nil];
            NSString * success = [dic objectForKey:@"code"];
            if ([success isEqualToString:@"200"]) {

                departmentArray = [[dic objectForKey:@"data"] objectForKey:@"info"];
                NSMutableArray * titleArray = [NSMutableArray array];
                for (int i = 0 ; i < departmentArray.count;  i ++) {
                    [titleArray addObject: [departmentArray[i] objectForKey:@"name"]];
                }
                classSheet = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
                [self addActionTarget:classSheet titles:titleArray];
                [self addCancelActionTarget:classSheet title:@"取消"];
                [self presentViewController:classSheet animated:YES completion:nil];

                
            }else{
                NSString * falseMessage = [dic objectForKey:@"message"];
                [self showHint:falseMessage];
            }
            
        } failure:^(NSError *error) {
            NSLog(@"%@",error);
        }];
    }else if (sender.tag - buttonTag == 3){
        self.updateParms = [NSMutableDictionary dictionary];
        workArray = [NSMutableArray array];
        [IWHttpTool postWithURL:HD_ZhuCe_Work params:self.updateParms success:^(id json) {
            
            NSDictionary * dic = [NSJSONSerialization JSONObjectWithData:json options:NSJSONReadingAllowFragments error:nil];
            NSString * success = [dic objectForKey:@"code"];
            if ([success isEqualToString:@"200"]) {
                
                workArray = [[dic objectForKey:@"data"] objectForKey:@"info"];
                NSMutableArray * titleArray = [NSMutableArray array];
                for (int i = 0 ; i < workArray.count;  i ++) {
                    [titleArray addObject: [workArray[i] objectForKey:@"name"]];
                }
                levelSheet = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
//                NSArray *titles = @[@"主任医师",@"副主任医师",@"主治医师",@"住院医师",@"医师"];
                [self addActionTarget:levelSheet titles:titleArray];
                [self addCancelActionTarget:levelSheet title:@"取消"];
                [self presentViewController:levelSheet animated:YES completion:nil];
                
                
            }else{
                NSString * falseMessage = [dic objectForKey:@"message"];
                [self showHint:falseMessage];
            }
            
        } failure:^(NSError *error) {
            NSLog(@"%@",error);
        }];
        
    }
}
// 添加其他按钮
- (void)addActionTarget:(UIAlertController *)alertController titles:(NSArray *)titles
{
    if (alertController == doctorSheet) {
        for (NSString *title in titles) {
            UIAlertAction *action = [UIAlertAction actionWithTitle:title style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
                UITextField * text = (UITextField * )[self.view viewWithTag:1 + TextFieldTag];
                text.text = title;
                hospitalDic = [NSMutableDictionary dictionary];
                for (int i = 0 ; i < hospitalArray.count ; i ++) {
                    if ([[hospitalArray[i] objectForKey:@"name"] isEqualToString:title]) {
                        hospitalDic = hospitalArray[i];
                        UITextField * keshi = (UITextField * )[self.view viewWithTag:2 + TextFieldTag];
                        keshi.text = @"";
                        UITextField * zhicheng = (UITextField * )[self.view viewWithTag:3 + TextFieldTag];
                        zhicheng.text = @"";
                    }
                }
            }];
            [alertController addAction:action];
        }
    }else if (alertController == classSheet){
        for (NSString *title in titles) {
            UIAlertAction *action = [UIAlertAction actionWithTitle:title style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
                UITextField * text = (UITextField * )[self.view viewWithTag:2 + TextFieldTag];
                text.text = title;
                departmentDic = [NSMutableDictionary dictionary];
                for (int i = 0 ; i < departmentArray.count ; i ++) {
                    if ([[departmentArray[i] objectForKey:@"name"] isEqualToString:title]) {
                        departmentDic = departmentArray[i];
                        UITextField * zhicheng = (UITextField * )[self.view viewWithTag:3 + TextFieldTag];
                        zhicheng.text = @"";
                    }
                }
            }];
            [alertController addAction:action];
        }
    }else if (alertController == levelSheet){
        for (NSString *title in titles) {
            UIAlertAction *action = [UIAlertAction actionWithTitle:title style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
                UITextField * text = (UITextField * )[self.view viewWithTag:3 + TextFieldTag];
                text.text = title;
                workDic = [NSMutableDictionary dictionary];
                for (int i = 0 ; i < workArray.count ; i ++) {
                    if ([[workArray[i] objectForKey:@"name"] isEqualToString:title]) {
                        workDic = workArray[i];
                    }
                }
                [self noButton:nil];
            }];
            [alertController addAction:action];
        }
    }
    
}

// 取消按钮
- (void)addCancelActionTarget:(UIAlertController *)alertController title:(NSString *)title
{
    UIAlertAction *action = [UIAlertAction actionWithTitle:title style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
    }];
    [alertController addAction:action];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - 懒加载

-(void)addLabel
{
    NSArray * labelArray = @[@"您所在的省市 *",@"您所在的医院名称（全称）*",@"您所在的科室名称 *",@"您的职称 *",@"科室电话 *"];
    NSArray * textFieldArray = @[@"请选择您所在的省市",@"请选择您的医院",@"请选择您的科室",@"请选择您的职称",@"请输入科室电话"];
    for (int i = 0 ; i < labelArray.count; i ++) {
        UILabel * label = [[UILabel alloc]init];
        label.text = labelArray[i];
        label.font = FONT(30);
        label.textColor = [UIColor HDBlackColor];
        [self.underView addSubview:label];
        label.sd_layout.leftSpaceToView(self.underView,Gato_Width_320_(30))
        .rightSpaceToView(self.underView,Gato_Width_320_(30))
        .heightIs(Gato_Height_548_(32))
        .topSpaceToView(self.underView,i * Gato_Height_548_(69) + navHeight);
        
        [GatoMethods NSMutableAttributedStringWithLabel:label WithAllString:label.text WithColorString:@"*" WithColor:[UIColor redColor]];
        
        UIView * view = [[UIView alloc]init];
        view.backgroundColor = [UIColor whiteColor];
        [self.underView addSubview:view];
        
        view.sd_layout.leftSpaceToView(self.underView,Gato_Width_320_(20))
        .rightSpaceToView(self.underView,Gato_Width_320_(20))
        .topSpaceToView(label,0)
        .heightIs(Gato_Height_548_(37));
        
        UITextField * textfield = [[UITextField alloc]init];
        textfield.tag = TextFieldTag + i;
        textfield.delegate = self;
        textfield.placeholder = textFieldArray[i];
        textfield.textColor = [UIColor HDBlackColor];
        textfield.font = FONT(30);
        textfield.keyboardType = UIKeyboardTypePhonePad;
        
        
       
        
        if (i != 4) {
            [view addSubview:textfield];
            GatoViewBorderRadius(view, 5, 1, [UIColor HDViewBackColor]);
            
            UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
            [button addTarget:self action:@selector(buttonDidClicked:) forControlEvents:UIControlEventTouchUpInside];
            button.tag = buttonTag + i;
            [self.underView addSubview:button];
            button.sd_layout.leftEqualToView(view)
            .topEqualToView(view)
            .rightEqualToView(view)
            .bottomEqualToView(view);
            
            UIImageView * image = [[UIImageView alloc]init];
            image.image = [UIImage imageNamed:@"home_icon_more"];
            [view addSubview:image];
            
            image.sd_layout.rightSpaceToView(view,Gato_Width_320_(15))
            .topSpaceToView(view,Gato_Height_548_(16))
            .widthIs(Gato_Width_320_(4))
            .heightIs(Gato_Height_548_(7));
            
            textfield.sd_layout.leftSpaceToView(view,Gato_Width_320_(5))
            .topSpaceToView(view,0)
            .bottomSpaceToView(view,0)
            .rightSpaceToView(view,Gato_Width_320_(5));
            
        }else{
            UIView * quhaoview = [[UIView alloc]init];
            quhaoview.backgroundColor = [UIColor whiteColor];
            [view addSubview:quhaoview];
            
            quhaoview.sd_layout.leftSpaceToView(view, Gato_Width_320_(0))
            .topSpaceToView(view, 0)
            .bottomSpaceToView(view , 0)
            .widthIs(Gato_Width_320_(50));
            
            UITextField * quhao = [[UITextField alloc]init];
            quhao.tag = TextFieldTag + 10;
            quhao.delegate = self;
            quhao.placeholder = @"区号";
            quhao.textAlignment = NSTextAlignmentCenter;
            quhao.textColor = [UIColor HDBlackColor];
            quhao.font = FONT(30);
            quhao.keyboardType = UIKeyboardTypePhonePad;
            [quhaoview addSubview:quhao];
            
            quhao.sd_layout.leftSpaceToView(quhaoview, 0)
            .topSpaceToView(quhaoview, 0)
            .bottomSpaceToView(quhaoview , 0)
            .widthIs(Gato_Width_320_(50));
            
            UIView * fgx = [[UIView alloc]init];
            fgx.backgroundColor = [UIColor HDViewBackColor];
            [view addSubview:fgx];
            fgx.sd_layout.leftSpaceToView(quhao, Gato_Width_320_(5))
            .centerYEqualToView(quhao)
            .widthIs(Gato_Width_320_(10))
            .heightIs(Gato_Height_548_(1));
            
            
            UIView * textfieldView = [[UIView alloc]init];
            textfieldView.backgroundColor = [UIColor whiteColor];
            [view addSubview:textfieldView];
            textfieldView.sd_layout.leftSpaceToView(fgx,Gato_Width_320_(5))
            .topSpaceToView(view,0)
            .bottomSpaceToView(view,0)
            .rightSpaceToView(view,Gato_Width_320_(0));
            
            [textfieldView addSubview:textfield];
            
            textfield.sd_layout.leftSpaceToView(textfieldView,Gato_Width_320_(5))
            .topSpaceToView(textfieldView,0)
            .bottomSpaceToView(textfieldView,0)
            .rightSpaceToView(textfieldView,Gato_Width_320_(5));
            
            
            GatoViewBorderRadius(quhaoview, 5, 1, [UIColor HDViewBackColor]);
            GatoViewBorderRadius(textfieldView, 5, 1, [UIColor HDViewBackColor]);
        }
        
        
    }
}
-(void)buttonDidClicked
{
//    [self.navigationController popViewControllerAnimated:YES];
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(UIView *)navView
{
    if (!_navView) {
        _navView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, Gato_Width, 64)];;
        _navView.backgroundColor = [UIColor HDThemeColor];
        UIButton *button =  [UIButton buttonWithType:UIButtonTypeSystem];
        //    [button setBackgroundImage:[UIImage imageNamed:@"returnButtonImage"] forState:UIControlStateNormal];
        button.frame = CGRectMake(0, 0, Gato_Width_320_(60), 64);
        //    [button setBackgroundColor:[UIColor blueColor]];
        [button addTarget:self action:@selector(buttonDidClicked) forControlEvents:UIControlEventTouchUpInside];
        
        UIImageView * image = [[UIImageView alloc]initWithFrame:CGRectMake(Gato_Width_320_(16), Gato_Height_548_(25) + Gato_iPhoneXHeight,Gato_Width_320_(11), Gato_Height_548_(18))];
        image.image = [UIImage imageNamed:@"nav_back"];
        [button addSubview:image];
        
        UIView * fgx = [[UIView alloc]initWithFrame:CGRectMake(0, 63 + Gato_iPhoneXHeight, Gato_Width, 1)];
        fgx.backgroundColor = [UIColor appAllBackColor];
        [self.navView addSubview:fgx];
        
        UILabel * label = [[UILabel alloc]initWithFrame:CGRectMake(0, 20 + Gato_iPhoneXHeight, Gato_Width, 44)];
        label.textAlignment = NSTextAlignmentCenter;
        label.font = FONT(40);
        label.text = @"医生资料";
        label.textColor = [UIColor whiteColor];
        [self.navView addSubview:label];
        [self.navView addSubview:button];
        image.sd_layout.centerYEqualToView(label);
        
    }
    return _navView;
}



-(UIButton *)noButton
{
    if (!_noButton) {
        _noButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_noButton setTitle:@"否" forState:UIControlStateNormal];
        [_noButton setBackgroundColor:[UIColor HDThemeColor]];
        [_noButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_noButton addTarget:self action:@selector(noButton:) forControlEvents:UIControlEventTouchUpInside];
        _noButton.titleLabel.font = FONT(26);
        [self.underView addSubview:_noButton];
    }
    return _noButton;
}
-(UIButton *)yesButton
{
    if (!_yesButton) {
        _yesButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_yesButton setTitle:@"是" forState:UIControlStateNormal];
        [_yesButton setBackgroundColor:[UIColor whiteColor]];
        [_yesButton setTitleColor:[UIColor HDBlackColor] forState:UIControlStateNormal];
        [_yesButton addTarget:self action:@selector(yesButton:) forControlEvents:UIControlEventTouchUpInside];
        _yesButton.titleLabel.font = FONT(26);
        [self.underView addSubview:_yesButton];
    }
    return _yesButton;
}
-(UIView *)TwoButtonView
{
    if (!_TwoButtonView) {
        _TwoButtonView = [[UIView alloc]init];
        _TwoButtonView.backgroundColor = [UIColor whiteColor];
        [self.underView addSubview:_TwoButtonView];
    }
    return _TwoButtonView;
}

-(UIButton *)nextButton
{
    if (!_nextButton) {
        _nextButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_nextButton setTitle:@"提交" forState:UIControlStateNormal];
        [_nextButton setBackgroundColor:[UIColor HDThemeColor]];
        _nextButton.titleLabel.font = FONT(30);
        [_nextButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_nextButton addTarget:self action:@selector(nextButtonDidClicked:) forControlEvents:UIControlEventTouchUpInside];
        [self.underView addSubview:_nextButton];
    }
    return _nextButton;
}


@end
