//
//  MainTabBarController.m
//  Yueshijia
//
//  Created by CosyVan on 2016/11/20.
//  Copyright © 2016年 Jeffery. All rights reserved.
//

#import "MainTabBarController.h"


#import "MyTabBar.h"
#import "NavigationViewController.h"
#import "GatoBaseHelp.h"
#import "UIColor+MACProject.h"
@interface MainTabBarController ()

@end

@implementation MainTabBarController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    // 1.初始化子控制器
    UIViewController *home = [[UIViewController alloc] init];
    home.title = @"工作台";
    home.navigationItem.title = @"蝴蝶医声";
    [self addChildVC:home imageName:@"tab_third-winner-in-contest" selectedImageName:@"tab_pre_third-winner-in-contest"];
    
    
    UIViewController *messageCenter = [[UIViewController alloc] init];
    messageCenter.title = @"住院患者";
    [self addChildVC:messageCenter imageName:@"tab_be-hospitalized" selectedImageName:@"tab_pre_be-hospitalized"];
    
    UIViewController *discover = [[UIViewController alloc] init];
    discover.title = @"荣誉";
    [self addChildVC:discover imageName:@"tab_honor" selectedImageName:@"tab_pre_honor"];
    
    
    UIViewController *profile = [[UIViewController alloc] init];
    profile.title = @"我的";
    [self addChildVC:profile imageName:@"tab_mine" selectedImageName:@"tab_pre_mine"];
    

//    CapitalCostViewController *meVC = [[CapitalCostViewController alloc] init];
//    meVC.title = @"资金费用";
//    [self addChildVC:meVC imageName:@"定位" selectedImageName:@"定位"];
    
    MyTabBar *myTabBar = [[MyTabBar alloc] init];
    [self setValue:myTabBar forKey:@"tabBar"];
}

- (void)addChildVC:(UIViewController *)childVc imageName:(NSString *)imageName selectedImageName:(NSString *)selectedImageName
{
    
    
    
    // 设置图标
    childVc.tabBarItem.image = [UIImage imageNamed:imageName];
    
    
    //设置文字样式
    NSMutableDictionary *textAttrs = [NSMutableDictionary dictionary];
    textAttrs[NSForegroundColorAttributeName] = [UIColor appTabBarTitleColor];
    [childVc.tabBarItem setTitleTextAttributes:textAttrs forState:UIControlStateNormal];
    
    // 设置tabBarItem的选中文字颜色
    NSMutableDictionary *selectedTextAttrs = [NSMutableDictionary dictionary];
    selectedTextAttrs[NSForegroundColorAttributeName] = [UIColor HDThemeColor];
    [childVc.tabBarItem setTitleTextAttributes:selectedTextAttrs forState:UIControlStateSelected];
    
    
    childVc.tabBarItem.selectedImage = [[UIImage imageNamed:selectedImageName] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
    // 添加为tabbar控制器的子控制器
    NavigationViewController *nav = [[NavigationViewController alloc] initWithRootViewController:childVc];
    
    [self addChildViewController:nav];
}



@end
