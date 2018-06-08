//
//  MineInfoDataModel.h
//  ButterflyDoctorVoice
//
//  Created by 辛书亮 on 2017/5/13.
//  Copyright © 2017年 辛书亮. All rights reserved.
//

#import "GatoBaseModel.h"


@interface MineInfoDataModel : GatoBaseModel

@property (nonatomic ,copy) NSString *photo;//头像
@property (nonatomic ,copy) NSString *name;//姓名
@property (nonatomic ,copy) NSString *sex;//性别
@property (nonatomic ,copy) NSString *birthday;//生日
@property (nonatomic ,copy) NSString *isBirthday;//出生年月是否显示 0;//保密 1;//显示
@property (nonatomic ,copy) NSString *introduction;//个人简介
@property (nonatomic ,copy) NSString *speciality;//擅长
@property (nonatomic ,copy) NSString *workAddress;//工作地点
@property (nonatomic ,copy) NSString *payPrice;//付费咨询价格设置
@property (nonatomic ,copy) NSString *notDisturb;//勿扰模式
@property (nonatomic ,copy) NSString *payPriceSet;//免费名额用完允许付费咨询 1;//允许 0;//不允许

@end
