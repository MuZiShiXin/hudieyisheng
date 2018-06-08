//
//  HospitalizedPatientInfoModel.h
//  butterflyDoctor
//
//  Created by 辛书亮 on 2017/5/9.
//  Copyright © 2017年 孟小猫. All rights reserved.
//

#import "GatoBaseModel.h"

@interface HospitalizedPatientInfoModel : GatoBaseModel

@property (nonatomic ,strong)NSString * caseNo;
@property (nonatomic ,strong)NSString * patientEasemobId;
@property (nonatomic ,strong)NSString * diagnose;
@property (nonatomic ,strong)NSString * patientCaseId;
@property (nonatomic ,strong)NSString * age;
@property (nonatomic ,strong)NSString * photo;
@property (nonatomic ,strong)NSString * bedTime;
@property (nonatomic ,strong)NSString * sex;
@property (nonatomic ,strong)NSString * name;
@property (nonatomic ,strong)NSString * bedNumber;

@property (nonatomic ,strong)NSString * ismine;// 0显示我的患者灰色标记 1显示我的患者蓝色标记 

@end
