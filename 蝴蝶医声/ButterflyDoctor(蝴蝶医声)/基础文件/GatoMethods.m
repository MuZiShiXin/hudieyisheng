//
//  GatoMethods.m
//  meiqi
//
//  Created by 辛书亮 on 2016/10/26.
//  Copyright © 2016年 mac. All rights reserved.
//

#import "GatoMethods.h"
#import "GatoBaseHelp.h"
#import <AFNetworking/AFHTTPSessionManager.h>
#import "AppDelegate.h"
#import "IWHttpTool.h"
#import "PellTableViewSelect.h"
#import <sys/utsname.h>

@implementation GatoMethods




-(void)drawRect:(CGRect)rect{
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(context, [UIColor clearColor].CGColor);
    CGContextFillRect(context, rect);
    
    CGContextSetStrokeColorWithColor(context, [UIColor whiteColor].CGColor);
    CGContextStrokeRect(context, CGRectMake(0, 0, rect.size.width, 1));
    //下分割线
    UIColor *color = Gato_(240,240,240);
    CGContextSetStrokeColorWithColor(context, color.CGColor);
    CGContextStrokeRect(context, CGRectMake(0, rect.size.height - 0.1, rect.size.width  , Gato_Height_548_(1)));
}

#pragma mark - 获取当前controller
+ (UIViewController *)getCurrentViewController
{
    UINavigationController *nav = nil;
    UIViewController *vc = [UIApplication sharedApplication].keyWindow.rootViewController;
    if ([vc isKindOfClass:[UITabBarController class]]) {
        UITabBarController *tab = (UITabBarController *)vc;
        if ([tab.selectedViewController isKindOfClass:[UINavigationController class]]) {
            nav = (UINavigationController *)tab.selectedViewController;
        }
    } else if ([vc isKindOfClass:[UINavigationController class]]){
        nav = (UINavigationController *)vc;
    }
    return [nav.viewControllers lastObject];
}

/*

 #pragma mark 网络请求
 -(void)getzhuce
 {
     //    model = [[MineModel alloc]init];
     self.updateParms = [NSMutableDictionary dictionary];
     NSLog(@"id %@",TOKEN);
     [IWHttpTool postWithURL:YM_CHABAIKE params:self.updateParms success:^(id json) {
     
     NSDictionary * dic = [NSJSONSerialization JSONObjectWithData:json options:NSJSONReadingAllowFragments error:nil];
     NSString * success = [dic objectForKey:@"success"];
         if ([success isEqualToString:@"true"]) {
         NSLog(@"dic %@",dic);
         }else{
         NSString * falseMessage = [[dic objectForKey:@"data"] objectForKey:@"message"];
         [tishiXiaoShiViewController showMessage:falseMessage];
         }
     
     } failure:^(NSError *error) {
         NSLog(@"%@",error);
     }];
 }

*/
+ (CGFloat )getPhoneHeight
{
    struct utsname systemInfo;
    uname(&systemInfo);
    NSString *platform = [NSString stringWithCString:systemInfo.machine encoding:NSASCIIStringEncoding];
    if ([platform isEqualToString:@"iPhone4,1"]){
        return iPhone4Height;
    }else{
        return 548;
    }
}
+ (CGFloat )getiPhoneXHeight
{
    if ([[GatoMethods getiPhoneType] isEqualToString:@"iPhone X"]) {
        return 24;
    }
    return 0;
}
//返回当前手机型号
+ (NSString *)getiPhoneType
{
    
    //需要导入头文件：#import <sys/utsname.h>
    
    struct utsname systemInfo;
    
    uname(&systemInfo);
    
    NSString*platform = [NSString stringWithCString: systemInfo.machine encoding:NSASCIIStringEncoding];
    
    if([platform isEqualToString:@"iPhone1,1"])  return@"iPhone 2G";
    
    if([platform isEqualToString:@"iPhone1,2"])  return@"iPhone 3G";
    
    if([platform isEqualToString:@"iPhone2,1"])  return@"iPhone 3GS";
    
    if([platform isEqualToString:@"iPhone3,1"])  return@"iPhone 4";
    
    if([platform isEqualToString:@"iPhone3,2"])  return@"iPhone 4";
    
    if([platform isEqualToString:@"iPhone3,3"])  return@"iPhone 4";
    
    if([platform isEqualToString:@"iPhone4,1"])  return@"iPhone 4S";
    
    if([platform isEqualToString:@"iPhone5,1"])  return@"iPhone 5";
    
    if([platform isEqualToString:@"iPhone5,2"])  return@"iPhone 5";
    
    if([platform isEqualToString:@"iPhone5,3"])  return@"iPhone 5c";
    
    if([platform isEqualToString:@"iPhone5,4"])  return@"iPhone 5c";
    
    if([platform isEqualToString:@"iPhone6,1"])  return@"iPhone 5s";
    
    if([platform isEqualToString:@"iPhone6,2"])  return@"iPhone 5s";
    
    if([platform isEqualToString:@"iPhone7,1"])  return@"iPhone 6 Plus";
    
    if([platform isEqualToString:@"iPhone7,2"])  return@"iPhone 6";
    
    if([platform isEqualToString:@"iPhone8,1"])  return@"iPhone 6s";
    
    if([platform isEqualToString:@"iPhone8,2"])  return@"iPhone 6s Plus";
    
    if([platform isEqualToString:@"iPhone8,4"])  return@"iPhone SE";
    
    if([platform isEqualToString:@"iPhone9,1"])  return@"iPhone 7";
    
    if([platform isEqualToString:@"iPhone9,2"])  return@"iPhone 7 Plus";
    
    if([platform isEqualToString:@"iPhone10,1"]) return@"iPhone 8";
    
    if([platform isEqualToString:@"iPhone10,4"]) return@"iPhone 8";
    
    if([platform isEqualToString:@"iPhone10,2"]) return@"iPhone 8 Plus";
    
    if([platform isEqualToString:@"iPhone10,5"]) return@"iPhone 8 Plus";
    
    if([platform isEqualToString:@"iPhone10,3"]) return@"iPhone X";
    
    if([platform isEqualToString:@"iPhone10,6"]) return@"iPhone X";
    
    if([platform isEqualToString:@"iPod1,1"])  return@"iPod Touch 1G";
    
    if([platform isEqualToString:@"iPod2,1"])  return@"iPod Touch 2G";
    
    if([platform isEqualToString:@"iPod3,1"])  return@"iPod Touch 3G";
    
    if([platform isEqualToString:@"iPod4,1"])  return@"iPod Touch 4G";
    
    if([platform isEqualToString:@"iPod5,1"])  return@"iPod Touch 5G";
    
    if([platform isEqualToString:@"iPad1,1"])  return@"iPad 1G";
    
    if([platform isEqualToString:@"iPad2,1"])  return@"iPad 2";
    
    if([platform isEqualToString:@"iPad2,2"])  return@"iPad 2";
    
    if([platform isEqualToString:@"iPad2,3"])  return@"iPad 2";
    
    if([platform isEqualToString:@"iPad2,4"])  return@"iPad 2";
    
    if([platform isEqualToString:@"iPad2,5"])  return@"iPad Mini 1G";
    
    if([platform isEqualToString:@"iPad2,6"])  return@"iPad Mini 1G";
    
    if([platform isEqualToString:@"iPad2,7"])  return@"iPad Mini 1G";
    
    if([platform isEqualToString:@"iPad3,1"])  return@"iPad 3";
    
    if([platform isEqualToString:@"iPad3,2"])  return@"iPad 3";
    
    if([platform isEqualToString:@"iPad3,3"])  return@"iPad 3";
    
    if([platform isEqualToString:@"iPad3,4"])  return@"iPad 4";
    
    if([platform isEqualToString:@"iPad3,5"])  return@"iPad 4";
    
    if([platform isEqualToString:@"iPad3,6"])  return@"iPad 4";
    
    if([platform isEqualToString:@"iPad4,1"])  return@"iPad Air";
    
    if([platform isEqualToString:@"iPad4,2"])  return@"iPad Air";
    
    if([platform isEqualToString:@"iPad4,3"])  return@"iPad Air";
    
    if([platform isEqualToString:@"iPad4,4"])  return@"iPad Mini 2G";
    
    
    if([platform isEqualToString:@"iPad4,5"])  return@"iPad Mini 2G";
    
    if([platform isEqualToString:@"iPad4,6"])  return@"iPad Mini 2G";
    
    if([platform isEqualToString:@"iPad4,7"])  return@"iPad Mini 3";
    
    if([platform isEqualToString:@"iPad4,8"])  return@"iPad Mini 3";
    
    if([platform isEqualToString:@"iPad4,9"])  return@"iPad Mini 3";
    
    if([platform isEqualToString:@"iPad5,1"])  return@"iPad Mini 4";
    
    if([platform isEqualToString:@"iPad5,2"])  return@"iPad Mini 4";
    
    if([platform isEqualToString:@"iPad5,3"])  return@"iPad Air 2";
    
    if([platform isEqualToString:@"iPad5,4"])  return@"iPad Air 2";
    
    if([platform isEqualToString:@"iPad6,3"])  return@"iPad Pro 9.7";
    
    if([platform isEqualToString:@"iPad6,4"])  return@"iPad Pro 9.7";
    
    if([platform isEqualToString:@"iPad6,7"])  return@"iPad Pro 12.9";
    
    if([platform isEqualToString:@"iPad6,8"])  return@"iPad Pro 12.9";
    
    if([platform isEqualToString:@"i386"])  return@"iPhone Simulator";
    
    if([platform isEqualToString:@"x86_64"])  return@"iPhone Simulator";
    
    return platform;
    
}
//根据机型返回字号
+ (CGFloat )getPhoneFONT
{
    CGSize screenSize = [UIScreen mainScreen].bounds.size;
    
    
    // 竖屏情况
    if (screenSize.height > screenSize.width) {
        
        if (screenSize.height == 568) {
            return 2.3f;
            NSLog(@"当前为iPhone 5/5c/5s iPod Touch5 设备");
        }else if (screenSize.height == 667) {
            return 2.0f;
            NSLog(@"当前为iPhone6/6s设备");
        }else if (screenSize.height == 736) {
            return 1.9f;
            NSLog(@"当前为iPhone6 Plus/iPhone6s Plus 设备");
        }else {
            return 2.0f;
            NSLog(@"当前为iPhone4/4s 等其他设备");
        }
        
    }
    return 2.0f;

}
//----------------------------170606--------------------//

//提示框
+ (void)AlertControllerWithtitle:(NSString * )title WithMessage:(NSString *)message success:(void (^)())success WithVC:(UIViewController *)VC
{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    [alertController addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
    }]];
    [alertController addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        if (success) {
            success();
        }
    }]];
    [VC presentViewController:alertController animated:YES completion:nil];
}
//提示框-有取消判断
+ (void)AlertControllerWithtitle:(NSString * )title WithMessage:(NSString *)message success:(void (^)())success error:(void(^)())error WithVC:(UIViewController *)VC
{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    [alertController addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        if (error) {
            error();
        }
    }]];
    [alertController addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        if (success) {
            success();
        }
    }]];
    [VC presentViewController:alertController animated:YES completion:nil];
}
//判断手机号码格式是否正确
+ (BOOL)PhoneNumberIsMobileNumber:(NSString *)mobileNum
{
    if (mobileNum.length != 11)
    {
        return NO;
    }
    /**
     * 手机号码:
     * 13[0-9], 14[5,7], 15[0, 1, 2, 3, 5, 6, 7, 8, 9], 17[6, 7, 8], 18[0-9], 170[0-9]
     * 移动号段: 134,135,136,137,138,139,150,151,152,157,158,159,182,183,184,187,188,147,178,1705
     * 联通号段: 130,131,132,155,156,185,186,145,176,1709
     * 电信号段: 133,153,180,181,189,177,1700
     */
    NSString *MOBILE = @"^1(3[0-9]|4[57]|5[0-35-9]|8[0-9]|70)\d{8}$";
    /**
     * 中国移动：China Mobile
     * 134,135,136,137,138,139,150,151,152,157,158,159,182,183,184,187,188,147,178,1705
     */
    NSString *CM = @"(^1(3[4-9]|4[7]|5[0-27-9]|7[8]|8[2-478])\d{8}$)|(^1705\d{7}$)";
    /**
     * 中国联通：China Unicom
     * 130,131,132,155,156,185,186,145,176,1709
     */
    NSString *CU = @"(^1(3[0-2]|4[5]|5[56]|7[6]|8[56])\d{8}$)|(^1709\d{7}$)";
    /**
     * 中国电信：China Telecom
     * 133,153,180,181,189,177,1700
     */
    NSString *CT = @"(^1(33|53|77|8[019])\d{8}$)|(^1700\d{7}$)";
    NSPredicate *regextestmobile = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", MOBILE];
    NSPredicate *regextestcm = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CM];
    NSPredicate *regextestcu = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CU];
    NSPredicate *regextestct = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CT];
    if (([regextestmobile evaluateWithObject:mobileNum] == YES)
        || ([regextestcm evaluateWithObject:mobileNum] == YES)
        || ([regextestct evaluateWithObject:mobileNum] == YES)
        || ([regextestcu evaluateWithObject:mobileNum] == YES))
    {
        return YES;
    }
    else
    {
        return NO;
    }
}
//判断字符串中是否含有空格
+ (BOOL)isHaveSpaceInString:(NSString *)string{
    NSRange _range = [string rangeOfString:@" "];
    if (_range.location != NSNotFound) {
        return YES;
    }else {
        return NO;
    }
}

//判断字符串中是否含有中文
+ (BOOL)isHaveChineseInString:(NSString *)string
{
    for(NSInteger i = 0; i < [string length]; i++){
        int a = [string characterAtIndex:i];
        if (a > 0x4e00 && a < 0x9fff) {
            return YES;
        }
    }
    return NO;
}

//对图片进行滤镜处理
+ (UIImage *)filterWithOriginalImage:(UIImage *)image filterName:(NSString *)name
{
    CIContext *context = [CIContext contextWithOptions:nil];
    CIImage *inputImage = [[CIImage alloc] initWithImage:image];
    CIFilter *filter = [CIFilter filterWithName:name];
    [filter setValue:inputImage forKey:kCIInputImageKey];
    CIImage *result = [filter valueForKey:kCIOutputImageKey];
    CGImageRef cgImage = [context createCGImage:result fromRect:[result extent]];
    UIImage *resultImage = [UIImage imageWithCGImage:cgImage];
    CGImageRelease(cgImage);
    return resultImage;
}

//对图片进行模糊处理
// CIGaussianBlur ---> 高斯模糊
// CIBoxBlur      ---> 均值模糊(Available in iOS 9.0 and later)
// CIDiscBlur     ---> 环形卷积模糊(Available in iOS 9.0 and later)
// CIMedianFilter ---> 中值模糊, 用于消除图像噪点, 无需设置radius(Available in iOS 9.0 and later)
// CIMotionBlur   ---> 运动模糊, 用于模拟相机移动拍摄时的扫尾效果(Available in iOS 9.0 and later)
+ (UIImage *)blurWithOriginalImage:(UIImage *)image
                          blurName:(NSString *)name
                            radius:(NSInteger)radius
{
    CIContext *context = [CIContext contextWithOptions:nil];
    CIImage *inputImage = [[CIImage alloc] initWithImage:image];
    CIFilter *filter;
    if (name.length != 0) {
        filter = [CIFilter filterWithName:name];
        [filter setValue:inputImage forKey:kCIInputImageKey];
        if (![name isEqualToString:@"CIMedianFilter"]) {
            [filter setValue:@(radius) forKey:@"inputRadius"];
        }
        CIImage *result = [filter valueForKey:kCIOutputImageKey];
        CGImageRef cgImage = [context createCGImage:result fromRect:[result extent]];
        UIImage *resultImage = [UIImage imageWithCGImage:cgImage];
        CGImageRelease(cgImage);
        return resultImage;
    }else{
        return nil;
    }
}

//设置Label的行间距
+ (void)setLineSpaceWithString:(UILabel *)label WithSpacing:(NSInteger) spacing
{
    
    NSMutableAttributedString *attributedString =
    [[NSMutableAttributedString alloc] initWithString:label.text];
    NSMutableParagraphStyle *paragraphStyle =  [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle setLineSpacing:spacing];
    
    //调整行间距
    [attributedString addAttribute:NSParagraphStyleAttributeName
                             value:paragraphStyle
                             range:NSMakeRange(0, [label.text length])];
    label.attributedText = attributedString;
}

//今天星期几
+ (NSString *)GetWeekDayStr
{
    NSString *weekDayStr = nil;
    
    NSDateComponents *comps = [[NSDateComponents alloc] init];
    
    NSString *str = [self description];
    if (str.length >= 10) {
        NSString *nowString = [str substringToIndex:10];
        NSArray *array = [nowString componentsSeparatedByString:@"-"];
        if (array.count == 0) {
            array = [nowString componentsSeparatedByString:@"/"];
        }
        if (array.count >= 3) {
            NSInteger year = [[array objectAtIndex:0] integerValue];
            NSInteger month = [[array objectAtIndex:1] integerValue];
            NSInteger day = [[array objectAtIndex:2] integerValue];
            [comps setYear:year];
            [comps setMonth:month];
            [comps setDay:day];
        }
    }
    
    NSCalendar *gregorian = [[NSCalendar alloc]
                             initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDate *_date = [gregorian dateFromComponents:comps];
    NSDateComponents *weekdayComponents = [gregorian components:NSCalendarUnitWeekday fromDate:_date];
    NSInteger week = [weekdayComponents weekday];
    week ++;
    switch (week) {
        case 1:
            weekDayStr = @"星期日";
            break;
        case 2:
            weekDayStr = @"星期一";
            break;
        case 3:
            weekDayStr = @"星期二";
            break;
        case 4:
            weekDayStr = @"星期三";
            break;
        case 5:
            weekDayStr = @"星期四";
            break;
        case 6:
            weekDayStr = @"星期五";
            break;
        case 7:
            weekDayStr = @"星期六";
            break;
        default:
            weekDayStr = @"";  
            break;  
    }  
    return weekDayStr;
}

//-----------------------------end-----------------------//




//蝴蝶等级计算
+ (NSString *)getButterflyLevelNameWithMonery:(NSString *)goldCount
{
    if ([goldCount integerValue] < 1000) {
        return @"铜";
    }else if ([goldCount integerValue] < 5000){
        return @"银";
    }else if ([goldCount integerValue] < 10000){
        return @"金";
    }else{
        return @"钻石";
    }
}
//蝴蝶医生文章类别匹配
+ (NSString *)getButterflyarticlesTypeWithType:(NSString *)type
{
    if (type.length < 1) {
        return @"";
    }
    switch ([type integerValue]) {
        case 0:
            return @"全部";
            break;
        case 1:
            return @"学术研究";
            break;
        case 2:
            return @"医学科普";
            break;
        case 3:
            return @"诊前须知";
            break;
        case 4:
            return @"诊后必读";
            break;
        case 5:
            return @"术后需知";
            break;
        case 6:
            return @"经典问答";
            break;
        case 7:
            return @"出院须知";
            break;
        case 8:
            return @"同位素治疗";
            break;
            
        default:
            return @"";
            break;
    }
}
//弹出确认框
+(void)AleartViewWithMessage:(NSString * )message
{
    UIAlertView* alert = [[UIAlertView alloc] initWithTitle:nil
                                                    message:message
                                                   delegate:nil
                                          cancelButtonTitle:@"OK"
                                          otherButtonTitles:nil];
    [alert show];
}


+ (NSString *)getButterflyarticlesTypeWithName:(NSString *)name
{
    if ([name isEqualToString:@"全部"]) {
        return @" ";
    }else if ([name isEqualToString:@"学术研究"]){
        return @"1";
    }else if ([name isEqualToString:@"医学科普"]){
        return @"2";
    }else if ([name isEqualToString:@"诊前须知"]){
        return @"3";
    }else if ([name isEqualToString:@"诊后必读"]){
        return @"4";
    }else if ([name isEqualToString:@"术后需知"]){
        return @"5";
    }else if ([name isEqualToString:@"经典问答"]){
        return @"6";
    }else if ([name isEqualToString:@"出院需知"]){
        return @"7";
    }else if ([name isEqualToString:@"同位素治疗"]){
        return @"8";
    }else{
        return @" ";
    }
}


//根据数字返回汉子【用于日期】
+ (NSString *)getButterflyMonthWihtNumberStr:(NSString *)numberStr
{
    switch ([numberStr integerValue]) {
        case 1:
            return @"一月";
            break;
        case 2:
            return @"二月";
            break;
        case 3:
            return @"三月";
            break;
        case 4:
            return @"四月";
            break;
        case 5:
            return @"五月";
            break;
        case 6:
            return @"六月";
            break;
        case 7:
            return @"七月";
            break;
        case 8:
            return @"八月";
            break;
        case 9:
            return @"九月";
            break;
        case 10:
            return @"十月";
            break;
        case 11:
            return @"十一月";
            break;
        case 12:
            return @"十二月";
            break;
            
        default:
            return @"";
            break;
    }
}


//返回入院患病诊断
+(NSString *)getButterflyDiagnosisWithName:(NSString *)name
{
    if ([name isEqualToString:@"其他"]) {
        return @"0";
    }else if ([name isEqualToString:@"甲状腺肿物"]){
        return @"1";
    }else if ([name isEqualToString:@"甲状旁腺肿物"]){
        return @"2";
    }else if ([name isEqualToString:@"甲状腺癌"]){
        return @"3";
    }else if ([name isEqualToString:@"颈部肿物"]){
        return @"4";
    }else if ([name isEqualToString:@"继发甲亢"]){
        return @"5";
    }else if ([name isEqualToString:@"原发甲亢"]){
        return @"6";
    }else if ([name isEqualToString:@"继发甲旁亢"]){
        return @"7";
    }else if ([name isEqualToString:@"原发甲旁亢"]){
        return @"8";
    }else{
        return @"0";
    }
}
+(NSString *)getButterflyDiagnosisWithNumber:(NSString *)number
{
    switch ([number integerValue]) {
        case 1:
            return @"甲状腺肿物";
            break;
        case 2:
            return @"甲状旁腺肿物";
            break;
        case 3:
            return @"甲状腺癌";
            break;
        case 4:
            return @"颈部肿物";
            break;
        case 5:
            return @"继发甲亢";
            break;
        case 6:
            return @"原发甲亢";
            break;
        case 7:
            return @"继发甲旁亢";
            break;
        case 8:
            return @"原发甲旁亢";
            break;
        default:
            return @"其他";
            break;
    }
}


//亲属甲状腺癌发病史
+(NSString *)getButterflyRelativesWithName:(NSString *)name
{
    if ([name isEqualToString:@"无"]) {
        return @"0";
    }else if ([name isEqualToString:@"父亲"]){
        return @"1";
    }else if ([name isEqualToString:@"母亲"]){
        return @"2";
    }else if ([name isEqualToString:@"兄弟"]){
        return @"3";
    }else if ([name isEqualToString:@"子女"]){
        return @"4";
    }else{
        return @"0";
    }
}
+(NSString *)getButterflyRelativesWithNumber:(NSString *)number
{
    switch ([number integerValue]) {
        case 1:
            return @"父亲";
            break;
        case 2:
            return @"母亲";
            break;
        case 3:
            return @"兄弟";
            break;
        case 4:
            return @"子女";
            break;
        default:
            return @"无";
            break;
    }
}


//初次分娩时间
+(NSString *)getButterflyChildbirthWithName:(NSString *)name
{
    if ([name isEqualToString:@"无"]) {
        return @"0";
    }else if ([name isEqualToString:@"10-20岁"]){
        return @"1";
    }else if ([name isEqualToString:@"20-30岁"]){
        return @"2";
    }else if ([name isEqualToString:@"30-40岁"]){
        return @"3";
    }else{
        return @"0";
    }
}
+(NSString *)getButterflyChildbirthWithNumber:(NSString *)number
{
    if ([number isKindOfClass:[NSNull class]]) {
        return @"无";
    }
    switch ([number integerValue]) {
        case 1:
            return @"10-20岁";
            break;
        case 2:
            return @"20-30岁";
            break;
        case 3:
            return @"30-40岁";
            break;
        default:
            return @"无";
            break;
    }
}

//颈部放射线检查史
+(NSString *)getButterflyRadWithName:(NSString *)name
{
    if ([name isEqualToString:@"无"]) {
        return @"0";
    }else if ([name isEqualToString:@"X线"]){
        return @"1";
    }else if ([name isEqualToString:@"CT"]){
        return @"2";
    }else if ([name isEqualToString:@"增强CT"]){
        return @"3";
    }else if ([name isEqualToString:@"MRI"]){
        return @"4";
    }else if ([name isEqualToString:@"增强MRI"]){
        return @"5";
    }else if ([name isEqualToString:@"PETCT"]){
        return @"6";
    }else if ([name isEqualToString:@"一种以上检查"]){
        return @"7";
    }else{
        return @"0";
    }
}
+(NSString *)getButterflyRadWithNumber:(NSString *)number
{
    switch ([number integerValue]) {
        case 1:
            return @"X线";
            break;
        case 2:
            return @"CT";
            break;
        case 3:
            return @"增强CT";
            break;
        case 4:
            return @"MRI";
            break;
        case 5:
            return @"增强MRI";
            break;
        case 6:
            return @"PETCT";
            break;
        case 7:
            return @"一种以上检查";
            break;
        default:
            return @"无";
            break;
    }
}

//查看未读消息
+ (NSInteger ) getTeamNumberWithunread
{
    NSArray *conversations = [[EMClient sharedClient].chatManager getAllConversations];
    NSMutableArray * teamConversations = [NSMutableArray array];
    for (int i = 0 ; i < conversations.count; i ++) {
        EMConversation *conversation = [[EMConversation alloc]init];
        conversation = conversations[i];
        if (conversation.type == EMConversationTypeGroupChat) {
            [teamConversations addObject:conversation];
        }
    }
    NSInteger messageNumber = 0;
    for (int j = 0 ; j < teamConversations.count ; j ++) {
        //        NSInteger unreadCount = 0;
        EMConversation *conversation = [[EMConversation alloc]init];
        conversation = teamConversations[j];
        messageNumber += conversation.unreadMessagesCount;
        //        if ([conversation.conversationId isEqualToString:model.groupId]) {
        //            unreadCount = conversation.unreadMessagesCount;
        //            NSLog(@"%@患者未读消息 %ld",conversation.conversationId,unreadCount);
        //            model.unreadMessagesCount = [NSString stringWithFormat:@"%ld",unreadCount];
        //        }
    }
    
//    EMError *error1 = nil;
//    EMPushOptions *options1 = [[EMClient sharedClient] getPushOptionsFromServerWithError:&error1];
    
    return messageNumber;
//    return 0;
}

//查看小组&图文资讯未读消息
+ (NSInteger) getTeamAndPeopleNumberWithunread
{
    NSArray *conversations = [[EMClient sharedClient].chatManager getAllConversations];
    NSMutableArray * teamConversations = [NSMutableArray array];
    for (int i = 0 ; i < conversations.count; i ++) {
        EMConversation *conversation = [[EMConversation alloc]init];
        conversation = conversations[i];
//        if (conversation.type == EMConversationTypeGroupChat) {
        [teamConversations addObject:conversation];
//        }
    }
    NSInteger messageNumber = 0;
    for (int j = 0 ; j < teamConversations.count ; j ++) {
        //        NSInteger unreadCount = 0;
        EMConversation *conversation = [[EMConversation alloc]init];
        conversation = teamConversations[j];
        if (conversation.conversationId.length > 11) {
            messageNumber += conversation.unreadMessagesCount;
        }
        NSLog(@"conversationId :%@ type :%d  unreadMessagesCount :%d",conversation.conversationId,conversation.type,conversation.unreadMessagesCount);
    }
    //每次查询信息时 都要改变 app图标红点
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:messageNumber];

    return messageNumber;
//    return 0;
}
//返回所有有未读消息的id 只返回个人
+ (NSArray *) getAllMessageNumberEMC
{
    NSArray *conversations = [[EMClient sharedClient].chatManager getAllConversations];
    NSMutableArray * teamConversations = [NSMutableArray array];
    NSMutableArray * getArray = [NSMutableArray array];
    for (int i = 0 ; i < conversations.count; i ++) {
        EMConversation *conversation = [[EMConversation alloc]init];
        conversation = conversations[i];
        //        if (conversation.type == EMConversationTypeGroupChat) {
        [teamConversations addObject:conversation];
        //        }
    }
    NSInteger messageNumber = 0;
    for (int j = 0 ; j < teamConversations.count ; j ++) {
        //        NSInteger unreadCount = 0;
        EMConversation *conversation = [[EMConversation alloc]init];
        conversation = teamConversations[j];
        if (conversation.conversationId.length > 11) {
            messageNumber += conversation.unreadMessagesCount;
            if (messageNumber > 0 && conversation.type == EMConversationTypeChat) {
                [getArray addObject:conversation.conversationId];
            }
        }
        NSLog(@"conversationId :%@ type :%d  unreadMessagesCount :%d",conversation.conversationId,conversation.type,conversation.unreadMessagesCount);
    }
    return getArray;
}
//拼接字符串 用于model
+(NSString * )getStringWithLeftStr:(NSString *)leftStr WithRightStr:(NSString *)rightStr
{
    NSString * str = [NSString stringWithFormat:@"%@%@",ModelNull(leftStr),ModelNull(rightStr)];
    return str;
}
//审核状态 -1审核失败 0审核中 1审核通过
+(NSString *)getStringWithShenheType:(NSString *)isVerify
{
    if ([isVerify isEqualToString:@"-1"]) {
        return @"审核未通过";
    }else if ([isVerify isEqualToString:@"0"]){
        return @"审核中";
    }else if ([isVerify isEqualToString:@"1"]){
        return @"审核成功";
    }else{
        return @"";
    }
}

+(NSString *)modelNull:(id )str
{
    if ([str isKindOfClass:[NSNull class]]) {
        NSLog(@"NSNull");
        return @"";
    }else if (![str isKindOfClass:[NSString class]]){
        NSLog(@"非字符串");
        return @"";
    }else{
        return str;
    }
}
+(void)TheMiddleHorizontalLineWithLabel:(UILabel *)label{
    if (label.text == nil) {
        return;
    }
    //中划线
    NSDictionary *attribtDic = @{NSStrikethroughStyleAttributeName: [NSNumber numberWithInteger:NSUnderlineStyleSingle]};
    NSMutableAttributedString *attribtStr = [[NSMutableAttributedString alloc]initWithString:label.text attributes:attribtDic];
    // 赋值
    label.attributedText = attribtStr;
}
+(void)TheNSUnderlineStyleAttributeNameWithLabel:(UILabel *)label
{
    if (label.text == nil) {
        return;
    }
    // 下划线
    NSDictionary *attribtDic = @{NSUnderlineStyleAttributeName: [NSNumber numberWithInteger:NSUnderlineStyleSingle]};
    NSMutableAttributedString *attribtStr = [[NSMutableAttributedString alloc]initWithString:label.text attributes:attribtDic];
    
    //赋值
    label.attributedText = attribtStr;
}
+(void)ImageViewForlayerCornerRadiusWith:(UIImageView *)imageView
{
    
    imageView.layer.masksToBounds = YES;
    imageView.layer.cornerRadius = imageView.frame.size.width / 2;
}
+(void)nextToLabelWithLabel:(UILabel *)label withImage:(UILabel *)label2{
    
    NSString * str =  label.text;
    NSScanner *scanner = [NSScanner scannerWithString:str];
    [scanner scanUpToCharactersFromSet:[NSCharacterSet decimalDigitCharacterSet] intoString:nil];
    int number;
    [scanner scanInt:&number];
    CGRect rect = label.frame;
    rect.size.width = [GatoMethods getWidthWithSring:label.text withSize:label.font.pointSize + 2 withHeight:CGRectGetHeight(label.frame)] ;
    label.frame = rect;
    
    rect = label2.frame;
    rect.origin.x = CGRectGetMaxX(label.frame) + Gato_Width_320_(6);
    label2.frame = rect;
}

+(CGFloat)getWidthWithSring:(NSString *)string withSize:(CGFloat)size withHeight:(CGFloat)height{
    
    if (![string.class isSubclassOfClass:[NSString class]] || string.length == 0) {
        return 0;
    }
    CGRect rect = [string boundingRectWithSize:CGSizeMake(MAXFLOAT, height) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:size]} context:nil];
    return rect.size.width;
}

+(CGFloat)getHeightWithString:(NSString *)string withSize:(CGFloat)size withWidth:(CGFloat)width{

    if (![string.class isSubclassOfClass:[NSString class]] || string.length == 0) {
        return 0;
    }
    NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc]init];
    //设置行距
    [style setLineSpacing:10.0f * Gato_Height_548_(2)];
    CGRect rect = [string boundingRectWithSize:CGSizeMake(width, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:size], NSParagraphStyleAttributeName : style} context:nil];
    return rect.size.height;
    
    
    
    
}



+(void)makeTheLayerWithID:(UILabel * )label WithWidth:(CGFloat)width WithColor:(UIColor *)color
{
    
    label.layer.borderWidth = width;
    label.layer.borderColor = [color CGColor];
}

+ (void)SOAPData:(NSString *)url soapBody:(NSString *)soapBody success:(void (^)(id responseObject))success failure:(void(^)(NSError *error))failure {
    
    NSString *soapStr = [NSString stringWithFormat:
                         @"<?xml version=\"1.0\" encoding=\"utf-8\"?>\
                         <soap:Envelope xmlns:xsi=\"http://services.common.com/\" xmlns:xsd=\"http://services.common.com/\"\
                         <soap:Header>\
                         </soap:Header>\
                         <soap:Body>%@</soap:Body>\
                         </soap:Envelope>",soapBody];
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFXMLParserResponseSerializer serializer];
    
    // 设置请求超时时间
    manager.requestSerializer.timeoutInterval = 30;
    
    // 返回NSData
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    // 设置请求头，也可以不设置
    [manager.requestSerializer setValue:@"application/soap+xml; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    [manager.requestSerializer setValue:[NSString stringWithFormat:@"%zd", soapStr.length] forHTTPHeaderField:@"Content-Length"];
    
    // 设置HTTPBody
    [manager.requestSerializer setQueryStringSerializationWithBlock:^NSString *(NSURLRequest *request, NSDictionary *parameters, NSError *__autoreleasing *error) {
        return soapStr;
    }];
    
    [manager POST:url parameters:soapStr success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
        // 把返回的二进制数据转为字符串
        NSString *result = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        
        // 利用正则表达式取出<return></return>之间的字符串
        NSRegularExpression *regular = [[NSRegularExpression alloc] initWithPattern:@"(?<=return\\>).*(?=</return)" options:NSRegularExpressionCaseInsensitive error:nil];
        
        NSDictionary *dict = [NSDictionary dictionary];
        for (NSTextCheckingResult *checkingResult in [regular matchesInString:result options:0 range:NSMakeRange(0, result.length)]) {
            
            // 得到字典
            dict = [NSJSONSerialization JSONObjectWithData:[[result substringWithRange:checkingResult.range] dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingMutableLeaves error:nil];
        }
        // 请求成功并且结果有值把结果传出去
        if (success && dict) {
            success(dict);
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (failure) {
            failure(error);
        }
    }];
}
+ (nullable NSData *)sendSynchronousRequest:(NSURLRequest *)request returningResponse:(NSURLResponse * _Nullable * _Nullable)response error:(NSError **)error NS_DEPRECATED(10_3, 10_11, 2_0, 9_0, "Use [NSURLSession dataTaskWithRequest:completionHandler:] (see NSURLSession.h") __WATCHOS_PROHIBITED
{
    return nil;
}

+(void)SetButtonWithButton:(UIButton *)sender WithFrame:(CGRect )rect WithText:(NSString *)text WithFont:(CGFloat )Font_float WithBC:(UIColor *)backColor WithcornerRadius:(CGFloat )Radius WithtitleColor:(UIColor* )titleColor
{
    if (!sender) {
        return;
    }
    if (!text) {
        text = @"";
    }
    if (!Font_float) {
        Font_float = 20;
    }
    if (!backColor) {
        backColor = Gato_(0, 130, 230);
    }
    if (!titleColor) {
        titleColor = [UIColor whiteColor];
    }
    
    sender.frame = rect;
    [sender setBackgroundColor:backColor];
    [sender setTitleColor:titleColor forState:UIControlStateNormal];
    [sender setTitle:text forState:UIControlStateNormal];
    sender.titleLabel.font = FONT(Font_float);
    sender.layer.cornerRadius = Radius;
    sender.layer.masksToBounds = YES;
    
}



+(float)fileSizeAtPath:(NSString *)path{
    NSFileManager *fileManager=[NSFileManager defaultManager];
    if([fileManager fileExistsAtPath:path]){
        long long size=[fileManager attributesOfItemAtPath:path error:nil].fileSize;
        return size/1024.0/1024.0;
    }
    return 0;
}
+(NSString * )componentsSeparatedByString:(NSString *)string WithFirstString:(NSString *)firststring WithLastString:(NSString *)laststring
{
    NSArray *array = [string componentsSeparatedByString:firststring];
    NSArray *array1 = [array[1] componentsSeparatedByString:laststring];
    return array1[0];
}

+(void)NSMutableAttributedStringWithLabel:(UILabel * )label WithAllString:(NSString *)string WithColorString:(NSString *)colorstring WithColor:(UIColor *)color
{
   
    // 创建对象.
    NSMutableAttributedString *mAttStri = [[NSMutableAttributedString alloc] initWithString:string];
    //
    NSRange range = [string rangeOfString:colorstring];
    
    [mAttStri addAttribute:NSForegroundColorAttributeName value:color range:range];
    
    label.attributedText = mAttStri;
}







//根据血压返回颜色
+(UIColor *)getColorWithXueYaUp:(NSString *)xueyaUp WithXueYaDown:(NSString *)xueyaDown
{
    CGFloat xueyaUpFloat = [xueyaUp floatValue];
    CGFloat xueyaDownFloat = [xueyaDown floatValue];
    if ( 90.0 <= xueyaUpFloat && xueyaUpFloat < 140.0 && 60.0 <= xueyaDownFloat && xueyaDownFloat < 90.0) {
        //正常血压
        return  [UIColor appYLAlltitleViewColor];
    }else if (140.0 <= xueyaUpFloat && xueyaUpFloat < 160.0 && 90.0 <= xueyaDownFloat && xueyaDownFloat < 100.0) {
        //偏高血压
        return [UIColor orangeColor];
    }else{
        //过高血压
       return  [UIColor redColor];
    }
}
//根据血糖返回颜色
+(UIColor *)getColorWithXueTang:(NSString *)xuetang
{
    CGFloat xuetangFloat = [xuetang floatValue];
    if ( 3.9 <= xuetangFloat && xuetangFloat < 6.1) {
        //正常血糖
        return  [UIColor appYLAlltitleViewColor];
    }else if (6.1 <= xuetangFloat && xuetangFloat < 11.0 ) {
        //偏高血糖
        return [UIColor orangeColor];
    }else{
        //过高血糖
        return [UIColor redColor];
    }
}
//根据温度返回颜色
+(UIColor *)getColorWithWendu:(NSString *)wendu
{
    CGFloat wenduFloat = [wendu floatValue];
    if ( 36.0 <= wenduFloat && wenduFloat < 37.0) {
        //正常温度
        return [UIColor appYLAlltitleViewColor];
    }else if (37.0 <= wenduFloat && wenduFloat < 37.3) {
        //偏高温度
        return [UIColor orangeColor];
    }else{
        //过高温度
        return [UIColor redColor];
    }
}



//点击图片放大
+ (void)amplificationImageWithPicUrl:(NSString *)url
{
    UIImageView * image = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, Gato_Width - 30, Gato_Width - 30)];
    [image sd_setImageWithURL:[NSURL URLWithString:url] placeholderImage:nil];
    [UIView animateWithDuration:0.5 // 动画时长
                     animations:^{
                         [PellTableViewSelect addPellTableViewSelectWithwithView:image WindowFrame:CGRectMake(0, 0, Gato_Width - 30, Gato_Width - 30) WithViewFrame:CGRectMake(15, Gato_Height / 2 - (Gato_Width - 30) / 2, Gato_Width - 30, Gato_Width - 30) selectData:nil action:^(NSInteger index) {
                             ;
                         } animated:YES];
                     }];
    
}


@end
