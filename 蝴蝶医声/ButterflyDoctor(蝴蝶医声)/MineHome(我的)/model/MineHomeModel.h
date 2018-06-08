//
//  MineHomeModel.h
//  ButterflyDoctorVoice
//
//  Created by 辛书亮 on 2017/5/13.
//  Copyright © 2017年 辛书亮. All rights reserved.
//

#import "GatoBaseModel.h"

@interface MineHomeModel : GatoBaseModel
@property (nonatomic ,copy) NSString *photo;//头像
@property (nonatomic ,copy) NSString *name;//姓名
@property (nonatomic ,copy) NSString *work;//职称
@property (nonatomic ,copy) NSString *hospitalDepartment;//所属科室
@property (nonatomic ,copy) NSString *hospital;//所属医院
@property (nonatomic ,copy) NSString *speciality;//特长
@property (nonatomic ,copy) NSString *patientAllCount;//患者总数
@property (nonatomic ,copy) NSString *satisfied;//满意度
@property (nonatomic ,copy) NSString *goldCount;//蝴蝶币
@property (nonatomic ,copy) NSString *isTeam;//是否是组长
@property (nonatomic ,copy) NSString *isVerify;//审核 -1未通过 0;//待审核 1;//通过
@property (nonatomic ,copy) NSString *isSetSafePassword;//是否已设置安全密码（隐私密码） 0:未设置 1：已设置
@property (nonatomic ,copy) NSString *teamApplyCount;//成员申请数
@property (nonatomic ,copy) NSString *noReadMessageCount;//站内消息未读数
@property (nonatomic ,copy) NSString *patientTodayCount;//今日患者
@end
