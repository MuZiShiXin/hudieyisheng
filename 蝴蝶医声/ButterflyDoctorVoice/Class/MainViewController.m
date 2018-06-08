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

#import "MainViewController.h"

#import "SettingsViewController.h"
#import "ApplyViewController.h"
#import "ChatViewController.h"

#import "ConversationListController.h"
#import "ContactListViewController.h"
#import "ChatUIHelper.h"
#import "RedPacketChatViewController.h"
#import <UserNotifications/UserNotifications.h>


#import "homeViewController.h"
#import "HospitalizedPatientsViewController.h"
#import "honorHomeViewController.h"
#import "MineHomeViewController.h"
#import "MyTeamViewController.h"
#import "GatoBaseHelp.h"
#import "IMMessageOneForAllViewController.h"
#import "ImMessageOneForOneViewController.h"
#import "AppDelegate.h"
#import "UITabBar+bedge.h"
static NSString *kConversationChatter = @"ConversationChatter";
static NSString *kMessageType = @"MessageType";

#if DEMO_CALL == 1
#import <Hyphenate/Hyphenate.h>

@interface MainViewController () <UIAlertViewDelegate, EMCallManagerDelegate>
#else
@interface MainViewController () <UIAlertViewDelegate>
#endif
{
    ConversationListController *_chatListVC;
    ContactListViewController *_contactsVC;
    SettingsViewController *_settingsVC;
    ConversationListController *_otherVC;
    UIBarButtonItem *_addFriendItem;
//   住院患者页面
    HospitalizedPatientsViewController * patients;
//   我的页面
    MineHomeViewController * mine;
//   主页面 工作站
    homeViewController *home;
}
@end

@implementation MainViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self setupSubviews];
    self.selectedIndex = 0;
    //if 使tabBarController中管理的viewControllers都符合 UIRectEdgeNone
    if ([self respondsToSelector:@selector(setEdgesForExtendedLayout:)]) {
        [self setEdgesForExtendedLayout: UIRectEdgeNone];
    }
    
    self.title = @"蝴蝶医声";
    
    //获取未读消息数，此时并没有把self注册为SDK的delegate，读取出的未读数是上次退出程序时的
    //    [self didUnreadMessagesCountChanged];
    NOTIFY_ADD(setupUntreatedApplyCount, kSetupUntreatedApplyCount);
    NOTIFY_ADD(setupUnreadMessageCount, kSetupUnreadMessageCount);
    NOTIFY_ADD(networkChanged, kConnectionStateChanged);
    
    
    

    
    [self setupUnreadMessageCount];
    [self setupUntreatedApplyCount];
    
    
    [ChatUIHelper shareHelper].contactViewVC = _contactsVC;
    [ChatUIHelper shareHelper].conversationListVC = _chatListVC;
}



- (void)PushSelectedIndex:(NSInteger )index
{
    self.selectedIndex = index;
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter]removeObserver:@"homeMessage"];
}


#pragma mark - UITabBarDelegate

- (void)tabBar:(UITabBar *)tabBar didSelectItem:(UITabBarItem *)item
{
    if (item.tag == 0) {
        self.title = @"蝴蝶医声";
        self.navigationItem.rightBarButtonItem = nil;
        self.navigationItem.rightBarButtonItems = nil;
    }else if (item.tag == 1){
        self.title = @"住院患者";
        UIButton*right1Button = [[UIButton alloc]initWithFrame:CGRectMake(0,0,Gato_Width_320_(17),Gato_Height_548_(18))];
        [right1Button setBackgroundImage:[UIImage imageNamed:@"nav_essay"] forState:UIControlStateNormal];
        right1Button.titleLabel.font = FONT(30);
        [right1Button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [right1Button addTarget:patients action:@selector(mobanButton)forControlEvents:UIControlEventTouchUpInside];
        UIBarButtonItem*rightItem1 = [[UIBarButtonItem alloc]initWithCustomView:right1Button];
        
        UIButton*right2Button = [[UIButton alloc]initWithFrame:CGRectMake(0,0,Gato_Width_320_(17),Gato_Height_548_(18))];
        [right2Button setBackgroundImage:[UIImage imageNamed:@"nav_seek"] forState:UIControlStateNormal];
        right2Button.titleLabel.font = FONT(30);
        [right2Button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [right2Button addTarget:patients action:@selector(searchButton)forControlEvents:UIControlEventTouchUpInside];
        UIBarButtonItem*rightItem2 = [[UIBarButtonItem alloc]initWithCustomView:right2Button];
        self.navigationItem.rightBarButtonItems = @[rightItem2,rightItem1];
    }else if (item.tag == 3){
        self.title = @"我的";
        UIButton*right2Button = [[UIButton alloc]initWithFrame:CGRectMake(0,0,Gato_Width_320_(19),Gato_Height_548_(18))];
        [right2Button setBackgroundImage:[UIImage imageNamed:@"nav_set"] forState:UIControlStateNormal];
        right2Button.titleLabel.font = FONT(30);
        [right2Button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [right2Button addTarget:mine action:@selector(mineOtherButtonItem)forControlEvents:UIControlEventTouchUpInside];
        UIBarButtonItem*rightItem2 = [[UIBarButtonItem alloc]initWithCustomView:right2Button];
        self.navigationItem.rightBarButtonItems = @[rightItem2];
    }else if (item.tag == 2){
        self.title = @"我的小组";
        self.navigationItem.rightBarButtonItem = nil;
        self.navigationItem.rightBarButtonItems = nil;
    }
}

#pragma mark - private

- (void)setupSubviews
{
    self.tabBar.accessibilityIdentifier = @"tabbar";
    self.tabBar.backgroundColor = [UIColor whiteColor];

    home = [[homeViewController alloc] init];
    [self addChildVc:home title:@"工作站" image:@"tab_third-winner-in-contest" selectedImage:@"tab_pre_third-winner-in-contest"];
    
    HospitalizedPatientsViewController *messageCenter = [[HospitalizedPatientsViewController alloc] init];
    [self addChildVc:messageCenter title:@"住院患者" image:@"tab_be-hospitalized" selectedImage:@"tab_pre_be-hospitalized"];

    honorHomeViewController *discover = [[honorHomeViewController alloc] init];
    [self addChildVc:discover title:@"荣誉" image:@"tab_honor" selectedImage:@"tab_pre_honor"];
    
    
    MineHomeViewController *profile = [[MineHomeViewController alloc] init];
    [self addChildVc:profile title:@"我的" image:@"tab_mine" selectedImage:@"tab_pre_mine"];
     
}

- (void)addChildVc:(UIViewController *)childVc title:(NSString *)title image:(NSString *)image selectedImage:(NSString *)selectedImage
{
    childVc.title = title;
    childVc.tabBarItem.image = [UIImage imageNamed:image];
    childVc.tabBarItem.selectedImage = [[UIImage imageNamed:selectedImage] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
    NSMutableDictionary *textAttrs = [NSMutableDictionary dictionary];
    textAttrs[NSForegroundColorAttributeName] = [UIColor blackColor];
    NSMutableDictionary *selectTextAttrs = [NSMutableDictionary dictionary];
    selectTextAttrs[NSForegroundColorAttributeName] = [UIColor HDThemeColor];
    [childVc.tabBarItem setTitleTextAttributes:textAttrs forState:UIControlStateNormal];
    [childVc.tabBarItem setTitleTextAttributes:selectTextAttrs forState:UIControlStateSelected];
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:childVc];
    [self addChildViewController:nav];
}

-(void)unSelectedTapTabBarItems:(UITabBarItem *)tabBarItem
{
    [tabBarItem setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
                                        [UIFont systemFontOfSize:12], NSFontAttributeName,
                                        [UIColor blackColor],NSForegroundColorAttributeName,
                                        nil] forState:UIControlStateNormal];
}

-(void)selectedTapTabBarItems:(UITabBarItem *)tabBarItem
{
    [tabBarItem setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
                                        [UIFont systemFontOfSize:12],NSFontAttributeName,
                                        [UIColor HDThemeColor],NSForegroundColorAttributeName,
                                        nil] forState:UIControlStateSelected];
}

// 统计未读消息数
-(void)setupUnreadMessageCount
{
    if ([GatoMethods getTeamAndPeopleNumberWithunread] > 0) {
        [home.tabBarController.tabBar showBadgeOnItemIndex:0];
    }else{
        [home.tabBarController.tabBar hideBadgeOnItemIndex:0];
    }
    
    NSNotification *notification = [NSNotification notificationWithName:@"homeMessage" object:@"success"];
    [[NSNotificationCenter defaultCenter] postNotification:notification];
}

- (void)setupUntreatedApplyCount
{
    if ([GatoMethods getTeamAndPeopleNumberWithunread] > 0) {
        [home.tabBarController.tabBar showBadgeOnItemIndex:0];
    }else{
        [home.tabBarController.tabBar hideBadgeOnItemIndex:0];
    }
}

- (void)networkChanged
{
    _connectionState = [ChatUIHelper shareHelper].connectionState;
    [_chatListVC networkChanged:_connectionState];
}



#pragma mark - 自动登录回调

- (void)willAutoReconnect{
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    NSNumber *showreconnect = [ud objectForKey:@"identifier_showreconnect_enable"];
    if (showreconnect && [showreconnect boolValue]) {
        [self hideHud];
        [self showHint:NSLocalizedString(@"reconnection.ongoing", @"reconnecting...")];
    }
}

- (void)didAutoReconnectFinishedWithError:(NSError *)error{
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    NSNumber *showreconnect = [ud objectForKey:@"identifier_showreconnect_enable"];
    if (showreconnect && [showreconnect boolValue]) {
        [self hideHud];
        if (error) {
            [self showHint:NSLocalizedString(@"reconnection.fail", @"reconnection failure, later will continue to reconnection")];
        }else{
            [self showHint:NSLocalizedString(@"reconnection.success", @"reconnection successful！")];
        }
    }
}

#pragma mark - public

- (void)jumpToChatList
{
    if ([self.navigationController.topViewController isKindOfClass:[ChatViewController class]]) {
//        ChatViewController *chatController = (ChatViewController *)self.navigationController.topViewController;
//        [chatController hideImagePicker];
    }
//    else if(_chatListVC)
//    {
//        [self.navigationController popToViewController:self animated:NO];
//        [self setSelectedViewController:_chatListVC];
//    }
}

- (EMConversationType)conversationTypeFromMessageType:(EMChatType)type
{
    EMConversationType conversatinType = EMConversationTypeChat;
    switch (type) {
        case EMChatTypeChat:
            conversatinType = EMConversationTypeChat;
            break;
        case EMChatTypeGroupChat:
            conversatinType = EMConversationTypeGroupChat;
            break;
        case EMChatTypeChatRoom:
            conversatinType = EMConversationTypeChatRoom;
            break;
        default:
            break;
    }
    return conversatinType;
}

- (void)didReceiveLocalNotification:(UILocalNotification *)notification
{
    
    NSDictionary *userInfo = notification.userInfo;
    NSLog(@"点击推送进入  userInfo：%@",userInfo);
    if (userInfo)
    {
        AppDelegate *app = (AppDelegate *)[UIApplication sharedApplication].delegate;
        MainViewController *tab = (MainViewController *)app.window.rootViewController;
        tab.selectedIndex = 0;
        
        UINavigationController * nc = tab.viewControllers[0];
        
        EMChatType messageType = [userInfo[kMessageType] intValue];
        NSString *conversationChatter = userInfo[kConversationChatter];
        if (messageType == EMChatTypeChat) {
            //单聊
            ImMessageOneForOneViewController *chatController = [[ImMessageOneForOneViewController alloc] initWithConversationChatter:conversationChatter conversationType:EMConversationTypeChat];
            chatController.hidesBottomBarWhenPushed = YES;
            [nc pushViewController:chatController animated:NO];
        }else{
            //群聊
            IMMessageOneForAllViewController *chatController = [[IMMessageOneForAllViewController alloc] initWithConversationChatter:conversationChatter conversationType:EMConversationTypeGroupChat];
            chatController.hidesBottomBarWhenPushed = YES;
            [nc pushViewController:chatController animated:YES];
        }
    }else{
        AppDelegate *app = (AppDelegate *)[UIApplication sharedApplication].delegate;
        MainViewController *tab = (MainViewController *)app.window.rootViewController;
        tab.selectedIndex = 0;
    }

  
}

#pragma mark - 点击推送跳转页面
- (void)didReceiveUserNotification:(UNNotification *)notification
{
    NSDictionary *userInfo = notification.request.content.userInfo;
    NSLog(@"点击推送进入  userInfo：%@",userInfo);
    if (userInfo)
    {
        AppDelegate *app = (AppDelegate *)[UIApplication sharedApplication].delegate;
        MainViewController *tab = (MainViewController *)app.window.rootViewController;
        tab.selectedIndex = 0;
        
        UINavigationController * nc = tab.viewControllers[0];
        
        EMChatType messageType = [userInfo[kMessageType] intValue];
        NSString *conversationChatter = userInfo[kConversationChatter];
        if (messageType == EMChatTypeChat) {
            //单聊
            ImMessageOneForOneViewController *chatController = [[ImMessageOneForOneViewController alloc] initWithConversationChatter:conversationChatter conversationType:EMConversationTypeChat];
            chatController.hidesBottomBarWhenPushed = YES;
            [nc pushViewController:chatController animated:NO];
        }else{
            //群聊
            IMMessageOneForAllViewController *chatController = [[IMMessageOneForAllViewController alloc] initWithConversationChatter:conversationChatter conversationType:EMConversationTypeGroupChat];
            chatController.hidesBottomBarWhenPushed = YES;
            [nc pushViewController:chatController animated:YES];
        }
    }else{
        AppDelegate *app = (AppDelegate *)[UIApplication sharedApplication].delegate;
        MainViewController *tab = (MainViewController *)app.window.rootViewController;
        tab.selectedIndex = 0;
    }
}

@end
