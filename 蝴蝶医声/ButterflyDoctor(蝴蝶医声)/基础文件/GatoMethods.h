//
//  GatoMethods.h
//  meiqi
//
//  Created by 辛书亮 on 2016/10/26.
//  Copyright © 2016年 mac. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>


@interface GatoMethods : NSObject


#pragma mark -给label添加中滑线
+(void)TheMiddleHorizontalLineWithLabel:(UILabel *)label;
+(void)TheNSUnderlineStyleAttributeNameWithLabel:(UILabel *)label;//给label添加下划线
+(void)makeTheLayerWithID:(UILabel * )label WithWidth:(CGFloat)width WithColor:(UIColor *)color;//给label添加边框
+(void)ImageViewForlayerCornerRadiusWith:(UIImageView *)imageView;//把照片变圆
+ (void)SOAPData:(NSString *)url soapBody:(NSString *)soapBody success:(void (^)(id responseObject))success failure:(void(^)(NSError *error))failure ;

+ (CGFloat )getiPhoneXHeight;
//返回当前手机型号
+ (NSString *)getiPhoneType;
//获取当前VC
+ (UIViewController *)getCurrentViewController;
//根据机型返回高度
+ (CGFloat )getPhoneHeight;

//根据机型返回字号
+ (CGFloat )getPhoneFONT;
//----------------------------170606--------------------//
//判断手机号码格式是否正确
+ (BOOL)PhoneNumberIsMobileNumber:(NSString *)mobileNum;

//判断字符串中是否含有空格
+ (BOOL)isHaveSpaceInString:(NSString *)string;

//判断字符串中是否含有中文
+ (BOOL)isHaveChineseInString:(NSString *)string;

//对图片进行滤镜处理
// 怀旧 --> CIPhotoEffectInstant                         单色 --> CIPhotoEffectMono
// 黑白 --> CIPhotoEffectNoir                            褪色 --> CIPhotoEffectFade
// 色调 --> CIPhotoEffectTonal                           冲印 --> CIPhotoEffectProcess
// 岁月 --> CIPhotoEffectTransfer                        铬黄 --> CIPhotoEffectChrome
// CILinearToSRGBToneCurve, CISRGBToneCurveToLinear, CIGaussianBlur, CIBoxBlur, CIDiscBlur, CISepiaTone, CIDepthOfField
+ (UIImage *)filterWithOriginalImage:(UIImage *)image filterName:(NSString *)name;

//对图片进行模糊处理
// CIGaussianBlur ---> 高斯模糊
// CIBoxBlur      ---> 均值模糊(Available in iOS 9.0 and later)
// CIDiscBlur     ---> 环形卷积模糊(Available in iOS 9.0 and later)
// CIMedianFilter ---> 中值模糊, 用于消除图像噪点, 无需设置radius(Available in iOS 9.0 and later)
// CIMotionBlur   ---> 运动模糊, 用于模拟相机移动拍摄时的扫尾效果(Available in iOS 9.0 and later)
+ (UIImage *)blurWithOriginalImage:(UIImage *)image
                          blurName:(NSString *)name
                            radius:(NSInteger)radius;

//设置Label的行间距
+ (void)setLineSpaceWithString:(UILabel *)label WithSpacing:(NSInteger) spacing;

//今天星期几
+ (NSString *)GetWeekDayStr;

//提示框
+ (void)AlertControllerWithtitle:(NSString * )title WithMessage:(NSString *)message success:(void (^)())success WithVC:(UIViewController *)VC;

//提示框-有取消判断
+ (void)AlertControllerWithtitle:(NSString * )title WithMessage:(NSString *)message success:(void (^)())success error:(void(^)())error WithVC:(UIViewController *)VC;

//-----------------------------end-----------------------//
//button按钮初始化
+(void)SetButtonWithButton:(UIButton *)sender WithFrame:(CGRect )rect WithText:(NSString *)text WithFont:(CGFloat )Font_float WithBC:(UIColor *)backColor WithcornerRadius:(CGFloat )Radius WithtitleColor:(UIColor* )titleColor;

+(float)fileSizeAtPath:(NSString *)path;//缓存大小计算

+(NSString * )componentsSeparatedByString:(NSString *)string WithFirstString:(NSString *)firststring WithLastString:(NSString *)laststring;//拆分字符串 得到中间的字符

+(void)nextToLabelWithLabel:(UILabel *)label withImage:(UILabel *)label2;//拼接两个label
+(CGFloat)getWidthWithSring:(NSString *)string withSize:(CGFloat)size withHeight:(CGFloat)heigh;//自适应宽度
+(CGFloat)getHeightWithString:(NSString *)string withSize:(CGFloat)size withWidth:(CGFloat)width;//自适应高度

//改变字符串中 某个字符颜色
+(void)NSMutableAttributedStringWithLabel:(UILabel * )label WithAllString:(NSString *)string WithColorString:(NSString *)colorstring WithColor:(UIColor *)color;



//审核状态 -1审核失败 0审核中 1审核通过
+(NSString *)getStringWithShenheType:(NSString *)isVerify;
//拼接字符串 用于model
+(NSString * )getStringWithLeftStr:(NSString *)leftStr WithRightStr:(NSString *)rightStr;

//屏蔽null崩溃
+(NSString *)modelNull:(id )str;

//点击图片放大
+ (void)amplificationImageWithPicUrl:(NSString *)url;



/////-------------------环信 专用------------------////
//查看小组未读消息
+ (NSInteger) getTeamNumberWithunread;


//查看小组&图文资讯未读消息
+ (NSInteger) getTeamAndPeopleNumberWithunread;

//返回所有有未读消息的id 只返回个人
+ (NSArray *) getAllMessageNumberEMC;
/////-------------------环信 专用END------------------////


/////0-------------------蝴蝶医声专用------------------////
//蝴蝶等级计算
+ (NSString *)getButterflyLevelNameWithMonery:(NSString *)goldCount;

//蝴蝶医生文章类别匹配
+ (NSString *)getButterflyarticlesTypeWithType:(NSString *)type;
//蝴蝶医生文章类别匹配
+ (NSString *)getButterflyarticlesTypeWithName:(NSString *)name;

//根据数字返回汉子【用于日期】
+ (NSString *)getButterflyMonthWihtNumberStr:(NSString *)numberStr;

//弹出确认框
+(void)AleartViewWithMessage:(NSString * )message;

//返回入院患病诊断
+(NSString *)getButterflyDiagnosisWithName:(NSString *)name;
//返回入院患病诊断
+(NSString *)getButterflyDiagnosisWithNumber:(NSString *)number;


//亲属甲状腺癌发病史
+(NSString *)getButterflyRelativesWithName:(NSString *)name;
//亲属甲状腺癌发病史
+(NSString *)getButterflyRelativesWithNumber:(NSString *)number;


//初次分娩时间
+(NSString *)getButterflyChildbirthWithName:(NSString *)name;
//初次分娩时间
+(NSString *)getButterflyChildbirthWithNumber:(NSString *)number;

//颈部放射线检查史
+(NSString *)getButterflyRadWithName:(NSString *)name;
//颈部放射线检查史
+(NSString *)getButterflyRadWithNumber:(NSString *)number;

/////0-------------------蝴蝶医声专用END------------------////

@end
