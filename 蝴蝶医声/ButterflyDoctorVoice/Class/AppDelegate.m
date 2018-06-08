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

#import "AppDelegate.h"
#import "MainViewController.h"
#import "LoginViewController.h"

#import "AppDelegate+EaseMob.h"
#import "AppDelegate+UMeng.h"
#import "RedPacketUserConfig.h"
#import <UserNotifications/UserNotifications.h>
#import "GatoBaseHelp.h"
#import "DLTabBarController.h"
#import "ChatUIHelper.h"
#import "IWHttpTool.h"

#import <IQKeyboardManager.h>
#import <UMSocialCore/UMSocialCore.h>
#import "JPUSHService.h"
// iOS10注册APNs所需头文件
#ifdef NSFoundationVersionNumber_iOS_9_x_Max
#import <UserNotifications/UserNotifications.h>
#endif
// 如果需要使用idfa功能所需要引入的头文件（可选）
#import <AdSupport/AdSupport.h>

//------JPush跳转页面------//
#import "homeViewController.h"
#import "MineHomeViewController.h"
#import "MyTeamViewController.h"
#import "WorkAddressViewController.h"
#import "ImageMessageViewController.h"
#import "TheArticleViewController.h"
#import "releaseStopWorkViewController.h"
#import "DoctorHomeViewController.h"
#import "APPMessageViewController.h"
#import "MyTeamAuditViewController.h"
#import "MineBankCardViewController.h"
#import "PellTableViewSelect.h"
//---------END------------//
@interface AppDelegate () <UNUserNotificationCenterDelegate,UITabBarControllerDelegate,JPUSHRegisterDelegate>
@property (nonatomic, strong) DLTabBarController *tabbarVC;
@end


@implementation AppDelegate



- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    if (NSClassFromString(@"UNUserNotificationCenter")) {
        [UNUserNotificationCenter currentNotificationCenter].delegate = self;
    }
#ifdef REDPACKET_AVALABLE
    /**
     *  TODO: 通过环信的AppKey注册红包
     */
    [[RedPacketUserConfig sharedConfig] configWithAppKey:EaseMobAppKey];
#endif
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.backgroundColor = [UIColor whiteColor];
    

    //极光推送
    JPUSHRegisterEntity * entity = [[JPUSHRegisterEntity alloc] init];
    entity.types = JPAuthorizationOptionAlert|JPAuthorizationOptionBadge|JPAuthorizationOptionSound;
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 8.0) {
        // 可以添加自定义categories
        // NSSet<UNNotificationCategory *> *categories for iOS10 or later
        // NSSet<UIUserNotificationCategory *> *categories for iOS8 and iOS9
    }
    [JPUSHService registerForRemoteNotificationConfig:entity delegate:self];
    
    BOOL isProduction = NO;//是否生产环境. 如果为开发状态,设置为 NO; 如果为生产状态,应改为 YES.
    NSString *advertisingId = [[[ASIdentifierManager sharedManager] advertisingIdentifier] UUIDString];
    [JPUSHService setupWithOption:launchOptions appKey:Gato_JPush_KEY
                          channel:@"App Store"
                 apsForProduction:isProduction
            advertisingIdentifier:advertisingId];
    
    
    //键盘回收
    IQKeyboardManager *manager = [IQKeyboardManager sharedManager];
    manager.enable = YES;
    manager.shouldResignOnTouchOutside = YES;//这个是点击空白区域键盘收缩的开关
    manager.enableAutoToolbar = NO;//这个是它自带键盘工具条开关

    
    
    //友盟分享
    /* 打开调试日志 */
    [[UMSocialManager defaultManager] openLog:YES];
    /* 设置友盟appkey */
    [[UMSocialManager defaultManager] setUmSocialAppkey:Gato_UMSocial_KEY];
    [self configUSharePlatforms];
    
    [self confitUShareSettings];
    

    
    
    if ([UIDevice currentDevice].systemVersion.floatValue >= 7.0) {
        [[UINavigationBar appearance] setBarTintColor:RGBACOLOR(30, 167, 252, 1)];
        [[UINavigationBar appearance] setTitleTextAttributes:
         [NSDictionary dictionaryWithObjectsAndKeys:RGBACOLOR(245, 245, 245, 1), NSForegroundColorAttributeName, [UIFont fontWithName:@ "HelveticaNeue-CondensedBlack" size:21.0], NSFontAttributeName, nil]];
    }
    
    // 环信UIdemo中有用到友盟统计crash，您的项目中不需要添加，可忽略此处。
//    [self setupUMeng];
    
#warning Init SDK，detail in AppDelegate+EaseMob.m
#warning SDK注册 APNS文件的名字, 需要与后台上传证书时的名字一一对应
    NSString *apnsCertName = nil;
#if DEBUG
    apnsCertName = @"hudieDeve";
#else
    apnsCertName = @"hudiePro";
#endif
    
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    NSString *appkey = [ud stringForKey:@"identifier_appkey"];
    if (!appkey) {
        appkey = EaseMobAppKey;
        [ud setObject:appkey forKey:@"identifier_appkey"];
    }

    
    [self easemobApplication:application
didFinishLaunchingWithOptions:launchOptions
                      appkey:EaseMobAppKey
                apnsCertName:apnsCertName
                 otherConfig:@{kSDKConfigEnableConsoleLogger:[NSNumber numberWithBool:YES]}];

    [self.window makeKeyAndVisible];
    [self setNav];
    
    
    /**
     注册APNS离线推送  iOS8 注册APNS
     */
    if ([application respondsToSelector:@selector(registerForRemoteNotifications)]) {
        [application registerForRemoteNotifications];
        UIUserNotificationType notificationTypes = UIUserNotificationTypeBadge |
        UIUserNotificationTypeSound |
        UIUserNotificationTypeAlert;
        UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:notificationTypes categories:nil];
        [application registerUserNotificationSettings:settings];
    }
    else{
        UIRemoteNotificationType notificationTypes = UIRemoteNotificationTypeBadge |
        UIRemoteNotificationTypeSound |
        UIRemoteNotificationTypeAlert;
        [[UIApplication sharedApplication] registerForRemoteNotificationTypes:notificationTypes];
    }
    
    //实时监听推送消息
    [[EMClient sharedClient].chatManager addDelegate:self delegateQueue:nil];
    
    
    
    return YES;
}



#pragma mark - navView颜色
- (void)setNav
{
    UINavigationBar *bar = [UINavigationBar appearance];
    bar.barTintColor = [UIColor HDThemeColor];
    bar.tintColor = [UIColor whiteColor];
    [bar setTitleTextAttributes:@{ NSForegroundColorAttributeName : [UIColor whiteColor],
                                   NSFontAttributeName : [UIFont boldSystemFontOfSize:20]
                                   }];
}


- (BOOL)tabBarController:(UITabBarController *)tabBarController shouldSelectViewController:(UIViewController *)viewController
{
    NSLog(@"--tabbaritem.title--%@",viewController.tabBarItem.title);
  
    if (TOKEN) { return YES;}
    else{
        loginViewController *login = [[loginViewController alloc] init];
        [((UINavigationController *)tabBarController.selectedViewController) presentViewController:login animated:NO completion:nil];
        return NO;
    }
}

// 将得到的deviceToken传给SDK
- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken{
    [[EMClient sharedClient] bindDeviceToken:deviceToken];
}

// 注册deviceToken失败
- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error{
    NSLog(@"error -- %@",error);
}

// APP进入后台
- (void)applicationDidEnterBackground:(UIApplication *)application
{
    [[EMClient sharedClient] applicationDidEnterBackground:application];
   
}

// APP将要从后台返回
- (void)applicationWillEnterForeground:(UIApplication *)application
{
//    [SVProgressHUD showWithStatus:@"App正在重新连接.."];
//    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeBlack];
//    [SVProgressHUD show];
    [[EMClient sharedClient] applicationWillEnterForeground:application];
}

#pragma mark- JPUSHRegisterDelegate



// iOS 10 Support
- (void)jpushNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(NSInteger))completionHandler {
    // Required
    NSDictionary * userInfo = notification.request.content.userInfo;
    if([notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
        [JPUSHService handleRemoteNotification:userInfo];
    }
    completionHandler(UNNotificationPresentationOptionAlert); // 需要执行这个方法，选择是否提醒用户，有Badge、Sound、Alert三种类型可以选择设置
}

// iOS 10 Support
- (void)jpushNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void (^)())completionHandler {
    // Required
    NSDictionary * userInfo = response.notification.request.content.userInfo;
    if([response.notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
        [JPUSHService handleRemoteNotification:userInfo];
        
        [self goToJPushVCWithType:[userInfo objectForKey:@"ext"]];
    }
    completionHandler();  // 系统要求执行这个方法
}
/*1 组内信息
 2 我的医疗组
 3 执业地点
 4 图文咨询
 5 患教文章
 6 停诊公告
 7 门诊时间
 8 医生信息
 9 站内消息
 10 加组申请审核 
 11 跳转至我的银行卡页面
 20 审核结果-通过
 22 审核结果-拒绝*/
- (void)goToJPushVCWithType:(NSString *)type
{
    if (!TOKEN) {
        return;
    }
    
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
        if ([type isEqualToString:@"22"] || [type isEqualToString:@"20"] ) {
            [self shenheHttpWithViweController:nil];
        }
    }
    else
    {
        UIViewController * NowVC = [GatoMethods getCurrentViewController];
        [NowVC.navigationController popToRootViewControllerAnimated:NO];
        AppDelegate *app = (AppDelegate *)[UIApplication sharedApplication].delegate;
        MainViewController *tab = (MainViewController *)app.window.rootViewController;
        tab.selectedIndex = 0;
    
    
        NSLog(@"跳转type ：%@",type);
        [[NSUserDefaults standardUserDefaults] setObject:@"1" forKey:GET_JPush_Dismiss];
        [[NSUserDefaults standardUserDefaults] setObject:@"1" forKey:GET_JPush_Welcome_AD];
        switch ([type integerValue]) {
            case 1:
            {
                MyTeamViewController * vc = [MyTeamViewController new];
    //            homeViewController * HomeVc = [homeViewController new];
    //            UINavigationController * Nav = [[UINavigationController alloc]initWithRootViewController:HomeVc];
    //            [self.window.rootViewController presentViewController:Nav animated:NO completion:nil];
                vc.hidesBottomBarWhenPushed = YES;
                [tab.selectedViewController pushViewController:vc animated:NO];
                return;
            }
                break;
            case 2:
            {
                MyTeamViewController * vc = [MyTeamViewController new];
                vc.comeForMine = @"0";
    //            homeViewController * HomeVc = [homeViewController new];
    //            UINavigationController * Nav = [[UINavigationController alloc]initWithRootViewController:HomeVc];
    //            [self.window.rootViewController presentViewController:Nav animated:NO completion:nil];
                vc.hidesBottomBarWhenPushed = YES;
                [tab.selectedViewController pushViewController:vc animated:NO];
                return;
            }
                break;
            case 3:
            {
                WorkAddressViewController * vc = [[WorkAddressViewController alloc]init];
    //            homeViewController * HomeVc = [homeViewController new];
    //            UINavigationController * Nav = [[UINavigationController alloc]initWithRootViewController:HomeVc];
    //            [self.window.rootViewController presentViewController:Nav animated:NO completion:nil];
                vc.hidesBottomBarWhenPushed = YES;
                [tab.selectedViewController pushViewController:vc animated:NO];
                return;
            }
                break;
            case 4:
            {
                ImageMessageViewController * vc = [[ImageMessageViewController alloc]init];
    //            homeViewController * HomeVc = [homeViewController new];
    //            UINavigationController * Nav = [[UINavigationController alloc]initWithRootViewController:HomeVc];
    //            [self.window.rootViewController presentViewController:Nav animated:NO completion:nil];
                vc.hidesBottomBarWhenPushed = YES;
                [tab.selectedViewController pushViewController:vc animated:NO];
                return;
            }
                break;
            case 5:
            {
                TheArticleViewController * vc = [TheArticleViewController new];
                vc.hidesBottomBarWhenPushed = YES;
                [tab.selectedViewController pushViewController:vc animated:NO];
                return;
            }
                break;
            case 6:
            {
                releaseStopWorkViewController * vc = [releaseStopWorkViewController new];
                vc.JPushType = @"0";
                vc.hidesBottomBarWhenPushed = YES;
                [tab.selectedViewController pushViewController:vc animated:NO];
                return;
            }
                break;
            case 7:
            {
                releaseStopWorkViewController * vc = [releaseStopWorkViewController new];
                vc.JPushType = @"1";
                vc.hidesBottomBarWhenPushed = YES;
                [tab.selectedViewController pushViewController:vc animated:NO];
                return;
            }
                break;
            case 8:
            {
                
                DoctorHomeViewController * vc = [[DoctorHomeViewController alloc]init];
                vc.doctorId = TOKEN;
                vc.hidesBottomBarWhenPushed = YES;
                [tab.selectedViewController pushViewController:vc animated:NO];
                return;
                
            }
                break;
            case 9:
            {
                APPMessageViewController * vc = [APPMessageViewController new];
                vc.hidesBottomBarWhenPushed = YES;
                [tab.selectedViewController pushViewController:vc animated:NO];
                return;
            }
                break;
            case 10:
            {
                MyTeamAuditViewController * vc = [MyTeamAuditViewController new];
                vc.hidesBottomBarWhenPushed = YES;
                [tab.selectedViewController pushViewController:vc animated:NO];
                return;
            }
                break;
            case 11:
            {
                MineBankCardViewController * vc = [MineBankCardViewController new];
                vc.pushCome = @"1";
                vc.hidesBottomBarWhenPushed = YES;
                [tab.selectedViewController pushViewController:vc animated:NO];
                return;
            }
                break;
            case 20:
            {
                [self shenheHttpWithViweController:nil];
                return;
            }
                break;
            case 22:
            {
                [self shenheHttpWithViweController:nil];
                return;
            }
                break;
            default:
                break;
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
            [PellTableViewSelect hiden];
            for (UIView * view in self.window.subviews) {
                [view removeAllSubviews];
            }
             //审核通过
            self.window.rootViewController = self.mainController;
            [[NSUserDefaults standardUserDefaults] setObject:@"1" forKey:GET_HomeAD_Hidden];
        }
    } failure:^(NSError *error) {
        ;
    }];
    
}
#pragma mark - app将要结束时需要执行的操作
-(void)applicationWillTerminate:(UIApplication *)application
{
    [[NSUserDefaults standardUserDefaults] setObject:@"0" forKey:GET_JPush_Welcome_AD];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:GET_Again_Login];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:Get_registered_Image];
}
- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler {
    
    // Required, iOS 7 Support
    [JPUSHService handleRemoteNotification:userInfo];
    completionHandler(UIBackgroundFetchResultNewData);
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
        // iOS 10 以下 Required
    [JPUSHService handleRemoteNotification:userInfo];
    if (_mainController) {
        [_mainController jumpToChatList];
    }
    [self easemobApplication:application didReceiveRemoteNotification:userInfo];
}

- (void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification
{
    NSLog(@"点击推送进入  notification：%@",notification);
    if (_mainController) {
        [_mainController didReceiveLocalNotification:notification];
    }
}

- (void)userNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(UNNotificationPresentationOptions))completionHandler
{
    NSDictionary *userInfo = notification.request.content.userInfo;
    [self easemobApplication:[UIApplication sharedApplication] didReceiveRemoteNotification:userInfo];
}

- (void)userNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void (^)())completionHandler
{
    if (_mainController) {
        [_mainController didReceiveUserNotification:response.notification];
    }
    completionHandler();
}
#pragma mark - UMSocial 分享
- (void)confitUShareSettings
{
    /*
     * 打开图片水印
     */
    //[UMSocialGlobal shareInstance].isUsingWaterMark = YES;
    
    /*
     * 关闭强制验证https，可允许http图片分享，但需要在info.plist设置安全域名
     <key>NSAppTransportSecurity</key>
     <dict>
     <key>NSAllowsArbitraryLoads</key>
     <true/>
     </dict>
     */
    //[UMSocialGlobal shareInstance].isUsingHttpsWhenShareContent = NO;
    
}

- (void)configUSharePlatforms
{
    /* 设置微信的appKey和appSecret */
    [[UMSocialManager defaultManager] setPlaform:UMSocialPlatformType_WechatSession appKey:@"wx5d0107004ad5cef5" appSecret:@"63efb34587592fab90cbb24f9339bcdf" redirectURL:@"http://www.hudieyisheng.com/"];
    /*
     * 移除相应平台的分享，如微信收藏
     */
    //[[UMSocialManager defaultManager] removePlatformProviderWithPlatformTypes:@[@(UMSocialPlatformType_WechatFavorite)]];
    
    /* 设置分享到QQ互联的appID
     * U-Share SDK为了兼容大部分平台命名，统一用appKey和appSecret进行参数设置，而QQ平台仅需将appID作为U-Share的appKey参数传进即可。
     */
    [[UMSocialManager defaultManager] setPlaform:UMSocialPlatformType_QQ appKey:@"1106074277"/*设置QQ平台的appID*/  appSecret:nil redirectURL:@"http://www.hudieyisheng.com/"];

    [[UMSocialManager defaultManager] removePlatformProviderWithPlatformTypes:@[@(UMSocialPlatformType_Sina)]];
    /* 设置新浪的appKey和appSecret */
//    [[UMSocialManager defaultManager] setPlaform:UMSocialPlatformType_Sina appKey:@"3921700954"  appSecret:@"04b48b094faeb16683c32669824ebdad" redirectURL:@"https://sns.whalecloud.com/sina2/callback"];

    
}
- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    if (application.applicationIconBadgeNumber>0) {//badge number 不为0，说明程序有那个圈圈图标
        NSLog(@"我可能收到了推送");
        //这里进行有关处理
//        [application setApplicationIconBadgeNumber:0];//将图标清零。
    }
}



@end
