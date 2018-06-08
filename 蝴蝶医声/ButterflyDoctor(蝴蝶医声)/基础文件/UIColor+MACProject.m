//
//  UIColor+MACProject
//  MACProject
//
//  Created by MacKun on 15/12/14.
//  Copyright © 2015年 MacKun. All rights reserved.
//

#import "UIColor+MACProject.h"
#import "UIColor+Mac.h"
#import "GatoBaseHelp.h"
@implementation UIColor(MACProject)



//蝴蝶医声主色调
+(UIColor *)HDThemeColor
{
    return Gato_(120,189,255);
}
//蝴蝶医声 黑色文字
+(UIColor *)HDBlackColor
{
    return Gato_(47, 47, 47);
}
//蝴蝶医声 职称背景颜色【橘红色】
+(UIColor *)HDOrangeColor
{
    return Gato_(255,96,5);
}
//蝴蝶医声 红色文字
+(UIColor *)HDTitleRedColor
{
    return  Gato_(255,96,107);
}
//蝴蝶 控件边框【比背景颜色略深】
+(UIColor *)HDViewBackColor
{
    return Gato_(207, 207, 207);
}


//美如那年app 主题色
+(UIColor *)YMAppAllColor
{
    return  Gato_(120,189,255);
}
//美如那年app 同意粉红色
+(UIColor *)YMAppAllRedColor
{
    return  Gato_(255,96,107);
}

//美如那年app 深灰色文字颜色
+(UIColor *)YMAppAllTitleColor
{
    return  Gato_(192,192,192);
}
+(UIColor *)appMainColor{

    return [UIColor colorWithMacHexString:@"#323542"];
}

//app navBar 背景颜色
+ (UIColor *)appYLAlltitleViewColor
{
    return Gato_(74, 191, 252);
}
//app 红粉色[用与 首页标题下方横线]
+ (UIColor *)appYLAlltitleRedViewColor
{
    return Gato_(255, 110, 110);
}

//app 页面背景  统一灰色
+ (UIColor *)appAllBackColor
{
    return Gato_(247 , 247, 247);
}
//app tabbar点击蓝色 //同意点击按钮颜色
+ (UIColor *)appTabbarBlueColor
{
    return Gato_(17,134,192);
}

//app蓝色
+ (UIColor *)appBlueColor{
    return Gato_(0,0,255);//099fde
}

//app tabbar 浅灰色字体
+ (UIColor * )appTabBarTitleColor
{
    return Gato_(187,187,194);
}

//导航条颜色
+ (UIColor *)appNavigationBarColor{
    return [UIColor colorWithMacHexString:@"#323542"];//#1aa7f2 2da4f6
}

//app红色
+ (UIColor *)appRedColor{
    return [UIColor colorWithMacHexString:@"#ff415b"];
}

//app黄色
+ (UIColor *)appYellowColor{
    return [UIColor colorWithMacHexString:@"#f7ba5b"];
}


//app橙色
+ (UIColor *)appOrangeColor{
    return [UIColor colorWithMacHexString:@"#ea6644"];
}

//app绿色
+ (UIColor *)appGreenColor{
    return [UIColor colorWithMacHexString:@"#52cbb9"];
}

//app背景色
+ (UIColor *)appBackGroundColor{
    return [UIColor colorWithMacHexString:@"#e6e6e6"];
}

//app直线色
+ (UIColor *)appLineColor{
//    return [UIColor colorWithMacHexString:@"#c8c8c8"];
    return [UIColor colorWithMacHexString:@"#D6D6D6"];
}
//app导航栏文字颜色
+ (UIColor *)appNavTitleColor{
    return [UIColor colorWithMacHexString:@"#013e5d"];
}
//app标题颜色
+ (UIColor *)appTitleColor{
    return [UIColor colorWithMacHexString:@"#474747"];
}

//app文字颜色
+ (UIColor *)appTextColor{
    return [UIColor colorWithMacHexString:@"#A0A0A0"];
}

//app浅红颜色
+ (UIColor *)appLightRedColor{
    return [UIColor colorWithMacHexString:@"#FFB7C1"];
}

//app输入框颜色
+ (UIColor *)appTextFieldColor{
    return [UIColor colorWithMacHexString:@"#FFFFFF"];
}

//app黑色色
+ (UIColor *)appBlackColor{
    return [UIColor colorWithMacHexString:@"#333d47" ];
}
/**
 *  app次分割线
 */
+ (UIColor *)appSecondLineColor{
     return [UIColor colorWithMacHexString:@"#e5e5e5"];
}




- (CGFloat)red {
    const CGFloat* components = CGColorGetComponents(self.CGColor);
    return components[0];
}

- (CGFloat)green {
    const CGFloat* components = CGColorGetComponents(self.CGColor);
    return components[1];
}

- (CGFloat)blue {
    const CGFloat* components = CGColorGetComponents(self.CGColor);
    return components[2];
}

- (CGFloat)alpha {
    return CGColorGetAlpha(self.CGColor);
}

- (BOOL)isClearColor {
    return [self isEqual:[UIColor clearColor]];
}

- (BOOL)isLighterColor {
    const CGFloat* components = CGColorGetComponents(self.CGColor);
    return (components[0]+components[1]+components[2])/3 >= 0.5;
}

- (UIColor *)lighterColor {
    if ([self isEqual:[UIColor whiteColor]]) return [UIColor colorWithWhite:0.99 alpha:1.0];
    if ([self isEqual:[UIColor blackColor]]) return [UIColor colorWithWhite:0.01 alpha:1.0];
    CGFloat hue, saturation, brightness, alpha, white;
    if ([self getHue:&hue saturation:&saturation brightness:&brightness alpha:&alpha]) {
        return [UIColor colorWithHue:hue
                          saturation:saturation
                          brightness:MIN(brightness * 1.3, 1.0)
                               alpha:alpha];
    } else if ([self getWhite:&white alpha:&alpha]) {
        return [UIColor colorWithWhite:MIN(white * 1.3, 1.0) alpha:alpha];
    }
    return nil;
}

- (UIColor *)darkerColor {
    if ([self isEqual:[UIColor whiteColor]]) return [UIColor colorWithWhite:0.99 alpha:1.0];
    if ([self isEqual:[UIColor blackColor]]) return [UIColor colorWithWhite:0.01 alpha:1.0];
    CGFloat hue, saturation, brightness, alpha, white;
    if ([self getHue:&hue saturation:&saturation brightness:&brightness alpha:&alpha]) {
        return [UIColor colorWithHue:hue
                          saturation:saturation
                          brightness:brightness * 0.75
                               alpha:alpha];
    } else if ([self getWhite:&white alpha:&alpha]) {
        return [UIColor colorWithWhite:MAX(white * 0.75, 0.0) alpha:alpha];
    }
    return nil;
}
@end
