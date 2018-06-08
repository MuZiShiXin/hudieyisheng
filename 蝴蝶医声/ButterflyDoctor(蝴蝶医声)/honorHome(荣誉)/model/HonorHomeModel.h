//
//  HonorHomeModel.h
//  ButterflyDoctorVoice
//
//  Created by 辛书亮 on 2017/5/15.
//  Copyright © 2017年 辛书亮. All rights reserved.
//

#import "GatoBaseModel.h"

@interface HonorHomeModel : GatoBaseModel
@property (nonatomic ,copy) NSString * satisfied;////满意度
@property (nonatomic ,copy) NSString * work;//职称
@property (nonatomic ,copy) NSString * goldCount;//蝴蝶币
@property (nonatomic ,copy) NSString * hospital;//医院
@property (nonatomic ,copy) NSString * hospitalDepartment;//科室
@property (nonatomic ,copy) NSString * doctorId;//id
@property (nonatomic ,copy) NSString * photo;//头像
@property (nonatomic ,copy) NSString * speciality;//擅长
@property (nonatomic ,copy) NSString * name;//名字
@property (nonatomic ,copy) NSString * patientAllCount;//患者量
@end
