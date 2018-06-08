//
//  MyCardModel.h
//  ButterflyDoctorVoice
//
//  Created by 辛书亮 on 2017/5/13.
//  Copyright © 2017年 辛书亮. All rights reserved.
//

#import "GatoBaseModel.h"

@interface MyCardModel : GatoBaseModel

@property (nonatomic ,copy) NSString *token;//医生ID
@property (nonatomic ,copy) NSString *photo;//头像
@property (nonatomic ,copy) NSString *name;//姓名
@property (nonatomic ,copy) NSString *work;//职位
@property (nonatomic ,copy) NSString *hospitalDepartment;//所属科室
@property (nonatomic ,copy) NSString *hospital;//所属医院
@property (nonatomic ,copy) NSString *speciality;//特长
@property (nonatomic ,copy) NSString *patientAllCount;//患者总数
@property (nonatomic ,copy) NSString *satisfied;//满意度
@property (nonatomic ,copy) NSString *goldCount;//蝴蝶币
@property (nonatomic ,copy) NSString *qrCode;//二维码地址
@property (nonatomic ,copy) NSString *patientTodayCount;//今日患者
@end
