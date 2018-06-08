/************************************************************
 *  * Hyphenate CONFIDENTIAL
 * __________________
 * Copyright (C) 2016 Hyphenate Inc. All rights reserved.
 *
 * NOTICE: All information contained herein is, and remains
 * the property of Hyphenate Inc.
 * Dissemination of this information or reproduction of this material
 * is strictly forbidden unless prior written permission is obtained
 * from Hyphenate Inc.
 */

#import "AppDelegate+EaseMob.h"
#import "AppDelegate+EaseMobDebug.h"

#import "EMNavigationController.h"
#import "loginViewController.h"
#import "ChatUIHelper.h"
#import "MBProgressHUD.h"
#import "GatoBaseHelp.h"
#import "DLTabBarController.h"
#import "nextRigisteredViewController.h"
/**
 *  本类中做了EaseMob初始化和推送等操作
 */

#import "JPUSHService.h"
// iOS10注册APNs所需头文件
#ifdef NSFoundationVersionNumber_iOS_9_x_Max
#import <UserNotifications/UserNotifications.h>
#endif
// 如果需要使用idfa功能所需要引入的头文件（可选）
#import <AdSupport/AdSupport.h>
#import "PellTableViewSelect.h"



@implementation AppDelegate (EaseMob)

- (void)easemobApplication:(UIApplication *)application
didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
                    appkey:(NSString *)appkey
              apnsCertName:(NSString *)apnsCertName
               otherConfig:(NSDictionary *)otherConfig
{
    //注册登录状态监听
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(loginStateChange:)
                                                 name:KNOTIFICATION_LOGINCHANGE
                                               object:nil];
    
    [[NSUserDefaults standardUserDefaults] setObject:@"0" forKey:GET_FIRST];
    
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    BOOL isHttpsOnly = [ud boolForKey:@"identifier_httpsonly"];
    
    [[EaseSDKHelper shareHelper] hyphenateApplication:application
                    didFinishLaunchingWithOptions:launchOptions
                                           appkey:appkey
                                     apnsCertName:apnsCertName
                                      otherConfig:@{@"httpsOnly":[NSNumber numberWithBool:isHttpsOnly], kSDKConfigEnableConsoleLogger:[NSNumber numberWithBool:YES],@"easeSandBox":[NSNumber numberWithBool:[self isSpecifyServer]]}];
    
    [ChatUIHelper shareHelper];
    
    BOOL isAutoLogin = [EMClient sharedClient].isAutoLogin;
    if (isAutoLogin){
        [[NSNotificationCenter defaultCenter] postNotificationName:KNOTIFICATION_LOGINCHANGE object:@YES];
    }
    else
    {
        [[NSNotificationCenter defaultCenter] postNotificationName:KNOTIFICATION_LOGINCHANGE object:@NO];
    }

    // 注册web缓存
    [UserWebManager config:launchOptions
                     appId:@"VBYeQuiVPD9CWS2aINWrwBv0-gzGzoHsz"
                    appKey:@"1LItewi0x6hlkgYHxi8DERNN"];


    
}

- (void)easemobApplication:(UIApplication *)application
didReceiveRemoteNotification:(NSDictionary *)userInfo
{
    [[EaseSDKHelper shareHelper] hyphenateApplication:application didReceiveRemoteNotification:userInfo];
}

#pragma mark - App Delegate

// 将得到的deviceToken传给SDK
- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken
{
    [[EMClient sharedClient] bindDeviceToken:deviceToken];
    [JPUSHService registerDeviceToken:deviceToken];
    NSNotificationCenter *defaultCenter = [NSNotificationCenter defaultCenter];
    [defaultCenter addObserver:self selector:@selector(networkDidReceiveMessage:) name:kJPFNetworkDidLoginNotification object:nil];
}
-(void)networkDidReceiveMessage:(NSNotification *)notification{
    NSString *registerid = [JPUSHService registrationID];
    if (registerid) {
        NSLog(@"GET_TOKEN_registerId :%@",registerid);
        [self updateRegisterIdWithReg:registerid];
        [[NSUserDefaults standardUserDefaults] setObject:registerid forKey:GET_TOKEN_registerId];
    }
    
}
//更新registerId
-(void)updateRegisterIdWithReg:(NSString *)reg
{
    if (TOKEN) {
        NSMutableDictionary * dic = [NSMutableDictionary dictionary];
        
        [dic setObject:TOKEN forKey:@"token"];
        [dic setObject:reg forKey:@"pushId"];
        [IWHttpTool postWithURL:@"http://api.hudieyisheng.com/v1/home/update-pushid" params:dic success:^(id json) {
            
            NSDictionary * dic = [NSJSONSerialization JSONObjectWithData:json options:NSJSONReadingAllowFragments error:nil];
            NSString * success = [dic objectForKey:@"code"];
            if ([success isEqualToString:@"200"]) {
                
            }else{
                NSString * falseMessage = [dic objectForKey:@"message"];
            }
            
        } failure:^(NSError *error) {
            NSLog(@"%@",error);
        }];
    }
    
}
#pragma mark - login changed

- (void)loginStateChange:(NSNotification *)notification
{
    
    if (TOKEN) {
        
        BOOL loginSuccess = [notification.object boolValue];
        EMNavigationController *navigationController = nil;
        if (loginSuccess) {//登陆成功加载主窗口控制器
            //加载申请通知的数据
            [[ApplyViewController shareController] loadDataSourceFromLocalDB];
            if (self.mainController == nil) {
                self.mainController = [[MainViewController alloc] init];
                //            navigationController = [[EMNavigationController alloc] initWithRootViewController:self.mainController];
                
            }else{
                //            navigationController  = (EMNavigationController *)self.mainController.navigationController;
            }
            navigationController.navigationBar.accessibilityIdentifier = @"navigationbar";
            
                if ([GATO_FIRST isEqualToString:@"0"] && !Gato_Login_isVerify) {
                    static dispatch_once_t onceToken;
                    dispatch_once(&onceToken, ^{
                        UIViewController * vc = [[UIViewController alloc]init];
                        UIImageView * image = [[UIImageView alloc]init];
                        image.image = [UIImage imageNamed:@"welcome_1242×2208"];
                        [vc.view addSubview:image];
                        image.frame = vc.view.bounds;
                        self.window.rootViewController = vc;
                        [[NSUserDefaults standardUserDefaults] setObject:@"1" forKey:GET_FIRST];
                        [self shenheHttpWithViweController:nil];
                    });
                }else{
                    NSLog(@"Gato_Login_isVerify : %@",Gato_Login_isVerify);
                    if ([Gato_Login_isVerify isEqualToString:@"-1"]) {
                        loginViewController *login = [[loginViewController alloc] init];
                        self.window.rootViewController = [[UINavigationController alloc] initWithRootViewController:login];
                        [[NSUserDefaults standardUserDefaults] setObject:@"1" forKey:GET_HomeAD_Hidden];
                    }else if ([Gato_Login_isVerify isEqualToString:@"0"]){
                        
                        [[NSUserDefaults standardUserDefaults] setObject:@"0" forKey:GET_HomeAD_Hidden];
                        UIViewController * vc = [[UIViewController alloc]init];
                        UIImageView * timeImage = [[UIImageView alloc]initWithFrame:vc.view.bounds];
                        NSData *imageData;
                        if (Gato_registered_Image) {
                            imageData = GATO_ShenHe_Image;
                            UIImage *image = [UIImage imageWithData: imageData];
                            timeImage.image = image;
                        }else{
                            timeImage.image = [UIImage imageNamed:@"welcome_1242×2208"];
                        }
                        [vc.view addSubview:timeImage];
                        self.window.rootViewController = vc;
                        
                    }else if ([Gato_Login_isVerify isEqualToString:@"1"]){
                        self.window.rootViewController = self.mainController;
                        [[NSUserDefaults standardUserDefaults] setObject:@"1" forKey:GET_HomeAD_Hidden];
                    }else{
                        UIViewController * vc = [[UIViewController alloc]init];
                        self.window.rootViewController = vc;
                    }
                    [self shenheHttpWithViweController:nil];
                }
            //        self.window.rootViewController = self.mainController;
            //        [[NSUserDefaults standardUserDefaults] setObject:@"1" forKey:GET_HomeAD_Hidden];
            
            
            [ChatUIHelper shareHelper].mainVC = self.mainController;
            
            [[ChatUIHelper shareHelper] asyncGroupFromServer];
            [[ChatUIHelper shareHelper] asyncConversationFromDB];
            [[ChatUIHelper shareHelper] asyncPushOptions];
        }else{//登陆失败加载登陆页面控制器
            if (self.mainController) {
                [self.mainController.navigationController popToRootViewControllerAnimated:NO];
            }
            self.mainController = nil;
            [ChatUIHelper shareHelper].mainVC = nil;
            if ([Gato_Login_isVerify isEqualToString:@"0"]){
           
                //                [PellTableViewSelect addPellTableViewSelectWithwithView:image WindowFrame:CGRectMake(0, 0, Gato_Width, Gato_Height) WithViewFrame:CGRectMake(0, 0, Gato_Width, Gato_Height) selectData:nil action:nil animated:YES];
                [[NSUserDefaults standardUserDefaults] setObject:@"0" forKey:GET_HomeAD_Hidden];
                UIViewController * vc = [[UIViewController alloc]init];
                UIImageView * timeImage = [[UIImageView alloc]initWithFrame:vc.view.bounds];
                NSData *imageData;
                if (Gato_registered_Image) {
                    imageData = GATO_ShenHe_Image;
                    UIImage *image = [UIImage imageWithData: imageData];
                    timeImage.image = image;
                }else{
                    timeImage.image = [UIImage imageNamed:@"welcome_1242×2208"];
                }
                [vc.view addSubview:timeImage];
                self.window.rootViewController = vc;
            }else{
                [[NSUserDefaults standardUserDefaults] removeObjectForKey:GET_TOKEN];
                [[NSUserDefaults standardUserDefaults] removeObjectForKey:GET_Again_Login];
                loginViewController *login = [[loginViewController alloc] init];
                self.window.rootViewController = [[UINavigationController alloc] initWithRootViewController:login];
            }
            
            if (TOKEN) {
                [self logout];
            }
            
        }
        //设置7.0以下的导航栏
        if ([UIDevice currentDevice].systemVersion.floatValue < 7.0){
            navigationController.navigationBar.barStyle = UIBarStyleDefault;
            [navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"titleBar"]
                                                     forBarMetrics:UIBarMetricsDefault];
            [navigationController.navigationBar.layer setMasksToBounds:YES];
        }
        
    }else{
        if ([Gato_Login_isVerify isEqualToString:@"0"]){
            
            //                [PellTableViewSelect addPellTableViewSelectWithwithView:image WindowFrame:CGRectMake(0, 0, Gato_Width, Gato_Height) WithViewFrame:CGRectMake(0, 0, Gato_Width, Gato_Height) selectData:nil action:nil animated:YES];
            [[NSUserDefaults standardUserDefaults] setObject:@"0" forKey:GET_HomeAD_Hidden];
            UIViewController * vc = [[UIViewController alloc]init];
            UIImageView * timeImage = [[UIImageView alloc]initWithFrame:vc.view.bounds];
            NSData *imageData = GATO_ShenHe_Image;
            UIImage *image = [UIImage imageWithData: imageData];
            timeImage.image = image;
            [vc.view addSubview:timeImage];
            self.window.rootViewController = vc;
        }else{
            loginViewController *login = [[loginViewController alloc] init];
            self.window.rootViewController = [[UINavigationController alloc] initWithRootViewController:login];
            return;
        }
    }
    
    
    
    
    
}
- (void)shenheHttpWithViweController:(UIViewController *)vc
{
    NSMutableDictionary * dic = [NSMutableDictionary dictionary];
    [dic setObject:TOKEN forKey:@"token"];
    [IWHttpTool postWithURL:@"http://api.hudieyisheng.com/v1/home/is-verify" params:dic success:^(id json) {
        NSDictionary * dic = [NSJSONSerialization JSONObjectWithData:json options:NSJSONReadingAllowFragments error:nil];
        NSString * isVerify = [[[dic objectForKey:@"data"] objectForKey:@"info"] objectForKey:@"isVerify"];
        [[NSUserDefaults standardUserDefaults] setObject:isVerify forKey:GET_Login_isVerify];
        if ([isVerify isEqualToString:@"-1"]) {
            //审核被拒绝
            EMError *error = [[EMClient sharedClient] logout:YES];
            if (!error) {
                NSLog(@"退出成功");
            }
            [[NSUserDefaults standardUserDefaults] removeObjectForKey:GET_TOKEN];
            [[NSUserDefaults standardUserDefaults] removeObjectForKey:GET_Again_Login];
            loginViewController *login = [[loginViewController alloc] init];
            self.window.rootViewController = [[UINavigationController alloc] initWithRootViewController:login];
            [[NSUserDefaults standardUserDefaults] setObject:@"1" forKey:GET_HomeAD_Hidden];
        }else if ([isVerify isEqualToString:@"0"]){
            //审核中
            
            [[NSUserDefaults standardUserDefaults] setObject:@"0" forKey:GET_HomeAD_Hidden];
            UIViewController * vc = [[UIViewController alloc]init];
            UIImageView * timeImage = [[UIImageView alloc]initWithFrame:vc.view.bounds];
            NSData *imageData = GATO_ShenHe_Image;
            UIImage *image = [UIImage imageWithData: imageData];
            timeImage.image = image;
            [vc.view addSubview:timeImage];
            self.window.rootViewController = vc;
        }else if ([isVerify isEqualToString:@"1"]){
            //审核通过
            self.window.rootViewController = self.mainController;
            [[NSUserDefaults standardUserDefaults] setObject:@"1" forKey:GET_HomeAD_Hidden];
        }
    } failure:^(NSError *error) {
        ;
    }];
    
}
#pragma mark - 退出登录
-(void)logout
{
    NSMutableDictionary * dic = [NSMutableDictionary dictionary];
    [dic setObject:TOKEN forKey:@"token"];
    [IWHttpTool postWithURL:HD_OUT_TOKEN params:dic success:^(id json) {
        
        NSDictionary * dic = [NSJSONSerialization JSONObjectWithData:json options:NSJSONReadingAllowFragments error:nil];
        NSString * success = [dic objectForKey:@"code"];
        if ([success isEqualToString:@"200"]) {
            [[NSUserDefaults standardUserDefaults] removeObjectForKey:GET_TOKEN];
            [[NSUserDefaults standardUserDefaults] removeObjectForKey:GET_Again_Login];
            loginViewController *login = [[loginViewController alloc] init];
            self.window.rootViewController = [[UINavigationController alloc] initWithRootViewController:login];
        }else{
            [[NSUserDefaults standardUserDefaults] removeObjectForKey:GET_TOKEN];
            [[NSUserDefaults standardUserDefaults] removeObjectForKey:GET_Again_Login];
            loginViewController *login = [[loginViewController alloc] init];
            self.window.rootViewController = [[UINavigationController alloc] initWithRootViewController:login];
        }
        
    } failure:^(NSError *error) {
        NSLog(@"%@",error);
    }];
    
}


#pragma mark - EMPushManagerDelegateDevice

// 打印收到的apns信息
-(void)didReceiveRemoteNotification:(NSDictionary *)userInfo
{
    NSError *parseError = nil;
    NSData  *jsonData = [NSJSONSerialization dataWithJSONObject:userInfo
                                                        options:NSJSONWritingPrettyPrinted error:&parseError];
    NSString *str =  [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"apns.content", @"Apns content")
                                                    message:str
                                                   delegate:nil
                                          cancelButtonTitle:NSLocalizedString(@"ok", @"OK")
                                          otherButtonTitles:nil];
    [alert show];
    
}

- (void)didUnreadMessagesCountChanged
{
    NSLog(@"我好像接收到了消息");
}

@end
