//
//  loginViewController.m
//  butterflyDoctor
//
//  Created by 辛书亮 on 2017/4/17.
//  Copyright © 2017年 孟小猫. All rights reserved.
//

#import "loginViewController.h"
#import "GatoBaseHelp.h"
#import "registeredViewController.h"
#import "forgetPasswordViewController.h"
#import "homeViewController.h"
#import <Hyphenate/Hyphenate.h>
#import <Hyphenate/EMError.h>
#import "ChatUIHelper.h"
#import "MBProgressHUD.h"
#import "AppDelegate.h"
#import "DLTabBarController.h"
#import "MainViewController.h"
#import<CommonCrypto/CommonDigest.h>
#import "LookMessageView.h"
#import "PellTableViewSelect.h"
#define shenhtHttp @"http://api.hudieyisheng.com/v1/banner/get-verify"
//#import "ChatUIHelper.h"
@interface loginViewController ()<UITextFieldDelegate>
@property (nonatomic ,strong) UIImageView * UnderImage;
@property (nonatomic ,strong) UIView * phoneView;
@property (nonatomic ,strong) UITextField * phoneTF;
@property (nonatomic ,strong) UIView * passwordView;
@property (nonatomic ,strong) UITextField * passwordTF;
@property (nonatomic ,strong) UIButton * wangjiButton;
@property (nonatomic ,strong) UIButton * zhuceButton;
@property (nonatomic ,strong) UIButton * dengluButton;

@property (nonatomic ,strong) NSString * nickName;
@property (nonatomic ,strong) NSString * photoUrl;
@end

@implementation loginViewController


-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = YES;
}
//-(void)viewWillDisappear:(BOOL)animated
//{
//    [super viewWillAppear:animated];
//    self.navigationController.navigationBarHidden = NO;
//}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self newFrame];
    [self welcomeImage];
    UIImageView * image = [[UIImageView alloc]init];
    if (Gato_iPhoneXHeight > 0) {
        image.image = [UIImage imageNamed:@"iphoneXshenhe"];
    }else{
        image.image = [UIImage imageNamed:@"shenheImage-1"];
    }
    [[NSUserDefaults standardUserDefaults] setObject:UIImagePNGRepresentation(image.image) forKey:GET_ShenHe_Image];
//    [self shenheImage];
    
    [self updateHttp];
    
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
#pragma mark - 获取欢迎页医生图片
-(void)welcomeImage
{
    NSMutableDictionary * dic = [NSMutableDictionary dictionary];
    [IWHttpTool postWithURL:HD_Home_Welcome params:dic success:^(id json) {
        
        NSDictionary * dic = [NSJSONSerialization JSONObjectWithData:json options:NSJSONReadingAllowFragments error:nil];
        NSString * success = [dic objectForKey:@"code"];
        if ([success isEqualToString:@"200"]) {
            NSString * imageUrl = [[[dic objectForKey:@"data"] objectForKey:@"info"] objectForKey:@"picUrl"];
            if (Gato_iPhoneXHeight > 0) {
                imageUrl = [[[dic objectForKey:@"data"] objectForKey:@"info"] objectForKey:@"picUrlx"];
            }
            UIImage * welcomeImage = [UIImage imageWithData: [NSData dataWithContentsOfURL:[NSURL URLWithString:imageUrl]]];
            [[NSUserDefaults standardUserDefaults] setObject:UIImagePNGRepresentation(welcomeImage) forKey:GET_Home_Image];
        }else{
            
        }
        NSLog(@"%@",GATO_HOME_Image);
    } failure:^(NSError *error) {
        NSLog(@"%@",error);
    }];
    
}
#pragma mark - 获取审核图片
-(void)shenheImage
{
    NSMutableDictionary * dic = [NSMutableDictionary dictionary];
    [IWHttpTool postWithURL:shenhtHttp params:dic success:^(id json) {
        
        NSDictionary * dic = [NSJSONSerialization JSONObjectWithData:json options:NSJSONReadingAllowFragments error:nil];
        NSString * success = [dic objectForKey:@"code"];
        if ([success isEqualToString:@"200"]) {
            UIImage * welcomeImage = [UIImage imageWithData: [NSData dataWithContentsOfURL:[NSURL URLWithString:[[[dic objectForKey:@"data"] objectForKey:@"info"] objectForKey:@"picUrl"]]]];
           
            [[NSUserDefaults standardUserDefaults] setObject:UIImagePNGRepresentation(welcomeImage) forKey:GET_ShenHe_Image];
        }else{
            
        }
        NSLog(@"%@",GET_ShenHe_Image);
    } failure:^(NSError *error) {
        NSLog(@"%@",error);
    }];
    
}
-(void)newFrame
{
    self.UnderImage.sd_layout.leftSpaceToView(self.view,0)
    .rightSpaceToView(self.view,0)
    .topSpaceToView(self.view,0)
    .bottomSpaceToView(self.view,0);
    
    
    self.phoneView.sd_layout.leftSpaceToView(self.UnderImage,30)
    .rightSpaceToView(self.UnderImage,30)
    .topSpaceToView(self.UnderImage,Gato_Width_320_(167))
    .heightIs(Gato_Height_548_(37));
    
    GatoViewBorderRadius(self.phoneView, 5, 1, [UIColor HDThemeColor]);
    
    UIImageView * pImage = [[UIImageView alloc]init];
    pImage.image = [UIImage imageNamed:@"login_icon_user-name"];
    [self.phoneView addSubview:pImage];
    pImage.sd_layout.leftSpaceToView(self.phoneView,Gato_Width_320_(13))
    .topSpaceToView(self.phoneView,Gato_Height_548_(9))
    .widthIs(Gato_Width_320_(20))
    .heightIs(Gato_Height_548_(20));
    
    self.phoneTF.sd_layout.leftSpaceToView(self.UnderImage,30 + Gato_Width_320_(40))
    .rightSpaceToView(self.UnderImage,30 + Gato_Width_320_(13))
    .topSpaceToView(self.UnderImage,Gato_Width_320_(167))
    .heightIs(Gato_Height_548_(37));
    
    
    self.passwordView.sd_layout.leftSpaceToView(self.UnderImage,30)
    .rightSpaceToView(self.UnderImage,30)
    .topSpaceToView(self.phoneView,-1)
    .heightIs(Gato_Height_548_(37));
    
    GatoViewBorderRadius(self.passwordView, 5, 1, [UIColor HDThemeColor]);
    
    UIImageView * wImage = [[UIImageView alloc]init];
    wImage.image = [UIImage imageNamed:@"login_icon_password"];
    [self.passwordView addSubview:wImage];
    wImage.sd_layout.leftSpaceToView(self.passwordView,Gato_Width_320_(13))
    .topSpaceToView(self.passwordView,Gato_Height_548_(9))
    .widthIs(Gato_Width_320_(20))
    .heightIs(Gato_Height_548_(20));
    
    self.passwordTF.sd_layout.leftSpaceToView(self.UnderImage,30 + Gato_Width_320_(40))
    .rightSpaceToView(self.UnderImage,30 + Gato_Width_320_(13))
    .topSpaceToView(self.phoneView,0)
    .heightIs(Gato_Height_548_(37));
    
    self.wangjiButton.sd_layout.leftEqualToView(self.phoneView)
    .topSpaceToView(self.passwordView ,0)
    .widthIs(Gato_Width_320_(70))
    .heightIs(Gato_Height_548_(30));
    
    self.zhuceButton.sd_layout.rightEqualToView(self.phoneView)
    .topEqualToView(self.wangjiButton)
    .widthIs(Gato_Width_320_(70))
    .heightIs(Gato_Height_548_(30));
    
    self.dengluButton.sd_layout.leftEqualToView(self.phoneView)
    .rightEqualToView(self.phoneView)
    .bottomSpaceToView(self.UnderImage,Gato_Height_548_(175))
    .heightIs(Gato_Height_548_(32));
    
    GatoViewBorderRadius(self.dengluButton, 5, 0, [UIColor redColor]);
}
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string;
{  //string就是此时输入的那个字符 textField就是此时正在输入的那个输入框 返回YES就是可以改变输入框的值 NO相反
    
    if ([string isEqualToString:@"\n"]) //按会车可以改变
    {
        return YES;
    }
    if (textField == self.phoneTF) {
        NSString * toBeString = [textField.text stringByReplacingCharactersInRange:range withString:string];//得到输入框的内容
        NSInteger toInteger = 11;//限制长途

        if ([toBeString length] > toInteger) { //如果输入框内容大于20则弹出警告
                textField.text = [toBeString substringToIndex:toInteger];
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"只能输入11位手机号！" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
                [alert show];
                return NO;
        }
    }
    return YES;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)buttonDidClicked
{
    [self dismissViewControllerAnimated:YES completion:^{
        ;
    }];
}


-(void)dengluButton:(UIButton *)sender
{
    if (self.passwordTF.text.length < 8) {
        [self showHint:@"密码不能少于8位"];
        return;
    }
    if (self.phoneTF.text.length != 11) {
        [self showHint:@"请输入正确手机号"];
        return;
    }
    self.updateParms = [NSMutableDictionary dictionary];
    if (registerId) {
        [self.updateParms setObject:ModelNull(registerId)  forKey:@"pushId"];
    }
    
    [self.updateParms setObject:self.phoneTF.text forKey:@"phone"];
    [self.updateParms setObject:self.passwordTF.text forKey:@"password"];
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
    
    
    NSLog(@"/loginViewController.m  \n 登录");
    
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


-(void)zhuceButton:(UIButton *)sender
{
    NSLog(@"/Users/xinshuliang/Desktop/butterflyDoctor/butterflyDoctor/login（登录）/loginViewController.m  \n 注册账号");
    registeredViewController * vc = [[registeredViewController alloc]init];
//    [self presentViewController:vc animated:YES completion:nil];
    [self.navigationController pushViewController:vc animated:YES];
}
-(void)wangjimimaButton:(UIButton *)sender
{
    NSLog(@"/Users/xinshuliang/Desktop/butterflyDoctor/butterflyDoctor/login（登录）/loginViewController.m  \n 忘记密码");
    forgetPasswordViewController * vc = [[forgetPasswordViewController alloc]init];
    [self presentViewController:vc animated:YES completion:nil];
}


//注册账号
//Registered account
- (void)doRegister:(id)sender {
    if (![self isEmpty]) {
        //隐藏键盘
        [self.view endEditing:YES];
        //判断是否是中文，但不支持中英文混编
        if ([self.phoneTF.text isChinese]) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"login.nameNotSupportZh", @"Name does not support Chinese")
                                                            message:nil
                                                           delegate:nil
                                                  cancelButtonTitle:NSLocalizedString(@"ok", @"OK")
                                                  otherButtonTitles:nil];
            
            [alert show];
            
            return;
        }
        
        [self showHudInView:self.view hint:NSLocalizedString(@"register.ongoing", @"Is to register...")];
        __weak typeof(self) weakself = self;
        [[EMClient sharedClient] registerWithUsername:weakself.phoneTF.text password:weakself.passwordTF.text completion:^(NSString *aUsername, EMError *aError) {
            [weakself hideHud];
            if (!aError) {
                TTAlertNoTitle(NSLocalizedString(@"register.success", @"Registered successfully, please log in"));
            }else{
                switch (aError.code) {
                    case EMErrorServerNotReachable:
                        TTAlertNoTitle(NSLocalizedString(@"error.connectServerFail", @"Connect to the server failed!"));
                        break;
                    case EMErrorUserAlreadyExist:
                        TTAlertNoTitle(NSLocalizedString(@"register.repeat", @"You registered user already exists!"));
                        break;
                    case EMErrorNetworkUnavailable:
                        TTAlertNoTitle(NSLocalizedString(@"error.connectNetworkFail", @"No network connection!"));
                        break;
                    case EMErrorServerTimeout:
                        TTAlertNoTitle(NSLocalizedString(@"error.connectServerTimeout", @"Connect to the server timed out!"));
                        break;
                    case EMErrorServerServingForbidden:
                        TTAlertNoTitle(NSLocalizedString(@"servingIsBanned", @"Serving is banned"));
                        break;
                    default:
                        TTAlertNoTitle(NSLocalizedString(@"register.fail", @"Registration failed"));
                        break;
                }
            }
        }];
    }
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
            [[NSUserDefaults standardUserDefaults] setObject:self.phoneTF.text forKey:GET_HYP_PHOTO];
            [[NSUserDefaults standardUserDefaults] setObject:self.passwordTF.text forKey:GET_HYP_PASSWORD];
            

            Gato_DismissRootView
            AppDelegate *tempAppDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
            MainViewController *tab = (MainViewController *)tempAppDelegate.window.rootViewController;
            if (!self.navigationController || GATO_Again_Login) {
                tab.selectedIndex = 0;
            }
//            [[NSUserDefaults standardUserDefaults] setObject:@"1" forKey:GET_Again_Login];
//            tempAppDelegate.window.rootViewController = [[MainViewController alloc] init];
//            if ([tab.selectedIndex isKindOfClass:[NSIndexPath class]]) {
//                tab.selectedIndex = 0;
//            }
            
            
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

//弹出提示的代理方法
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if ([alertView cancelButtonIndex] != buttonIndex) {
        //获取文本输入框
        UITextField *nameTextField = [alertView textFieldAtIndex:0];
        if(nameTextField.text.length > 0)
        {
            //设置推送设置
            [[EMClient sharedClient] setApnsNickname:nameTextField.text];
        }
    }
    //登陆
    [self loginWithUsername:self.phoneTF.text password:self.passwordTF.text];
}

//登陆账号
- (void)doLogin:(id)sender {
    if (![self isEmpty]) {
        [self.view endEditing:YES];
        //支持是否为中文
        if ([self.phoneTF.text isChinese]) {
            UIAlertView *alert = [[UIAlertView alloc]
                                  initWithTitle:NSLocalizedString(@"login.nameNotSupportZh", @"Name does not support Chinese")
                                  message:nil
                                  delegate:nil
                                  cancelButtonTitle:NSLocalizedString(@"ok", @"OK")
                                  otherButtonTitles:nil];
            
            [alert show];
            
            return;
        }
        /*
         #if !TARGET_IPHONE_SIMULATOR
         //弹出提示
         UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:NSLocalizedString(@"login.inputApnsNickname", @"Please enter nickname for apns") delegate:self cancelButtonTitle:NSLocalizedString(@"cancel", @"Cancel") otherButtonTitles:NSLocalizedString(@"ok", @"OK"), nil];
         [alert setAlertViewStyle:UIAlertViewStylePlainTextInput];
         UITextField *nameTextField = [alert textFieldAtIndex:0];
         nameTextField.text = self.usernameTextField.text;
         [alert show];
         #elif TARGET_IPHONE_SIMULATOR
         [self loginWithUsername:_usernameTextField.text password:_passwordTextField.text];
         #endif
         */
        NSString * password = [self md5:self.passwordTF.text];
        password = [self md5:password];
        [self loginWithUsername:self.phoneTF.text password:password];
    }
}

//是否使用ip
- (void)useIpAction:(id)sender
{
    //    UISwitch *ipSwitch = (UISwitch *)sender;
    //    [[EMClient sharedClient].options setEnableDnsConfig:ipSwitch.isOn];
}

//判断账号和密码是否为空
- (BOOL)isEmpty{
    BOOL ret = NO;
    NSString *username = self.phoneTF.text;
    NSString *password = self.passwordTF.text;
    if (username.length == 0 || password.length == 0) {
        ret = YES;
        [EMAlertView showAlertWithTitle:NSLocalizedString(@"prompt", @"Prompt")
                                message:NSLocalizedString(@"login.inputNameAndPswd", @"Please enter username and password")
                        completionBlock:nil
                      cancelButtonTitle:NSLocalizedString(@"ok", @"OK")
                      otherButtonTitles:nil];
    }
    
    return ret;
}


#pragma  mark - TextFieldDelegate
-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    if (textField == self.phoneTF) {
        self.passwordTF.text = @"";
    }
    
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (textField == self.phoneTF) {
        [self.view endEditing:YES];
        [self.phoneTF resignFirstResponder];
        [self.passwordTF becomeFirstResponder];
    } else if (textField == self.passwordTF) {
        [self.phoneTF resignFirstResponder];
        [self.passwordTF resignFirstResponder];
//        [self doLogin:nil];
    }
    return YES;
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

- (NSString*)lastLoginUsername
{
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    NSString *username = [ud objectForKey:[NSString stringWithFormat:@"em_lastLogin_username"]];
    if (username && username.length > 0) {
        return username;
    }
    return nil;
}

// 测试发送消息
-(void)sendChatMsg:(NSString*)toUserId
              text:(NSString*)text{
    EMMessage *message = [EaseSDKHelper sendTextMessage:text
                                                     to:toUserId
                                            messageType:EMChatTypeChat
                                             messageExt:nil];
    
    [[EMClient sharedClient].chatManager sendMessage:message progress:nil completion:^(EMMessage *aMessage, EMError *aError) {
        if (!aError) {
            
        }
    }];
}



#pragma mark - 懒加载

-(UIButton *)dengluButton
{
    if (!_dengluButton) {
        _dengluButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_dengluButton setTitle:@"确认登陆" forState:UIControlStateNormal];
        [_dengluButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_dengluButton setBackgroundColor:[UIColor HDThemeColor]];
        _dengluButton.titleLabel.font = FONT(30);
        [_dengluButton addTarget:self action:@selector(dengluButton:) forControlEvents:UIControlEventTouchUpInside];
        [self.UnderImage addSubview:_dengluButton];
    }
    return _dengluButton;
}



-(UIButton *)zhuceButton
{
    if (!_zhuceButton) {
        _zhuceButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_zhuceButton setTitle:@"注册账号" forState:UIControlStateNormal];
        [_zhuceButton setTitleColor:[UIColor HDThemeColor] forState:UIControlStateNormal];
        _zhuceButton.titleLabel.font = FONT(26);
        [_zhuceButton addTarget:self action:@selector(zhuceButton:) forControlEvents:UIControlEventTouchUpInside];
        [self.UnderImage addSubview:_zhuceButton];
    }
    return _zhuceButton;
}



-(UIButton *)wangjiButton
{
    if (!_wangjiButton) {
        _wangjiButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_wangjiButton setTitle:@"忘记密码" forState:UIControlStateNormal];
        [_wangjiButton setTitleColor:[UIColor HDThemeColor] forState:UIControlStateNormal];
        _wangjiButton.titleLabel.font = FONT(26);
        [_wangjiButton addTarget:self action:@selector(wangjimimaButton:) forControlEvents:UIControlEventTouchUpInside];
        [self.UnderImage addSubview:_wangjiButton];
    }
    return _wangjiButton;
}

-(UIView *)passwordView
{
    if (!_passwordView) {
        _passwordView = [[UIView alloc]init];
        _passwordView.backgroundColor = [UIColor lightTextColor];
        [self.UnderImage addSubview:_passwordView];
    }
    return _passwordView;
}
-(UITextField *) passwordTF
{
    if (!_passwordTF) {
        _passwordTF = [[UITextField alloc]init];
        _passwordTF.delegate = self;
        _passwordTF.placeholder = @"请输入密码";
        [_passwordTF setSecureTextEntry:YES];
        _passwordTF.font = FONT(30);
        [self.UnderImage addSubview:_passwordTF];
    }
    return _passwordTF;
}
-(UIView *)phoneView
{
    if (!_phoneView) {
        _phoneView = [[UIView alloc]init];
        _phoneView.backgroundColor = [UIColor lightTextColor];
        [self.UnderImage addSubview:_phoneView];
    }
    return _phoneView;
}
-(UITextField *) phoneTF
{
    if (!_phoneTF) {
        _phoneTF = [[UITextField alloc]init];
        _phoneTF.delegate = self;
        _phoneTF.placeholder = @"请输入手机号";
        _phoneTF.keyboardType = UIKeyboardTypeNumberPad;
        _phoneTF.font = FONT(30);
        [self.UnderImage addSubview:_phoneTF];
    }
    return _phoneTF;
}
-(UIImageView *)UnderImage
{
    if (!_UnderImage) {
        _UnderImage = [[UIImageView alloc]init];
        if (Gato_iPhoneXHeight > 0) {
            _UnderImage.image = [UIImage imageNamed:@"iphoneXLoginImage"];
        }else{
            _UnderImage.image = [UIImage imageNamed:@"login_bg"];
        }
        _UnderImage.userInteractionEnabled = YES;
        [self.view addSubview:_UnderImage];
    }
    return _UnderImage;
}

@end
