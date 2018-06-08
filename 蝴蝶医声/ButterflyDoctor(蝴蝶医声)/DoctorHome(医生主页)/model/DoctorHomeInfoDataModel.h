//
//  DoctorHomeInfoDataModel.h
//  ButterflyDoctorVoice
//
//  Created by 辛书亮 on 2017/5/15.
//  Copyright © 2017年 辛书亮. All rights reserved.
//

#import "GatoBaseModel.h"

@interface DoctorHomeInfoDataModel : GatoBaseModel

@property (nonatomic ,copy) NSString * work;
@property (nonatomic ,copy) NSString * hospital;
@property (nonatomic ,copy) NSString * hospitalDepartment;
@property (nonatomic ,copy) NSString * name;
@property (nonatomic ,copy) NSString * photo;
@property (nonatomic ,copy) NSString * speciality;
@property (nonatomic ,copy) NSString * paiming;
@property (nonatomic ,copy) NSString * paimingNumber;
@property (nonatomic ,copy) NSString * patientTodayCount;
@end
