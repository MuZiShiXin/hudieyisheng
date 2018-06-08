//
//  UIColor+MACProject.h
//  MACProject
//
//  Created by MacKun on 15/12/14.
//  Copyright © 2015年 MacKun. All rights reserved.
//

#import <UIKit/UIKit.h>
/**
 *  颜色规范
 */
@interface UIColor(MACProject)


/*
 蝴蝶医声 色调
 */
//蝴蝶医声主色调
+(UIColor *)HDThemeColor;

//蝴蝶医声 黑色文字
+(UIColor *)HDBlackColor;

//蝴蝶医声 职称背景颜色【橘红色】
+(UIColor *)HDOrangeColor;

//蝴蝶医声 红色文字
+(UIColor *)HDTitleRedColor;

//蝴蝶 控件边框【比背景颜色略深】
+(UIColor *)HDViewBackColor;













//美如那年app 主题色
+(UIColor *)YMAppAllColor;
//美如那年app 同意粉红色
+(UIColor *)YMAppAllRedColor;
//美如那年app 深灰色文字颜色
+(UIColor *)YMAppAllTitleColor;

//app 页面背景  统一灰色
+ (UIColor *)appAllBackColor;


//app tabbar点击蓝色
+ (UIColor *)appTabbarBlueColor;

//app蓝色
+ (UIColor *)appBlueColor;

//app tabbar 浅灰色
+ (UIColor * )appTabBarTitleColor;


//app navBar 背景颜色
+ (UIColor *)appYLAlltitleViewColor;
//app 红粉色[用与 首页标题下方横
+ (UIColor *)appYLAlltitleRedViewColor;



//--------------配置文件需要 不要删---------///////
- (CGFloat)red;
- (CGFloat)green;
- (CGFloat)blue;
- (CGFloat)alpha;

- (UIColor *)darkerColor;
- (UIColor *)lighterColor;
- (BOOL)isLighterColor;
- (BOOL)isClearColor;



@end
