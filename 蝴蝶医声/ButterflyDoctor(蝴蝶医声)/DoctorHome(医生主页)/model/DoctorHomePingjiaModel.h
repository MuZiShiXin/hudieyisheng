//
//  DoctorHomePingjiaModel.h
//  ButterflyDoctorVoice
//
//  Created by 辛书亮 on 2017/5/15.
//  Copyright © 2017年 辛书亮. All rights reserved.
//

#import "GatoBaseModel.h"

@interface DoctorHomePingjiaModel : GatoBaseModel

@property (nonatomic ,copy) NSString * therapeuticEffect;//治疗效果
@property (nonatomic ,copy) NSString * time;//
@property (nonatomic ,copy) NSString * content;//
@property (nonatomic ,copy) NSString * serviceAttitude;//服务态度
@property (nonatomic ,copy) NSString * medalLevel;//金牌级别
@property (nonatomic ,copy) NSString * patientId;//
@property (nonatomic ,copy) NSString * diagnose;//诊断
@end
