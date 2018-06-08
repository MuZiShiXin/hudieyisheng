//
//  GatoBaseHelp.h
//  meiqi
//
//  Created by 辛书亮 on 2016/10/24.
//  Copyright © 2016年 mac. All rights reserved.
//

#import "UIColor+MACProject.h"
#import "GatoReturnButton.h"
#import "UIImageView+WebCache.h"
#import "GatoURL.h"
#import "GatoMethods.h"
#import <MJRefresh.h>
#import "UIView+SDAutoLayout.h"
#import "IWHttpTool.h"
#import "SVProgressHUD.h"
#import "UIView+AICategory.h"





#ifndef GatoBaseHelp_h
#define GatoBaseHelp_h


#define iPhone4Height (480.f)
#define iPhone4Width (320.f)

#define iPhone5Height (568.f)
#define iPhone5Width (320.f)

#define iPhone6Height (667.f)
#define iPhone6Width (375.f)

#define iPhone6PlusHeight (736.f)
#define iPhone6PlusWidth (414.f)

#define Gato_iPhoneXHeight [GatoMethods getiPhoneXHeight]
#define Gato_Width [UIScreen mainScreen].bounds.size.width
#define Gato_Height [UIScreen mainScreen].bounds.size.height
#define Gato_Bounds [UIScreen mainScreen].bounds
#define Gato_Width_320_(s)  Gato_Width / 320 * s
#define Gato_Height_548_(s) Gato_Height / (Gato_Height / (Gato_Width / 320)) * s
#define WIDTH_2(width)  (Gato_Width_750*(width)*2)
#define HEIGHT_2(height) (Gato_Height_1334*(height)*2)
#define Gato_CGRectMake(x,y,w,h) CGRectMake(Gato_Width_320_(x), Gato_Height_548_(y), Gato_Width_320_(w),  Gato_Height_548_(h))
#define Gato_20 20
#define Gato_10 10
#define Gato_0 0
#define FONT(s) [UIFont fontWithName:@"Helvetica" size:s/[GatoMethods getPhoneFONT]] //设置字体 原nil
#define FONT_Bold_(s) [UIFont fontWithName:@"Helvetica-Bold" size:s/[GatoMethods getPhoneFONT]] //加粗
#define Gato_(r,g,b) [UIColor colorWithRed:(r)/255.0f green:(g)/255.0f blue:(b)/255.0f alpha:1.0]
#define Gato_font_(s) [UIFont fontWithName:nil size:Gato_Width / 640 * s ]
#define Gato_NV self.edgesForExtendedLayout = UIRectEdgeNone
#define Gato_Frame(x,y,w,h) CGRectMake((x) * Gato_Width_640, (y) * Gato_Height_1136, (w) * Gato_Width_640, (h) * Gato_Height_1136)
#define Gato_STRING_2F(x) [NSString stringWithFormat:@"%.2f", [x floatValue]]
#define Gato_CeShi(...) [NSString stringWithFormat:@"%@",(__VA_ARGS__)]

#define Gato_Push_HiddenTabBar self.hidesBottomBarWhenPushed=YES;
#define Gato_Push_vc vc.view.backgroundColor = [UIColor whiteColor]
#define Gato_tabBar_NO vc.tabBarController.tabBar.hidden = YES;
#define NAV_BAR_HEIGHT CGRectGetMaxY(self.navigationController.navigationBar.frame)
#define Tab_BAr_Height self.tabBarController.tabBar.frame.size.height
#define STRING(x) [NSString stringWithFormat:@"%@", x] 

#define GatoViewBorderRadius(View, Radius, Width, Color)\
\
[View.layer setCornerRadius:(Radius)];\
[View.layer setMasksToBounds:YES];\
[View.layer setBorderWidth:(Width)];\
[View.layer setBorderColor:[Color CGColor]]

#define ModelNull(str) [GatoMethods modelNull:str] 




//APP版本号
#define GatoAppVersion [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"]

//系统版本号
#define GatoSystemVersion [[UIDevice currentDevice] systemVersion]

//开发的时候打印，但是发布的时候不打印的NSLog
#ifdef DEBUG
#define NSLog(...) NSLog(@"%s 第%d行 \n %@\n\n",__func__,__LINE__,[NSString stringWithFormat:__VA_ARGS__])
#else
#define NSLog(...)
#endif

//弱引用/强引用
#define Gato_WeakSelf(type)  __weak typeof(type) weak##type = type;
#define Gato_StrongSelf(type) __strong typeof(type) type = weak##type;


//用于加载tableviewcell 的初始化  空cell  xib——cell
#define Gato_tableviewcell_new static NSString * cell_id03 = @"UITableViewCell";\
UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:cell_id03];\
if (cell == nil) {\
    cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cell_id03];\
}\
cell.backgroundColor = [UIColor whiteColor];\
return cell;

#define Gato_Tableviewcell_StyleNone  UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];\
[cell setSelectionStyle:UITableViewCellSelectionStyleNone];

#define Gato_tableviewcellForRoot_(tableViewCell) tableViewCell *cell = [tableViewCell cellWithTableView:tableView];\
cell.selectionStyle = UITableViewCellSelectionStyleNone;\
return cell;


#define Gato_DismissRootView UIViewController * presentingViewController = self.presentingViewController;\
while (presentingViewController.presentingViewController) {\
    presentingViewController = presentingViewController.presentingViewController;\
}\
[presentingViewController dismissViewControllerAnimated:YES completion:nil];

//返回按钮
#define Gato_Return  GatoReturnButton *returnButton = [[GatoReturnButton alloc] initWithTarget:self IsAccoedingBar:YES];\
self.navigationItem.leftBarButtonItem = returnButton;
//添加夫文件tableview
#define Gato_TableView   self.GatoTableview.frame = CGRectMake(0, 0, Gato_Width, Gato_Height - NAV_BAR_HEIGHT);\
[self.view addSubview:self.GatoTableview];





//self.GatoTableview.frame = CGRectMake(0, 0, Gato_Width, Gato_Height);\
//[self.view addSubview:self.GatoTableview];

//清理缓存 1小时以内变成0
#define GET_cache_time @"GET_cache_time"
#define Gato_Chche_Time [[NSUserDefaults standardUserDefaults] objectForKey:GET_cache_time]

//存储用户id
#define GET_TOKEN @"token_user_id"
#define TOKEN [[NSUserDefaults standardUserDefaults] objectForKey:GET_TOKEN]
//存储用户id类型  用户端 1  医生端2  美容院3  医院4
#define GET_TOKEN_TYPE @"token_user_id_type"
#define TOKEN_TYPE [[NSUserDefaults standardUserDefaults] objectForKey:GET_TOKEN_TYPE]
//存储用户昵称 用来回复评论刷新本地数据用
#define GET_TOKEN_NAME @"token_user_name"
#define TOKEN_NAME [[NSUserDefaults standardUserDefaults] objectForKey:GET_TOKEN_NAME]

//极光推送 registerId
#define GET_TOKEN_registerId @"token_user_registerId"
#define registerId [[NSUserDefaults standardUserDefaults] objectForKey:GET_TOKEN_registerId]

//更改个人资料成功时存储  刷新首页 成功后人数
#define GET_UPDATEPHOTO @"HD_Info_updatePhoto"
#define Gato_Update_Info [[NSUserDefaults standardUserDefaults] objectForKey:GET_UPDATEPHOTO]

//存储定位信息
#define GET_CITY @"city_user_name"
#define GATO_CITY [[NSUserDefaults standardUserDefaults] objectForKey:GET_CITY]

//判断是否打开引导页
#define GET_FIRST @"first_come"
#define GATO_FIRST [[NSUserDefaults standardUserDefaults] objectForKey:GET_FIRST]

//发布tab页面 是否进行网络请求（如果有id 进行 如果没有 不进行）
#define GET_RELEASE_ID @"GET_RELEASE_ID"
#define GATO_RELEASE_ID [[NSUserDefaults standardUserDefaults] objectForKey:GET_RELEASE_ID]

//发布tab页面 是否进行网络请求（如果有id 进行 如果没有 不进行）
#define GET_VIRTUAL_BUTTON @"GET_VIRTUAL_BUTTON"
#define GATO_VIRTUAL_BUTTON [[NSUserDefaults standardUserDefaults] objectForKey:GET_VIRTUAL_BUTTON]


//登录验证码时间检验 ----登录页面
#define GET_LOGIN_TIME_LOGINVIEW @"login_time_loginview"
#define LOGIN_LOGINVIEW [[NSUserDefaults standardUserDefaults] objectForKey:GET_LOGIN_TIME_LOGINVIEW]

//登录验证码时间检验 ----找回密码
#define GET_LOGIN_TIME_PASSWORD @"login_time_password"
#define LOGIN_PASSWORD [[NSUserDefaults standardUserDefaults] objectForKey:GET_LOGIN_TIME_PASSWORD]

//登录验证码时间检验 ----注册
#define GET_LOGIN_TIME_registered @"login_time_registered"
#define LOGIN_registered [[NSUserDefaults standardUserDefaults] objectForKey:GET_LOGIN_TIME_registered]

//登录验证码时间检验 ----修改手机号
#define GET_INFO_NEW_PHONE @"info_new_phone"
#define INFO_PHONE [[NSUserDefaults standardUserDefaults] objectForKey:GET_INFO_NEW_PHONE]

//从那个页面支付 创建单独通知  发布需求 1  需求列表 2  需求列表详情3  确认接单4  购买项目 5
#define GET_PAY_COME @"get_pay_come"
#define PAY_COME [[NSUserDefaults standardUserDefaults] objectForKey:GET_PAY_COME]


//帖子详情文字高度
#define GET_XFDate_Type @"get_xfdata_type"
#define GATO_XFData [[NSUserDefaults standardUserDefaults] objectForKey:GET_XFDate_Type]

//如果从发现进入 都需要 - 64  如果从首页进入 不需要
#define get_fand_home @"comeforFandHome"
#define come_fand [[NSUserDefaults standardUserDefaults] objectForKey:get_fand_home]


//帖子详情文字高度
#define GET_JPush_Dismiss @"GET_JPush_Dismiss"
#define GATO_JPush_Return [[NSUserDefaults standardUserDefaults] objectForKey:GET_JPush_Dismiss]

//如果是正常进入 无所谓 如果是通过jpush 进入app 那么 不再运行首页广告 当 1 就是jpush进入  其他正常
#define GET_JPush_Welcome_AD @"GET_JPush_Welcome_AD"
#define GATO_JPush_Welcome_AD [[NSUserDefaults standardUserDefaults] objectForKey:GET_JPush_Welcome_AD]

//要求每次登录都要有广告，所有 当退出登录后【非首次登陆】 就记录为 1  当触发1状态 显示广告 然后remove
#define GET_Again_Login @"GET_Again_Login"
#define GATO_Again_Login [[NSUserDefaults standardUserDefaults] objectForKey:GET_Again_Login]



//当用户为审核阶段0  不显示广告 当用户通过审核 1 显示广告
#define GET_HomeAD_Hidden @"GET_HomeAD_Hidden"
#define Gato_HomeAD_Hidden [[NSUserDefaults standardUserDefaults] objectForKey:GET_HomeAD_Hidden]



//当用户为审核阶段0  不显示广告 当用户通过审核 1 显示广告
#define GET_Login_isVerify @"GET_Login_isVerify"
#define Gato_Login_isVerify [[NSUserDefaults standardUserDefaults] objectForKey:GET_Login_isVerify]


//如果是注册跳转审核页面 加载appdelete中 显示审核页面图片  结束app后清空 如果空显示蝴蝶页面
#define Get_registered_Image @"Get_registered_Image"
#define Gato_registered_Image [[NSUserDefaults standardUserDefaults] objectForKey:Get_registered_Image]


//各种第三方应用KEY
//百度地图
#define Gato_BaiDu_Key @"91rhcucyS2dHQvFXoVsgObsxNXOq6iZk"

//极光推送
#define Gato_JPush_KEY @"5ff5e2acfd32552ffe352659"

//友盟分享
#define Gato_UMSocial_KEY @"590bd6d7f29d9811ef0017c9"

//环信聊天
#define Gato_Hyphenate_KEY @"1131170505115642#butterflydoctor"
#ifdef DEBUG//调试状态
#define Gato_Hyphenate_apnsCertName @"HyPush_dev"
#else//发布状态
#define Gato_Hyphenate_apnsCertName @"HyPush_pro"
#endif


#define GET_HYP_PHOTO @"get_hyp_photo"
#define GATO_PHOTO [[NSUserDefaults standardUserDefaults] objectForKey:GET_HYP_PHOTO]

#define GET_HYP_PASSWORD @"get_hyp_password"
#define GATO_PASSWORD [[NSUserDefaults standardUserDefaults] objectForKey:GET_HYP_PASSWORD]

#define GET_Home_Image @"get_home_image"
#define GATO_HOME_Image [[NSUserDefaults standardUserDefaults] objectForKey:GET_Home_Image]

#define GET_ShenHe_Image @"GET_ShenHe_Image"
#define GATO_ShenHe_Image [[NSUserDefaults standardUserDefaults] objectForKey:GET_ShenHe_Image]

//存储首页个人信息缓存 方便二次加载
#define GET_Mine_Info @"GET_Mine_Info"
#define Gato_Mine_Info [[NSUserDefaults standardUserDefaults] objectForKey:GET_Mine_Info]
//存储首页轮播图缓存 方便二次加载
#define GET_Mine_Banner @"GET_Mine_Banner"
#define Gato_Mine_Banner [[NSUserDefaults standardUserDefaults] objectForKey:GET_Mine_Banner]

#define Gato_COLOR_MORE Gato_(200, 200, 200)//查看更多 颜色（浅灰色）


//本地数据库
#define ArticlePlist @"Article1.splist"

#define Get_ArticleTitle @"get_ArticleTitle"
#define GATO_ArticleTitle [[NSUserDefaults standardUserDefaults] objectForKey:Get_ArticleTitle]

#endif /* GatoBaseHelp_h */
