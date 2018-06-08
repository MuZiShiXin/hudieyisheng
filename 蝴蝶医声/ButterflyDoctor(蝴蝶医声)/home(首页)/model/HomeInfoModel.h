//
//  HomeInfoModel.h
//  ButterflyDoctorVoice
//
//  Created by 辛书亮 on 2017/5/16.
//  Copyright © 2017年 辛书亮. All rights reserved.
//

#import "GatoBaseModel.h"

@interface HomeInfoModel : GatoBaseModel

@property (nonatomic ,strong) NSString * photo;//头像
@property (nonatomic ,strong) NSString * name;//姓名
@property (nonatomic ,strong) NSString * hospital;//所属医院
@property (nonatomic ,strong) NSString * hospitalDepartment;//所属科室
@property (nonatomic ,strong) NSString * patientAllCount;//患者总量
@property (nonatomic ,strong) NSString * patientTodayCount;//今日患者量
@property (nonatomic ,copy) NSString * isVerify;//1审核通过 其他不让用
@property (nonatomic ,copy) NSString * work;
@end
