//
//  CityChooseViewController.h
//  yoyo
//
//  Created by YoYo on 16/5/12.
//  Copyright © 2016年 cn.yoyoy.mw. All rights reserved.
//

#import <UIKit/UIKit.h>
//定义一个代码块
typedef void(^CityBlock)(NSString *province, NSString *area);

//定义一个代码块
typedef void(^cityArrayBlock)(NSMutableArray *provinceArray,NSMutableArray *areaArray);

@interface CityChooseViewController : UIViewController
//选择的城市信息
@property (copy, nonatomic) CityBlock cityInfo;

//选择的城市的数组信息
@property (nonatomic,copy) cityArrayBlock cityInfoArray;

//赋值的时候回调
-(void)returnCityInfo:(CityBlock)block;

-(void)returnCityInfoArray:(cityArrayBlock)block;

@end
